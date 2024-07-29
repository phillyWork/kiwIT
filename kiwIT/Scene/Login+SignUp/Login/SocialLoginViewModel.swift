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
    @Published var showLoginErrorAlert = false
   
    var profileData: ProfileResponse?
    var userDataForSignUp: SignUpRequest?
    
    init() {
        print("DEBUG: SocialLoginViewModel initialized")
    }
    
    func handleSocialLoginResult(success: Bool, errorMessage: String? = nil, profileData: ProfileResponse? = nil, userDataToSignUp: SignUpRequest? = nil) {
        if success {
            print("Login Succeed!!!")
            if let profile = profileData {
                print("Profile Data from SignIn and ProfileRequest!!!")
                self.profileData = profile
            } else {
                print("Can't send user profile data!!!")
            }
            self.didLoginSucceed = true
        } else {
            if let userData = userDataToSignUp {
                print("userData for signup: \(userData)")
                self.userDataForSignUp = userData
                self.shouldMoveToSignUp = true
            } else {
                print("Sign In failed with error message: \(errorMessage)")
                self.showLoginErrorAlert = true
            }
        }
    }
    
    deinit {
        print("SocialLoginViewModel DEINIT")
    }
    
}
