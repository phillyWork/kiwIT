//
//  QuizResultDetailEachQuestion.swift
//  kiwIT
//
//  Created by Heedon on 5/20/24.
//

import SwiftUI

struct QuizResultDetailEachQuestion: View {
    
    //번호, 문제, 제출 답안, 실제 답안, 오답 여부 (원래라면 모델로 한번에 전달)
  
    //해설까지 같이 전달받을 수도 있음
    
    //OX 가정
    var quizIndex: Int
    var question: String
    var submittedAnswer: Bool
    var answer: Bool
    
    var body: some View {
        ZStack(alignment: .center) {
            
            Rectangle()
                .fill(Color.shadowColor)
                .frame(width: Setup.Frame.quizContentItemWidth, height: Setup.Frame.quizContentAnswerDetailHeight)
                .offset(CGSize(width: Setup.Frame.contentListShadowWidthOffset, height: Setup.Frame.contentListShadowHeightOffset))
            
            HStack {
                
                Text("Test 결과입니다")
                    .multilineTextAlignment(.leading)
                    .font(.custom(Setup.FontName.notoSansBold, size: 12))
                
            }
            .frame(width: Setup.Frame.quizContentItemWidth, height: Setup.Frame.quizContentAnswerDetailHeight)
            .background(answer == submittedAnswer ? Color.brandBlandColor : Color.errorHighlightColor)
            .offset(CGSize(width: Setup.Frame.contentListItemWidthOffset, height: Setup.Frame.contentListItemHeightOffset))
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 5)
    }
}

#Preview {
    QuizResultDetailEachQuestion(quizIndex: 0, question: "OS는 운영체제이다", submittedAnswer: true, answer: true)
}
