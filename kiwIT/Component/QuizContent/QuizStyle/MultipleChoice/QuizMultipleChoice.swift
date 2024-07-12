//
//  QuizMultipleChoice.swift
//  kiwIT
//
//  Created by Heedon on 5/13/24.
//

import SwiftUI

struct QuizMultipleChoice: View {
    
    //0: 선택하지 않음
    @State var userChoiceNumber: Int
    
    var quizPayload: QuizPayload
    var quizIndex: Int
    var quizCount: Int
    
    var completion: (Result<Int, QuizError>) -> Void
    var bookmarkAction: (Int) -> Void
    
    var body: some View {
        VStack {
            withAnimation {
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
                                        userChoiceNumber = userChoiceNumber == eachChoice.number ? 0 : eachChoice.number
                                    } label: {
                                        QuizMultipleChoiceButtonLabel(choiceLabel: eachChoice.payload)
                                    }
                                    .background(userChoiceNumber == eachChoice.number ? Color.brandColor : Color.surfaceColor)
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
            }
            HStack {
                if (quizIndex != 0) {
                    Spacer()
                    Button {
                        print("Tap this button to go back to previous question")
                        self.completion(.failure(.backToPreviousQuestion))
                        userChoiceNumber = 0
                    } label: {
                        Text("이전으로")
                    }
                }
                Spacer()
                Button {
                    print("Tap this button to move to next question")
                    self.completion(.success(userChoiceNumber))
                    userChoiceNumber = 0
                } label: {
                    Text(quizIndex == quizCount - 1 ? "제출하기" : "다음으로")
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
