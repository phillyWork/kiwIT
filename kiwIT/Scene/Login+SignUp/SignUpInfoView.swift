//
//  SignUpInfoView.swift
//  kiwIT
//
//  Created by Heedon on 3/12/24.
//

import SwiftUI

struct SignUpInfoView: View {

    @StateObject var signUpInfoVM: SignUpInfoViewModel
    
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack {
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
                              prompt: Text("닉네임을 입력해주세요")
                        .foregroundColor(Color.textPlaceholderColor)
                    )
                    .focused($isTextFieldFocused)
                    .background(Color.shadowColor)
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
                
                ScrollView {
                    Text("동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...동의 내용 확인 사항들...")
                        .padding()
                }
                .frame(height: Setup.Frame.signUpConfirmScrollViewHeight)
                .background(Color.shadowColor)
                .border(Color.purple)
            
                HStack {
                    Button(action: {
                        signUpInfoVM.toggleSwitchIsOn.toggle()
                    }, label: {
                        Image(systemName: signUpInfoVM.toggleSwitchIsOn ? Setup.ImageStrings.toggleButtonChecked : Setup.ImageStrings.toggleButtonUnchecked)
                            .imageScale(.large)
                            .foregroundStyle(Color.brandColor)
                    })
                    Text("안내 사항을 확인하고 동의합니다")
                        .foregroundStyle(Color.textColor)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .border(Color.purple)
                .padding(.vertical, 8)
                
            }
            
            Spacer()
            
            if signUpInfoVM.toggleSwitchIsOn && !signUpInfoVM.isNicknameEmpty {
                ShrinkAnimationButtonView(title: "회원 가입", color: Color.brandColor) {
                    signUpInfoVM.requestSignUp()
                }
                .padding(.vertical, 12)
            } else {
                ShrinkAnimationButtonView(title: "가입 준비", color: Color.gray) {
                    signUpInfoVM.requestSignUp()
                }
                .padding(.vertical, 12)
            }
            
        }
        .frame(maxHeight: .infinity)
        .padding(.horizontal, 8)
        .background(Color.backgroundColor)
    }
}

#Preview {
    SignUpInfoView(signUpInfoVM: SignUpInfoViewModel(userDataForSignUp: SignUpRequest(email: "aaa@bbb.com", nickname: "abcabc123123", provider: SocialLoginProvider.apple)))
}
