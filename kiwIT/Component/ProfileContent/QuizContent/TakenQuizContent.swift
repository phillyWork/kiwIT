//
//  CompletedQuizContent.swift
//  kiwIT
//
//  Created by Heedon on 7/8/24.
//

import SwiftUI

//MARK: - 탭할 경우, 내부 퀴즈 목록 보여주는 것 시도?

struct TakenQuizContent: View {
    
    var quiz: TakenQuizResponse
    
    init(_ quiz: TakenQuizResponse) {
        self.quiz = quiz
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.shadowColor)
                .frame(width: Setup.Frame.profileQuizContentWidth, height: Setup.Frame.profileQuizContentHeight)
                .offset(CGSize(width: 4.0, height: 4.0))
            VStack(alignment: .center, spacing: 8) {
                Text(quiz.title)
                    .font(.custom(Setup.FontName.galMuri11Bold, size: 20))
                    .foregroundStyle(Color.brandTintColor)
                Text(quiz.subtitle)
                    .font(.custom(Setup.FontName.notoSansBold, size: 14))
                    .foregroundStyle(Color.brandColor)
            }
            .frame(width: Setup.Frame.profileQuizContentWidth, height: Setup.Frame.profileQuizContentHeight)
            .background(Color.surfaceColor)
            .overlay {
                HStack {
                    Text("LV. \(quiz.levelNum)")
                        .font(.custom(Setup.FontName.lineBold, size: 12))
                        .foregroundStyle(Color.textColor)
                    Spacer()
                }
                .padding(.horizontal, 8)
                .offset(CGSize(width: 0, height: Setup.Frame.profileQuizContentOverlayTakenQuizTextHeightOffset))
            }
            .overlay {
                HStack {
                    Text("최고 기록: \(quiz.result.highestScore)")
                        .font(.custom(Setup.FontName.notoSansMedium, size: 12))
                    Text("/")
                        .font(.custom(Setup.FontName.notoSansMedium, size: 12))
                    Text("최근 기록: \(quiz.result.latestScore)")
                        .font(.custom(Setup.FontName.notoSansMedium, size: 12))
                }
                .foregroundStyle(Color.textColor)
                .padding(.horizontal, 8)
                .offset(CGSize(width: 0, height: Setup.Frame.profileQuizContentOverlayTakenQuizScoreOffset))
            }
            .offset(CGSize(width: -4.0, height: -4.0))
        }
    }
}

#Preview {
    TakenQuizContent(TakenQuizResponse(id: 1, title: "Test Quiz Group 1", subtitle: "부제입니다", levelNum: 2, totalScore: 30, result: SubmitQuizResponse(userId: 1, quizGroupId: 1, latestScore: 10, highestScore: 20)))
}
