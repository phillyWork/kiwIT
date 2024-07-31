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
    
    init(_ quizVM: QuizViewModel, path: Binding<NavigationPath>, isLoginAvailable: Binding<Bool>) {
        self._path = path
        self._isLoginAvailable = isLoginAvailable
        self._quizResultVM = StateObject(wrappedValue: QuizResultViewModel(quizVM.quizGroupId, title: quizVM.quizData!.title, score: quizVM.quizData!.totalScore, userAnswer: quizVM.userAnswerListForRequest, quizList: quizVM.quizData!.quizList))
    }
    
    var body: some View {
        VStack {
            ZStack {
                if quizResultVM.didFinishSubmittingAnswer {
                    QuizResult(quizTitle: quizResultVM.quizTitle, quizList: quizResultVM.quizList, userAnswerList: quizResultVM.userAnswerListForRequest, totalScore: quizResultVM.totalScore, result: quizResultVM.userResult!) { result in
                        switch result {
                        case .confirmToMoveToQuizList:
                            path = NavigationPath()
                        case .takeQuizAgain:
                            if (path.count > 0) {
                                path.removeLast()
                            } else {
                                quizResultVM.showRetakeQuizErrorAlert = true
                            }
                        }
                    }
                } else {
                    ProgressView {
                        Text("답안 제출 중...")
                    }
                }
            
                TrophyPageTabView(trophyList: quizResultVM.acquiredTrophyList, buttonAction: {
                    quizResultVM.handleAfterCloseTrophyCardView()
                })
                .opacity(quizResultVM.acquiredTrophyList.isEmpty ? 0 : 1)
                
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.backgroundColor)
        .navigationBarBackButtonHidden()
        .alert(Setup.ContentStrings.submitQuizAnswerErrorAlertTitle, isPresented: $quizResultVM.showSubmitAnswerErrorAlert, actions: {
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
        .alert(Setup.ContentStrings.unknownNetworkErrorAlertTitle, isPresented: $quizResultVM.showUnknownNetworkErrorAlert, actions: {
            ErrorAlertConfirmButton { }
        }, message: {
            Text(Setup.ContentStrings.unknownNetworkErrorAlertMessage)
        })
        .alert(Setup.ContentStrings.loginErrorAlertTitle, isPresented: $quizResultVM.shouldLoginAgain) {
            ErrorAlertConfirmButton {
                isLoginAvailable = false
            }
        } message: {
            Text(Setup.ContentStrings.loginErrorAlertMessage)
        }
        .alert(Setup.ContentStrings.retakeQuizErrorAlertTitle, isPresented: $quizResultVM.showRetakeQuizErrorAlert) {
            ErrorAlertConfirmButton {
                path = NavigationPath()
            }
        } message: {
            Text("오류로 인해 해당 퀴즈의 다시 풀기가 불가합니다. 퀴즈 목록으로 돌아갑니다.")
        }
    }
}

//#Preview {
//    QuizResultView(path: <#T##Binding<[String]>#>, testDataForQuestion: ["첫번째 문제입니다", "두번째 문제입니다", "세번째 문제입니다", "네번째 문제입니다", "다섯번째 문제입니다"], userOXAnswer: [true, false, false, false, true], answers: [false, true, true, true, true])
//}
