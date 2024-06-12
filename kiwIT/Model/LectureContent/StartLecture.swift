//
//  StartLecture.swift
//  kiwIT
//
//  Created by Heedon on 5/8/24.
//

import Foundation

struct StartLectureRequest: Encodable {
   
}

struct StartLectureResponse: Decodable {
    var paylod: [StartLecturePayload]
}

struct StartLecturePayload: Codable {
    var id: Int
    var title: String
    var contentList: [LectureContent]
}
