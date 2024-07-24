//
//  StartLecture.swift
//  kiwIT
//
//  Created by Heedon on 5/8/24.
//

import Foundation

struct HandleLectureRequest {
    var contentId: Int
    var access: String
}

struct StartLectureResponse: Decodable {
    var id: Int
    var title: String
    var point: Int
    var exercise: String
    var answer: Bool
    var levelNum: Int
    var categoryChapterId: Int
    var payloadUrl: String
    var contentStudied: BasicCompleteLectureContentPayload?    //학습한 적 없다면 null
}
