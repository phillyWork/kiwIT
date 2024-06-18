//
//  SignUpInfoView.swift
//  kiwIT
//
//  Created by Heedon on 3/12/24.
//

import SwiftUI

struct SignUpInfoView: View {

    @StateObject var signUpInfoVM: SignUpInfoViewModel
    @ObservedObject var mainTabBarVM: MainTabBarViewModel
    
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        ScrollView {
            Text("회원 가입 정보")
                .font(.custom(Setup.FontName.notoSansBold, size: 25))
                .padding(.vertical, 8)
            
            Group {
                HStack {
                    Text("이메일: ")
                    Text(signUpInfoVM.userDataForSignUp.email)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    Text("닉네임: ")
                    TextField("",
                              text: $signUpInfoVM.userDataForSignUp.nickname,
                              prompt: Text("닉네임 입력은 필수입니다")
                        .foregroundColor(Color.textPlaceholderColor)
                    )
                    .onSubmit {
                        signUpInfoVM.updateNicknameEmptiness()
                    }
                    .background(Color.brandBlandColor)
                    .foregroundStyle(Color.black)
                    .focused($isTextFieldFocused)
                }
                
                HStack {
                    Text("서비스: ")
                    HStack {
                        Image(systemName: signUpInfoVM.userDataForSignUp.provider == .apple ? Setup.ImageStrings.toggleButtonChecked : Setup.ImageStrings.toggleButtonUnchecked )
                            .foregroundStyle(Color.brandColor)
                        Text("애플")
                    }
                    HStack {
                        Image(systemName: signUpInfoVM.userDataForSignUp.provider == .kakao ? Setup.ImageStrings.toggleButtonChecked : Setup.ImageStrings.toggleButtonUnchecked )
                            .foregroundStyle(Color.brandColor)
                        Text("카카오")
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 8)
                
                ScrollView {
                    Text("동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...")
                        .foregroundStyle(Color.black)
                        .padding()
                }
                .frame(height: Setup.Frame.signUpConfirmScrollViewHeight)
                .background(Color.brandBlandColor)
            
                HStack {
                    Button(action: {
                        signUpInfoVM.isToggleSwitchOn.toggle()
                    }, label: {
                        Image(systemName: signUpInfoVM.isToggleSwitchOn ? Setup.ImageStrings.toggleButtonChecked : Setup.ImageStrings.toggleButtonUnchecked)
                            .imageScale(.large)
                            .foregroundStyle(Color.brandColor)
                    })
                    Text("안내 사항을 확인하고 동의합니다")
                        .foregroundStyle(Color.textColor)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 8)
                
            }
            
            Spacer()
            
            ShrinkAnimationButtonView(title: signUpInfoVM.isToggleSwitchOn && !signUpInfoVM.isNicknameEmpty ? "회원 가입" : "필수 사항 입력이 우선됩니다", color: signUpInfoVM.isToggleSwitchOn && !signUpInfoVM.isNicknameEmpty ? Color.brandColor : Color.errorHighlightColor) {
                
                if signUpInfoVM.isToggleSwitchOn && !signUpInfoVM.isNicknameEmpty {
                    signUpInfoVM.requestSignUp()
                } else {
                    signUpInfoVM.showSignUpRequestIsNotSetAlert.toggle()
                }
                
            }
            .padding(.vertical, 12)
            .alert("회원 가입을 시도할 수 없습니다", isPresented: $signUpInfoVM.showSignUpRequestIsNotSetAlert, actions: { }, message: {
                Text("닉네임을 입력해주시고 안내 사항을 체크해주셔야 회원 가입을 할 수 있습니다")
            })
        }
        .frame(maxHeight: .infinity)
        .padding(.horizontal, 8)
        .background(Color.backgroundColor)
        .onChange(of: signUpInfoVM.didSignUpSucceed) { newValue in
            if newValue {
                print("Sign Up and Login Succeed!!! Move to TabViews")
                mainTabBarVM.isUserLoggedIn = true
            }
        }
    }
}

#Preview {
    SignUpInfoView(signUpInfoVM: SignUpInfoViewModel(userDataForSignUp: SignUpRequest(email: "aaa@bbb.com", nickname: "abcabc123123", provider: SocialLoginProvider.apple)), mainTabBarVM: MainTabBarViewModel())
}
