//
//  InterviewRoomList.swift
//  kiwIT
//
//  Created by Heedon on 8/7/24.
//

import Foundation

//InterviewRoom: 생성된 인터뷰에서 과거 기록 및 현재 실행 가능 여부 판단

struct InterviewRoomListRequest {
    var access: String
    var interviewId: Int
    var next: Int?
    var limit: Int?
}

struct InterviewRoomListResponse: Decodable {
    var id: Int
    var title: String
    var createdAt: String
    var updatedAt: String
    var interviewRoomList: [InterviewRoomPayload]
    
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

struct InterviewRoomPayload: Decodable {
    var id: Int
    var score: Int
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
