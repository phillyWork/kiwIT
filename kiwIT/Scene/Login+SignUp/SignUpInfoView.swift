//
//  SignUpInfoView.swift
//  kiwIT
//
//  Created by Heedon on 3/12/24.
//

import SwiftUI

struct MinimalView: View {
    
    @State private var shouldNavigate = false
    @State private var userData: SignUpRequest? = SignUpRequest(email: "test@example.com", nickname: "testuser", provider: .kakao)
    
    var body: some View {
        NavigationStack {
            VStack {
                Button("Trigger Navigation") {
                    shouldNavigate = true
                }
            }
            .navigationDestination(isPresented: $shouldNavigate) {
                if let userData = userData {
                    SignUpInfoView(signUpInfoVM: SignUpInfoViewModel(userDataForSignUp: userData))
                } else {
                    EmptyView()
                }
            }
        }
    }
}


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
    MinimalView()
//    SignUpInfoView(signUpInfoVM: SignUpInfoViewModel(userDataForSignUp: SignUpRequest(email: "aaa@bbb.com", nickname: "abcabc123123", provider: SocialLoginProvider.apple)))
}
