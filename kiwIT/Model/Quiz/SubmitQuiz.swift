//
//  SubmitQuiz.swift
//  kiwIT
//
//  Created by Heedon on 6/21/24.
//

import Foundation

struct SubmitQuizRequest {
    var quizGroupId: Int
    var access: String
    var answerList: [QuizAnswer]
}

struct QuizAnswer: Codable {
    var quizId: Int
    var answer: String
    
    //개별 퀴즈 문항의 id와 해당 답안으로 구성된 Object의 배열
    //TF 문제의 경우 “true”, “false”의 문자열로
}

struct SubmitQuizResponse: Decodable, Hashable {
    var userId: Int
    var quizGroupId: Int
    var latestScore: Int
    var highestScore: Int
    var trophyAwardedList: [TrophyEntity]
}

struct BasicSubmittedQuizResponse: Decodable, Hashable {
    var userId: Int
    var quizGroupId: Int
    var latestScore: Int
    var highestScore: Int
}
