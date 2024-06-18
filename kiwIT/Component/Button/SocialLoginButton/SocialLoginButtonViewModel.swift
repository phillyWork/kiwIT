//
//  SocialLoginButtonViewModel.swift
//  kiwIT
//
//  Created by Heedon on 6/11/24.
//

import Foundation

import Combine

import AuthenticationServices

import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

//Service Provider에게서 받은 Token 전달하기

final class SocialLoginButtonViewModel: ObservableObject {
    
    var cancellables = Set<AnyCancellable>()
    var serverLoginResultPublisher = PassthroughSubject<(Bool, String?, ProfileResponse?, SignUpRequest?), Never>()

    init() {
        print("DEBUG -- Social Login Button ViewModel init")
    }
    
    //MARK: - Apple Login
    
    func requestAppleUserLogin(_ credential: ASAuthorizationCredential) {
        switch credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential: break
            //Network 모델로 로그인 요청
            
                //성공 시, access 및 refresh token response
            
                //self.didLoginSucceed = true
            
                //실패 시, 가입 화면으로 이동 요청 (by HTTP response code)
            
                //self.shouldMoveToSignUp = true
        default:
            break
        }
    }
    
    //MARK: - Kakao Login

    func requestKakaoUserLogin() {
        //kakao talk 앱 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            requestLoginWithKakaoTalkApp()
        } else {
            requestLoginWithKakaoWebAccount()
        }
    }
    
    private func requestLoginWithKakaoTalkApp() {
        UserApi.shared.loginWithKakaoTalk { oAuthToken, error in
            if let error = error {
                print("Login with Kakao Talk Error: \(error)")
                //token 받아오기 실패
                self.serverLoginResultPublisher.send((false, ServiceProviderError.kakaoError.message, nil, nil))
            }
            if let oAuthToken = oAuthToken {
                print("token for kakao user with kakaoTalk: \(oAuthToken)")
                self.handleKakaoToken(oAuthToken)
            }
        }
    }
    
    private func requestLoginWithKakaoWebAccount() {
        UserApi.shared.loginWithKakaoAccount { oAuthToken, error in
            if let error = error {
                print("Login with Kakao User Account Error: \(error)")
                //token 받아오기 실패 시 처리할 방안
                self.serverLoginResultPublisher.send((false, ServiceProviderError.kakaoError.message, nil, nil))
            }
            if let oAuthToken = oAuthToken {
                print("token for kakao user with kakao account: \(oAuthToken)")
                self.handleKakaoToken(oAuthToken)
            }
        }
    }
    
    private func handleKakaoToken(_ token: OAuthToken) {
        
        //MARK: - Save Kakao Token to KeyChain
        
        
        NetworkManager.shared.request(type: SignInResponse.self, api: .signIn(request: SignInRequest(token: token.accessToken, provider: .kakao)), errorCase: .signIn)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    if let signInError = error as? NetworkError {
                        print("SignInError as Network: \(signInError.description)")
                        self.serverLoginResultPublisher.send((false, signInError.description, nil, nil))
                    } else {
                        print("SignInError as other reason: \(error.localizedDescription)")
                        self.serverLoginResultPublisher.send((false, error.localizedDescription, nil, nil))
                    }
                }
            } receiveValue: { response in
                print("response from signIn: \(response)")
                switch response {
                case .signInSuccess(let tokenResponse):
                    //로그인 성공: Token 활용해서 profile 요청, 이메일 받아오기
                    self.requestProfileEmail(tokenResponse) { profile in
                        print("Profile Passed From RequestProfile!!!")
                        guard let profile = profile else {
                            //프로필 얻어오기 에러: 현재 로그인한 계정 이메일 모름
                            //기존 키체인 삭제, 일회성 로그인으로 처리하기
                            //다음 로그인 체크 시, 저장된 토큰 없으므로 새로 로그인하기
                            print("Error for Profile Request!!!")
                            KeyChainManager.shared.delete()
                            self.serverLoginResultPublisher.send((true, nil, nil, nil))
                            return
                        }
                        self.updateToken(token: tokenResponse, profile: profile)
                    }
                case .signUpRequired(let userData):
                    self.serverLoginResultPublisher.send((false, nil, nil, SignUpRequest(email: userData.email, nickname: userData.nickname, provider: .kakao)))
                }
            }
            .store(in: &self.cancellables)
    }
    
    private func requestProfileEmail(_ token: SignInResponseSuccess, returnCompletion: @escaping (ProfileResponse?) -> Void) {
        print("Request for Profile Email to update Token Data")
        NetworkManager.shared.request(type: ProfileResponse.self, api: .profileCheck(request: AuthorizationRequest(access: token.accessToken)), errorCase: .profileCheck)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print("Error for Profile Email in SignIn: \(error.localizedDescription)")
                    returnCompletion(nil)
                }
            } receiveValue: { response in
                print("Profile Response in Email: \(response)")
                returnCompletion(response)
            }
            .store(in: &self.cancellables)
    }
    
    private func updateToken(token: SignInResponseSuccess, profile: ProfileResponse) {
        //UserDefaults 저장된 이메일과 동일한 지 체크
        do {
            let savedEmail = try UserDefaultsManager.shared.retrieveFromUserDefaults(forKey: Setup.UserDefaultsKeyStrings.emailString) as String
            if savedEmail == profile.email {
                //동일: 해당 이메일 활용, 토큰 Update
                if KeyChainManager.shared.update(token: UserTokenValue(access: token.accessToken, refresh: token.refreshToken)) {
                    print("Login Succeed, Token Exists, Updated Token")
                } else {
                    print("Login Succeed, Token Exists, but Cannot Update Token")
                }
               
                //토큰 업데이트 하지 못하더라도 어차피 다음 session에서 다시 체크
                //기존 토큰 만료되었으므로 refresh request 혹은 login request 다시 시도함
                self.serverLoginResultPublisher.send((true, nil, profile, nil))
                
                print("Same Email as Before, Done Anyhow for checking later...")
            } else {
                //동일X: 기존 토큰 keychain에서 삭제, UserDefaults update 후 토큰 Keychain에 새로 Create
                if KeyChainManager.shared.delete() {
                    print("Deleting Token from Keychain Succeed!")
                } else {
                    print("Deleting Token from Keychain Failed!!!")
                }
                
                UserDefaultsManager.shared.saveToUserDefaults(newValue: profile.email, forKey: Setup.UserDefaultsKeyStrings.emailString)
                
                KeyChainManager.shared.create(token: UserTokenValue(access: token.accessToken, refresh: token.refreshToken))
                
                self.serverLoginResultPublisher.send((true, nil, profile, nil))
                
                print("Not Same Email as Before, Updated UserDefaults, Created Token")
            }
        } catch {
            print("Error for getting email -- No Saved Email")
            //UserDefaults에 존재 X: 새로 email 추가, 그 후 토큰 keychain에 새로 create
            UserDefaultsManager.shared.saveToUserDefaults(newValue: profile.email, forKey: Setup.UserDefaultsKeyStrings.emailString)
            
            KeyChainManager.shared.create(token: UserTokenValue(access: token.accessToken, refresh: token.refreshToken))
            
            self.serverLoginResultPublisher.send((true, nil, profile, nil))
            
            print("No Saved Email, Updated UserDefaults, Created Token")
        }
    }
        
}
