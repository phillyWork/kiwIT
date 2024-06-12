//
//  AcquiredTrophyList.swift
//  kiwIT
//
//  Created by Heedon on 3/25/24.
//

import Foundation

//MARK: - Request

struct TrophyRequest: Encodable {
    var access: String
    var next: Int?
    var limit: Int?
}

//MARK: - Response

struct AcquiredTrophyListResponse: Decodable {
    var acquiredList: [AcquiredTrophy]
}

struct MostRecentAcquiredTrophyResponse: Decodable {
    var mostAcquiredTrophy: AcquiredTrophy
}

struct AcquiredTrophy: Decodable, Identifiable {
    
    //MARK: - userId 대신 Id로 받는 것 처리 필요
    
    var id: String
//    let userId: String
    var trophy: TrophyEntity
    //시간 타입 설정 필요
    var createdAt: String
    var updatedAt: String
}

struct TrophyEntity: Decodable, Identifiable {
    var id: String
    var title: String
    var imageUrl: String
}
