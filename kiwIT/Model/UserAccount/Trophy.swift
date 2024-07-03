//
//  AcquiredTrophyList.swift
//  kiwIT
//
//  Created by Heedon on 3/25/24.
//

import Foundation

import Alamofire

//MARK: - Request

struct TrophyRequest {
    var access: String
    var next: Int?
    var limit: Int?
}

//MARK: - Response

struct AcquiredTrophyListResponse: Decodable {
    var acquiredList: [AcquiredTrophy]
}

struct MostRecentAcquiredTrophySuccess: Decodable {
    var mostAcquiredTrophy: AcquiredTrophy
}

enum MostRecentAcquiredTrophyResponse: Decodable {
    case success(MostRecentAcquiredTrophySuccess)
    case emptyBody          //Empty Body

    enum CodingKeys: String, CodingKey {
        case acquiredList
        case emptyBody
    }
        
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        if let acquired = try? container.decode(AcquiredTrophy.self, forKey: .acquiredList) {
            let mostTrophySuccess = MostRecentAcquiredTrophySuccess(mostAcquiredTrophy: acquired)
            print("Most Recent Acquired Trophy data: \(mostTrophySuccess)")
            self = .success(mostTrophySuccess)
        } else if let emptyBody = try? container.decode(Empty.self, forKey: .emptyBody) {
            print("No Acquired Trophy Data")
            self = .emptyBody
        } else {
            throw DecodingError.dataCorrupted(.init(codingPath: decoder.codingPath, debugDescription: "Data does not match any MostRecentlyAcquiredTrophy type"))
        }
    }
}


struct AcquiredTrophy: Decodable, Identifiable {
    var id: String
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
