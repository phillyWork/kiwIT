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
        
        static let nextContentButtonWidth = devicePortraitWidth * 0.85
        static let nextContentButtonHeight = nextContentButtonWidth * 0.4
        
        static let socialLoginButtonWidth = devicePortraitWidth * 0.8
        static let socialLoginButtonStackHeight = socialLoginButtonWidth * 0.3
        
        //컨텐츠 리스트 개별 Item 크기
        static let contentListItemWidth = devicePortraitWidth * 0.9
        static let contentListCategoryItemHeight = contentListItemWidth * 0.55
        static let contentListChapterItemHeight = contentListItemWidth * 0.3
        static let contentListSectionItemHeight = contentListItemWidth * 0.2
        
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
        

        //컨텐츠 Image 비율 4:3 고정
        static let contentImageWidth = devicePortraitWidth * 0.9
        static let contentImageHeight = contentImageWidth * 0.75
        
        //확대 시의 Image 크기
        static let expandedContentImageWidth = devicePortraitHeight * 0.85
        static let expandedContentImageHeight = devicePortraitWidth * 0.9
        
        
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
        static let quizContentAnswerResultImageWidth = quizContentItemWidth * 0.2
        
        
    }
    
}
