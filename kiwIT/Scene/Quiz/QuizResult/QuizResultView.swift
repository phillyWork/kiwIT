//
//  QuizResultView.swift
//  kiwIT
//
//  Created by Heedon on 5/5/24.
//

import SwiftUI

struct QuizResultView: View {
    
    //방안 1. ViewModel 공유, QuizView user answer 공유 및 활용해서 결과 보여주기
    
    //방안 2. ViewModel 분리, 답변 전달받아 결과 보여주기
    //다시 테스트 버튼 누를 시, 새롭게 QuizView와 QuizViewModel 설정하도록 데이터 전달하기
    
    
    //OX 문제 예시...
    var testDataForQuestion: [String]
    var userOXAnswer: [Bool]
    var answers: [Bool]
    
    var body: some View {
        NavigationStack {
            QuizResult(questions: testDataForQuestion, submittedAnswers: userOXAnswer, answers: answers)
                .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    QuizResultView(testDataForQuestion: ["첫번째 문제입니다", "두번째 문제입니다", "세번째 문제입니다", "네번째 문제입니다", "다섯번째 문제입니다"], userOXAnswer: [true, false, false, false, true], answers: [false, true, true, true, true])
}
