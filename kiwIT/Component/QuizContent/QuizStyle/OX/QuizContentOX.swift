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
    
    //var quizPayload: QuizPayload
    
    @Binding var content: String
    
    @State private var chosenState: UserOXAnswerState
//    @State private var chosenState = UserOXAnswerState.unchosen
    
    var quizIndex: Int
    var quizCount: Int
    
    var previousAnswer: Bool?
    
    var completion: (Result<Bool, QuizError>) -> Void
    
    init(content: Binding<String>, quizIndex: Int, quizCount: Int, previous: Bool?, completion: @escaping (Result<Bool, QuizError>) -> Void) {
        self._content = content
        self.quizIndex = quizIndex
        self.quizCount = quizCount
        self.previousAnswer = previous
        self.completion = completion
        
        if let previousAnswer = previousAnswer {
            print("previousAnswer from QuizView: \(previousAnswer)")
            self._chosenState = State(initialValue: previousAnswer ? .chosenTrue : .chosenFalse)
        } else {
            self._chosenState = State(initialValue: .unchosen)
        }
    }
    
    var body: some View {
        VStack {
            ZStack(alignment: .center) {
                Rectangle()
                    .fill(Color.shadowColor)
                    .frame(width: Setup.Frame.quizContentItemWidth, height: Setup.Frame.quizContentOXItemHeight)
                    .offset(CGSize(width: Setup.Frame.contentListShadowWidthOffset, height: Setup.Frame.contentListShadowHeightOffset))
                
                VStack {
                    Spacer()

                    Text(content)
                        .multilineTextAlignment(.leading)
                        .font(.custom(Setup.FontName.notoSansBold, size: 25))
                    
                    Spacer()
                    
                    HStack {
                        Button(action: {
                            //O 표시 확인 및 다음 문제로 넘어가기
                            chosenState = chosenState == .chosenTrue ? .unchosen : .chosenTrue
                        }, label: {
                            QuizOXButtonLabel(buttonLabel: "O")
                        })
                        .background(chosenState == .chosenTrue ? Color.brandColor : Color.surfaceColor)
                        Button(action: {
                            //X 표시 확인 및 다음 문제로 넘어가기
                            chosenState = chosenState == .chosenFalse ? .unchosen : .chosenFalse
                        }, label: {
                            QuizOXButtonLabel(buttonLabel: "X")
                        })
                        .background(chosenState == .chosenFalse ? Color.brandColor : Color.surfaceColor)
                    }
                    
                    Spacer()
                    
                }
                .frame(width: Setup.Frame.quizContentItemWidth, height: Setup.Frame.quizContentOXItemHeight)
                .background(Color.surfaceColor)
                .offset(CGSize(width: Setup.Frame.contentListItemWidthOffset, height: Setup.Frame.contentListItemHeightOffset))
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 5)
            .onDisappear {
                self.content = ""
            }
            
            HStack {
                if (quizIndex != 0) {
                    Spacer()
                    Button(action: {
                        print("Tap this button to go back to previous question")
                        self.completion(.failure(.backToPreviousQuestion))
                        chosenState = .unchosen
                    }, label: {
                        Text("이전으로")
                    })
                }
                Spacer()
                Button(action: {
                    print("Tap this button to move to next question")
                    if chosenState == .unchosen {
                        //Alert 띄우기
                        print("O, X 중 하나는 선택해야 합니다!!!")
                    } else {
                        chosenState == .chosenTrue ? self.completion(.success(true)) : self.completion(.success(false))
                        chosenState = .unchosen
                    }
                }, label: {
                    Text(quizIndex == quizCount - 1 ? "제출하기" : "다음으로")
                })
                Spacer()
            }
            
        }
    }
}
