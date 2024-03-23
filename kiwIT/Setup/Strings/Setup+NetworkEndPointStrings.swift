//
//  Setup+NetworkURL.swift
//  kiwIT
//
//  Created by Heedon on 3/23/24.
//

import Foundation

extension Setup {
    
    enum NetworkEndpointStrings {
        
        //MARK: - User Account
        
        static let user = "user"    //profile check, edit, withdraw
        
        static let userSignUp = user+"/sign-up"
        static let userSignIn = user+"/sign-in"
        static let userSignOut = user+"/sign-out"
        static let userRefreshAccessToken = user+"/refresh"
        static let userAcquiredTrophyList = user+"/trophy"
        static let userRecentAcquiredTrophy = userAcquiredTrophyList+"/latest"
        static let userSummaryStat = user+"/stat"
        
        //MARK: - Lecture Contents
        
        static let content = "content/"
        
        
        
        
        //MARK: - Quiz
        
        static let quiz = "quiz/"
        
        
        
        
    }
    
}
