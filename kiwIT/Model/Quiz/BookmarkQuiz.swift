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
    var kept: Bool      //Bookmark Request: 200 --> kept의 값에서 toggle된 값 Return
}
