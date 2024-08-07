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

struct InterviewPayload: Decodable {
    var id: Int
    var title: String
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
