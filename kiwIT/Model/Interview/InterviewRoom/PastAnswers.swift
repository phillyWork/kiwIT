//
//  PastAnswers.swift
//  kiwIT
//
//  Created by Heedon on 8/7/24.
//

import Foundation

struct BasicInterviewRoomRequest {
    var access: String
    var interviewRoomId: Int
}

struct PastAnswersResponse: Decodable {
    var id: Int
    var score: Int
    var createdAt: String
    var updatedAt: String
    var answerList: [PastAnswerPaylaod]
}

struct PastAnswerPaylaod: Decodable {
    var id: Int
    var myAnswer: String
    var question: InterviewQuestionPayload
}

//DeleteInterviewRoom: status code로 처리 (Empty response body)
