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
        
        //MARK: - 네트워크 Signup 시도하기
        
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
                
                //새로 가입, 이미 가입한 다른 이메일 계정 존재 시
                if let existingToken = KeyChainManager.shared.read() {
                    //해당 계정 Keychain 삭제 및 새로 등록하기
                    
                    
                    
                    if KeyChainManager.shared.delete() {
                        
                    }
                    if KeyChainManager.shared.create(token: UserTokenValue(access: response.accessToken, refresh: response.refreshToken)) {
                        print("SignUp Succeed, Created Token")
                    } else {
                        
                    }
                } else {
                    if KeyChainManager.shared.create(token: UserTokenValue(access: response.accessToken, refresh: response.refreshToken)) {
                        print("SignUp Succeed, Created Token")
                    } else {
                        
                    }

                }
                
//                UserDefaultsManager.shared.saveToUserDefaults(newValue: response.accessToken, forKey: "accessToken")
//                UserDefaultsManager.shared.saveToUserDefaults(newValue: response.refreshToken, forKey: "refreshToken")
//                print("Sign Up Succeed!")
//                self.didSignUpSucceed = true
                
            }
            .store(in: &self.cancellables)
    }
    
}
