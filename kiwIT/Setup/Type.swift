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
    case normal = "NORMAL"
    case pro = "PRO"
    case premium = "PREMIUM"
    
    init(from decoder: any Decoder) throws {
        self = try UserPlan(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .normal
    }
}

//활성화, 임시 탈퇴, 완전 탈퇴 구분
enum UserStatus: String, Codable {
    case activated = "ACTIVATED"
    case deactivated = "DEACTIVATED"
    case banned = "BANNED"
    case deleted = "DELETED"
    case unknown = "UNKNOWN"
    
    init(from decoder: any Decoder) throws {
        self = try UserStatus(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
    }
}

//enum LectureContentPayloadType: String, Codable {
//    case textContent = "text"
//    case imageFile = "image"
//}

enum QuizType: String, Codable {
    case multipleChoice = "multiple"
    case trueOrFalse = "tf"
    case shortAnswer = "short"
}
