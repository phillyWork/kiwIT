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
    
    var completion: (Int) -> Void
    
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .fill(Color.shadowColor)
                .frame(width: Setup.Frame.quizContentItemWidth, height: Setup.Frame.quizContentItemWidth)
                .offset(CGSize(width: Setup.Frame.contentListShadowWidthOffset, height: Setup.Frame.contentListShadowHeightOffset))
            
            VStack {
                Text(content)
                    .multilineTextAlignment(.leading)
                    .font(.custom(Setup.FontName.notoSansBold, size: 25))
                VStack {
                    Button(action: {
                        //O 표시 확인 및 다음 문제로 넘어가기
                        print("Choice 1 is tapped. Move on to next!")
                        self.completion(1)
                    }, label: {
                        QuizMultipleChoiceButtonLabel(choiceLabel: $choiceOne)
                    })
                    Button(action: {
                        //X 표시 확인 및 다음 문제로 넘어가기
                        print("Choice 2 is tapped. Move on to next!")
                        self.completion(2)
                    }, label: {
                        QuizMultipleChoiceButtonLabel(choiceLabel: $choiceTwo)
                    })
                    Button(action: {
                        //X 표시 확인 및 다음 문제로 넘어가기
                        print("Choice 3 is tapped. Move on to next!")
                        self.completion(3)
                    }, label: {
                        QuizMultipleChoiceButtonLabel(choiceLabel: $choiceThree)
                    })
                    Button(action: {
                        //X 표시 확인 및 다음 문제로 넘어가기
                        print("Choice 4 is tapped. Move on to next!")
                        self.completion(4)
                    }, label: {
                        QuizMultipleChoiceButtonLabel(choiceLabel: $choiceFour)
                    })
                    Button(action: {
                        //X 표시 확인 및 다음 문제로 넘어가기
                        print("Choice 5 is tapped. Move on to next!")
                        self.completion(5)
                    }, label: {
                        QuizMultipleChoiceButtonLabel(choiceLabel: $choiceFive)
                    })
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
    }
}
