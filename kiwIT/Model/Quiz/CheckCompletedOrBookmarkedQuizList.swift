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

struct BookmarkedQuizListResponse: Decodable, Hashable {
    var id: Int
    var type: QuizType
    var title: String
    var question: String
    var answer: String      //multiple choice: Int, trueOrFalse: Bool
    var explanation: String
    var score: Int
    var result: BookmarkQuiz?   //안 풀었을 경우, null
}

struct BookmarkQuiz: Decodable, Hashable {
    var userId: Int
    var quizId: Int
    var correct: String     //multiple choice: Int, trueOrFalse: Bool || 문제 푼 결과?
    var myAnswer: String
}
