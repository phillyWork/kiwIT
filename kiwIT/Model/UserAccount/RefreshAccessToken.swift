//
//  RefreshToken.swift
//  kiwIT
//
//  Created by Heedon on 3/23/24.
//

import Foundation

struct RefreshAccessTokenRequest: Encodable {
    var refreshToken: String
}

struct RefreshAccessTokenResponse: Decodable {
    var accessToken: String
    var refreshToken: String
}
