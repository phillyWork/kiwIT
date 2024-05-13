//
//  QuizContentItem.swift
//  kiwIT
//
//  Created by Heedon on 5/7/24.
//

import SwiftUI

struct QuizContentOX: View {
    
    //var quizPayload: QuizPayload
    
    @Binding var content: String
    var completion: (Bool) -> Void
        
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .fill(Color.shadowColor)
                .frame(width: Setup.Frame.quizContentItemWidth, height: Setup.Frame.quizContentItemWidth)
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
                        print("O button is tapped. Move on to next!")
                        self.completion(true)
                    }, label: {
                        QuizOXButtonLabel(buttonLabel: "O")
                    })
                    Button(action: {
                        //X 표시 확인 및 다음 문제로 넘어가기
                        print("X button is tapped. Move on to next!")
                        self.completion(false)
                    }, label: {
                        QuizOXButtonLabel(buttonLabel: "X")
                    })
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
    }
}
