//
//  QuizResultDetailView.swift
//  kiwIT
//
//  Created by Heedon on 5/5/24.
//

import SwiftUI

struct DetailedEachQuestionResult: Hashable {
    var question: String
    var userSubmit: String
    var answer: String
}

struct QuizResultDetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var eachQuestionResult: [DetailedEachQuestionResult] = []
        
    init(_ quizList: [QuizPayload], userAnswer: [QuizAnswer]) {
        for i in 0..<quizList.count {
            let result = DetailedEachQuestionResult(question: quizList[i].question, userSubmit: userAnswer[i].answer, answer: quizList[i].answer)
            eachQuestionResult.append(result)
        }
    }
    
    var body: some View {
        ScrollView {
            Text(Setup.ContentStrings.Quiz.detailedQuizResultTitle)
                .font(.custom(Setup.FontName.phuduBold, size: 20))
                .padding()
            
            ForEach(eachQuestionResult, id: \.self) { eachQuestion in
                QuizResultDetailEachQuestion(eachQuestionWithAnswer: eachQuestion)
                    .padding(.vertical, 3)
                    .background(Color.backgroundColor)
            }
                        
            Button {
                dismiss()
            } label: {
                Image(systemName: Setup.ImageStrings.defaultXMark2)
            }
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
