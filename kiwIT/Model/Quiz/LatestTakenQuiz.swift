//
//  MostRecentTakenQuiz .swift
//  kiwIT
//
//  Created by Heedon on 6/21/24.
//

import Foundation

import Alamofire

//MARK: - Response

struct TakenQuizResponse: Decodable {
    var id: Int             //quiz group id
    var title: String
    var subtitle: String
    var levelNum: Int
    var totalScore: Int
    var result: SubmitQuizResponse
}
