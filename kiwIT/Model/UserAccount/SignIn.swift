//
//  SignIn.swift
//  kiwIT
//
//  Created by Heedon on 3/23/24.
//

import Foundation

struct SignInRequest: Encodable {
    let token: String
    let provider: SocialLoginProvider
}

struct SignInResponse: Decodable {
    let accessToken: String
    let refreshToken: String
}
