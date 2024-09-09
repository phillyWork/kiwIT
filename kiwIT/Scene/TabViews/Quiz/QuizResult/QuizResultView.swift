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
                                quizResultVM.updateToShowRetakeErrorAlert()
                            }
                        }
                    }
                } else {
                    ProgressView {
                        Text(Setup.ContentStrings.Quiz.submitQuizProgressTitle)
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
            Text(Setup.ContentStrings.Quiz.submitQuizAnswerErrorAlertMessage)
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
            Text(Setup.ContentStrings.Quiz.retryQuizErrorAlertMessage)
        }
    }
}
