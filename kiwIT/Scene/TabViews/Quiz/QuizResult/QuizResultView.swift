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
        
    init(_ quizVM: QuizViewModel, id: Int, userAnswer: UserAnswerType, quizList: [QuizPayload], path: Binding<NavigationPath>, isLoginAvailable: Binding<Bool>) {
        self._path = path
        self._isLoginAvailable = isLoginAvailable
        _quizVM = ObservedObject(wrappedValue: quizVM)
        let quizResultVM = QuizResultViewModel(id, userAnswer: userAnswer, quizList: quizList) { userTakesQuizAgain in
            if userTakesQuizAgain {
                print("User Chose to Take Quiz Again!!!")
                quizVM.resetQuiz()
            }
        }
        _quizResultVM = StateObject(wrappedValue: quizResultVM)
    }
    
    var body: some View {
        if quizResultVM.didFinishSubmittingAnswer {
            LazyVStack {
                let _ = print("In QuizResultView, path is :\(path)")
                QuizResult(quizList: quizResultVM.quizList, userAnswerList: quizResultVM.passedUserAnswer, result: quizResultVM.userResult!) { result in
                    switch result {
                    case .confirmToMoveToQuizList:
                        path = NavigationPath()
                        print("Go back to Quiz List")
                    case .takeQuizAgain:
                        if (path.count > 0) {
                            print("back to take quiz again")
                            quizResultVM.takeQuizAgainClosure(true)
                            path.removeLast()
                        } else {
                            print("cannot move back to take quiz")
                            quizResultVM.showRetakeQuizErrorAlert = true
                        }
                    }
                }
            }
            .frame(maxHeight: .infinity)
            .background(Color.backgroundColor)
            .navigationBarBackButtonHidden()
            .alert("네트워크 오류!", isPresented: $quizResultVM.showUnknownNetworkErrorAlert, actions: {
                ErrorAlertConfirmButton { }
            }, message: {
                Text("네트워크 요청에 실패했습니다! 다시 시도해주세요!")
            })
            .alert("로그인 오류!", isPresented: $quizResultVM.shouldLoginAgain) {
                ErrorAlertConfirmButton {
                    isLoginAvailable = false
                }
            } message: {
                Text("세션 만료입니다. 다시 로그인해주세요!")
            }
            .alert("재풀이 오류!", isPresented: $quizResultVM.showRetakeQuizErrorAlert) {
                ErrorAlertConfirmButton {
                    path = NavigationPath()
                }
            } message: {
                Text("오류로 인해 해당 퀴즈의 다시 풀기가 불가합니다. 퀴즈 목록으로 돌아갑니다.")
            }
        } else {
            ProgressView {
                Text("답안 제출 중...")
            }
        }
    }
}

//#Preview {
//    QuizResultView(path: <#T##Binding<[String]>#>, testDataForQuestion: ["첫번째 문제입니다", "두번째 문제입니다", "세번째 문제입니다", "네번째 문제입니다", "다섯번째 문제입니다"], userOXAnswer: [true, false, false, false, true], answers: [false, true, true, true, true])
//}
