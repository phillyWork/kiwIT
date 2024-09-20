//
//  QuizMultipleChoice.swift
//  kiwIT
//
//  Created by Heedon on 5/13/24.
//

import SwiftUI

struct QuizMultipleChoice: View {
    
    //0: 선택하지 않음
    @State private var internalUserChoiceNumber: Int
    
    var quizPayload: QuizPayload
    var quizIndex: Int
    var quizCount: Int
    
    var completion: (Result<Int, QuizError>) -> Void
    var bookmarkAction: (Int) -> Void
    
    init(userChoiceNumber: Int, quizPayload: QuizPayload, quizIndex: Int, quizCount: Int, completion: @escaping (Result<Int, QuizError>) -> Void, bookmarkAction: @escaping (Int) -> Void) {
        self._internalUserChoiceNumber = State(initialValue: userChoiceNumber)
        self.quizPayload = quizPayload
        self.quizIndex = quizIndex
        self.quizCount = quizCount
        self.completion = completion
        self.bookmarkAction = bookmarkAction
    }
    
    var body: some View {
        VStack {
            ZStack(alignment: .center) {
                Rectangle()
                    .fill(Color.shadowColor)
                    .frame(width: Setup.Frame.quizContentItemWidth, height: Setup.Frame.quizContentMultipleChoiceItemHeight)
                    .offset(CGSize(width: Setup.Frame.contentListShadowWidthOffset, height: Setup.Frame.contentListShadowHeightOffset))
                VStack {
                    Text(quizPayload.question)
                        .multilineTextAlignment(.leading)
                        .font(.custom(Setup.FontName.notoSansBold, size: 20))
                        .foregroundStyle(Color.textColor)
                    VStack {
                        if let choiceList = quizPayload.choiceList {
                            ForEach(choiceList, id: \.self) { eachChoice in
                                Button {
                                    internalUserChoiceNumber = internalUserChoiceNumber == eachChoice.number ? 0 : eachChoice.number
                                } label: {
                                    QuizMultipleChoiceButtonLabel(choiceLabel: eachChoice.payload)
                                }
                                .background(internalUserChoiceNumber == eachChoice.number ? Color.brandColor : Color.surfaceColor)
                            }
                        }
                    }
                }
                .frame(width: Setup.Frame.quizContentItemWidth, height: Setup.Frame.quizContentMultipleChoiceItemHeight)
                .background(Color.surfaceColor)
                .offset(CGSize(width: Setup.Frame.contentListItemWidthOffset, height: Setup.Frame.contentListItemHeightOffset))
                .overlay {
                    Button {
                        bookmarkAction(quizPayload.id)
                    } label: {
                        Image(systemName: quizPayload.kept ? Setup.ImageStrings.bookmarked : Setup.ImageStrings.bookmarkNotYet)
                    }
                    .offset(CGSize(width: Setup.Frame.quizContentItemWidth/2.5, height: -Setup.Frame.quizContentMultipleChoiceItemHeight/2.3))
                }
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 5)
            HStack {
                if (quizIndex != 0) {
                    Spacer()
                    Button {
                        self.completion(.failure(.backToPreviousQuestion))
                    } label: {
                        Text(Setup.ContentStrings.Quiz.backButtonTitle)
                    }
                }
                Spacer()
                Button {
                    self.completion(.success(internalUserChoiceNumber))
                } label: {
                    Text(quizIndex == quizCount - 1 ? Setup.ContentStrings.Quiz.submitButtonTitle : Setup.ContentStrings.Quiz.nextButtonTitle)
                }
                Spacer()
            }
        }
    }
}

#Preview {
    QuizMultipleChoice(userChoiceNumber: 0, quizPayload: QuizPayload(id: 1, type: .multipleChoice, title: "문제 1", question: "질문 1. sdfsdfsdfsdfsdfsdfsdf sdfsdf dfdfdf sdfsdf", answer: "2", explanation: "정답 설명", score: 5, choiceList: [MultipleChoiceList(number: 1, quizId: 1, payload: "1번 선택지"), MultipleChoiceList(number: 2, quizId: 1, payload: "2번 선택지"), MultipleChoiceList(number: 3, quizId: 1, payload: "3번 선택지"), MultipleChoiceList(number: 4, quizId: 1, payload: "4번 선택지"), MultipleChoiceList(number: 5, quizId: 1, payload: "5번 선택지")], kept: false), quizIndex: 1, quizCount: 3) { result in
        print("Hi there!")
    } bookmarkAction: { id in
        print("quiz id to bookmark: \(id)")
    }
}
