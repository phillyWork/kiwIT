//
//  QuizMultipleChoice.swift
//  kiwIT
//
//  Created by Heedon on 5/13/24.
//

import SwiftUI

struct QuizMultipleChoice: View {
    
    //var quizPayload: QuizPayload
    
    @Binding var content: String
    
    @Binding var choiceOne: String
    @Binding var choiceTwo: String
    @Binding var choiceThree: String
    @Binding var choiceFour: String
    @Binding var choiceFive: String
    
    @State var userChoiceNumber = 0
    
    var completion: (Result<Int, QuizError>) -> Void
    
    var body: some View {
        VStack {
            ZStack(alignment: .center) {
                Rectangle()
                    .fill(Color.shadowColor)
                    .frame(width: Setup.Frame.quizContentItemWidth, height: Setup.Frame.quizContentMultipleChoiceItemHeight)
                    .offset(CGSize(width: Setup.Frame.contentListShadowWidthOffset, height: Setup.Frame.contentListShadowHeightOffset))
                
                VStack {
                    Text(content)
                        .multilineTextAlignment(.leading)
                        .font(.custom(Setup.FontName.notoSansBold, size: 25))
                    VStack {
                        Button(action: {
//                            self.completion(1)
                            userChoiceNumber = userChoiceNumber == 1 ? 0 : 1
                        }, label: {
                            QuizMultipleChoiceButtonLabel(choiceLabel: $choiceOne)
                        })
                        .background(userChoiceNumber == 1 ? Color.brandColor : Color.surfaceColor)
                        Button(action: {
//                            self.completion(2)
                            userChoiceNumber = userChoiceNumber == 2 ? 0 : 2
                        }, label: {
                            QuizMultipleChoiceButtonLabel(choiceLabel: $choiceTwo)
                        })
                        .background(userChoiceNumber == 2 ? Color.brandColor : Color.surfaceColor)
                        Button(action: {
//                            self.completion(3)
                            userChoiceNumber = userChoiceNumber == 3 ? 0 : 3
                        }, label: {
                            QuizMultipleChoiceButtonLabel(choiceLabel: $choiceThree)
                        })
                        .background(userChoiceNumber == 3 ? Color.brandColor : Color.surfaceColor)
                        Button(action: {
//                            self.completion(4)
                            userChoiceNumber = userChoiceNumber == 4 ? 0 : 4
                        }, label: {
                            QuizMultipleChoiceButtonLabel(choiceLabel: $choiceFour)
                        })
                        .background(userChoiceNumber == 4 ? Color.brandColor : Color.surfaceColor)
                        Button(action: {
//                            self.completion(5)
                            userChoiceNumber = userChoiceNumber == 5 ? 0 : 5
                        }, label: {
                            QuizMultipleChoiceButtonLabel(choiceLabel: $choiceFive)
                        })
                        .background(userChoiceNumber == 5 ? Color.brandColor : Color.surfaceColor)
                    }
                }
                .frame(width: Setup.Frame.quizContentItemWidth, height: Setup.Frame.quizContentMultipleChoiceItemHeight)
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
            
            HStack {
                Spacer()
                Button(action: {
                    print("Tap this button to go back to previous question")
                    self.completion(.failure(.backToPreviousQuestion))
                    userChoiceNumber = 0
                }, label: {
                    Text("이전으로")
                })
                Spacer()
                Button(action: {
                    print("Tap this button to move to next question")
                    self.completion(.success(userChoiceNumber))
                    userChoiceNumber = 0
                }, label: {
                    Text("다음으로")
                })
                Spacer()
            }
            
        }
    }
}
