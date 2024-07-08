//
//  SignUp.swift
//  kiwIT
//
//  Created by Heedon on 3/23/24.
//

import Foundation

struct SignUpRequest: Encodable {
    var email: String
    var nickname: String
    var provider: SocialLoginProvider
}

struct SignUpResponse: Decodable {
    var accessToken: String
    var refreshToken: String
}
