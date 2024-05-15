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
    
    var completion: (Result<String, QuizError>) -> Void
    
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
                    TextField("정답을 입력해주세요", text: $textFieldInput)
                        .padding()
                        .background(Color.green)
                        .focused($isTextFieldFocused)
//                        .onSubmit {
//                            print("isTextFieldFocused before state: \(isTextFieldFocused)")
//                            isTextFieldFocused = false
//                            print("isTextFieldFocused state after submit: \(isTextFieldFocused)")
//                        }
                }
                .frame(width: Setup.Frame.quizContentItemWidth, height: Setup.Frame.quizContentMultipleChoiceItemHeight)
                .background(Color.surfaceColor)
                .offset(CGSize(width: Setup.Frame.contentListItemWidthOffset, height: Setup.Frame.contentListItemHeightOffset))
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 5)
            
            HStack {
                Spacer()
                Button(action: {
                    print("Tap this button to go back to previous question")
                    self.completion(.failure(.backToPreviousQuestion))
                    textFieldInput = ""
                }, label: {
                    Text("이전으로")
                })
                Spacer()
                Button(action: {
                    print("Tap this button to move to next question")
                    self.completion(.success(textFieldInput))
                    textFieldInput = ""
                }, label: {
                    Text("다음으로")
                })
                Spacer()
            }
            
            
        }
    }
}
