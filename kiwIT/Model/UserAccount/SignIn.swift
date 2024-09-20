//
//  SignIn.swift
//  kiwIT
//
//  Created by Heedon on 3/23/24.
//

import Foundation

struct SignInRequest: Encodable {
    var token: String
    var provider: SocialLoginProvider
}

struct SignInResponseSuccess: Decodable {
    var accessToken: String
    var refreshToken: String
}

struct SignInResponseSignUpRequired: Decodable {
    var email: String
    var nickname: String
    var provider: String
}

enum SignInResponse: Decodable {
    case signInSuccess(SignInResponseSuccess)
    case signUpRequired(SignInResponseSignUpRequired)

    enum CodingKeys: String, CodingKey {
        case accessToken
        case refreshToken
        case email
        case nickname
        case provider
    }
        
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let accessToken = try? container.decode(String.self, forKey: .accessToken), let refreshToken = try? container.decode(String.self, forKey: .refreshToken) {
            let signInSuccess = SignInResponseSuccess(accessToken: accessToken, refreshToken: refreshToken)
            self = .signInSuccess(signInSuccess)
        } else if let email = try? container.decode(String.self, forKey: .email), let nickname = try? container.decode(String.self, forKey: .nickname), let provider = try? container.decode(String.self, forKey: .provider) {
            let signUpRequired = SignInResponseSignUpRequired(email: email, nickname: nickname, provider: provider)
            self = .signUpRequired(signUpRequired)
        } else {
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Data does not match any SignInResponse type"))
        }
    }
}
