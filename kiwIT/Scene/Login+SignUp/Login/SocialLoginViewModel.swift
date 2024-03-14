//
//  SocialLoginViewModel.swift
//  kiwIT
//
//  Created by Heedon on 3/12/24.
//

import Foundation
import Combine

import AuthenticationServices

final class SocialLoginViewModel: ObservableObject {
    
    @Published var didLoginSucceed = false
    @Published var shouldMoveToSignUp = false
        
    //Social Login 성공 시, 서버에 로그인 request
    //Token 일반화 가능하면 함수 하나로 처리, 아니라면 각자 생성
    func requestLogin() {
        
    }
    
    func requestAppleUserLogin(_ credential: ASAuthorizationCredential) {
        print("Request to Server for User's Access and Refresh Token")
        
        switch credential {
        case let appleIDCredential as ASAuthorizationAppleIDCredential: break
            //Network 모델로 로그인 요청
            
                //성공 시, access 및 refresh token response
            
                //self.didLoginSucceed = true
            
                //실패 시, 가입 화면으로 이동 요청 (by HTTP response code)
            
                //self.shouldMoveToSignUp = true

        default:
            break
        }
    }

    
    
    
    //가입 화면에서 작성한 모든 정보 기반으로 요청
    func requestSignUp() {
        
    }
    
}
