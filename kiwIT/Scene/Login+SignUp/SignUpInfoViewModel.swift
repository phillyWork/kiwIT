//
//  SignUpInfoViewModel.swift
//  kiwIT
//
//  Created by Heedon on 6/9/24.
//

import Foundation

import Combine

final class SignUpInfoViewModel: ObservableObject {
        
    @Published var isToggleSwitchOn = false
    @Published var isNicknameEmpty = false
    @Published var showSignUpRequestIsNotSetAlert = false
    @Published var didSignUpSucceed = false
    @Published var showSignUpErrorAlert = false

    private var cancellables = Set<AnyCancellable>()

    var userDataForSignUp: SignUpRequest
    var signedUpProfile: ProfileResponse?
    
    init(userDataForSignUp: SignUpRequest) {
        print("DEBUG - initialize SignUpInfo ViewModel")
        self.userDataForSignUp = userDataForSignUp
        print("DEBUG - initialize SignUpInfo ViewModel Done")
    }
        
    func updateNicknameEmptiness() {
       isNicknameEmpty = userDataForSignUp.nickname.isEmpty
    }
    
    //가입 화면에서 작성한 모든 정보 기반으로 요청
    func requestSignUp() {
        print("data so far to request signup: \(userDataForSignUp)")
        
        NetworkManager.shared.request(type: SignUpResponse.self, api: .signUp(request: userDataForSignUp), errorCase: .signUp)
            .sink { completion in
                if case .failure(let error) = completion {
                    if let signUpError = error as? NetworkError {
                        switch signUpError {
                        case .invalidRequestBody(_):
                            print("Nickname Duplicated or Cannot SignUp!! -- \(signUpError.description)")
                        default:
                            print("other reason for signup network error: \(signUpError.description)")
                        }
                    } else {
                        print("Error For Sign Up Request for other reason: \(error.localizedDescription)")
                    }
                    self.showSignUpErrorAlert = true
                }
            } receiveValue: { response in
                print("SignUpRequest Response: \(response)")
                self.requestProfile(response)
            }
            .store(in: &self.cancellables)
    }
    
    private func requestProfile(_ userToken: SignUpResponse) {
        NetworkManager.shared.request(type: ProfileResponse.self, api: .profileCheck(request: AuthorizationRequest(access: userToken.accessToken)), errorCase: .profileCheck)
            .sink { completion in
                if case .failure(let error) = completion {
                    if let profileError = error as? NetworkError {
                        print("Profile Check Error in SignUp!! -- \(profileError.description)")
                    } else {
                        print("Error For Sign Up Request for other reason: \(error.localizedDescription)")
                    }
                    self.didSignUpSucceed = true
                }
            } receiveValue: { response in
                self.updateToken(token: userToken, profile: response)
            }
            .store(in: &self.cancellables)
    }
    
    private func updateToken(token: SignUpResponse, profile: ProfileResponse) {
        //새로 가입 성공: 기존 저장된 Keychain 삭제, 그 후 새롭게 UserDefaults와 Keychain create
        KeyChainManager.shared.deleteAll()
        
        UserDefaultsManager.shared.saveToUserDefaults(newValue: String(profile.id), forKey: Setup.UserDefaultsKeyStrings.userIdString)
        
        KeyChainManager.shared.create(UserTokenValue(access: token.accessToken, refresh: token.refreshToken), id: String(profile.id))
        
        signedUpProfile = profile
        didSignUpSucceed = true
        
        print("Success in Sign Up, Update UserDefaults, Create New Token in KeyChain")
    }
    
}
