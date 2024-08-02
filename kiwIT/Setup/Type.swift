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

enum LectureListType: String, CaseIterable {
    case category = "과목"
    case level = "레벨"
}

enum QuizType: String, Codable, Hashable {
    case multipleChoice = "MULTIPLE"
    case trueOrFalse = "TF"
    case shortAnswer = "SHORT"
}

//퀴즈 사용처 구분 필요시? (HomeView, QuizListView 구분용?)
enum QuizTag: String, Codable {
    case homeTab
    case quizTab
    
}
