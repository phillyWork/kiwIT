//
//  AcquireTrophy.swift
//  kiwIT
//
//  Created by Heedon on 7/7/24.
//

import Foundation

struct AcquireTrophyResponse: Decodable {
    var userId: Int
    //trophy field는 항상 Null
    var createdAt: String
    var updatedAt: String
}
