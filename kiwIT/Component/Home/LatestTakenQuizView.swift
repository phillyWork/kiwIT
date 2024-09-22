//
//  LatestTakenQuiz.swift
//  kiwIT
//
//  Created by Heedon on 7/17/24.
//

import SwiftUI

struct LatestTakenQuizView: View {
    
    var latestTakenQuiz: TakenQuizResponse
    var quizAction: () -> Void
    
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .fill(Color.shadowColor)
                .frame(width: Setup.Frame.homeViewContentWidth, height: Setup.Frame.homeViewNextLectureHeight)
                .offset(CGSize(width: Setup.Frame.contentListShadowWidthOffset, height: Setup.Frame.contentListShadowHeightOffset))
            VStack {
                Text(latestTakenQuiz.title)
                    .font(.custom(Setup.FontName.galMuri11Bold, size: 23))
                    .foregroundStyle(Color.brandColor)
//                Text(latestTakenQuiz.subtitle)
//                    .font(.custom(Setup.FontName.notoSansBold, size: 15))
//                    .foregroundStyle(Color.brandTintColor2)
            }
            .frame(width: Setup.Frame.homeViewContentWidth, height: Setup.Frame.homeViewNextLectureHeight)
            .background(Color.surfaceColor)
            .overlay {
                HStack {
                    Text(Setup.ContentStrings.level + "\(latestTakenQuiz.levelNum)")
                        .font(.custom(Setup.FontName.lineBold, size: 12))
                        .foregroundStyle(Color.textColor)
                    Spacer()
                }
                .padding(.horizontal, 8)
                .offset(CGSize(width: 0, height: Setup.Frame.homeViewNextLectureLevelOffsetHeight))
            }
            .overlay {
                HStack {
                    Text(Setup.ContentStrings.Quiz.highestScoreTitle + "\(latestTakenQuiz.result.highestScore)")
                        .font(.custom(Setup.FontName.notoSansMedium, size: 12))
                    Text("/")
                        .font(.custom(Setup.FontName.notoSansMedium, size: 12))
                    Text(Setup.ContentStrings.Quiz.latestScoreTitle +  "\(latestTakenQuiz.result.latestScore)")
                        .font(.custom(Setup.FontName.notoSansMedium, size: 12))
                }
                .foregroundStyle(Color.textColor)
                .padding(.horizontal, 8)
                .offset(CGSize(width: 0, height: Setup.Frame.homeViewNextLectureButtonOffsetHeight))
            }
            .overlay {
                HStack {
                    Spacer()
                    Button {
                        quizAction()
                    } label: {
                        Text(Setup.ContentStrings.Quiz.takeQuizAgainButtonTitle)
                            .font(.custom(Setup.FontName.lineBold, size: 12))
                            .foregroundStyle(Color.textColor)
                    }
                }
                .padding(.horizontal, 8)
                .offset(CGSize(width: 0, height: Setup.Frame.homeViewNextLectureButtonOffsetHeight))
            }
            .offset(CGSize(width: Setup.Frame.contentListItemWidthOffset, height: Setup.Frame.contentListItemHeightOffset))
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 10)
    }
}
