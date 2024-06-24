//
//  CompleteLecture.swift
//  kiwIT
//
//  Created by Heedon on 6/21/24.
//

import Foundation

struct CompleteLectureResponse: Decodable {
    var userId: Int
    var contentId: Int
    var myAnswer: Bool?
    var kept: Bool
    var createdAt: String
    var updatedAt: String
}
