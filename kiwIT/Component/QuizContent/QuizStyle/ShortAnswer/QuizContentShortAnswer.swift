//
//  QuizContentShortAnswer.swift
//  kiwIT
//
//  Created by Heedon on 5/13/24.
//

import SwiftUI

struct QuizContentShortAnswer: View {
    
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
        
    @State var textFieldInput = ""
    
    @FocusState private var isTextFieldFocused: Bool
    
    var quizIndex: Int
    var quizCount: Int
    
    var fontSize: CGFloat
    
    var completion: (Result<String, QuizError>) -> Void
    
    var body: some View {
        VStack {
            ZStack(alignment: .center) {
                Rectangle()
                    .fill(Color.shadowColor)
//                    .frame(width: Setup.Frame.quizContentItemWidth, height: Setup.Frame.quizContentShortAnswerItemHeight)
                    .frame(width: Setup.Frame.quizContentItemWidth, height: updateHeight(height: Setup.Frame.quizContentShortAnswerItemHeight, fontSize: fontSize))
                    .offset(CGSize(width: Setup.Frame.contentListShadowWidthOffset, height: Setup.Frame.contentListShadowHeightOffset))
                
                VStack {
                    Spacer()
                    
                    Text(content)
                        .multilineTextAlignment(.leading)
                        .font(.custom(Setup.FontName.notoSansBold, size: fontSize))
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
//                .frame(width: Setup.Frame.quizContentItemWidth, height: Setup.Frame.quizContentShortAnswerItemHeight)
                .frame(width: Setup.Frame.quizContentItemWidth, height: updateHeight(height: Setup.Frame.quizContentShortAnswerItemHeight, fontSize: fontSize))
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
