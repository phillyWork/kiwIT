//
//  QuizResult.swift
//  kiwIT
//
//  Created by Heedon on 5/20/24.
//

import SwiftUI

struct QuizResult: View {

//    var quizResult: QuizResultModel
    
//    var questions: [String]
//    var answers: [String]
//    var result: [String]
    
    @State private var isDetailButtonTapped = false
    
    var body: some View {
        VStack {
            ZStack(alignment: .center) {
                
                Rectangle()
                    .fill(Color.shadowColor)
                    .frame(width: Setup.Frame.quizContentItemWidth, height: Setup.Frame.quizContentAnswerHeight)
                    .offset(CGSize(width: Setup.Frame.contentListShadowWidthOffset, height: Setup.Frame.contentListShadowHeightOffset))
                
                VStack {
                    Spacer()
                    
                    Text("Test 결과입니다")
                        .multilineTextAlignment(.leading)
                        .font(.custom(Setup.FontName.notoSansBold, size: 12))
                    
                    Spacer()
                    
                }
                .frame(width: Setup.Frame.quizContentItemWidth, height: Setup.Frame.quizContentAnswerHeight)
                .background(Color.surfaceColor)
                .offset(CGSize(width: Setup.Frame.contentListItemWidthOffset, height: Setup.Frame.contentListItemHeightOffset))
            }
            .padding(.vertical, 8)
            .padding(.horizontal, 5)
            
            HStack {
                Spacer()
                
                Button(action: {
                    print("Take Quiz Again!!!")
                    
                }, label: {
                    Text("다시 풀기")
                })
                Spacer()
                
                Button(action: {
                    print("Show Details of Quiz Answer")
                    isDetailButtonTapped = true
                }, label: {
                    Text("상세 보기")
                })
                
                Spacer()
                
                Button(action: {
                    print("Confirm Result and Go Back to Quiz List View")
                    
                }, label: {
                    Text("확인 완료")
                })
                
                Spacer()
            }
            .popover(isPresented: $isDetailButtonTapped) {
                //상세 결과 보여주기 위한 View 및 데이터 전달하기
               
                QuizResultDetailView()
                
            }

        }
    }
}

#Preview {
    QuizResult()
}
