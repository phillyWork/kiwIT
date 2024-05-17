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
    let paylod: [StartLecturePayload]
}

struct StartLecturePayload: Codable {
    let id: Int
    let title: String
    let contentList: [LectureContent]
}
