//
//  CheckCompletedQuiz.swift
//  kiwIT
//
//  Created by Heedon on 6/21/24.
//

import Foundation

struct CheckCompletedOrBookmarkedQuizRequest {
    var access: String
    var next: Int?
    var limit: Int?
}

struct CheckCompletedQuizResponse: Decodable {
    var list: [TakenQuizResponse]
}
