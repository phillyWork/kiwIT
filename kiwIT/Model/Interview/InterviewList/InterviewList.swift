//
//  InterviewRequest.swift
//  kiwIT
//
//  Created by Heedon on 8/7/24.
//

import Foundation

struct InterviewListRequest {
    var access: String
    var next: Int?
    var limit: Int?
}

struct InterviewListResponse: Decodable {
    var interviewList: [InterviewPayload]
}

//생성 후 Polling 여부 판단할 수도 있음
struct InterviewPayload: Decodable, Hashable {
    var id: Int
    var title: String
    var timeLimit: Int  //초 단위, 전체 인터뷰 시간
    var questionsCnt: Int
    var createdAt: String
    var updatedAt: String
    
    var creationFullDate: String {
        if let date = createdAt.toDate() {
            return date.toFullString()
        } else {
            return createdAt
        }
    }
    
    var creationCompactDate: String {
        if let date = createdAt.toDate() {
            return date.toCompactString()
        } else {
            return createdAt
        }
    }
}
