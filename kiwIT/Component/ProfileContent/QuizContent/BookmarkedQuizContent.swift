//
//  BookmarkedQuizContent.swift
//  kiwIT
//
//  Created by Heedon on 7/8/24.
//

import SwiftUI

struct BookmarkedQuizContent: View {
    
    var quiz: BookmarkedQuizListResponse
    var bookmarkAction: () -> Void
    
    init(_ quiz: BookmarkedQuizListResponse, action: @escaping () -> Void) {
        self.quiz = quiz
        self.bookmarkAction = action
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.shadowColor)
                .frame(width: Setup.Frame.profileQuizContentWidth, height: Setup.Frame.profileQuizBookmarkedContentHeight)
                .offset(CGSize(width: 4.0, height: 4.0))
            VStack(spacing: 10) {
                Text(quiz.question)
                    .multilineTextAlignment(.leading)
                    .font(.custom(Setup.FontName.galMuri11Bold, size: 18))
                    .foregroundStyle(Color.brandColor)
                Text("정답: \(quiz.answer)")
                    .font(.custom(Setup.FontName.notoSansBold, size: 15))
                    .foregroundStyle(Color.textColor)
            }
            .frame(width: Setup.Frame.profileQuizContentWidth, height: Setup.Frame.profileQuizBookmarkedContentHeight)
            .background(Color.surfaceColor)
            .overlay {
                Text("해설: \(quiz.answer)")
                    .multilineTextAlignment(.leading)
                    .font(.custom(Setup.FontName.notoSansBold, size: 13))
                    .foregroundStyle(Color.textColor)
                    .offset(CGSize(width: 0, height: Setup.Frame.profileQuizContentAnswerExplanationOverlayHeightOffset))
            }
            .overlay {
                HStack {
                    Text("점수: \(quiz.score)")
                        .font(.custom(Setup.FontName.lineBold, size: 12))
                        .foregroundStyle(Color.textColor)
                    Spacer()
                    Button {
                        bookmarkAction()
                    } label: {
                        Image(systemName: Setup.ImageStrings.bookmarked)
                            .foregroundStyle(Color.errorHighlightColor)
                    }
                }
                .padding(.horizontal, 8)
                .offset(CGSize(width: 0, height: Setup.Frame.profileQuizContentOverlayTextHeightOffset))
            }
            .offset(CGSize(width: -4.0, height: -4.0))
        }
    }
}

#Preview {
    VStack(spacing: 30) {
        BookmarkedQuizContent(BookmarkedQuizListResponse(id: 1, type: .shortAnswer, title: "문제 2", question: "질문 1sd fsdfs dfsdf sdfs dfsdf sdfsdfsdfsdf", answer: "DFS", explanation: "DFS 설명", score: 10, result: BookmarkQuiz(userId: 2, quizId: 1, correct: "DFS", myAnswer: "DFS"))) {
            print("Unbookmark Quiz")
        }
        BookmarkedQuizContent(BookmarkedQuizListResponse(id: 1, type: .shortAnswer, title: "문제 2", question: "질문 1", answer: "DFS", explanation: "DFS 설명", score: 10)) {
            print("Unbookmark Quiz")
        }
    }
}
