//
//  EditInterview.swift
//  kiwIT
//
//  Created by Heedon on 8/7/24.
//

import Foundation

//To Edit Interview Title
struct EditInterviewRequest {
    var access: String
    var interviewId: Int
    var title: String       //수정할 제목
    var timeLimit: Int      //전체 시간 수정
}
