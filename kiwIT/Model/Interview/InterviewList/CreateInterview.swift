//
//  CreateInterview.swift
//  kiwIT
//
//  Created by Heedon on 7/21/24.
//

import Foundation

struct CreateInterviewRequest {
    var access: String
    var content: CreateInterviewContent
}

struct CreateInterviewContent: Codable {
    var title: String? //사용자가 직접 설정할 경우, 인터뷰 제목 설정 가능 (Default: GPT 기본 생성)
    var topic: String
    var numOfQuestions: Int
    var expectedTotalAnswerTime: Int
    var shouldBeIncludedString: String
}
