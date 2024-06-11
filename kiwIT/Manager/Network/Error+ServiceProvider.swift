//
//  Error+ServiceProvider.swift
//  kiwIT
//
//  Created by Heedon on 6/11/24.
//

import Foundation

enum ServiceProviderError: Error {
    case kakaoError
    case appleError
    
    var message: String {
        switch self {
        case .kakaoError:
            return "카카오 계정 오류! 잠시 후 다시 시도해주세요"
        case .appleError:
            return "애플 계정 오류! 잠시 후 다시 시도해주세요"
        }
    }
}
