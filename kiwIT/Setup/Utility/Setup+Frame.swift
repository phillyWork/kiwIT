//
//  Setup+Frame.swift
//  kiwIT
//
//  Created by Heedon on 3/11/24.
//

import SwiftUI

extension Setup {
    
    enum Frame {
        
        static let deviceWidth = UIScreen.main.bounds.width
        
        static let nextContentButtonWidth = deviceWidth * 0.85
        static let nextContentButtonHeight = nextContentButtonWidth * 0.4
        
        static let socialLoginButtonWidth = deviceWidth * 0.8
        static let socialLoginButtonStackHeight = socialLoginButtonWidth * 0.3
        
        //컨텐츠 Image 비율 4:3 고정
        static let contentImageWidth = deviceWidth * 0.9
        static let contentImageHeight = contentImageWidth * 0.75
        
    }
    
}
