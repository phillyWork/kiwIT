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

struct BookmarkLectureResponse: Decodable {
    var userId: Int
    var contentId: Int
    var myAnswer: Bool
    var kept: Bool
    var createdAt: String   //Date type
    var updatedAt: String   //Date type

    var creationDate: String {
        if let date = createdAt.toDate() {
            return date.toFullString()
        } else {
            return createdAt
        }
    }
    
    var creationCompactDate: String {
        if let date = createdAt.toDate() {
            return date.toCompactString()
        } else {
            return createdAt
        }
    }
}
