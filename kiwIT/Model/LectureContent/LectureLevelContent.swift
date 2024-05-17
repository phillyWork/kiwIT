//
//  LectureLevelContent.swift
//  kiwIT
//
//  Created by Heedon on 5/8/24.
//

import Foundation

struct LectureLevelContentRequest: Encodable {
    let access: String
}

struct LectureLevelContentResponse: Decodable {
    let payload: [LectureContent]
}

struct LectureContent: Codable {
    let id: Int
    let title: String
    let point: Int
    let exercise: String
    let answer: Bool
    let levelNum: Int
    let categoryChapterId: Int
}
