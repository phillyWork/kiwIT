//
//  LectureLevelList.swift
//  kiwIT
//
//  Created by Heedon on 5/8/24.
//

import Foundation

struct LectureLevelListResponse: Decodable {
    var list: [LectureLevelListPayload]
}

struct LectureLevelListPayload: Decodable {
    var num: Int
    var title: String
}
