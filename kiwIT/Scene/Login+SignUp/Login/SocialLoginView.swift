//
//  LoginView.swift
//  kiwIT
//
//  Created by Heedon on 3/12/24.
//

import SwiftUI

import Combine

//버튼 누른 뒤, 이미 가입되어 있다면 로그인 화면 제거, HomeView로 이동
//가입되어 있지 않다면 회원가입 view로

//구조
//1. SocialLoginView ~ SocialLoginVM
//2. SocialLoginButton ~ SocialLoginButtonVM
//3. SocialLoginButton tap: SocialLoginButtonVM requestLogin
//4. request 결과 ~ 로그인 성공 / 회원가입 필요 / 실패
//5-1. 로그인 성공 --> SocialLoginVM의 didSucceedLogin 변경
//5-2. 회원가입 필요 --> SocialLoginVM의 shouldMoveToSignUp 변경
//5-3. 실패 --> 에러 케이스 처리 필요

//해당 view로 오는 경우
//1. 처음 앱을 설치한 경우 (keychain에 저장된 token 없음)
//2. 로그아웃 되어서 다시 로그인해야 하는 경우 (refresh token 만료)

struct SocialLoginView: View {
    
    //ObservedObject: 해당 뷰 및 상위 뷰에서 활용 ~ 뷰가 다시 그려지면 초기화 다시 됨
    //StateObject: 해당 뷰의 생명주기 동안만 상태 유지
    
    @StateObject private var socialLoginVM = SocialLoginViewModel()
    @ObservedObject var mainTabBarVM: MainTabBarViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                SignInMainImageView()
                Spacer()
                VStack(alignment: .center, spacing: 10) {
                    LazyView(SocialLoginButtonView(socialLoginVM: socialLoginVM, service: .apple))
                        .frame(width: Setup.Frame.socialLoginButtonWidth, height: Setup.Frame.socialLoginButtonHeight)
                    LazyView(SocialLoginButtonView(socialLoginVM: socialLoginVM, service: .kakao)).frame(width: Setup.Frame.socialLoginButtonWidth, height: Setup.Frame.socialLoginButtonHeight)
                }
                .padding(.vertical, 8)
            }
            .frame(maxWidth: .infinity)
            .background(Color.backgroundColor)
            .onChange(of: socialLoginVM.didLoginSucceed) { newValue in
                if newValue {
                    if let profile = socialLoginVM.profileData {
                        mainTabBarVM.userProfileInput.send(profile)
                    }
                    mainTabBarVM.checkLoginStatus.send(true)
                }
            }
            .alert(Setup.ContentStrings.loginErrorAlertTitle, isPresented: $socialLoginVM.showLoginErrorAlert, actions: {
                ErrorAlertConfirmButton { }
            }, message: {
                Text(Setup.ContentStrings.loginTryErrorAlertMessage)
            })
            .navigationDestination(isPresented: $socialLoginVM.shouldMoveToSignUp) {
                if let userDataForSignUp = socialLoginVM.userDataForSignUp {
                    SignUpInfoView(signUpInfoVM: SignUpInfoViewModel(userDataForSignUp: userDataForSignUp), mainTabBarVM: mainTabBarVM)
                }
            }
        }
    }
}

#Preview {
    SocialLoginView(mainTabBarVM: MainTabBarViewModel())
}
