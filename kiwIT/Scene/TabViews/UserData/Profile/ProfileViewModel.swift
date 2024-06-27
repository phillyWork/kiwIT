//
//  ProfileViewModel.swift
//  kiwIT
//
//  Created by Heedon on 6/17/24.
//

import Foundation

import Combine

import Alamofire


//MARK: - 함수 구조 변경 필요

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
    
    private var cancellables = Set<AnyCancellable>()
    
    var updateProfileClosure: ((ProfileResponse) -> Void)?
    
    init(updateProfileClosure: @escaping (ProfileResponse) -> Void) {
        self.updateProfileClosure = updateProfileClosure
        setupDebounce()
    }
    
    private func setupDebounce() {
        $nicknameInputFromUser
            .debounce(for: .seconds(Setup.Time.debounceInterval), scheduler: RunLoop.main)
            .sink { [weak self] debouncedValue in
                self?.debouncedNickname = debouncedValue
            }
            .store(in: &self.cancellables)
    }
    
    private func handleDebouncedInput(_ newValue: String) {
        print("how to handle this debounced input -- \(newValue)")
    }
    
    func updateNickname() {
        do {
            let userId = try UserDefaultsManager.shared.retrieveFromUserDefaults(forKey: Setup.UserDefaultsKeyStrings.userIdString) as String
            if let token = KeyChainManager.shared.read(userId) {
                self.requestProfileEdit(token, nickname: debouncedNickname, userId: userId)
            } else {
                //No Token: Move to LogIn Again!!!
                print("No Token in ProfileView!!! Should Move to Log-In!!!")
                self.showSessionExpiredAlert = true
            }
        } catch {
            print("No Saved id!!! Should Login!!!")
            self.showSessionExpiredAlert = true
        }
    }
    
    private func requestProfileEdit(_ current: UserTokenValue, nickname: String, userId: String) {
        NetworkManager.shared.request(type: ProfileResponse.self, api: .profileEdit(request: ProfileEditRequest(access: current.access, nickname: nickname)), errorCase: .profileEdit)
            .sink { completion in
                if case .failure(let error) = completion {
                    if let profileEditError = error as? NetworkError {
                        switch profileEditError {
                        case .invalidRequestBody(_):
                            print("Cannot Update Profile Nickname in ProfileViewModel: \(profileEditError.description)")
                            self.showNicknameErrorAlert = true
                        case .invalidToken(_):
                            print("Access Token is not available in ProfileViewModel: \(profileEditError.description)")
                            self.requestRefreshToken(current, nickname: nickname, userId: userId)
                        default:
                            print("Profile Update Error in ProfileViewModel: \(profileEditError.description)")
                            self.showNicknameErrorAlert = true
                        }
                    } else {
                        print("Profile Edit Request Error for other reason in ProfileViewModel: \(error.localizedDescription)")
                        self.showNicknameErrorAlert = true
                    }
                }
            } receiveValue: { response in
                print("Getting Updated Profile Data from Server! Available Saved Token!")
                self.updateProfileClosure?(response)
                self.nicknameInputFromUser.removeAll()
            }
            .store(in: &self.cancellables)
    }
    
    private func requestRefreshToken(_ current: UserTokenValue, nickname: String, userId: String) {
        NetworkManager.shared.request(type: RefreshAccessTokenResponse.self, api: .refreshToken(request: RefreshAccessTokenRequest(refreshToken: current.refresh)), errorCase: .refreshToken)
            .sink { completion in
                if case .failure(let error) = completion {
                    if let refreshError = error as? NetworkError {
                        switch refreshError {
                        case .invalidToken(_):
                            print("Invalid For Both Access and Refresh. Needs to Sign In Again")
                            AuthManager.shared.handleRefreshTokenExpired(userId: userId)
                        default:
                            print("Refresh Token Error in MainTabsViewModel Initiailzation: \(refreshError.description)")
                            AuthManager.shared.handleRefreshTokenExpired(userId: userId)
                        }
                        //로그인 화면 이동하기
                        self.showSessionExpiredAlert = true
                    } else {
                        print("Refresh Token Error for other eason: \(error.localizedDescription) -- Needs to Sign In Again")
                        AuthManager.shared.handleRefreshTokenExpired(userId: userId)
                        //로그인 화면 이동하기
                        self.showSessionExpiredAlert = true
                    }
                }
            } receiveValue: { response in
                print("Update Token!!!")
                KeyChainManager.shared.update(UserTokenValue(access: response.accessToken, refresh: response.refreshToken), id: userId)
                
                print("Call ProfileRequest Again!!!")
                self.requestProfileEdit(UserTokenValue(access: response.accessToken, refresh: response.refreshToken), nickname: nickname, userId: userId)
            }
            .store(in: &self.cancellables)
    }
    
    func signOut(resultCompletion: @escaping (Bool) -> Void) {
        do {
            let userId = try UserDefaultsManager.shared.retrieveFromUserDefaults(forKey: Setup.UserDefaultsKeyStrings.userIdString) as String
            if let token = KeyChainManager.shared.read(userId) {
                NetworkManager.shared.request(type: Empty.self, api: .signOut(request: AuthorizationRequest(access: token.access)), errorCase: .signOut)
                    .sink { completion in
                        if case .failure(let error) = completion {
                            if let profileError = error as? NetworkError {
                                print("SignOut Error in ProfileViewModel: \(profileError.description)")
                            } else {
                                print("SignOut Error in ProfileViewModel for other reason: \(error.localizedDescription)")
                            }
                            resultCompletion(false)
                        }
                    } receiveValue: { _ in
                        print("Response for Sign Out Success!")
                        self.handleSignOutSucceed()
                        resultCompletion(true)
                    }
                    .store(in: &self.cancellables)
            } else {
                //No Token: Move to LogIn Again!!!
                print("No Token in ProfileView!!! Should Move to Log-In!!!")
                self.showSessionExpiredAlert = true
            }
        } catch {
            print("No Saved Email!!! Should Login!!!")
            self.showSessionExpiredAlert = true
        }
    }
    
    private func handleSignOutSucceed() {
        if let userId = try? UserDefaultsManager.shared.retrieveFromUserDefaults(forKey: Setup.UserDefaultsKeyStrings.userIdString) as String {
            //재로그인 및 다른 계정 로그인: 네트워크 콜 횟수 줄이기 목적
            AuthManager.shared.handleRefreshTokenExpired(userId: userId)
        }
    }
    
}
