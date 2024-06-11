//
//  SocialLoginViewModel.swift
//  kiwIT
//
//  Created by Heedon on 3/12/24.
//

import Foundation

import Combine

final class SocialLoginViewModel: ObservableObject {
    
    @Published var didLoginSucceed = false
    @Published var shouldMoveToSignUp = false
    @Published var errorMessage: String?
    
    var userDataForSignUp: SignUpRequest? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    var providerToken = ""
    
    init() {
        print("DEBUG: SocialLoginViewModel initialized")
    }
    
    //Social Login Button ViewModel에서 서버 로그인 성공 시,
    //Token 일반화 가능하면 함수 하나로 처리, 아니라면 각자 생성
    func handleSocialLoginResult(success: Bool, error: String? = nil, userData: SignUpRequest? = nil) {
        if success {
            print("Login Succeed!!!")
            self.didLoginSucceed = true
        } else {
            if let userData = userData {
                print("userData for signup: \(userData)")
                self.userDataForSignUp = userData
                self.shouldMoveToSignUp = true
            } else {
                print("error message from server: \(error)")
                self.errorMessage = error
            }
        }
    }
    
    

    

    
}
