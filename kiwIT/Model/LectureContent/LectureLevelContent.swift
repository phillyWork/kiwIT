//
//  LectureLevelContent.swift
//  kiwIT
//
//  Created by Heedon on 5/8/24.
//

import Foundation

struct LectureLevelContentRequest: Encodable {
    var access: String
}

struct LectureLevelContentResponse: Decodable {
    var payload: [LectureContent]
}

struct LectureContent: Codable {
    var id: Int
    var title: String
    var point: Int
    var exercise: String
    var answer: Bool
    var levelNum: Int
    var categoryChapterId: Int
}
