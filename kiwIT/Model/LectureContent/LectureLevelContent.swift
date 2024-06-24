//
//  LectureLevelContent.swift
//  kiwIT
//
//  Created by Heedon on 6/21/24.
//

import Foundation

struct LectureLevelContentRequest {
    var levelId: Int
    var access: String
    var next: Int?
    var limit: Int?
}

struct LectureLevelContentResponse: Decodable {
    var list: [LectureListPayload]
}

struct LectureListPayload: Decodable {
    var id: Int
    var title: String
    var point: Int
    var exercise: String
    var answer: Bool
    var levelNum: Int
    var categoryChapterId: Int
}
