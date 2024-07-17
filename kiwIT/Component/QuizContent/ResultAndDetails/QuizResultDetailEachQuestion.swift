//
//  QuizResultDetailEachQuestion.swift
//  kiwIT
//
//  Created by Heedon on 5/20/24.
//

import SwiftUI

struct QuizResultDetailEachQuestion: View {
    
    var eachQuestionWithAnswer: DetailedEachQuestionResult
    
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .fill(Color.shadowColor)
                .frame(width: Setup.Frame.quizContentItemWidth, height: Setup.Frame.quizContentAnswerDetailHeight)
                .offset(CGSize(width: Setup.Frame.contentListShadowWidthOffset, height: Setup.Frame.contentListShadowHeightOffset))
            HStack {
                Image(systemName: eachQuestionWithAnswer.answer == eachQuestionWithAnswer.userSubmit ? Setup.ImageStrings.defaultCircle : Setup.ImageStrings.defaultXMark)
                    .resizable()
                    .frame(width: Setup.Frame.quizContentAnswerResultImageWidth, height: Setup.Frame.quizContentAnswerResultImageWidth)
                    .scaledToFit()
                    .padding()
                    .foregroundStyle(eachQuestionWithAnswer.answer == eachQuestionWithAnswer.userSubmit ? Color.brandBlandColor : Color.errorHighlightColor)
                VStack {
                    Text(eachQuestionWithAnswer.question)
                        .multilineTextAlignment(.leading)
                        .lineLimit(3)
                        .font(.custom(Setup.FontName.notoSansBold, size: 20))
                        .minimumScaleFactor(0.8)
                    HStack {
                        Text("제출: \(eachQuestionWithAnswer.userSubmit)")
                            .font(.custom(Setup.FontName.lineRegular, size: 15))
                            .foregroundStyle(Color.textColor)
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                        Divider()
                            .frame(maxHeight: 10)
                            .background(Color.textColor)
                        Text("정답: \(eachQuestionWithAnswer.answer)")
                            .font(.custom(Setup.FontName.lineRegular, size: 15))
                            .foregroundStyle(Color.textColor)
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 4)
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
    VStack {
        QuizResultDetailEachQuestion(eachQuestionWithAnswer: DetailedEachQuestionResult(question: "질문 1 예제 문제입니다 화이팅스 ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ ㄴㅇㄹㄴㅇㄹㄴㅇㄹㄴㅇㄹㄴㅇㄹ", userSubmit: "1", answer: "예시 답변입니다 테스트 테스트 test est test test test tes test tests "))
        QuizResultDetailEachQuestion(eachQuestionWithAnswer: DetailedEachQuestionResult(question: "질문 2", userSubmit: "DFS", answer: "Depth First Search sdfsdfsdfsdfsdfsdfsdfasdfasdfasdf"))
        QuizResultDetailEachQuestion(eachQuestionWithAnswer: DetailedEachQuestionResult(question: "질문 3", userSubmit: "DFS", answer: "DFS"))
        QuizResultDetailEachQuestion(eachQuestionWithAnswer: DetailedEachQuestionResult(question: "질문 4", userSubmit: "1", answer: "3"))
    }
}
