//
//  Setup+ContentStrings+Quiz.swift
//  kiwIT
//
//  Created by Heedon on 9/9/24.
//

import Foundation

extension Setup.ContentStrings {
    
    enum Quiz {
        
        static let highestScoreTitle = "최고 기록: "
        static let latestScoreTitle = "최근 기록: "
        
        static let quizResultScoreTitle = "성취도: "
        
        static let takeQuizAgainButtonTitle = "다시 풀기"
        static let showQuizResultDetails = "상세 보기"
        static let confirmToMoveBackToQuizListTitle = "확인 완료"
        
        static let oxTrue = "O"
        static let oxFalse = "X"
        
        static let shortAnswerTextFieldPrompt = "정답을 입력해주세요"
        
        static let nextButtonTitle = "다음으로"
        static let submitButtonTitle = "제출하기"
        static let backButtonTitle = "이전으로"
        static let shouldChooseAnswerToMoveToNextQuestionAlertMessage = "정답을 선택해야 다음 문제로 넘어갈 수 있어요!"
        
        static let detailedQuizResultTitle = "상세 답안"
        static let detailedQuizResultUserAnswerTitle = "제출: "
        static let detailedQuizResultRightAnswerTitle = "정답: "
        
        static let quizAnswerExplanationTitle = "해설: "
        static let quizAnswerScoreTitle = "점수: "
        
        static let submitQuizProgressTitle = "답안 제출 중..."
        
        static let submitQuizAnswerErrorAlertMessage = "제출에 오류가 발생했습니다. 다시 시도하려면 확인 버튼을, 나가려면 취소 버튼을 눌러주세요."
        static let retryQuizErrorAlertMessage = "오류로 인해 해당 퀴즈의 다시 풀기가 불가합니다. 퀴즈 목록으로 돌아갑니다."
        
        static let takenQuizTitle = "문제 풀이 완료 콘텐츠"
        static let noneOfTakenQuizTitle = "문제 풀이 완료한 퀴즈가 없어요"
        
        static let unbookmarkQuizErrorAlertMessage = "보관함 제거에 실패했습니다. 다시 시도해주세요."
        static let bookmarkedQuizTitle = "보관한 컨텐츠"
        static let noneOfBookmarkedQuizTitle = "보관한 퀴즈가 없어요"
        static let unbookmarkThisQuizAlertMessage = "정말로 보관함에서 제거하실 건가요?"
        
    }
    
}
