//
//  CompletedQuizContent.swift
//  kiwIT
//
//  Created by Heedon on 7/8/24.
//

import SwiftUI

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
                    .foregroundStyle(Color.brandColor)
                Text(quiz.subtitle)
                    .font(.custom(Setup.FontName.notoSansBold, size: 14))
                    .foregroundStyle(Color.brandTintColor2)
            }
            .frame(width: Setup.Frame.profileQuizContentWidth, height: Setup.Frame.profileQuizContentHeight)
            .background(Color.surfaceColor)
            .overlay {
                HStack {
                    Text(Setup.ContentStrings.level + "\(quiz.levelNum)")
                        .font(.custom(Setup.FontName.lineBold, size: 12))
                        .foregroundStyle(Color.textColor)
                    Spacer()
                }
                .padding(.horizontal, 8)
                .offset(CGSize(width: 0, height: Setup.Frame.profileQuizContentOverlayTakenQuizTextHeightOffset))
            }
            .overlay {
                HStack {
                    Text(Setup.ContentStrings.Quiz.highestScoreTitle + "\(quiz.result.highestScore)")
                        .font(.custom(Setup.FontName.notoSansMedium, size: 12))
                    Text("/")
                        .font(.custom(Setup.FontName.notoSansMedium, size: 12))
                    Text(Setup.ContentStrings.Quiz.latestScoreTitle + "\(quiz.result.latestScore)")
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
