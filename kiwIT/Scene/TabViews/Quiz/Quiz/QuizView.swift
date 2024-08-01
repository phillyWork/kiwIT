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
    
    @Environment(\.dismiss) private var dismiss
    
    init(quizListVM: QuizListViewModel, quizGroupId: Int, pathString: String, path: Binding<NavigationPath>, isLoginAvailable: Binding<Bool>) {
        self.quizListVM = quizListVM
        _quizVM = StateObject(wrappedValue: QuizViewModel(quizGroupId: quizGroupId, pathString: pathString))
        self._path = path
        self._isLoginAvailable = isLoginAvailable
    }
    
    var body: some View {
        ScrollView {
            if let quizData = quizVM.quizData {
                switch quizData.quizList[quizVM.quizIndex].type {
                case .multipleChoice:
                    QuizMultipleChoice(userChoiceNumber: quizVM.isThisPreviousQuestion ?  quizVM.recentSelectedMultipleChoice : 0, quizPayload: quizData.quizList[quizVM.quizIndex], quizIndex: quizVM.quizIndex, quizCount: quizVM.quizCount) { result in
                        switch result {
                        case .success(let selectedChoice):
                            quizVM.updateMultipleChoice(selectedChoice)
                            if quizVM.isQuizCompleted {
                                print("Quiz done by MultipleChoice")
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
                                print("Quiz done by Short Answer")
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
                                print("Quiz done by OX")
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
        .onAppear {
            quizVM.checkRetakeQuiz()
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Quiz Title")
                    .font(.custom(Setup.FontName.phuduBold, size: 20))
            }
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    quizListVM.dismissFromQuiz()
                    dismiss()
                } label: {
                    Image(systemName: Setup.ImageStrings.defaultXMark2)
                }
                .tint(Color.textColor)
            }
        }
        .alert(Setup.ContentStrings.unknownNetworkErrorAlertTitle, isPresented: $quizVM.showUnknownNetworkErrorAlert, actions: {
            ErrorAlertConfirmButton { }
        }, message: {
            Text(Setup.ContentStrings.unknownNetworkErrorAlertMessage)
        })
        .alert(Setup.ContentStrings.loginErrorAlertTitle, isPresented: $quizVM.shouldLoginAgain, actions: {
            ErrorAlertConfirmButton {
                isLoginAvailable = false
            }
        }, message: {
            Text(Setup.ContentStrings.loginErrorAlertMessage)
        })
        .background {
            NavigationLink("", isActive: $quizVM.isQuizCompleted) {
                QuizResultView(quizVM, path: $path, isLoginAvailable: $isLoginAvailable)
            }
        }
        .environment(\EnvironmentValues.refresh as! WritableKeyPath<EnvironmentValues, RefreshAction?>, nil)        //to disable pull to refresh
    }
}
