//
//  Setup+SocialLoginProvider.swift
//  kiwIT
//
//  Created by Heedon on 3/23/24.
//

import Foundation

//response에 body없는 경우

enum SocialLoginProvider: String, Encodable {
    case apple = "APPLE"
    case kakao = "KAKAO"
}

//구독 여부
enum UserPlan: String, Codable {
    case basic = "BASIC"
    case normal = "NORMAL"
    case subscribed = "SUBSCRIBED"
    case unknown = "UNKNOWN"
    
    init(from decoder: any Decoder) throws {
        self = try UserPlan(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }
}

//활성화, 임시 탈퇴, 완전 탈퇴 구분
enum UserStatus: String, Codable {
    case activated = "ACTIVATED"
    case deactivated = "DEACTIVATED"
    case unknown = "UNKNOWN"
    
    init(from decoder: any Decoder) throws {
        self = try UserStatus(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }
}
