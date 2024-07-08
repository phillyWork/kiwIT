//
//  BookmarkQuiz.swift
//  kiwIT
//
//  Created by Heedon on 6/21/24.
//

import Foundation

struct BookmarkQuizRequest {
    var quizId: Int
    var access: String
}

struct BookmarkQuizResponse: Decodable {
    var userId: Int
    var quizId: Int
    var quizSolved: BookmarkQuiz?   //답안 제출 여부에 따라 Null 올 수도
}
