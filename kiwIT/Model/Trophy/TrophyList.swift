//
//  AcquiredTrophyList.swift
//  kiwIT
//
//  Created by Heedon on 3/25/24.
//

import Foundation

struct TrophyListRequest {
    var access: String
    var next: Int?
    var limit: Int?
}

//전체 트로피 리스트
struct AcquiredTrophy: Decodable, Identifiable {
    var userId: Int
    var trophy: TrophyEntity
    //시간 타입 설정 필요
    var createdAt: String
    var updatedAt: String
    
    //for identifiable: use trophy id
    var id: Int {
        trophy.id
    }
}

enum TrophyType: String, Decodable {
    case totalContentStudied = "TOTAL_CONTENT_STUDIED"
    case totalQuizGroupSolved = "TOTAL_QUIZ_GROUP_SOLVED"
    case chapterClear = "CHAPTER_CLEAR"
    case categoryClear = "CATEGORY_CLEAR"
    
    var description: String {
        switch self {
        case .totalContentStudied:
            return "누적 학습량"
        case .totalQuizGroupSolved:
            return "누적 퀴즈 풀이량"
        case .chapterClear:
            return "챕터 수료"
        case .categoryClear:
            return "카테고리 수료"
        }
    }
}

struct TrophyEntity: Decodable, Identifiable, Hashable {
    var id: Int
    var title: String
    var imageUrl: String
    var type: TrophyType
    var threshold: Int
}


