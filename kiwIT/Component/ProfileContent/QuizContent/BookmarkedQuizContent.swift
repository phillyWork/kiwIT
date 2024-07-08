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
                .frame(width: Setup.Frame.profileQuizGroupContentWidth, height: Setup.Frame.profileQuizGroupContentHeight)
            VStack(spacing: 8) {
                Text(quiz.title)
                    .font(.custom(Setup.FontName.notoSansThin, size: 20))
                    .foregroundStyle(Color.textColor)
                Text(quiz.answer)
                    .font(.custom(Setup.FontName.notoSansLight, size: 15))
                    .foregroundStyle(Color.textColor)
            }
            .frame(width: Setup.Frame.profileQuizGroupContentWidth, height: Setup.Frame.profileQuizGroupContentHeight)
            .background(Color.brandBlandColor)
            .overlay {
                HStack {
                    Text("LV. \(quiz.score)")
                        .font(.custom(Setup.FontName.lineRegular, size: 12))
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
                .offset(CGSize(width: 0, height: Setup.Frame.profileQuizGroupContentOVerlayTextHeightOffset))
            }
            .offset(CGSize(width: -8.0, height: -8.0))
        }
    }
}

#Preview {
    VStack {
        BookmarkedQuizContent(BookmarkedQuizListResponse(id: 1, type: .shortAnswer, title: "문제 2", question: "질문 1", answer: "DFS", explanation: "DFS 설명", score: 10, result: BookmarkQuiz(userId: 2, quizId: 1, correct: "DFS", myAnswer: "DFS"))) {
            print("Unbookmark Quiz")
        }
        BookmarkedQuizContent(BookmarkedQuizListResponse(id: 1, type: .shortAnswer, title: "문제 2", question: "질문 1", answer: "DFS", explanation: "DFS 설명", score: 10)) {
            print("Unbookmark Quiz")
        }
    }
}
