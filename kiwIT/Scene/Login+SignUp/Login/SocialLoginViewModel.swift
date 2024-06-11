//
//  SocialLoginViewModel.swift
//  kiwIT
//
//  Created by Heedon on 3/12/24.
//

import Foundation

import Combine

import AuthenticationServices

import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

final class SocialLoginViewModel: ObservableObject {
    
    @Published var didLoginSucceed = false
    @Published var shouldMoveToSignUp = false
    
    var userDataForSignUp: SignUpRequest? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        print("DEBUG: SocialLoginViewModel initialized")
    }
    
    //Social Login Button ViewModel에서 서버 로그인 성공 시,
    //Token 일반화 가능하면 함수 하나로 처리, 아니라면 각자 생성
    func requestLogin() {
        
    }
    
    //MARK: - Apple Login
    
    func requestAppleUserLogin(_ credential: ASAuthorizationCredential) {
        print("Request to Server for User's Access and Refresh Token")
        
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
    
    //async, await 활용: @MainActor로 Task로 호출한 Published 변화 추적: Main thread에서 되도록 처리하기
    
    func requestKakaoUserLogin() {
        //kakao talk 앱 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            requestLoginWithKakaoTalkApp()
        } else {
            requestLoginWithKakaoWebAccount()
        }
    }
    
    func requestLoginWithKakaoTalkApp() {
        UserApi.shared.loginWithKakaoTalk { oAuthToken, error in
            if let error = error {
                print("Login with Kakao Talk Error: \(error)")
                //token 받아오기 실패 시 처리할 방안
                
            }
            //token 받아옴
            if let oAuthToken = oAuthToken {
                print("token for kakao user with kakaoTalk: \(oAuthToken)")
                print("accessToken: \(oAuthToken.accessToken)")
                print("scopes: \(oAuthToken.scopes)")

                //Network 모델로 로그인 요청
                //Token 서버에 전달하기
//                let signInRequest = SignInRequest(token: oAuthToken.accessToken, provider: SocialLoginProvider.kakao)
//                
//                NetworkManager.shared.request(type: SignInResponse.self, api: Router.signIn(request: signInRequest), errorCase: .signIn)
                    
                
                //성공 시, access 및 refresh token 저장 및 didLoginSucceed update
                
                
                //싪패 시, error Message 통한 어떤 action 취할 지 결정하기
                
                
                //회원가입 필요한 실패: 회원가입 화면으로 넘어가기 및 데이터 넘기기? Or 동일한 ViewModel 활용?
                self.userDataForSignUp = SignUpRequest(email: "", nickname: "", provider: SocialLoginProvider.kakao)
                self.shouldMoveToSignUp = true
            }
        }
    }
    
    func requestLoginWithKakaoWebAccount() {
        UserApi.shared.loginWithKakaoAccount { oAuthToken, error in
            if let error = error {
                print("Login with Kakao User Account Error: \(error)")
                //token 받아오기 실패 시 처리할 방안
                
            }
            if let oAuthToken = oAuthToken {
                print("token for kakao user with kakao account: \(oAuthToken)")
                             
                NetworkManager.shared.request(type: SignInResponse.self, api: .signIn(request: SignInRequest(token: oAuthToken.accessToken, provider: SocialLoginProvider.kakao)), errorCase: .signIn)
                    .sink { completion in
                        switch completion {
                        case .finished:
                            if self.shouldMoveToSignUp {
                                if let data = self.userDataForSignUp {
                                    SignUpInfoViewModel(userDataForSignUp: data)
                                }
                            }
                            break
                        case .failure(let error):
                            //싪패 시, error Message 통한 어떤 action 취할 지 결정하기
                            print("Login Failed!!! - \(error.localizedDescription)")
                            
                        }
                    } receiveValue: { response in
                        print("Received response: \(response)")
                        
                        switch response {
                        case .signInSuccess(let tokenResponse):
                            print("token from server: \(tokenResponse)")
                            //성공한 경우: access 및 refresh token 받아옴 ~ 해당 토큰 저장하기
                            
                            self.didLoginSucceed = true
                        case .signUpRequired(let userData):
                            //회원가입 필요: 회원가입 화면으로 넘어가기 및 데이터 넘기기
                            self.userDataForSignUp = SignUpRequest(email: userData.email, nickname: userData.nickname, provider: SocialLoginProvider.kakao)
                            self.shouldMoveToSignUp = true
                        }
                    }
                    .store(in: &self.cancellables)
            }
        }
    }

    
}
