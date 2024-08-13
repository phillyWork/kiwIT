//
//  CreateInterviewRoom.swift
//  kiwIT
//
//  Created by Heedon on 8/7/24.
//

import Foundation

struct InterviewQuestionsListResponse: Decodable {
    var id: Int
    var title: String
    var timeLimit: Int
    var questionsCnt: Int
    var createdAt: String
    var updatedAt: String
    var questionList: [InterviewQuestionPayload]
    
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

struct InterviewQuestionPayload: Decodable {
    var id: Int
    var question: String
    var modelAnswer: String
}
