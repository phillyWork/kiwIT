//
//  QuizContentShortAnswer.swift
//  kiwIT
//
//  Created by Heedon on 5/13/24.
//

import SwiftUI

struct QuizContentShortAnswer: View {
    
    @State private var textFieldInput: String
    
    @FocusState private var isTextFieldFocused: Bool
    
    private var previousUserAnswer: String
    
    var quizPayload: QuizPayload
    var quizIndex: Int
    var quizCount: Int
    
    var completion: (Result<String, QuizError>) -> Void
    var bookmarkAction: (Int) -> Void
        
    init(textFieldInput: String, quizPayload: QuizPayload, quizIndex: Int, quizCount: Int, completion: @escaping (Result<String, QuizError>) -> Void, bookmarkAction: @escaping (Int) -> Void) {
        self.previousUserAnswer = textFieldInput
        self._textFieldInput = State(initialValue: textFieldInput)
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
                    .frame(width: Setup.Frame.quizContentItemWidth, height: Setup.Frame.quizContentShortAnswerItemHeight)
                    .offset(CGSize(width: Setup.Frame.contentListShadowWidthOffset, height: Setup.Frame.contentListShadowHeightOffset))
                VStack {
                    Spacer()
                    Text(quizPayload.question)
                        .multilineTextAlignment(.leading)
                        .font(.custom(Setup.FontName.notoSansBold, size: 20))
                        .foregroundStyle(Color.textColor)
                    Spacer()
                    ZStack {
                        Rectangle()
                            .fill(Color.shadowColor)
                            .frame(width: Setup.Frame.quizContentShortAnswerTextFieldWidth, height: Setup.Frame.quizContentShortAnswerTextFieldHeight)
                            .offset(CGSize(width: Setup.Frame.contentListShadowWidthOffset, height: Setup.Frame.contentListShadowHeightOffset))
                        TextField("",
                                  text: $textFieldInput,
                                  prompt: Text(Setup.ContentStrings.Quiz.shortAnswerTextFieldPrompt)
                            .foregroundColor(Color.textPlaceholderColor)
                        )
                        .frame(width: Setup.Frame.quizContentShortAnswerTextFieldWidth, height: Setup.Frame.quizContentShortAnswerTextFieldHeight)
                        .background(Color.brandBlandColor)
                        .foregroundStyle(Color.black)
                        .offset(CGSize(width: Setup.Frame.contentListItemWidthOffset, height: Setup.Frame.contentListItemHeightOffset))
                        .focused($isTextFieldFocused)
                    }
                    .onChange(of: quizPayload.id) {
                        if previousUserAnswer == "" {
                            textFieldInput = ""
                        } else {
                            textFieldInput = previousUserAnswer
                        }
                    }
                    Spacer()
                }
                .frame(width: Setup.Frame.quizContentItemWidth, height: Setup.Frame.quizContentShortAnswerItemHeight)
                .background(Color.surfaceColor)
                .offset(CGSize(width: Setup.Frame.contentListItemWidthOffset, height: Setup.Frame.contentListItemHeightOffset))
                .overlay {
                    Button {
                        bookmarkAction(quizPayload.id)
                    } label: {
                        Image(systemName: quizPayload.kept ? Setup.ImageStrings.bookmarked : Setup.ImageStrings.bookmarkNotYet)
                    }
                    .offset(CGSize(width: Setup.Frame.quizContentItemWidth/2.5, height: -Setup.Frame.quizContentShortAnswerItemHeight/2.5))
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
                    self.completion(.success(textFieldInput))
                } label: {
                    Text(quizIndex == quizCount - 1 ? Setup.ContentStrings.Quiz.submitButtonTitle : Setup.ContentStrings.Quiz.nextButtonTitle)
                }
                Spacer()
            }
        }
    }
}

#Preview {
    QuizContentShortAnswer(textFieldInput: "Previous Answer", quizPayload: QuizPayload(id: 1, type: .shortAnswer, title: "example 3", question: "question 3", answer: "Answer3", explanation: "Explanation", score: 30, kept: true), quizIndex: 2, quizCount: 4) { result in
        print("After user chose answer")
    } bookmarkAction: { id in
        print("book/unbookmark this quiz")
    }

}
