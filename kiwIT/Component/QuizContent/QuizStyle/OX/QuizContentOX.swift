//
//  QuizContentItem.swift
//  kiwIT
//
//  Created by Heedon on 5/7/24.
//

import SwiftUI

enum UserOXAnswerState {
    case chosenTrue
    case chosenFalse
    case unchosen
}

struct QuizContentOX: View {
    
    @State private var chosenState: UserOXAnswerState
    @State private var showAnswerNotChosenAlert = false
    
    var quizPayload: QuizPayload
    var quizIndex: Int
    var quizCount: Int
    
    var completion: (Result<Bool, QuizError>) -> Void
    var bookmarkAction: (Int) -> Void
    
    init(chosenState: UserOXAnswerState, showAnswerNotChosenAlert: Bool = false, quizPayload: QuizPayload, quizIndex: Int, quizCount: Int, completion: @escaping (Result<Bool, QuizError>) -> Void, bookmarkAction: @escaping (Int) -> Void) {
        self._chosenState = State(initialValue: chosenState)
        self.showAnswerNotChosenAlert = showAnswerNotChosenAlert
        self.quizPayload = quizPayload
        self.quizIndex = quizIndex
        self.quizCount = quizCount
        self.completion = completion
        self.bookmarkAction = bookmarkAction
    }
    
    var body: some View {
        VStack {
            withAnimation(.easeInOut) {
                ZStack(alignment: .center) {
                    Rectangle()
                        .fill(Color.shadowColor)
                        .frame(width: Setup.Frame.quizContentItemWidth, height: Setup.Frame.quizContentOXItemHeight)
                        .offset(CGSize(width: Setup.Frame.contentListShadowWidthOffset, height: Setup.Frame.contentListShadowHeightOffset))
                    VStack {
                        Spacer()
                        Text(quizPayload.question)
                            .multilineTextAlignment(.leading)
                            .font(.custom(Setup.FontName.notoSansBold, size: 20))
                            .foregroundStyle(Color.textColor)
                        Spacer()
                        HStack {
                            Button {
                                //O 표시 확인 및 다음 문제로 넘어가기
                                chosenState = chosenState == .chosenTrue ? .unchosen : .chosenTrue
                            } label: {
                                QuizOXButtonLabel(buttonLabel: "O")
                            }
                            .background(chosenState == .chosenTrue ? Color.brandColor : Color.surfaceColor)
                            
                            Button {
                                //X 표시 확인 및 다음 문제로 넘어가기
                                chosenState = chosenState == .chosenFalse ? .unchosen : .chosenFalse
                            } label: {
                                QuizOXButtonLabel(buttonLabel: "X")
                            }
                            .background(chosenState == .chosenFalse ? Color.brandColor : Color.surfaceColor)
                        }
                        Spacer()
                    }
                    .frame(width: Setup.Frame.quizContentItemWidth, height: Setup.Frame.quizContentOXItemHeight)
                    .background(Color.surfaceColor)
                    .offset(CGSize(width: Setup.Frame.contentListItemWidthOffset, height: Setup.Frame.contentListItemHeightOffset))
                    .overlay {
                        Button {
                            bookmarkAction(quizPayload.id)
                        } label: {
                            Image(systemName: quizPayload.kept ? Setup.ImageStrings.bookmarked : Setup.ImageStrings.bookmarkNotYet)
                        }
                        .offset(CGSize(width: Setup.Frame.quizContentItemWidth/2.5, height: -Setup.Frame.quizContentOXItemHeight/2.5))
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
                    } label: {
                        Text("이전으로")
                    }
                }
                Spacer()
                Button {
                    print("Tap this button to move to next question")
                    if chosenState == .unchosen {
                        showAnswerNotChosenAlert = true
                    } else {
                        chosenState == .chosenTrue ? self.completion(.success(true)) : self.completion(.success(false))
                    }
                } label: {
                    Text(quizIndex == quizCount - 1 ? "제출하기" : "다음으로")
                }
                Spacer()
            }
            .alert(Setup.ContentStrings.submitQuizAnswerErrorAlertTitle, isPresented: $showAnswerNotChosenAlert) {
                ErrorAlertConfirmButton { }
            } message: {
                Text("정답을 선택해야 다음 문제로 넘어갈 수 있어요!")
            }
        }
    }
}

#Preview {
    QuizContentOX(chosenState: .unchosen, quizPayload: QuizPayload(id: 2, type: .trueOrFalse, title: "단답형 질문 1", question: "질문 2", answer: "true", explanation: "정답 설명", score: 2, kept: false), quizIndex: 2, quizCount: 4) { result in
        print("OX Quiz!!!")
    } bookmarkAction: { id in
        print("Bookmark action wit hid: \(id)!!!")
    }
}
