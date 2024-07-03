//
//  QuizResultView.swift
//  kiwIT
//
//  Created by Heedon on 5/5/24.
//

import SwiftUI

struct QuizResultView: View {
    
    @StateObject var quizResultVM: QuizResultViewModel
    @ObservedObject var quizVM: QuizViewModel
    
    @Binding var path: NavigationPath
    @Binding var isLoginAvailable: Bool
        
    //OX 문제 예시...
    var testDataForQuestion: [String]
    var userOXAnswer: [Bool]
    var answers: [Bool]
    
    var body: some View {
        
        //MARK: - 계산 중 화면 (빈 화면이라도) 보여주고, 그 동안 서버 업데이트 처리, 실제 결과 나타내기
        
            LazyVStack {
                
                let _ = print("In QuizResultView, path is :\(path)")
                
                QuizResult(questions: testDataForQuestion, submittedAnswers: userOXAnswer, answers: answers) { result in
                    
                    //save the quiz result (server update) & viewmodel에게 데이터 전달
                    
                    switch result {
                    case .confirmToMoveToQuizList:
//                        path.removeAll()
                        path = NavigationPath()
                        print("Go back to Quiz List")
                    case .takeQuizAgain:
                        
                        //MARK: - 기능 오류 (QuizResultView path가 중간에 삭제됨. 원인 추측으로는 QuizView에서 데이터 업뎃 도중 순서 꼬임으로 그냥 QuizView path만 추가한 것을 넘김). 차후 네트워크 작업 후, hashable한 모델 설정 후에 ForEach 및 List 설정 다시 하면서 데이터 구분되도록 설정 후 다시 테스트하기 (안되면 이 버튼은 삭제하는 것으로 추정)
                        
//                        if let quizPathID = path.first {
//                            path = [quizPathID]
                        if (path.count > 0) {
                            print("back to take quiz")
                            path.removeLast()
                        } else {
                            print("cannot move back to take quiz")
                        }
//                            path.append("RetakeQuiz-\(quizPathID)")
//                        }
                    }
                }
            }
            .frame(maxHeight: .infinity)
            .background(Color.backgroundColor)
            .navigationBarBackButtonHidden()
            .alert("로그인 오류!", isPresented: $quizResultVM.shouldLoginAgain) {
                ErrorAlertConfirmButton {
                    isLoginAvailable = false
                }
            } message: {
                Text("세션 만료입니다. 다시 로그인해주세요!")
            }

    }
}

//#Preview {
//    QuizResultView(path: <#T##Binding<[String]>#>, testDataForQuestion: ["첫번째 문제입니다", "두번째 문제입니다", "세번째 문제입니다", "네번째 문제입니다", "다섯번째 문제입니다"], userOXAnswer: [true, false, false, false, true], answers: [false, true, true, true, true])
//}
