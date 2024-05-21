//
//  QuizResultDetailView.swift
//  kiwIT
//
//  Created by Heedon on 5/5/24.
//

import SwiftUI

struct QuizResultDetailView: View {
    
    //var quizResult: QuizResultModel (viewModel 공유하기)
    
    var quizOXResultExample: [QuizOXResultModel]
    
    var body: some View {
        ScrollView {
            
            //문제 With 오답 여부 사각형 색으로 구분, 제출 답안, 실제 정답)
            //이유도 같이 제공할 수 있다면 같이 제공
            
            ForEach(quizOXResultExample) { example in
                QuizResultDetailEachQuestion(question: example.question, submittedAnswer: example.submittedAnswer, answer: example.answer)
            }

        }
        .frame(maxWidth: .infinity)
        .background(Color.backgroundColor)
        
    }
}

//#Preview {
//    QuizResultDetailView(quizOXResultExample: <#[QuizOXResultModel]#>)
//}
