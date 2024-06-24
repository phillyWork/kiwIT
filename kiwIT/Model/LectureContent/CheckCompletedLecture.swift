//
//  NextLecture.swift
//  kiwIT
//
//  Created by Heedon on 6/21/24.
//

import Foundation

struct CompletedLectureListCheckRequest {
    var access: String
    var next: Int?
    var limit: Int?
    var byLevel: Bool?
}

struct CompletedLectureListCheckResponse: Decodable {
    var list: [CompletedLecture]
}

struct CompletedLecture: Decodable {
    var id: Int         //Quiz Group ID
    var title: String
    var point: Int
    var exercise: String
    var answer: Bool
    var levelNum: Int
    var categoryChapterId: Int
    var contentStudied: CompleteLectureResponse
}
