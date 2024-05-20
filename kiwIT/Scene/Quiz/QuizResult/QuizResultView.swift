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
    
    var body: some View {
        NavigationStack {
            
            Text("Quiz Result Score: 90")
            
            Text("Example View for Quiz Result!!!")
            
            
                .navigationBarBackButtonHidden()
            
        }
    }
}

#Preview {
    QuizResultView()
}
