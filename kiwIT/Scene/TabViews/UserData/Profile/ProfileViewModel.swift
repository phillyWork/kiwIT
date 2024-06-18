//
//  ProfileViewModel.swift
//  kiwIT
//
//  Created by Heedon on 6/17/24.
//

import Foundation

import Combine

import Alamofire

final class ProfileViewModel: ObservableObject {
    
    @Published private var debouncedNickname = ""
    @Published var nicknameInputFromUser = ""
    @Published var showEditNicknameAlert = false
    @Published var showNicknameErrorAlert = false
    
    @Published var isTokenAvailable = true
    
    @Published var showWithdrawAlert = false
    @Published var showRealWithdrawAlert = false
    @Published var emailToBeWithdrawn = ""
    @Published var showEmailWithdrawalErrorAlert = false
    
    @Published var showSessionExpiredAlert = false
    
    @Published var showLogoutAlert = false
    
    private let debounceInterval = 0.5
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupDebounce()
    }
    
    private func setupDebounce() {
        $nicknameInputFromUser
            .debounce(for: .seconds(debounceInterval), scheduler: RunLoop.main)
            .sink { [weak self] debouncedValue in
                self?.debouncedNickname = debouncedValue
            }
            .store(in: &self.cancellables)
    }
    
    private func handleDebouncedInput(_ newValue: String) {
        print("how to handle this debounced input -- \(newValue)")
    }
    
    func updateNickname(completion: @escaping (ProfileResponse) -> Void) {
        
        //1. check Token Availability
        if let token = KeyChainManager.shared.read() {
            NetworkManager.shared.request(type: ProfileResponse.self, api: .profileEdit(request: ProfileEditRequest(access: token.access, nickname: debouncedNickname)), errorCase: .profileEdit)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        if let nicknameUpdateErr = error as? NetworkError {
                            print("Profile Nickname Update Error: \(nicknameUpdateErr.description)")
                        } else {
                            print("Profile Nickname Update Error By Other Reason: \(error.localizedDescription)")
                        }
                        self.showNicknameErrorAlert = true
                    }
                } receiveValue: { response in
                    print("Updated Profile Nickname: \(response)")
                    completion(response)
                }
                .store(in: &self.cancellables)
        } else {
            //No Token: Move to LogIn Again!!!
            print("No Token in ProfileView!!! Should Move to Log-In!!!")
            self.showSessionExpiredAlert = true            
        }
    }
    
    func signOut(resultCompletion: @escaping (Bool) -> Void) {
        if let token = KeyChainManager.shared.read() {
            print("SignOut with Saved Token!!!")
            NetworkManager.shared.request(type: Empty.self, api: .signOut(request: AuthorizationRequest(access: token.access)), errorCase: .signOut)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        if let signOutError = error as? NetworkError {
                            print("SignOut with Network Error: \(signOutError.description)")
                        } else {
                            print("Signout Error for Other Reason: \(error.localizedDescription)")
                        }
                        resultCompletion(false)
                    }
                } receiveValue: { _ in
                    print("Response for Sign Out Success!")
                    resultCompletion(true)
                }
                .store(in: &self.cancellables)
        } else {
            //No Token: Move to LogIn Again!!!
            print("No Token in ProfileView!!! Should Move to Log-In!!!")
            self.showSessionExpiredAlert = true
        }
    }
    
    
    
}
