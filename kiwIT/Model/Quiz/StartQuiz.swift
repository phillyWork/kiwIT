//
//  TakeQuiz.swift
//  kiwIT
//
//  Created by Heedon on 6/21/24.
//

import Foundation

struct StartQuizRequest {
    var quizGroupId: String
    var access: String
}

struct StartQuizResponse: Decodable {
    var id: Int
    var title: String
    var subtitle: String
    var totalScore: Int
    var quizList: [QuizPayload]
}

struct QuizPayload: Decodable {
    var id: Int
    var type: QuizType
    var title: String
    var question: String
    var answer: String      //multiple: Int, trueOrFalse: Bool
    var explanation: String
    var score: Int
    var choiceList: [MultipleChoiceList]?
    // multiple choice 아닌 경우 choiceList 조회하지 않음 (Lazy Loading)
}

struct MultipleChoiceList: Decodable {
    var number: Int
    var quizId: Int
    var payload: String
}
