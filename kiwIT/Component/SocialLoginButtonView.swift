//
//  AppleSignInButton.swift
//  kiwIT
//
//  Created by Heedon on 3/14/24.
//

import SwiftUI
import AuthenticationServices

//버튼 누른 뒤, 이미 가입되어 있다면 로그인 화면 제거, HomeView로 이동
//가입되어 있지 않다면 회원가입 view로

struct SocialLoginButtonView: View {
    
    var service: SocialLoginProvider
    
    private let socialLoginVM = SocialLoginViewModel()
    
    var body: some View {
        switch service {
        case .apple:
            SignInWithAppleButton { request in
                //Sign in Apple Action with request (요청할 정보)
                request.requestedScopes = [.email]
            } onCompletion: { result in
                switch result {
                case .success(let authResult):
                    print("Succeed in Sign in Apple")
                    socialLoginVM.requestAppleUserLogin(authResult.credential)
                case .failure(let error):
                    //실패: 유저 허가하지 않음
                    print("Failed in Sign in Apple: \(error.localizedDescription)")
                }
            }
        case .google:
            Button {
                print("Google Sign In Button Tapped")
            } label: {
                Text("Google Sign In Button")
            }
            //            GoogleSignInButton()
        case .kakao:
            Button {
                //Kakao Login Action
                print("Kakao Login Button Tapped")
            } label: {
                //Kakao Login Button Image
                Text("Kakao Login Button")
            }
            
        }
    }
    
}

#Preview {
    SocialLoginButtonView(service: .apple)
}
