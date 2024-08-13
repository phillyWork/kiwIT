//
//  LectureLevelList.swift
//  kiwIT
//
//  Created by Heedon on 5/8/24.
//

import Foundation

struct LectureLevelListPayload: Codable, Hashable {
    var num: Int
    var title: String
    
    var id: Int {
        return num
    }
}
