//
//  InterviewPolling.swift
//  kiwIT
//
//  Created by Heedon on 8/10/24.
//

import Foundation

struct InterviewPolling: Decodable {
    var order: Int
    var token: String?
    //해당 토큰 존재: 인터뷰 답변 제출 시 필요 (구현 예정)
    //202: 대기 중 ~ Token값 없음
}
