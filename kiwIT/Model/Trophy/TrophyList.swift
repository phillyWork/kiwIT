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

struct TrophyEntity: Decodable, Identifiable {
    var id: Int
    var title: String
    var imageUrl: String
}
