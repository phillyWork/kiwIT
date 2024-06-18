//
//  SignUpInfoViewModel.swift
//  kiwIT
//
//  Created by Heedon on 6/9/24.
//

import Foundation

import Combine

final class SignUpInfoViewModel: ObservableObject {
    
    var userDataForSignUp: SignUpRequest
    
    @Published var isToggleSwitchOn = false
    @Published var isNicknameEmpty = false
    @Published var showSignUpRequestIsNotSetAlert = false
    @Published var didSignUpSucceed = false
    
    var cancellables = Set<AnyCancellable>()
    
    init(userDataForSignUp: SignUpRequest) {
        print("DEBUG - initialize SignUpInfo ViewModel")
        self.userDataForSignUp = userDataForSignUp
    }
        
    func updateNicknameEmptiness() {
       isNicknameEmpty = userDataForSignUp.nickname.isEmpty
    }
    
    //가입 화면에서 작성한 모든 정보 기반으로 요청
    func requestSignUp() {
        print("data so far to request signup: \(userDataForSignUp)")
        
        NetworkManager.shared.request(type: SignUpResponse.self, api: .signUp(request: userDataForSignUp), errorCase: .signUp)
            .sink { completion in
                switch completion {
                case .finished:
                    print("Sign Up Request Succeed!!! End of Network")
                case .failure(let error):
                    print("Error For Sign Up Request: \(error.localizedDescription)")
                }
            } receiveValue: { response in
                print("SignUpRequest Response: \(response)")
                self.updateToken(token: response, newEmail: self.userDataForSignUp.email)
            }
            .store(in: &self.cancellables)
    }
    
    private func updateToken(token: SignUpResponse, newEmail: String) {
        //새로 가입 성공: 기존 저장된 Keychain 삭제, 그 후 새롭게 UserDefaults와 Keychain create
        KeyChainManager.shared.deleteAll()
        
        UserDefaultsManager.shared.saveToUserDefaults(newValue: newEmail, forKey: Setup.UserDefaultsKeyStrings.emailString)
        
        KeyChainManager.shared.create(token: UserTokenValue(access: token.accessToken, refresh: token.refreshToken))
        
        self.didSignUpSucceed = true
        
        print("Success in Sign Up, Update UserDefaults, Create New Token in KeyChain")
    }
    
}
