//
//  SignUpInfoView.swift
//  kiwIT
//
//  Created by Heedon on 3/12/24.
//

import SwiftUI

struct SignUpInfoView: View {
    
    @StateObject var signUpInfoVM: SignUpInfoViewModel
    
    var body: some View {
        VStack {
            Text("nickname: \(signUpInfoVM.userDataForSignUp.nickname)")
            Text("email: \(signUpInfoVM.userDataForSignUp.email)")
            Text("provider: \(signUpInfoVM.userDataForSignUp.provider)")
        }
    }
}

#Preview {
    SignUpInfoView(signUpInfoVM: SignUpInfoViewModel(userDataForSignUp: SignUpRequest(email: "aaa@bbb.com", nickname: "abcabc123123", provider: SocialLoginProvider.apple)))
}
