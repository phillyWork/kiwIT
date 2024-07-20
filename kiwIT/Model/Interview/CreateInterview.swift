//
//  CreateInterview.swift
//  kiwIT
//
//  Created by Heedon on 7/21/24.
//

import Foundation

struct CreateInterviewRequest {
    
}

struct CreateInterviewContent: Codable {
    var topic: String
    var numOfQuestions: Int
    var expectedTotalAnswerTime: Int
    var shouldBeIncludedString: String
}
