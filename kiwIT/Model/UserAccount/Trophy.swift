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

struct AcquiredTrophy: Decodable {
    let userId: String
    let trophy: TrophyEntity
    //시간 타입 설정 필요
    let createdAt: String
    let updatedAt: String
}

struct TrophyEntity: Decodable {
    let id: String
    let title: String
    let imageUrl: String
}
