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
    var byLevel: Bool?  //레벨 기준 분류 확인하기
}

struct CompletedOrBookmarkedLecture: Decodable, Hashable {
    var id: Int
    var title: String
    var point: Int
    var exercise: String
    var answer: Bool
    var levelNum: Int
    var categoryChapterId: Int
    var payloadUrl: String
    var contentStudied: BasicCompleteLectureContentPayload
}
