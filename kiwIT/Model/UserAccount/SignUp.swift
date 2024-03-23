//
//  SignUp.swift
//  kiwIT
//
//  Created by Heedon on 3/23/24.
//

import Foundation

struct SignUpRequest: Encodable {
    let email: String
    let nickname: String
    let provider: SocialLoginProvider
}

struct SignUpResponse: Decodable {
    
}
