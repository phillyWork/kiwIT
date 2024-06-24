//
//  Profile.swift
//  kiwIT
//
//  Created by Heedon on 3/25/24.
//

import Foundation

struct ProfileEditRequest {
    var access: String
    var nickname: String
}

struct ProfileResponse: Decodable {
    var id: Int
    var email: String
    var nickname: String
    var point: Int
    //구독 여부 타입 분류 필요
    var plan: UserPlan
    //유저 형태 타입 분류 필요
    var status: UserStatus
}
