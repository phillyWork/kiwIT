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
        
        static let unknownNetworkErrorAlertTitle = "네트워크 오류!"
        static let unknownNetworkErrorAlertMessage = "네트워크 요청에 실패했습니다! 다시 시도해주세요!"
        
        static let exampleQuestionsAlertTitle = "예제 문제"
        static let bookmarkThisLectureAlertTitle = "북마크"
        
        static let startLectureErrorAlertTitle = "학습 시작 오류!"
        static let completeLectureErrorAlertTitle = "학습 완료 오류!"
        
        static let submitLectureExampleErrorAlertTitle = "예제 제출 오류!"
        static let bookmarkErrorAlertTitle = "북마크 오류!"
        
        static let submitQuizAnswerErrorAlertTitle = "답안 제출 오류!"
        static let retakeQuizErrorAlertTitle = "다시 풀기 오류!"
        
        static let editNicknameAlertTitle = "닉네임 수정"
        static let editNicknameErrorAlertTitle = "닉네임 수정 오류!"
        
        static let logoutSuccessAlertTitle = "로그아웃 성공"
        static let logoutErrorAlertTitle = "로그아웃 실패!"
        
        static let withdrawEmailTextfieldAlertTitle = "탈퇴 확인용 이메일 입력"
        static let withdrawEmailInputErrorAlertTitle = "잘못된 입력입니다!"
        
        static let withdrawSuccessAlertTitle = "탈퇴 완료"
        static let withdrawErrorAlertTitle = "탈퇴 실패!"
        
        static let removeBookmarkedContentErrorAlertTitle = "보관함 제거 오류!"
        static let removeBookmarkedContentAlertTitle = "보관함 제거?"
        
        
        static let homeViewNavTitle = ["자, 이제 시작이야!",
                                       "CS, 갑니다!",
                                       "Get Ready for the next Study!",
                                       "응. 공부해야해.",
                                       "한계를 뚫을 드릴이다!",
                                       "까짓거 한번 해보죠",
        ]
    }
}
