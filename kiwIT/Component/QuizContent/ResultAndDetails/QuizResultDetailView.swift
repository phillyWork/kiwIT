//
//  QuizResultDetailView.swift
//  kiwIT
//
//  Created by Heedon on 5/5/24.
//

import SwiftUI

struct QuizResultDetailView: View {
    
    @Environment(\.dismiss) var dismiss
    
    //var quizResult: QuizResultModel (viewModel 공유하기)
    
    var quizOXResultExample: [QuizOXResultModel]
    
    var body: some View {
        ScrollView {
            Text("상제 답안")
                .font(.custom(Setup.FontName.phuduBold, size: 20))
                .padding()
            
            //문제 With 오답 여부 사각형 색으로 구분, 제출 답안, 실제 정답)
            //이유도 같이 제공할 수 있다면 같이 제공
           
            ForEach(quizOXResultExample) { example in
                    QuizResultDetailEachQuestion(question: example.question, submittedAnswer: example.submittedAnswer, answer: example.answer)
                        .padding(.vertical, 3)
                        .background(Color.backgroundColor)
            }
            
            Button(action: {
                dismiss()
            }, label: {
                Image(systemName: Setup.ImageStrings.defaultXMark2)
            })
            .tint(Color.textColor)
            .padding()

            
        }
        .scrollIndicators(.hidden)
        .frame(maxWidth: .infinity)
        .background(Color.backgroundColor)
        //to disable pull to refresh
        .environment(\EnvironmentValues.refresh as! WritableKeyPath<EnvironmentValues, RefreshAction?>, nil)
    }
}

//#Preview {
//    QuizResultDetailView(quizOXResultExample: <#[QuizOXResultModel]#>)
//}
