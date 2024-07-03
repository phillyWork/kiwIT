//
//  BookmarkLecture.swift
//  kiwIT
//
//  Created by Heedon on 6/21/24.
//

import Foundation

struct BookmarkedLectureCheckRequest {
    var access: String
    var next: Int?
    var limit: Int?
}

struct BookmarkLectureResponse {
    var userId: Int
    var contentId: Int
    var myAnswer: Bool
    var kept: Bool
    var createdAt: String   //Date type
    var updatedAt: String   //Date type
}
