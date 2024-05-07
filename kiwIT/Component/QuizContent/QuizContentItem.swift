//
//  QuizContentItem.swift
//  kiwIT
//
//  Created by Heedon on 5/7/24.
//

import SwiftUI

struct QuizContentItem: View {
    
    //var quizPayload: QuizPayload
    
    var quizContent: String
    
    init(content: String) {
        self.quizContent = content
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .fill(Color.shadowColor)
                .frame(width: Setup.Frame.quizContentItemWidth, height: Setup.Frame.quizContentItemWidth)
                .offset(CGSize(width: Setup.Frame.contentListShadowWidthOffset, height: Setup.Frame.contentListShadowHeightOffset))
            
            VStack {
                Text(quizContent)
                Text("Test for 단답형 주관식")
            }
            .frame(width: Setup.Frame.quizContentItemWidth, height: Setup.Frame.quizContentItemWidth)
            .background(Color.surfaceColor)
            .offset(CGSize(width: Setup.Frame.contentListItemWidthOffset, height: Setup.Frame.contentListItemHeightOffset))
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 5)
    }
}

#Preview {
    QuizContentItem(content: "Quiz 1. 이것은 무엇일까요?")
}
