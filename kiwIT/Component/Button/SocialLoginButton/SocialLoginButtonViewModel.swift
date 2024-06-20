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
        NetworkManager.shared.request(type: SignInResponse.self, api: .signIn(request: SignInRequest(token: token.accessToken, provider: .kakao)), errorCase: .signIn)
            .sink { completion in
                if case .failure(let error) = completion {
                    if let signInError = error as? NetworkError {
                        print("SignInError as Network: \(signInError.description)")
                        self.serverLoginResultPublisher.send((false, signInError.description, nil, nil))
                    } else {
                        print("SignInError as other reason")
                        self.serverLoginResultPublisher.send((false, error.localizedDescription, nil, nil))
                    }
                }
            } receiveValue: { response in
                print("response from signIn: \(response)")
                switch response {
                case .signInSuccess(let tokenResponse):
                    //로그인 성공: Token 활용해서 profile 요청, 이메일 받아오기
                    self.requestProfile(tokenResponse) { profile in
                        print("Profile Passed From RequestProfile!!!")
                        guard let profile = profile else {
                            //프로필 얻어오기 에러: 현재 로그인한 계정 이메일 모름
                            //기존 키체인 삭제, 일회성 로그인으로 처리하기
                            //다음 로그인 체크 시, 저장된 토큰 없으므로 새로 로그인하기
                            print("Error for Profile Request!!!")
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
    
    private func requestProfile(_ token: SignInResponseSuccess, returnCompletion: @escaping (ProfileResponse?) -> Void) {
        print("Request for Profile Id to update Token Data")
        NetworkManager.shared.request(type: ProfileResponse.self, api: .profileCheck(request: AuthorizationRequest(access: token.accessToken)), errorCase: .profileCheck)
            .sink { completion in
                if case .failure(let error) = completion {
                    if let profileError = error as? NetworkError {
                        print("Error for Profile Id in SignIn: \(profileError.description)")
                        returnCompletion(nil)
                    } else {
                        print("Error for Profile Id in SignIn: \(error.localizedDescription)")
                        returnCompletion(nil)
                    }
                }
            } receiveValue: { response in
                print("Profile Response in requestProfile: \(response)")
                returnCompletion(response)
            }
            .store(in: &self.cancellables)
    }
    
    private func updateToken(token: SignInResponseSuccess, profile: ProfileResponse) {
        if let userId = try? UserDefaultsManager.shared.retrieveFromUserDefaults(forKey: Setup.UserDefaultsKeyStrings.userIdString) as String, userId == String(profile.id) {
            KeyChainManager.shared.update(UserTokenValue(access: token.accessToken, refresh: token.refreshToken), id: userId)
        } else {
            UserDefaultsManager.shared.saveToUserDefaults(newValue: String(profile.id), forKey: Setup.UserDefaultsKeyStrings.userIdString)
            KeyChainManager.shared.create(UserTokenValue(access: token.accessToken, refresh: token.refreshToken), id: String(profile.id))
        }
        self.serverLoginResultPublisher.send((true, nil, profile, nil))
    }
        
}
