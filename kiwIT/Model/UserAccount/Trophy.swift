//
//  AcquiredTrophyList.swift
//  kiwIT
//
//  Created by Heedon on 3/25/24.
//

import Foundation

//MARK: - Request

struct TrophyRequest: Encodable {
    let access: String
    var next: Int?
    var limit: Int?
}

//MARK: - Response

struct AcquiredTrophyListResponse: Decodable {
    let acquiredList: [AcquiredTrophy]
}

struct MostRecentAcquiredTrophyResponse: Decodable {
    let mostAcquiredTrophy: AcquiredTrophy
}

struct AcquiredTrophy: Decodable, Identifiable {
    
    //MARK: - userId 대신 Id로 받는 것 처리 필요
    
    let id: String
//    let userId: String
    let trophy: TrophyEntity
    //시간 타입 설정 필요
    let createdAt: String
    let updatedAt: String
}

struct TrophyEntity: Decodable, Identifiable {
    let id: String
    let title: String
    let imageUrl: String
}
