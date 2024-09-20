//
//  CreateInterview.swift
//  kiwIT
//
//  Created by Heedon on 7/21/24.
//

import Foundation

struct CreateInterviewOptionResponse: Codable {
    var categoryList: [LectureCategoryListPayload]
    var levelList: [LectureLevelListPayload]
}

struct CreateInterviewRequest {
    var access: String
    var content: CreateInterviewContent
}

struct CreateInterviewContent: Codable {
    var title: String? //사용자가 직접 설정할 경우, 인터뷰 제목 설정 가능 (Default: GPT 기본 생성)
    var categoryId: Int

    var levelNum: Int
    var timeLimit: Int  //초 단위, 인터뷰 전체 시간
    var etcRequest: String
    var questionsCnt: Int   //인터뷰 문항 수
}
