//
//  LectureCategoryContent.swift
//  kiwIT
//
//  Created by Heedon on 6/21/24.
//

import Foundation

struct LectureCategoryContentRequest {
    var categoryId: Int
    var access: String
}

struct LectureCategoryContentResponse: Decodable {
    var id: Int
    var title: String
    var contentList: [LectureContentListPayload]
}
