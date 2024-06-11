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
    
    //ObservedObject: 상위 뷰 및 전체에서 활용
    //StateObject: 해당 뷰의 생명주기 동안만 상태 유지
    
    @StateObject private var socialLoginVM = SocialLoginViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(Setup.ContentStrings.appTitle)
                    .font(.title)
                Spacer(minLength: 50)
                VStack(alignment: .center, spacing: 10) {
                    SocialLoginButtonView(service: .apple)
                    SocialLoginButtonView(service: .kakao)
                }
                .frame(width: Setup.Frame.socialLoginButtonWidth, height: Setup.Frame.socialLoginButtonStackHeight)
            }
            .onChange(of: socialLoginVM.didLoginSucceed) { newValue in
                if newValue {
                    print("Login Succeed. Move to HomeView")
                    dismiss()
                } else {
                    print("Not Succeeding in Login")
                }
            }
            .navigationDestination(isPresented: $socialLoginVM.shouldMoveToSignUp) {
                let _ = print("navigationDestination???: \(socialLoginVM.shouldMoveToSignUp)")
                if let userDataForSignUp = socialLoginVM.userDataForSignUp {
                    let _ = print("data to pass to signup: \(userDataForSignUp)")
                    SignUpInfoView(signUpInfoVM: SignUpInfoViewModel(userDataForSignUp: userDataForSignUp))
                } else {
                    let _ = print("---Empty View---")
                }
            }
        }
    }
}

#Preview {
    SocialLoginView()
}
