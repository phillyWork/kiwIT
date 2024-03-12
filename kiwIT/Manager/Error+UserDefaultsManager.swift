//
//  Error+UserDefaultsManager.swift
//  kiwIT
//
//  Created by Heedon on 3/12/24.
//

import Foundation

enum UserDefaultsError: Error {
    case noDataInUserDefaults
    case cannotDecodeData
}
