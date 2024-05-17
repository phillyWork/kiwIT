//
//  QuizMultipleChoice.swift
//  kiwIT
//
//  Created by Heedon on 5/13/24.
//

import SwiftUI

struct QuizMultipleChoice: View {
    
    //var quizPayload: QuizPayload
    
    //이전 답변 보여주기: viewModel에서 답변도 보유, 해당 답변 참조해서 이전 문항의 답변 통해 색칠하기?
    
    func updateHeight(height: CGFloat, fontSize: CGFloat) -> CGFloat {
        if (fontSize <= 15) {
            return height
        } else if (fontSize <= 25) {
            return height * 1.2
        } else if (fontSize <= 50) {
            return height * 2
        } else {
            return height * 3
        }
    }
   
    
    @Binding var content: String
    
    @Binding var choiceOne: String
    @Binding var choiceTwo: String
    @Binding var choiceThree: String
    @Binding var choiceFour: String
    @Binding var choiceFive: String
    
    @State private var userChoiceNumber = 0
    
    var quizIndex: Int
    var quizCount: Int
    
    var fontSize: CGFloat
    
    var completion: (Result<Int, QuizError>) -> Void
    
    var body: some View {
        VStack {
            withAnimation {
                ZStack(alignment: .center) {
                Rectangle()
                    .fill(Color.shadowColor)
//                    .frame(width: Setup.Frame.quizContentItemWidth, height: Setup.Frame.quizContentMultipleChoiceItemHeight)
                    .frame(width: Setup.Frame.quizContentItemWidth, height: updateHeight(height: Setup.Frame.quizContentMultipleChoiceItemHeight, fontSize: fontSize))
                    .offset(CGSize(width: Setup.Frame.contentListShadowWidthOffset, height: Setup.Frame.contentListShadowHeightOffset))
                
                VStack {
                    Text(content)
                        .multilineTextAlignment(.leading)
                        .font(.custom(Setup.FontName.notoSansBold, size: fontSize))
                    VStack {
                        Button(action: {
                            userChoiceNumber = userChoiceNumber == 1 ? 0 : 1
                        }, label: {
                            QuizMultipleChoiceButtonLabel(choiceLabel: $choiceOne)
                        })
                        .background(userChoiceNumber == 1 ? Color.brandColor : Color.surfaceColor)
                        Button(action: {
                            userChoiceNumber = userChoiceNumber == 2 ? 0 : 2
                        }, label: {
                            QuizMultipleChoiceButtonLabel(choiceLabel: $choiceTwo)
                        })
                        .background(userChoiceNumber == 2 ? Color.brandColor : Color.surfaceColor)
                        Button(action: {
                            userChoiceNumber = userChoiceNumber == 3 ? 0 : 3
                        }, label: {
                            QuizMultipleChoiceButtonLabel(choiceLabel: $choiceThree)
                        })
                        .background(userChoiceNumber == 3 ? Color.brandColor : Color.surfaceColor)
                        Button(action: {
                            userChoiceNumber = userChoiceNumber == 4 ? 0 : 4
                        }, label: {
                            QuizMultipleChoiceButtonLabel(choiceLabel: $choiceFour)
                        })
                        .background(userChoiceNumber == 4 ? Color.brandColor : Color.surfaceColor)
                        Button(action: {
                            userChoiceNumber = userChoiceNumber == 5 ? 0 : 5
                        }, label: {
                            QuizMultipleChoiceButtonLabel(choiceLabel: $choiceFive)
                        })
                        .background(userChoiceNumber == 5 ? Color.brandColor : Color.surfaceColor)
                    }
                }
//                .frame(width: Setup.Frame.quizContentItemWidth, height: Setup.Frame.quizContentMultipleChoiceItemHeight)
                .frame(width: Setup.Frame.quizContentItemWidth, height: updateHeight(height: Setup.Frame.quizContentMultipleChoiceItemHeight, fontSize: fontSize))
                .background(Color.surfaceColor)
                .offset(CGSize(width: Setup.Frame.contentListItemWidthOffset, height: Setup.Frame.contentListItemHeightOffset))
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 5)
            .onDisappear {
                self.content = ""
                self.choiceOne = ""
                self.choiceTwo = ""
                self.choiceThree = ""
                self.choiceFour = ""
                self.choiceFive = ""
            }
        }
            
            HStack {
                if (quizIndex != 0) {
                    Spacer()
                    Button(action: {
                        print("Tap this button to go back to previous question")
                        self.completion(.failure(.backToPreviousQuestion))
                        userChoiceNumber = 0
                    }, label: {
                        Text("이전으로")
                    })
                }
                Spacer()
                Button(action: {
                    print("Tap this button to move to next question")
                    self.completion(.success(userChoiceNumber))
                    userChoiceNumber = 0
                }, label: {
                    Text(quizIndex == quizCount - 1 ? "제출하기" : "다음으로")
                })
                Spacer()
            }
            
        }
    }
}
