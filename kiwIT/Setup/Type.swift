//
//  Setup+SocialLoginProvider.swift
//  kiwIT
//
//  Created by Heedon on 3/23/24.
//

import Foundation

enum SocialLoginProvider: String, Encodable {
    case apple = "APPLE"
    case google = "GOOGLE"
    case kakao = "KAKAO"
}

//MARK: - Build 목적으로 예외 처리 중

//구독 여부
//enum UserPlan: Decodable {
//    
//}

//활성화, 임시 탈퇴, 완전 탈퇴 구분
//enum UserStatus: Decodable {
//    
//}
