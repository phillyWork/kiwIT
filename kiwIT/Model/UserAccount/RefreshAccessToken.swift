//
//  RefreshToken.swift
//  kiwIT
//
//  Created by Heedon on 3/23/24.
//

import Foundation

struct RefreshAccessTokenRequest: Encodable {
    let refreshToken: String
}

struct RefreshAccessTokenResponse: Decodable {
    let accessToken: String
    let refreshToken: String
}
