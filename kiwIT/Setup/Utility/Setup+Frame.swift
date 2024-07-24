//
//  Setup+Frame.swift
//  kiwIT
//
//  Created by Heedon on 3/11/24.
//

import SwiftUI

extension Setup {
    
    enum Frame {
        
        static let devicePortraitWidth = UIScreen.main.bounds.width
        static let devicePortraitHeight = UIScreen.main.bounds.height
        
        static let shrinkAnimationButtonWidth = devicePortraitWidth * 0.85
        static let shrinkAnimationButtonHeight = shrinkAnimationButtonWidth * 0.2
        
        static let socialLoginButtonWidth = devicePortraitWidth * 0.8
        static let socialLoginButtonStackHeight = socialLoginButtonWidth * 0.3
        
        static let signUpContentWidth = devicePortraitWidth * 0.9
        static let signUpConfirmScrollViewHeight = devicePortraitHeight * 0.45
        
        static let homeViewContentWidth = devicePortraitWidth * 0.88
        static let homeViewNextLectureHeight = homeViewContentWidth * 0.35
        static let homeViewNextLectureLevelOffsetHeight = -(homeViewNextLectureHeight/3)
        static let homeViewNextLectureButtonOffsetHeight = (homeViewNextLectureHeight/3)
        
        //컨텐츠 리스트 개별 Item 크기
        static let contentListItemWidth = devicePortraitWidth * 0.9
        
        static let contentListCategoryItemHeight = contentListItemWidth * 0.4
        static let contentListChapterItemHeight = contentListItemWidth * 0.3
        static let contentListNotExpandableHeight = contentListItemWidth * 0.35
        
        static let contentListCategoryImageWidth = contentListItemWidth * 0.65
        static let contentListCategoryImageHeight = contentListCategoryImageWidth * 0.75
        
        static let contentListItemWidthOffset = -5.0
        static let contentListItemHeightOffset = -4.0
        
        static let contentListShadowWidthOffset = 5.0
        static let contentListShadowHeightOffset = 4.0
        
        static let contentCategoryTrapezoidWidthOffset = -7.0
        static let contentCategoryTrapezoidHeightOffset = -7.0
        
        static let contentShadowTrapezoidWidthOffset = 7.0
        static let contentShadowTrapezoidHeightOffset = 7.0
        
        static let contentCategoryTrapezoidCompleteWidthOffset = 80
        static let contentCategoryTrapezoidCompleteHeightOffset = 80
        
        
        //컨텐츠 완료 표시용 이미지 크기
        static let contentListCategoryCompleteImageWidth = contentListItemWidth * 0.1
        static let contentListCategoryCompleteImageHeight = contentListItemWidth * 0.1
        
        static let contentListChapterCompleteImageWidth = contentListItemWidth * 0.1
        static let contentListChapterCompleteImageHeight = contentListItemWidth * 0.1
        
        static let contentListSectionCompleteImageWidth = contentListItemWidth * 0.05
        static let contentListSectionCompleteImageHeight = contentListItemWidth * 0.05
    
        static let contentImageWidth = devicePortraitWidth * 0.9
        static let contentImageHeight = contentImageWidth * 0.75
    
        //퀴즈용 크기 개별 Item 크기
        static let quizContentListItemWidth = devicePortraitWidth * 0.85
        static let quizContentListItemHeight = quizContentListItemWidth * 0.35

        //개별 퀴즈 문제 크기
        static let quizContentItemWidth = devicePortraitWidth * 0.88
        static let quizContentOXItemHeight = quizContentItemWidth * 1.25
        static let quizContentMultipleChoiceItemHeight = quizContentItemWidth * 1.5
        static let quizContentShortAnswerItemHeight = quizContentItemWidth * 1.34
        
        static let quizContentOXButtonWidth = quizContentItemWidth * 0.45
        static let quizContentOXButtonHeight = quizContentOXButtonWidth * 0.3
        
        static let quizContentMultipleChoiceButtonWidth = quizContentItemWidth * 0.9
        static let quizContentMultipleChoiceButtonHeight = quizContentMultipleChoiceButtonWidth * 0.2
        
        static let quizContentShortAnswerTextFieldWidth = quizContentItemWidth * 0.78
        static let quizContentShortAnswerTextFieldHeight = quizContentShortAnswerTextFieldWidth * 0.2
                
        static let quizContentAnswerHeight = quizContentItemWidth * 1.2
        static let quizContentAnswerButtonWidth = quizContentItemWidth * 0.4
        static let quizContentAnswerButtonHeight = quizContentAnswerButtonWidth * 0.75
        
        static let quizContentAnswerDetailHeight = quizContentItemWidth * 0.35
        static let quizContentAnswerResultImageWidth = quizContentItemWidth * 0.15
        
        static let profileContentHeight = contentListItemWidth * 0.3
        
        static let profileContentEquallyDivide = devicePortraitHeight/2
        
        static let profileLectureContentWidth = devicePortraitWidth * 0.95
        static let profileLectureContentHeight = profileLectureContentWidth * 0.28
        
        static let profileLectureContentOverlayTextWidthOffset = -(profileLectureContentWidth/2.5)
        static let profileLectureContentOverlayTextHeightOffset = -(profileLectureContentHeight/3)
        
        static let profileLectureContentHGridHeight = profileLectureContentHeight * 2.3
        static let profileLectureContentHScrollHeight = profileLectureContentHeight * 2.45
        
        static let profileQuizContentWidth = devicePortraitWidth * 0.95
        static let profileQuizContentHeight = profileQuizContentWidth * 0.33
        
        static let profileQuizBookmarkedContentHeight = profileQuizContentWidth * 0.7
        
        static let profileQuizContentOverlayTextWidthOffset = -(profileQuizContentWidth/2.5)
        static let profileQuizContentOverlayTakenQuizTextHeightOffset = -(profileQuizContentHeight/2.5)
        static let profileQuizContentOverlayTakenQuizScoreOffset = profileQuizContentHeight/2.5
        
        static let profileQuizContentOverlayTextHeightOffset = -(profileQuizBookmarkedContentHeight/2.5)
        static let profileQuizContentAnswerExplanationOverlayHeightOffset = profileQuizBookmarkedContentHeight/3.0
        
        static let profileQuizContentHGridHeight = profileQuizContentHeight * 2.3
        static let profileQuizContentHScrollHeight = profileQuizContentHeight * 2.45
        
        //트로피 이미지 크기
        static let trophyContentWidth = devicePortraitWidth * 0.93
        static let trophyContentHeight = trophyContentWidth * 0.33
        
        static let recentlyAcquiredTrophyContentWidth = devicePortraitWidth * 0.17
        static let recentlyAcquiredTrophyContentHeight = recentlyAcquiredTrophyContentWidth * 1.33
        
        static let recentlyAcquiredTrophyCardViewHeight = devicePortraitHeight * 0.45
        
        static let recentlyAcquiredTrophyNotifyViewHeight = devicePortraitHeight * 0.05
        
        static let recentlyAcquiredTrophyImageWidth = contentImageWidth * 0.7
        static let recentlyAcquiredTrophyImageHeight = recentlyAcquiredTrophyCardViewHeight * 0.5
        
    }
    
}
