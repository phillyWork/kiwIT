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
                    .font(.custom(Setup.FontName.galMuri11Bold, size: 25))
                    .foregroundStyle(Color.brandColor)
                Text(latestTakenQuiz.subtitle)
                    .font(.custom(Setup.FontName.notoSansBold, size: 15))
                    .foregroundStyle(Color.brandTintColor2)
            }
            .frame(width: Setup.Frame.homeViewContentWidth, height: Setup.Frame.homeViewNextLectureHeight)
            .background(Color.surfaceColor)
            .overlay {
                HStack {
                    Text("LV. \(latestTakenQuiz.levelNum)")
                        .font(.custom(Setup.FontName.lineBold, size: 12))
                        .foregroundStyle(Color.textColor)
                    Spacer()
                }
                .padding(.horizontal, 8)
                .offset(CGSize(width: 0, height: Setup.Frame.homeViewNextLectureLevelOffsetHeight))
            }
            .overlay {
                HStack {
                    Text("최고 기록: \(latestTakenQuiz.result.highestScore)")
                        .font(.custom(Setup.FontName.notoSansMedium, size: 12))
                    Text("/")
                        .font(.custom(Setup.FontName.notoSansMedium, size: 12))
                    Text("최근 기록: \(latestTakenQuiz.result.latestScore)")
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
                        Text("다시풀기")
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

//#Preview {
//    LatestTakenQuizView(latestTakenQuiz: TakenQuizResponse(id: 2, title: "quiz title 1", subtitle: "sub title 2", levelNum: 3, totalScore: 30, result: SubmitQuizResponse(userId: 33, quizGroupId: 2, latestScore: 30, highestScore: 30))) {
//        print("HIHI")
//    }
//}
