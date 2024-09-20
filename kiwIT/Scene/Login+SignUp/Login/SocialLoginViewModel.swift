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
            if let profile = profileData {
                self.profileData = profile
            } else {
                print("Can't send user profile data!!!")
            }
            self.didLoginSucceed = true
        } else {
            if let userData = userDataToSignUp {
                self.userDataForSignUp = userData
                self.shouldMoveToSignUp = true
            } else {
                self.showLoginErrorAlert = true
            }
        }
    }
    
    deinit {
        print("SocialLoginViewModel DEINIT")
    }
    
}
