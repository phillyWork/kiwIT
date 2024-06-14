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
    var serverLoginResultPublisher = PassthroughSubject<(Bool, String?, SignUpRequest?), Never>()

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
                self.serverLoginResultPublisher.send((false, ServiceProviderError.kakaoError.message, nil))
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
                self.serverLoginResultPublisher.send((false, ServiceProviderError.kakaoError.message, nil))
            }
            if let oAuthToken = oAuthToken {
                print("token for kakao user with kakao account: \(oAuthToken)")
                self.handleKakaoToken(oAuthToken)
            }
        }
    }
    
    private func handleKakaoToken(_ token: OAuthToken) {
        NetworkManager.shared.request(type: SignInResponse.self, api: .signIn(request: SignInRequest(token: token.accessToken, provider: .kakao)), errorCase: .signIn)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    if let signInError = error as? NetworkError {
                        self.serverLoginResultPublisher.send((false, signInError.description, nil))
                    } else {
                        self.serverLoginResultPublisher.send((false, error.localizedDescription, nil))
                    }
                }
            } receiveValue: { response in
                switch response {
                case .signInSuccess(let tokenResponse):
                    
                    //MARK: - 로그인 성공: Token 활용해서 profile 요청, 이메일 받아와서 UserDefaults 이메일과 동일한 지 체크
                    //MARK: - 동일하면 그대로 Update
                    //MARK: - 아니라면 기존 토큰 keychain에서 삭제, 그 후 기존 UserDefaults update 후 토큰 Keychain에 새로 Create
                    //MARK: - 존재하지 않다면 새로 UserDefaults에 추가, 그 후 토큰 keychain에 새로 create
                    
                                        
                    if let existingToken = KeyChainManager.shared.read() {
                        if KeyChainManager.shared.update(token: UserTokenValue(access: tokenResponse.accessToken, refresh: tokenResponse.refreshToken)) {
                            print("Login Succeed, Token Exists, Updated Token")
                            self.serverLoginResultPublisher.send((true, nil, nil))
                        } else {
                            print("Login Succeed, Token Exists, but Cannot Update Token")
                            //MARK: - Update Token Again or Exist and Move Up?
                            
                        }
                    } else {
                       
                        //MARK: - 로그인 성공, 기존 저장한 keychain 존재하지 않을 경우
                        
                        //MARK: - 이메일 먼저 userdefaults에 저장, 그 후 keychain 새로 생성하기
                        
                        //MARK: - 이메일 확인 위해선 Profile 요청으로 이메일 확인 필요...
                        
                        
                        
                        if KeyChainManager.shared.create(token: UserTokenValue(access: tokenResponse.accessToken, refresh: tokenResponse.refreshToken)) {
                            print("Login Succeed, Token Not Exist, Created Token")
                            self.serverLoginResultPublisher.send((true, nil, nil))
                        } else {
                            print("Login Succeed, Token Not Exist, but Cannot Create Token")
                            //MARK: - Create Token Again or Exist and Move Up?
                            
                        }
                    }
                    
//                    UserDefaultsManager.shared.saveToUserDefaults(newValue: tokenResponse.accessToken, forKey: "access")
//                    UserDefaultsManager.shared.saveToUserDefaults(newValue: tokenResponse.refreshToken, forKey: "refresh")
//                    self.serverLoginResultPublisher.send((true, nil, nil))
                    
                case .signUpRequired(let userData):
                    self.serverLoginResultPublisher.send((false, nil, SignUpRequest(email: userData.email, nickname: userData.nickname, provider: .kakao)))
                }
            }
            .store(in: &self.cancellables)
    }
        
}
