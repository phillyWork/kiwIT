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
        
        
        
        
        //컨텐츠 Image 비율 4:3 고정
        static let contentImageWidth = devicePortraitWidth * 0.9
        static let contentImageHeight = contentImageWidth * 0.75
        
        //확대 시의 Image 크기
        static let expandedContentImageWidth = devicePortraitHeight * 0.85
        static let expandedContentImageHeight = devicePortraitWidth * 0.9
        
    }
    
}
