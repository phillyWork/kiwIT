//
//  LectureLevelList.swift
//  kiwIT
//
//  Created by Heedon on 5/8/24.
//

import Foundation

struct Level


struct LectureLevelListRequest: Encodable {
    let access: String
}

struct LectureLevelListResponse: Decodable {
    let levelList: [LectureLevelPayload]
}

struct LectureLevelPayload: Codable {
    let num: Int
    let title: String
}
