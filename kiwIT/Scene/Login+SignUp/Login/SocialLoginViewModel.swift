//
//  SocialLoginViewModel.swift
//  kiwIT
//
//  Created by Heedon on 3/12/24.
//

import Foundation
import Combine

import AuthenticationServices

import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

import GoogleSignIn
import GoogleSignInSwift

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

    func requestKakaoUserLogin() {
        //kakao talk 여부 확인
        if (UserApi.isKakaoTalkLoginAvailable()) {
            UserApi.shared.loginWithKakaoTalk { oAuthToken, error in
                if let error = error {
                    print("Login with Kakao Talk Error: \(error)")
                    //token 받아오기 실패 시 처리할 방안
                    
                }
                //token 받아옴
                if let oAuthToken = oAuthToken {
                    //Token 서버에 전달하기
                    print("token for kakao user with kakaoTalk: \(oAuthToken)")
                    
                }
            }
        } else {
            //kakao 계정(웹)으로 로그인 시도
            UserApi.shared.loginWithKakaoAccount { oAuthToken, error in
                if let error = error {
                    print("Login with Kakao User Account Error: \(error)")
                    //token 받아오기 실패 시 처리할 방안
                    
                }
                //token 받아옴
                if let oAuthToken = oAuthToken {
                    //Token 서버에 전달하기
                    print("token for kakao user with kakao account: \(oAuthToken)")
                    
                }
            }
        }
    }
    
    func requestGoogleUserLogin() {
        
        //rootViewController
        guard let presentingVC = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first?.rootViewController else {
            print("No presentingVC!!!")
            return
        }
        
        GIDSignIn.sharedInstance.signIn(withPresenting: presentingVC) { signInResult, error in
            guard let result = signInResult else {
                print("Login with Google Error: \(error)")
                
                //유저 정보 받기 처리 실패 시 처리할 방안
                
                
                return
            }
            
            //로그인 성공, result에서 token 찾아 서버에 전달하기
            
            //result.user.idToken
            //result.user.accessToken
            //result.user.refreshToken
            
            
        }
    }
    
    
    //가입 화면에서 작성한 모든 정보 기반으로 요청
    //출처, 이메일, 닉네임, 등등...
    func requestSignUp() {
        
    }
    
}
