//
//  CompleteLecture.swift
//  kiwIT
//
//  Created by Heedon on 6/21/24.
//

import Foundation

struct CompleteLectureResponse: Decodable, Hashable {
    var userId: Int
    var contentId: Int
    var myAnswer: Bool?     //null: 예제 답안 미제출
    var kept: Bool
    var createdAt: String
    var updatedAt: String
    var trophyAwardedList: [TrophyEntity]
    
    var creationDate: String {
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

struct BasicCompleteLectureContentPayload: Decodable, Hashable {
    var userId: Int
    var contentId: Int
    var myAnswer: Bool?     //null: 예제 답안 미제출
    var kept: Bool
    var createdAt: String
    var updatedAt: String
    
    var creationDate: String {
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
