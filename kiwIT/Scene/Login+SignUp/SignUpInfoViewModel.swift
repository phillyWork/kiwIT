//
//  SignUpInfoViewModel.swift
//  kiwIT
//
//  Created by Heedon on 6/9/24.
//

import Foundation

import Combine

final class SignUpInfoViewModel: ObservableObject {
    
    @Published var userDataForSignUp: SignUpRequest
    
    init(userDataForSignUp: SignUpRequest) {
        self.userDataForSignUp = userDataForSignUp
    }
    
    //가입 화면에서 작성한 모든 정보 기반으로 요청
    //출처, 이메일, 닉네임, 등등...
    func requestSignUp() {
    
    }
    
}
