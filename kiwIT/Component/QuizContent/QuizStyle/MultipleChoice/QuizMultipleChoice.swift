//
//  QuizMultipleChoice.swift
//  kiwIT
//
//  Created by Heedon on 5/13/24.
//

import SwiftUI

struct QuizMultipleChoice: View {
    
    var quizPayload: QuizPayload

    @State var userChoiceNumber: Int = 0
    
    var quizIndex: Int
    var quizCount: Int
    
    var completion: (Result<Int, QuizError>) -> Void
    
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
