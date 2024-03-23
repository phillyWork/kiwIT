//
//  LoginView.swift
//  kiwIT
//
//  Created by Heedon on 3/12/24.
//

import SwiftUI

//해당 view로 오는 경우
//1. 처음 앱을 설치한 경우 (keychain에 저장된 token 없음)
//2. 로그아웃 되어서 다시 로그인해야 하는 경우 (refresh token 만료)

struct SocialLoginView: View {
    
    @StateObject private var socialLoginVM = SocialLoginViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Text(Setup.ContentStrings.appTitle)
                .font(.title)
            Spacer(minLength: 50)
            VStack(alignment: .center, spacing: 10) {
                SocialLoginButton(service: .apple)
                SocialLoginButton(service: .google)
                SocialLoginButton(service: .kakao)
            }
            .frame(width: Setup.Frame.socialLoginButtonWidth, height: Setup.Frame.socialLoginButtonStackHeight)
        }
        .onChange(of: socialLoginVM.didLoginSucceed) { newValue in
            if newValue {
                print("Login Succeed. Move to HomeView")
                dismiss()
            }
        }
        .onChange(of: socialLoginVM.shouldMoveToSignUp) { newValue in
            if newValue {
                print("New User! Move to SignUpInfoView")
                dismiss()
            }
        }
    }
}

#Preview {
    SocialLoginView()
}
