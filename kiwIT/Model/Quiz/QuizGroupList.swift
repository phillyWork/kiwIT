//
//  QuizGroupList.swift
//  kiwIT
//
//  Created by Heedon on 6/21/24.
//

import Foundation

struct QuizGroupListRequest {
    var access: String
    var next: Int?
    var limit: Int?
    var tag: String?
}

struct QuizGroupPayload: Decodable, Hashable {
    var id: Int
    var title: String
    var subtitle: String
    var levelNum: Int
    var totalScore: Int
    var categoryChapter: QuizCategoryChapter
}

struct QuizCategoryChapter: Decodable, Hashable {
    var id: Int
    var title: String
}
