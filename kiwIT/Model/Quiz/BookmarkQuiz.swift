//
//  BookmarkQuiz.swift
//  kiwIT
//
//  Created by Heedon on 6/21/24.
//

import Foundation

struct BookmarkQuizRequest {
    var quizId: String
    var access: String
}

struct BookmarkedQuizListResponse: Decodable {
    var id: Int
    var type: QuizType
    var title: String
    var question: String
    var answer: String      //multiple choice: Int, trueOrFalse: Bool
    var explanation: String
    var score: Int
    var result: BookmarkQuiz
}

struct BookmarkQuiz: Decodable {
    var id: Int             //quiz group id
    var userId: Int
    var quizId: Int
    var correct: String     //multiple choice: Int, trueOrFalse: Bool
    var myAnswer: String
    var kept: Bool
}

//Bookmark Request: 200 --> kept의 값에서 toggle된 값 Return
