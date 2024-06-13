//
//  AppleSignInButton.swift
//  kiwIT
//
//  Created by Heedon on 3/14/24.
//

import SwiftUI

import AuthenticationServices

//1. SocialLoginView ~ SocialLoginVM
//2. SocialLoginButton ~ SocialLoginButtonVM
//3. SocialLoginButton tap: SocialLoginButtonVM requestLogin
//4. request 결과 ~ 로그인 성공 / 회원가입 필요 / 실패
//5-1. 로그인 성공 --> SocialLoginVM의 didSucceedLogin 변경
//5-2. 회원가입 필요 --> SocialLoginVM의 shouldMoveToSignUp 변경
//5-3. 실패 --> 에러 케이스 처리 필요

struct SocialLoginButtonView: View {
    
    @StateObject private var socialLoginButtonVM = SocialLoginButtonViewModel()
    @ObservedObject var socialLoginVM: SocialLoginViewModel
    
    var service: SocialLoginProvider
    
    var body: some View {     
        AnyView(loginButton)
            .onAppear {
                socialLoginButtonVM.serverLoginResultPublisher
                    .sink { success, error, userData in
                        socialLoginVM.handleSocialLoginResult(success: success, errorMessage: error, userData: userData)
                    }
                    .store(in: &socialLoginButtonVM.cancellables)
            }
    }
    
    @ViewBuilder
    private var loginButton: some View {
        switch service {
        case .apple:
            SignInWithAppleButton { request in
                //Sign in Apple Action with request (요청할 정보)
                request.requestedScopes = [.email, .fullName]
            } onCompletion: { result in
                switch result {
                case .success(let authResult):
                    print("Succeed in Sign in Apple")
                    socialLoginButtonVM.requestAppleUserLogin(authResult.credential)
                case .failure(let error):
                    //실패: 유저 허가하지 않음
                    print("Failed in Sign in Apple: \(error.localizedDescription)")
                }
            }
        case .kakao:
            Button {
                socialLoginButtonVM.requestKakaoUserLogin()
            } label: {
                //Kakao Login Button Image
                Text("Kakao Login Button")
            }
        }
    }
    
}

#Preview {
    SocialLoginButtonView(socialLoginVM: SocialLoginViewModel(), service: .apple)
}
