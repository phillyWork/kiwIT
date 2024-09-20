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
            Text(Setup.ContentStrings.SignUp.userInfo)
                .font(.custom(Setup.FontName.notoSansBold, size: 25))
                .padding(.vertical, 8)
            
            Group {
                HStack {
                    Text(Setup.ContentStrings.SignUp.email)
                    Text(signUpInfoVM.userDataForSignUp.email)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack {
                    Text(Setup.ContentStrings.SignUp.nickname)
                    TextField("",
                              text: $signUpInfoVM.userDataForSignUp.nickname,
                              prompt: Text(Setup.ContentStrings.SignUp.requiredToFillInNickname)
                        .foregroundColor(Color.textPlaceholderColor)
                    )
                    .onSubmit {
                        signUpInfoVM.nicknameSubmitTab.send(())
                    }
                    .background(Color.brandBlandColor)
                    .foregroundStyle(Color.black)
                    .focused($isTextFieldFocused)
                }
                
                HStack {
                    Text(Setup.ContentStrings.SignUp.serviceProvider)
                    HStack {
                        Image(systemName: signUpInfoVM.userDataForSignUp.provider == .apple ? Setup.ImageStrings.toggleButtonChecked : Setup.ImageStrings.toggleButtonUnchecked )
                            .foregroundStyle(Color.brandColor)
                        Text(Setup.ContentStrings.SignUp.apple)
                    }
                    HStack {
                        Image(systemName: signUpInfoVM.userDataForSignUp.provider == .kakao ? Setup.ImageStrings.toggleButtonChecked : Setup.ImageStrings.toggleButtonUnchecked )
                            .foregroundStyle(Color.brandColor)
                        Text(Setup.ContentStrings.SignUp.kakao)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.vertical, 8)
                
                ScrollView {
                    Text(Setup.ContentStrings.SignUp.infoToBeGiven)
                        .foregroundStyle(Color.black)
                        .padding()
                }
                .frame(height: Setup.Frame.signUpConfirmScrollViewHeight)
                .background(Color.brandBlandColor)
            
                HStack {
                    Button {
                        signUpInfoVM.toggleSwitchTab.send(())
                    } label: {
                        Image(systemName: signUpInfoVM.isToggleSwitchOn ? Setup.ImageStrings.toggleButtonChecked : Setup.ImageStrings.toggleButtonUnchecked)
                            .imageScale(.large)
                            .foregroundStyle(Color.brandColor)
                    }
                    Text(Setup.ContentStrings.SignUp.checkInfoAndAgree)
                        .foregroundStyle(Color.textColor)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 8)
            }
            
            Spacer()
            
            ShrinkAnimationButtonView(title: signUpInfoVM.isToggleSwitchOn && !signUpInfoVM.isNicknameEmpty ? Setup.ContentStrings.SignUp.signUpText : Setup.ContentStrings.SignUp.cannotSignUpText, font: Setup.FontName.galMuri11Bold, color: signUpInfoVM.isToggleSwitchOn && !signUpInfoVM.isNicknameEmpty ? Color.brandColor : Color.errorHighlightColor) {
                signUpInfoVM.signUpRequestButtonTab.send(())
            }
            .padding(.vertical, 12)
            .alert(Setup.ContentStrings.SignUp.notReadyToSignUpErrorAlertTitle, isPresented: $signUpInfoVM.showSignUpRequestIsNotSetAlert, actions: {
                Button(Setup.ContentStrings.confirm, role: .cancel) { }
            }, message: {
                Text(Setup.ContentStrings.SignUp.notReadyToSignUpErrorAlertMessage)
            })
        }
        .alert(Setup.ContentStrings.SignUp.signUpErrorAlertTitle, isPresented: $signUpInfoVM.showSignUpErrorAlert, actions: {
            Button(Setup.ContentStrings.confirm, role: .cancel) { }
        }, message: {
            Text(Setup.ContentStrings.SignUp.signUpErrorAlertMessage)
        })
        .frame(maxHeight: .infinity)
        .padding(.horizontal, 8)
        .background(Color.backgroundColor)
        .onChange(of: signUpInfoVM.didSignUpSucceed) { newValue in
            if newValue {
                if let profile = signUpInfoVM.signedUpProfile {
                    mainTabBarVM.userProfileInput.send(profile)
                }
                mainTabBarVM.checkLoginStatus.send(true)
            }
        }
    }
}

#Preview {
    SignUpInfoView(signUpInfoVM: SignUpInfoViewModel(userDataForSignUp: SignUpRequest(email: "aaa@bbb.com", nickname: "", provider: SocialLoginProvider.apple)), mainTabBarVM: MainTabBarViewModel())
}
