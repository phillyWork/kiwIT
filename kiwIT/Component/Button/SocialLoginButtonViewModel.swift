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
                    self.serverLoginResultPublisher.send((false, error.localizedDescription, nil))
                }
            } receiveValue: { response in
                switch response {
                case .signInSuccess(let tokenResponse):
                    //save token in keychain / userDefaults
                    
                    self.serverLoginResultPublisher.send((true, nil, nil))
                case .signUpRequired(let userData):
                    self.serverLoginResultPublisher.send((false, nil, SignUpRequest(email: userData.email, nickname: userData.nickname, provider: .kakao)))
                }
            }
            .store(in: &self.cancellables)
    }
        
}
