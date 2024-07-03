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

enum MostRecentlyTakenQuiz: Decodable {
    case success(TakenQuizResponse)
    case emptyBody      //Empty Body
    
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case subtitle
        case levelNum
        case totalScore
        case result
        case emptyBody
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
    
        if let id = try? container.decode(Int.self, forKey: .id), let title = try? container.decode(String.self, forKey: .title), let subtitle = try? container.decode(String.self, forKey: .subtitle), let levelNum = try? container.decode(Int.self, forKey: .levelNum), let totalScore = try? container.decode(Int.self, forKey: .totalScore), let result = try? container.decode(SubmitQuizResponse.self, forKey: .result) {
            print("Most Recent Taken Quiz!")
            self = .success(TakenQuizResponse(id: id, title: title, subtitle: subtitle, levelNum: levelNum, totalScore: totalScore, result: result))
        } else if let emptyBody = try? container.decode(Empty.self, forKey: .emptyBody) {
            print("No Taken Quiz Data")
            self = .emptyBody
        } else {
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Data does not match any MostRecentlyTakenQuiz type"))
        }
    }
}
