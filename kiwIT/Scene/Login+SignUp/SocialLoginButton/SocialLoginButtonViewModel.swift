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
    
    //Input
    let appleLoginRequest = PassthroughSubject<Result<ASAuthorization, Error>, Never>()
    let kakaoLoginRequest = PassthroughSubject<Void, Never>()
    
    //Output
    @Published var loginResult: (success: Bool, error: String?, profileData: ProfileResponse?, userDataToSignUp: SignUpRequest?)?

    var cancellables = Set<AnyCancellable>()
        
    init() {
        print("DEBUG -- Social Login Button ViewModel init")
        bind()
    }
    
    private func bind() {
        appleLoginRequest
            .debounce(for: .seconds(Setup.Time.debounceInterval), scheduler: RunLoop.main)
            .sink { [weak self] result in
                self?.handleAppleSignIn(result)
            }
            .store(in: &self.cancellables)
        
        kakaoLoginRequest
            .debounce(for: .seconds(Setup.Time.debounceInterval), scheduler: RunLoop.main)
            .sink { [weak self] in
                self?.requestKakaoUserLogin()
            }
            .store(in: &self.cancellables)
    }
    
    //MARK: - Apple Login
    
    private func handleAppleSignIn(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let success):
            requestAppleUserLogin(success)
        case .failure(let error):
            handleAppleSignInFailure()
        }
    }
    
    private func requestAppleUserLogin(_ authResult: ASAuthorization) {
        switch authResult.credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential:
            
            guard let identityToken = appleIDCredential.identityToken, let identityTokenInString = String(data: identityToken, encoding: .utf8) else {
                return
            }
            
            guard let authorizationCode = appleIDCredential.authorizationCode else {
                return
            }
            
            handleToken(identityTokenInString, service: .apple)
        default:
            handleAppleSignInFailure()
            break
        }
    }
    
    private func handleAppleSignInFailure() {
        loginResult = (false, ServiceProviderError.appleError.message, nil, nil)
    }
    
    //MARK: - Kakao Login

    private func requestKakaoUserLogin() {
        //kakao talk 앱 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            requestLoginWithKakaoTalkApp()
        } else {
            requestLoginWithKakaoWebAccount()
        }
    }
    
    private func requestLoginWithKakaoTalkApp() {
        UserApi.shared.loginWithKakaoTalk { oAuthToken, error in
            self.handleKakaoLoginResult(token: oAuthToken, error: error)
        }
    }
    
    private func requestLoginWithKakaoWebAccount() {
        UserApi.shared.loginWithKakaoAccount { oAuthToken, error in
            self.handleKakaoLoginResult(token: oAuthToken, error: error)
        }
    }
    
    private func handleKakaoLoginResult(token: OAuthToken?, error: Error?) {
        if let token = token {
            handleToken(token.accessToken, service: .kakao)
        } else {
            loginResult = (false, ServiceProviderError.kakaoError.message, nil, nil)
        }
    }

    //MARK: - Common
    
    private func handleToken(_ accessToken: String, service: SocialLoginProvider) {
        NetworkManager.shared.request(type: SignInResponse.self, api: .signIn(request: SignInRequest(token: accessToken, provider: service)), errorCase: .signIn)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    if let signInError = error as? NetworkError {
                        self?.loginResult = (false, signInError.description, nil, nil)
                    } else {
                        self?.loginResult = (false, error.localizedDescription, nil, nil)
                    }
                }
            } receiveValue: { [weak self] response in
                switch response {
                case .signInSuccess(let tokenResponse):
                    //로그인 성공: Token 활용해서 profile 요청, 이메일 받아오기
                    self?.requestProfile(tokenResponse) { profile in
                        guard let profile = profile else {
                            //프로필 얻어오기 에러: 현재 로그인한 계정 정보 모름
                            self?.loginResult = (true, nil, nil, nil)
                            return
                        }
                        self?.updateToken(token: tokenResponse, profile: profile)
                    }
                case .signUpRequired(let userData):
                    self?.loginResult = (false, nil, nil, SignUpRequest(email: userData.email, nickname: userData.nickname, provider: service))
                }
            }
            .store(in: &self.cancellables)
    }
    
    private func requestProfile(_ token: SignInResponseSuccess, returnCompletion: @escaping (ProfileResponse?) -> Void) {
        NetworkManager.shared.request(type: ProfileResponse.self, api: .profileCheck(request: AuthorizationRequest(access: token.accessToken)), errorCase: .profileCheck)
            .sink { completion in
                if case .failure(let error) = completion {
                    if let profileError = error as? NetworkError {
                        returnCompletion(nil)
                    } else {
                        returnCompletion(nil)
                    }
                }
            } receiveValue: { response in
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
        self.loginResult = (true, nil, profile, nil)
    }
    
    deinit {
        print("SocialLoginButtonViewModel DEINIT")
    }
        
}
