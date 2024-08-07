//
//  Setup+NetworkStrings.swift
//  kiwIT
//
//  Created by Heedon on 3/24/24.
//

import Foundation

extension Setup {
    enum NetworkStrings {
        static let accessTokenToCheckTitle = "Authorization"
        static let authorizationPrefixHeaderTitle = "Bearer "
        static let emailTitle = "email"
        static let nicknameTitle = "nickname"
        static let providerTitle = "provider"
        static let accessTokenTitle = "token"
        static let refreshTokenTitle = "refreshToken"
        static let lectureExerciseAnswerTitle = "answer"
        static let submitQuizAnswerListTitle = "answerList"
        static let queryStringNextPageTitle = "next"
        static let queryStringLimitPageTitle = "limit"
        static let queryStringByLevelTitle = "byLevel"
        static let queryStringTagTitle = "tag"
        static let interviewTitle = "title"
        
        //MARK: - 추가적으로 API 업데이트 시 수정 필요
        static let createInterviewLevelOption = "level"
        static let createInterviewCategoryTitle = "category"
        
        static let submitInterviewAnswerListTitle = "answerList"
    }
}
