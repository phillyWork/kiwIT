//
//  SignUpInfoViewModel.swift
//  kiwIT
//
//  Created by Heedon on 6/9/24.
//

import Foundation

import Combine

final class SignUpInfoViewModel: ObservableObject {
    
    var userDataForSignUp: SignUpRequest
    
    init(userDataForSignUp: SignUpRequest) {
        print("about to initialize viewmodel")
        self.userDataForSignUp = userDataForSignUp
        print("passed userData from SocialLoginView: \(userDataForSignUp)")
    }
    
    //가입 화면에서 작성한 모든 정보 기반으로 요청
    //출처, 이메일, 닉네임, 등등...
    func requestSignUp() {
    
    }
    
}
