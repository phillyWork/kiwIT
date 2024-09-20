//
//  Setup+ContentStrings+Lecture.swift
//  kiwIT
//
//  Created by Heedon on 9/9/24.
//

import Foundation

extension Setup.ContentStrings {
    
    enum Lecture {
        
        static let moveToLectureButtonTitle = "학습하러 가기"
        
        static let loadingProgressTitle = "컨텐츠 불러오는 중..."
        
        static let showExampleTitle = "예제 보기"
        static let confirmStudyCompleteTitle = "학습 완료"
        
        static let defaultExampleQuizMessage = "본문 예제 문제입니다"
        
        static let exampleCorrectAnswerAlertTitle = "정답입니다!"
        static let exampleWrongAnswerAlertTitle = "오답입니다!"
        
        static let bookmarkThisLectureAlertMessage = "학습 자료를 보관함에 넣을까요?"
        static let confirmBookmarkThisLectureButtonTitle = "넣어주세요"
        static let cancelBookmarkThisLectureButtonTitle = "아니요, 괜찮습니다"
        
        static let loadingLectureErrorAlertMessage = "컨텐츠를 불러오는 데 오류가 발생했습니다. 다시 시도해주세요."
        static let completeLectureErrorAlertMessage = "학습 완료 처리에 실패했습니다. 다시 시도해주세요."
        static let submitExampleAnswerErrorAlertMessage = "예제 풀이 등록에 실패했습니다. 다시 시도해주세요."
        static let bookmarkLectureErrorAlertMessage = "보관함 처리에 실패했습니다. 다시 시도해주세요."
        
        static let completedLectureTitle = "학습 완료 컨텐츠"
        static let noneOfCompletedLectureTitle = "학습 완료한 컨텐츠가 없어요"

        static let unbookmarkLectureErrorAlertMessage = "보관함 제거에 실패했습니다. 다시 시도해주세요."
        static let bookmarkedLectureTitle = "보관한 컨텐츠"
        static let noneOfBookmarkedLectureTitle = "보관한 학습 컨텐츠가 없어요"
        static let unbookmarkThisLectureAlertMessage = "정말로 보관함에서 제거하실 건가요?"
        
    }
    
}
