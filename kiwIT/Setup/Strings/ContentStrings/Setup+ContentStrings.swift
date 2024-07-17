//
//  Setup+ContentStrings.swift
//  kiwIT
//
//  Created by Heedon on 3/14/24.
//

import Foundation

extension Setup {
    
    enum ContentStrings {
        static let appTitle = "kiwIT"
        static let kakaoNativeKeyString = "KAKAO_NATIVE_APP_KEY"
        static let lectureContentTitle = "학습"
        static let quizContentTitle = "퀴즈"
        static let profileTitle = "유저 정보"
        static let interviewTitle = "인터뷰"
        
        static let confirm = "확인"
        static let cancel = "취소"
        
        static let loginErrorAlertTitle = "로그인 오류!"
        static let loginErrorAlertMessage = "세션이 만료되었어요. 다시 로그인해주세요."
        
        static let homeViewNavTitle = ["오늘은 어떤 걸 알아볼까요?",
                                       "Ready, Set, Study!",
                                       "Get Ready for the next Study!",]
    }
}
