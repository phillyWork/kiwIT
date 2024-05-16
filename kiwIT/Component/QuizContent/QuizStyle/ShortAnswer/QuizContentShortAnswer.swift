//
//  QuizContentShortAnswer.swift
//  kiwIT
//
//  Created by Heedon on 5/13/24.
//

import SwiftUI

enum QuizError: Error {
    case backToPreviousQuestion

}

struct QuizContentShortAnswer: View {
    
    //var quizPayload: QuizPayload
    
    @Binding var content: String
        
    @State var textFieldInput = ""
    
    @FocusState private var isTextFieldFocused: Bool
    
    var quizIndex: Int
    var quizCount: Int
    
    var completion: (Result<String, QuizError>) -> Void
    
    var body: some View {
        VStack {
            ZStack(alignment: .center) {
                Rectangle()
                    .fill(Color.shadowColor)
                    .frame(width: Setup.Frame.quizContentItemWidth, height: Setup.Frame.quizContentMultipleChoiceItemHeight)
                    .offset(CGSize(width: Setup.Frame.contentListShadowWidthOffset, height: Setup.Frame.contentListShadowHeightOffset))
                
                VStack {
                    Spacer()
                    
                    Text(content)
                        .multilineTextAlignment(.leading)
                        .font(.custom(Setup.FontName.notoSansBold, size: 25))
                        .foregroundStyle(Color.textColor)
                    
                    Spacer()
                    
                    ZStack {
                        Rectangle()
                            .fill(Color.shadowColor)
                            .frame(width: Setup.Frame.quizContentShortAnswerTextFieldWidth, height: Setup.Frame.quizContentShortAnswerTextFieldHeight)
                            .offset(CGSize(width: Setup.Frame.contentListShadowWidthOffset, height: Setup.Frame.contentListShadowHeightOffset))
                        
                        TextField("",
                                  text: $textFieldInput,
                                  prompt: Text("정답을 입력해주세요")
                            .foregroundColor(Color.textPlaceholderColor)
                        )
                        .frame(width: Setup.Frame.quizContentShortAnswerTextFieldWidth, height: Setup.Frame.quizContentShortAnswerTextFieldHeight)
                        .background(Color.brandBland)
                        .foregroundStyle(Color.black)
                        .offset(CGSize(width: Setup.Frame.contentListItemWidthOffset, height: Setup.Frame.contentListItemHeightOffset))
                        .focused($isTextFieldFocused)
                    }
                    
                    Spacer()
                }
                .frame(width: Setup.Frame.quizContentItemWidth, height: Setup.Frame.quizContentMultipleChoiceItemHeight)
                .background(Color.surfaceColor)
                .offset(CGSize(width: Setup.Frame.contentListItemWidthOffset, height: Setup.Frame.contentListItemHeightOffset))
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 5)
            
            HStack {
                if (quizIndex != 0) {
                    Spacer()
                    Button(action: {
                        print("Tap this button to go back to previous question")
                        self.completion(.failure(.backToPreviousQuestion))
                        textFieldInput = ""
                    }, label: {
                        Text("이전으로")
                    })
                }
                Spacer()
                Button(action: {
                    print("Tap this button to move to next question")
                    self.completion(.success(textFieldInput))
                    textFieldInput = ""
                }, label: {
                    Text(quizIndex == quizCount - 1 ? "제출하기" : "다음으로")
                })
                Spacer()
            }
            
            
        }
    }
}
