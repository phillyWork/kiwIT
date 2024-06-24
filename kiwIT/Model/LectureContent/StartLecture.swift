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
    
    //same as LectureContent structure
    
    //MARK: - TO-BE: Web View 활용 위한 url link로 대체될 예정
    
//    var payloadList: [LectureContentPayload]
    
    var payloadUrl: String
}

//struct LectureContentPayload: Decodable {
//    var number: Int
//    var contentId: Int
//    var type: LectureContentPayloadType
//    var payload: String     //context or imageUrl
//}
