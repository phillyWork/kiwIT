//
//  LectureLevelList.swift
//  kiwIT
//
//  Created by Heedon on 5/8/24.
//

import Foundation

//struct Level


struct LectureLevelListRequest: Encodable {
    var access: String
}

struct LectureLevelListResponse: Decodable {
    var levelList: [LectureLevelPayload]
}

struct LectureLevelPayload: Codable {
    var num: Int
    var title: String
}
