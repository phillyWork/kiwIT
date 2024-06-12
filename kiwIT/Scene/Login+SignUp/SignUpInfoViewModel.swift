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
    
    @Published var toggleSwitchIsOn = false
    @Published var isNicknameEmpty = false
    
    init(userDataForSignUp: SignUpRequest) {
        print("about to initialize viewmodel")
        self.userDataForSignUp = userDataForSignUp
    }
        
    //가입 화면에서 작성한 모든 정보 기반으로 요청
    func requestSignUp() {
        
    }
    
}
