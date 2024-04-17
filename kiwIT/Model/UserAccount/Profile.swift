//
//  Profile.swift
//  kiwIT
//
//  Created by Heedon on 3/25/24.
//

import Foundation

struct ProfileEditRequest: Encodable {
    let access: String
    let nickname: String
}

struct ProfileResponse: Decodable {
    //id type 확인 필요
    let id: String
    let email: String
    let nickname: String
    let point: Int
    //구독 여부 타입 분류 필요
    let plan: String
    //유저 형태 타입 분류 필요
    let status: String
}
