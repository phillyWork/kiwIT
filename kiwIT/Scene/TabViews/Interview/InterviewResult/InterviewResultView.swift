//
//  InterviewResultView.swift
//  kiwIT
//
//  Created by Heedon on 8/1/24.
//

import SwiftUI

struct InterviewResultView: View {
    
    @StateObject var interviewResultVM = InterviewResultViewModel()
    
    @Binding var path: NavigationPath
    @Binding var isLoginAvaialble: Bool
    
    var body: some View {
        
        Text("")
        
        //MARK: - 결과 확인 및 다시하기, 확인 완료
        //MARK: - 다시하기: polling 처리 필요 확인해야 함 (API 문서 확인 필요)
        
        
//        VStack {
//            ZStack {
//                if quizResultVM.didFinishSubmittingAnswer {
//                    QuizResult(quizTitle: quizResultVM.quizTitle, quizList: quizResultVM.quizList, userAnswerList: quizResultVM.userAnswerListForRequest, totalScore: quizResultVM.totalScore, result: quizResultVM.userResult!) { result in
//                        switch result {
//                        case .confirmToMoveToQuizList:
//                            path = NavigationPath()
//                        case .takeQuizAgain:
//                            if (path.count > 0) {
//                                path.removeLast()
//                            } else {
//                                quizResultVM.updateToShowRetakeErrorAlert()
//                            }
//                        }
//                    }
//                } else {
//                    ProgressView {
//                        Text("답안 제출 중...")
//                    }
//                }
//            
//                TrophyPageTabView(trophyList: quizResultVM.acquiredTrophyList, buttonAction: {
//                    quizResultVM.handleAfterCloseTrophyCardView()
//                })
//                .opacity(quizResultVM.acquiredTrophyList.isEmpty ? 0 : 1)
//            }
//        }
//        .frame(maxWidth: .infinity, maxHeight: .infinity)
//        .background(Color.backgroundColor)
//        .navigationBarBackButtonHidden()
//        .alert(Setup.ContentStrings.submitQuizAnswerErrorAlertTitle, isPresented: $quizResultVM.showSubmitAnswerErrorAlert, actions: {
//            ErrorAlertConfirmButton {
//                quizResultVM.retrySubmitAnswer()
//            }
//            Button {
//                path = NavigationPath()
//            } label: {
//                Text(Setup.ContentStrings.cancel)
//            }
//        }, message: {
//            Text("제출에 오류가 발생했습니다. 다시 시도하려면 확인 버튼을, 나가려면 취소 버튼을 눌러주세요.")
//        })
//        .alert(Setup.ContentStrings.unknownNetworkErrorAlertTitle, isPresented: $quizResultVM.showUnknownNetworkErrorAlert, actions: {
//            ErrorAlertConfirmButton { }
//        }, message: {
//            Text(Setup.ContentStrings.unknownNetworkErrorAlertMessage)
//        })
//        .alert(Setup.ContentStrings.loginErrorAlertTitle, isPresented: $quizResultVM.shouldLoginAgain) {
//            ErrorAlertConfirmButton {
//                isLoginAvailable = false
//            }
//        } message: {
//            Text(Setup.ContentStrings.loginErrorAlertMessage)
//        }
//        .alert(Setup.ContentStrings.retakeQuizErrorAlertTitle, isPresented: $quizResultVM.showRetakeQuizErrorAlert) {
//            ErrorAlertConfirmButton {
//                path = NavigationPath()
//            }
//        } message: {
//            Text("오류로 인해 해당 퀴즈의 다시 풀기가 불가합니다. 퀴즈 목록으로 돌아갑니다.")
//        }
        
    }
}
