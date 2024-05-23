//
//  QuizResult.swift
//  kiwIT
//
//  Created by Heedon on 5/20/24.
//

import SwiftUI

// OX 퀴즈만 전제
struct QuizOXResultModel: Identifiable {
    
    //identifiable 목적
    var id = UUID()
    
    var question: String
    var submittedAnswer: Bool
    var answer: Bool
}

func gradeScore(submitted: [Bool], answers: [Bool]) -> Double {
    print("submitted: \(submitted)")
    print("answers: \(answers)")
    var correctCount = 0
    for i in 0..<submitted.count {
        if submitted[i] == answers[i] {
            correctCount += 1
        }
    }
    return Double(correctCount) / Double(submitted.count) * 100
}

func createDetailQuizResultModel(questions: [String], submitted: [Bool], answers: [Bool]) -> [QuizOXResultModel] {
    var model = [QuizOXResultModel]()
    print("questions count: \(questions.count)")
    print("submitted count: \(submitted.count)")
    print("answers count: \(answers.count)")

    for i in 0..<questions.count {
        model.append(QuizOXResultModel(question: questions[i], submittedAnswer: submitted[i], answer: answers[i]))
    }
    print("created model for each question result: \(model)")
    return model
}

struct QuizResult: View {
    
//    var quizResult: QuizResultModel
    
    var questions: [String]
    var submittedAnswers: [Bool]
    var answers: [Bool]
 
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
                    
                    Text("점수: \(String(format: "%.2f", gradeScore(submitted: submittedAnswers, answers: answers)))")
                    
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
            .fullScreenCover(isPresented: $isDetailButtonTapped, content: {
                //상세 결과 보여주기 위한 View 및 데이터 전달하기
                QuizResultDetailView(quizOXResultExample: createDetailQuizResultModel(questions: questions, submitted: submittedAnswers, answers: answers))
                    .presentationBackground(.thickMaterial)
            })
//            .popover(isPresented: $isDetailButtonTapped) {
//                //상세 결과 보여주기 위한 View 및 데이터 전달하기
//                QuizResultDetailView(quizOXResultExample: createDetailQuizResultModel(questions: questions, submitted: submittedAnswers, answers: answers))
//            }

        }
    }
}

//#Preview {
//   QuizResult(questions: <#T##[String]#>, submittedAnswers: <#T##[Bool]#>, answers: <#T##[Bool]#>)
//}
