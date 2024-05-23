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
    
    //문제 형식 따른 답변 형식도 설정 필요...
    
    //OX 가정
//    var quizIndex: Int
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
                Image(systemName: answer == submittedAnswer ? Setup.ImageStrings.defaultCheckMark : Setup.ImageStrings.defaultXMark)
                    .resizable()
                    .frame(width: Setup.Frame.quizContentAnswerResultImageWidth, height: Setup.Frame.quizContentAnswerResultImageWidth)
                    .foregroundStyle(answer == submittedAnswer ? Color.brandBlandColor : Color.errorHighlightColor)
                
                VStack {
    //                Text("\(quizIndex + 1). \(question)")
                    Text(question)
                        .multilineTextAlignment(.leading)
                        .font(.custom(Setup.FontName.notoSansBold, size: 25))
                    HStack {
                        Text("제출 답안: \(submittedAnswer ? "O" : "X")")
                            .font(.custom(Setup.FontName.lineRegular, size: 15))
                            .foregroundStyle(Color.textColor)
                        Divider()
                            .frame(maxHeight: 10)
                            .background(Color.textColor)
                        Text("실제 답안: \(answer ? "O" : "X")")
                            .font(.custom(Setup.FontName.lineRegular, size: 15))
                            .foregroundStyle(Color.textColor)
                    }
                }
                .padding()
            }
            .frame(width: Setup.Frame.quizContentItemWidth, height: Setup.Frame.quizContentAnswerDetailHeight)
            .background(Color.surfaceColor)
            .offset(CGSize(width: Setup.Frame.contentListItemWidthOffset, height: Setup.Frame.contentListItemHeightOffset))

        }
        .padding(.vertical, 8)
        .padding(.horizontal, 5)
    }
}

#Preview {
    QuizResultDetailEachQuestion(question: "OS는 운영체제이다", submittedAnswer: false, answer: true)
}
