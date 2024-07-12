//
//  QuizView.swift
//  kiwIT
//
//  Created by Heedon on 5/4/24.
//

import SwiftUI

struct QuizView: View {
    
    @StateObject var quizVM: QuizViewModel
    @ObservedObject var quizListVM: QuizListViewModel
    
    @Binding var path: NavigationPath
    @Binding var isLoginAvailable: Bool
    
    @Environment(\.dismiss) var dismiss
    
    init(quizListVM: QuizListViewModel, quizGroupId: Int, pathString: String, path: Binding<NavigationPath>, isLoginAvailable: Binding<Bool>) {
        self.quizListVM = quizListVM
        _quizVM = StateObject(wrappedValue: QuizViewModel(quizGroupId: quizGroupId, pathString: pathString))
        self._path = path
        self._isLoginAvailable = isLoginAvailable
    }

    var body: some View {
        ScrollView {
            if let quizData = quizVM.quizData {
                switch quizVM.quizType {
                case .multipleChoice:
                    QuizMultipleChoice(userChoiceNumber: quizVM.recentSelectedMultipleChoice, quizPayload: quizData.quizList[quizVM.quizIndex], quizIndex: quizVM.quizIndex, quizCount: quizVM.quizCount) { result in
                        switch result {
                        case .success(let selectedChoice):
                            quizVM.updateMultipleChoice(selectedChoice)
                            if quizVM.isQuizCompleted {
                                path.append("Result-\(quizVM.quizGroupId)")
                            }
                        case .failure(.backToPreviousQuestion):
                            quizVM.checkToRemoveSelected()
                        }
                    } bookmarkAction: { id in
                        quizVM.updateBookmarkedStatus(id)
                    }
                case .shortAnswer:
                    QuizContentShortAnswer(textFieldInput: quizVM.isThisPreviousQuestion ? quizVM.recentSelectedShortAnswer : "", quizPayload: quizData.quizList[quizVM.quizIndex], quizIndex: quizVM.quizIndex, quizCount: quizVM.quizCount) { result in
                        switch result {
                        case .success(let userAnswer):
                            quizVM.updateShortAnswer(userAnswer)
                            if quizVM.isQuizCompleted {
                                path.append("Result-\(quizVM.quizGroupId)")
                            }
                        case .failure(.backToPreviousQuestion):
                            quizVM.checkToRemoveSelected()
                        }
                    } bookmarkAction: { id in
                        quizVM.updateBookmarkedStatus(id)
                    }
                case .trueOrFalse:
                    QuizContentOX(chosenState: quizVM.isThisPreviousQuestion ? quizVM.recentSelectedBoolAnswer : .unchosen, quizPayload: quizData.quizList[quizVM.quizIndex], quizIndex: quizVM.quizIndex, quizCount: quizVM.quizCount) { result in
                        switch result {
                        case .success(let userAnswer):
                            quizVM.updateOXAnswer(userAnswer)
                            if quizVM.isQuizCompleted {
                                path.append("Result-\(quizVM.quizGroupId)")
                            }
                        case .failure(.backToPreviousQuestion):
                            quizVM.checkToRemoveSelected()
                        }
                    } bookmarkAction: { id in
                        quizVM.updateBookmarkedStatus(id)
                    }
                }
            } else {
                WholeEmptyView()
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.backgroundColor)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Quiz Title")
                    .font(.custom(Setup.FontName.phuduBold, size: 20))
            }
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: Setup.ImageStrings.defaultXMark2)
                }
                .tint(Color.textColor)
            }
        }
        
//        .onAppear {
//            print("user takes quiz again??")
//            if quizVM.checkRetakeQuiz() {
//                print("user takes quiz again")
//                quizVM.resetQuiz()
//            }
//        }
        
        .alert("네트워크 오류!", isPresented: $quizVM.showUnknownNetworkErrorAlert, actions: {
            ErrorAlertConfirmButton { }
        }, message: {
            Text("네트워크 요청에 실패했습니다! 다시 시도해주세요!")
        })
        .alert("로그인 오류!", isPresented: $quizVM.shouldLoginAgain, actions: {
            ErrorAlertConfirmButton {
                isLoginAvailable = false
            }
        }, message: {
            Text("세션 만료입니다. 다시 로그인해주세요!")
        })
        .navigationDestination(isPresented: $quizVM.isQuizCompleted) {
            if let quizData = quizVM.quizData {
                let _ = print("Moving to Quiz Result View with path: \(path)")
                QuizResultView(quizVM, id: quizVM.quizGroupId, userAnswer: quizVM.getUserAnswer(), quizList: quizData.quizList, path: $path, isLoginAvailable: $isLoginAvailable)
            }
        }
        .environment(\EnvironmentValues.refresh as! WritableKeyPath<EnvironmentValues, RefreshAction?>, nil)        //to disable pull to refresh
    }
    
}
