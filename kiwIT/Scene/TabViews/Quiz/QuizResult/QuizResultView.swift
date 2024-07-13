//
//  QuizResultView.swift
//  kiwIT
//
//  Created by Heedon on 5/5/24.
//

import SwiftUI

struct QuizResultView: View {
    
    @StateObject var quizResultVM: QuizResultViewModel
    
    @Binding var path: NavigationPath
    @Binding var isLoginAvailable: Bool
    
    //to notify it's coming from QuizResultView to QuizListView via confirmToMoveToQuizList
    @Environment(\.quizNavigationNotification) var quizNavigationNotification: () -> Void
    
    init(_ quizVM: QuizViewModel, path: Binding<NavigationPath>, isLoginAvailable: Binding<Bool>) {
        self._path = path
        self._isLoginAvailable = isLoginAvailable
        self._quizResultVM = StateObject(wrappedValue: QuizResultViewModel(quizVM.quizGroupId, userAnswer: quizVM.userAnswerListForRequest, quizList: quizVM.quizData!.quizList))
    }
    
    var body: some View {
        VStack {
            if quizResultVM.didFinishSubmittingAnswer {
                QuizResult(quizList: quizResultVM.quizList, userAnswerList: quizResultVM.userAnswerListForRequest, result: quizResultVM.userResult!) { result in
                    switch result {
                    case .confirmToMoveToQuizList:
                        path = NavigationPath()
                        quizNavigationNotification()
                        print("Go back to Quiz List")
                    case .takeQuizAgain:
                        if (path.count > 0) {
                            print("back to take quiz again")
                            
//                            quizResultVM.takeQuizAgainClosure(true)
                            
                            //notify QuizView
                            path.removeLast()
                            
//                            path = NavigationPath()
                            
                        } else {
                            print("cannot move back to take quiz")
                            quizResultVM.showRetakeQuizErrorAlert = true
                        }
                    }
                }
            } else {
                ProgressView {
                    Text("답안 제출 중...")
                }
            }
        }
        .frame(maxHeight: .infinity)
        .background(Color.backgroundColor)
        .navigationBarBackButtonHidden()
        .alert("답안 제출 오류!", isPresented: $quizResultVM.showSubmitAnswerErrorAlert, actions: {
            ErrorAlertConfirmButton {
                quizResultVM.retrySubmitAnswer()
            }
            Button {
                path = NavigationPath()
            } label: {
                Text(Setup.ContentStrings.cancel)
            }
        }, message: {
            Text("제출에 오류가 발생했습니다. 다시 시도하려면 확인 버튼을, 나가려면 취소 버튼을 눌러주세요.")
        })
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
        .onDisappear {
            quizResultVM.cleanUpCancellables()
        }
    }
}

//#Preview {
//    QuizResultView(path: <#T##Binding<[String]>#>, testDataForQuestion: ["첫번째 문제입니다", "두번째 문제입니다", "세번째 문제입니다", "네번째 문제입니다", "다섯번째 문제입니다"], userOXAnswer: [true, false, false, false, true], answers: [false, true, true, true, true])
//}
