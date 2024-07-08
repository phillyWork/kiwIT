//
//  CompletedQuizContent.swift
//  kiwIT
//
//  Created by Heedon on 7/8/24.
//

import SwiftUI

//MARK: - 탭할 경우, 내부 퀴즈 목록 보여주는 것 시도?

struct CompletedQuizContent: View {
    
    var quiz: TakenQuizResponse
    
    init(_ quiz: TakenQuizResponse) {
        self.quiz = quiz
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.shadowColor)
                .frame(width: Setup.Frame.profileQuizGroupContentWidth, height: Setup.Frame.profileQuizGroupContentHeight)
            VStack(spacing: 8) {
                Text(quiz.title)
                    .font(.custom(Setup.FontName.notoSansThin, size: 20))
                    .foregroundStyle(Color.textColor)
                Text(quiz.subtitle)
                    .font(.custom(Setup.FontName.notoSansLight, size: 15))
                    .foregroundStyle(Color.textColor)
            }
            .frame(width: Setup.Frame.profileQuizGroupContentWidth, height: Setup.Frame.profileQuizGroupContentHeight)
            .background(Color.brandBlandColor)
            .overlay {
                HStack {
                    Text("LV. \(quiz.levelNum)")
                        .font(.custom(Setup.FontName.lineRegular, size: 12))
                        .foregroundStyle(Color.textColor)
                    Spacer()
                }
                .padding(.horizontal, 8)
                .offset(CGSize(width: 0, height: Setup.Frame.profileQuizGroupContentOVerlayTextHeightOffset))
            }
            .offset(CGSize(width: -8.0, height: -8.0))
        }
    }
}

#Preview {
    CompletedQuizContent(TakenQuizResponse(id: 1, title: "Test Quiz Group 1", subtitle: "부제입니다", levelNum: 2, totalScore: 30, result: SubmitQuizResponse(userId: 1, quizGroupId: 1, latestScore: 10, highestScore: 20)))
}
