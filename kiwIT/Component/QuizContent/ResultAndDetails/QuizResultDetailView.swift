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
    
    @Environment(\.dismiss) var dismiss
    
    var eachQuestionResult: [DetailedEachQuestionResult] = []
    
    init(_ quizList: [QuizPayload], userAnswer: UserAnswerType) {
        for i in 0..<quizList.count {
            switch userAnswer {
            case .ox(let array):
                let result = DetailedEachQuestionResult(question: quizList[i].question, userSubmit: "\(array[i])", answer: quizList[i].answer)
                eachQuestionResult.append(result)
            case .multiple(let array):
                let result = DetailedEachQuestionResult(question: quizList[i].question, userSubmit: "\(array[i])", answer: quizList[i].answer)
                eachQuestionResult.append(result)
            case .short(let array):
                let result = DetailedEachQuestionResult(question: quizList[i].question, userSubmit: "\(array[i])", answer: quizList[i].answer)
                eachQuestionResult.append(result)
            }
        }
    }
    
    var body: some View {
        ScrollView {
            Text("상제 답안")
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
