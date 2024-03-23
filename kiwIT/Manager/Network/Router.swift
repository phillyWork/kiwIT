//
//  Router.swift
//  kiwIT
//
//  Created by Heedon on 3/23/24.
//

import Foundation
import Alamofire

enum Router: URLRequestConvertible {
    
    //MARK: - User
    case signUp
    case signIn
    case signOut
    case refreshToken
    case withdraw
    case acquiredTrophyList
    case mostRecentAcquiredTrophy
    case summaryStat
    
    //MARK: - Lecture Contents
    
    
    
    //MARK: - Quiz
    
    
    
    
    func asURLRequest() throws -> URLRequest {
        
    }
    
}
