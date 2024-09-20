//
//  SubmitInterviewRoom.swift
//  kiwIT
//
//  Created by Heedon on 8/7/24.
//

import Foundation

struct SubmitInterviewRoomRequest {
    var access: String
    var interviewRoomId: Int
    var answerList: [InterviewAnswer]
}

struct InterviewAnswer: Codable {
    var myAnswer: String
    var roomId: Int
    var questionId: Int
}
