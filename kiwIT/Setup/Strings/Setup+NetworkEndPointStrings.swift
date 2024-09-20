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
        
        static let user = "/user"    //profile check, edit, withdraw
        
        static let userSignUp = "/sign-up"
        static let userSignIn = "/sign-in"
        static let userSignOut = "/sign-out"
        static let userRefreshAccessToken = "/refresh"
        static let userSummaryStat = "/stat"
        
        //MARK: - Lecture Contents
        
        static let lectureContent = "/content"
        
        static let lectureLevel = "/level"
        static let exerciseForLecture = "/exercise"
        static let lectureCategory = "/category"
        static let lectureNextToStudy = "/latest"
        static let completedLecture = "/studied"
        
        //MARK: - Quiz
        
        static let quiz = "/quiz"
        
        static let quizList = "/group"
        static let quizMostRecentTaken = "/latest-solved"
        static let quizTakenList = "/solved"
      
        static let bookmark = "/kept"
        
        //MARK: - Trophy
        
        static let trophy = "/trophy"
        
        static let acquiredTrophyList = "/my"
        static let latestAcquiredTrophy = "/latest"
        
        //MARK: - Interview
        
        static let interview = "/interview"
        
        static let interviewOption = "/option"
        static let interviewQuestion = "/question"
        static let interviewRoom = "/room"
        static let interviewRoomQueue = "/queue"
        
    }
    
}
