//
//  UserQuizListView.swift
//  kiwIT
//
//  Created by Heedon on 7/5/24.
//

import SwiftUI

struct UserQuizListView: View {
    
    @StateObject var quizListVM = UserQuizListViewModel()
    @ObservedObject var profileVM: ProfileViewModel
    
    @Binding var isLoginAvailable: Bool
    
    private let gridItemLayoutForTakenQuiz = [GridItem(.flexible()),
                                              GridItem(.flexible())]
    
    private let gridItemLayoutForBookmarkedQuiz = [GridItem(.flexible())]
    
    var body: some View {
        VStack {
            TakenQuizSection(quizListVM: quizListVM, gridItemLayout: gridItemLayoutForTakenQuiz)
            BookmarkedQuizSection(quizListVM: quizListVM, gridItemLayout: gridItemLayoutForBookmarkedQuiz)
        }
        .frame(maxHeight: .infinity)
        .background(Color.backgroundColor)
        .alert("네트워크 오류!", isPresented: $quizListVM.showUnknownNetworkErrorAlert, actions: {
            ErrorAlertConfirmButton { }
        }, message: {
            Text("네트워크 요청에 실패했습니다! 다시 시도해주세요!")
        })
        .alert("보관함 오류!", isPresented: $quizListVM.showRemoveBookmarkedQuizError) {
            ErrorAlertConfirmButton { }
        } message: {
            Text("보관함 제거에 실패했습니다. 다시 시도해주세요.")
        }
        .alert(Setup.ContentStrings.loginErrorAlertTitle, isPresented: $quizListVM.shouldLoginAgain) {
            ErrorAlertConfirmButton {
                isLoginAvailable = false
            }
        } message: {
            Text(Setup.ContentStrings.loginErrorAlertMessage)
        }
        .onChange(of: quizListVM.shouldUpdateProfileVM) { newValue in
            profileVM.removeThisBookmarkedQuiz(quizListVM.idForToBeRemovedQuiz)
        }
        .onDisappear {
            quizListVM.cleanUpCancellables()
        }
    }
}

struct TakenQuizSection: View {
    
    @ObservedObject var quizListVM: UserQuizListViewModel
    let gridItemLayout: [GridItem]
    
    var body: some View {
        VStack {
            HStack {
                Text("문제 풀이 완료 콘텐츠")
                Spacer()
                Button {
                    quizListVM.debouncedResetTakenQuiz()
                } label: {
                    Image(systemName: Setup.ImageStrings.retryAction)
                }
            }
            if quizListVM.showTakenQuizError {
                EmptyViewWithRetryButton {
                    quizListVM.debouncedResetTakenQuiz()
                }
            } else if quizListVM.takenQuizList.isEmpty {
                EmptyViewWithNoError(title: "문제 풀이 완료한 퀴즈가 없어요")
            } else {
                ScrollView(.horizontal) {
                    LazyHGrid(rows: gridItemLayout, spacing: 10) {
                        ForEach(quizListVM.takenQuizList, id: \.self) { quizGroup in
                            TakenQuizContent(quizGroup)
                                .padding(.horizontal, 8)
                                .onAppear {
                                    if quizListVM.takenQuizList.last == quizGroup {
                                        print("Last data for list: should call more!!!")
                                        quizListVM.loadMoreTakenQuiz()
                                    }
                                }
                        }
                    }
                    .frame(height: Setup.Frame.profileQuizContentHGridHeight)
                    .background(Color.red)
                }
                .scrollIndicators(.visible)
                .frame(height: Setup.Frame.profileQuizContentHeight * 2.5)
                .background(Color.orange)
            }
        }
        .background(Color.blue)
    }
}

struct BookmarkedQuizSection: View {
    
    @ObservedObject var quizListVM: UserQuizListViewModel
    let gridItemLayout: [GridItem]
    
    var body: some View {
        VStack {
            HStack {
                Text("보관한 콘텐츠")
                Spacer()
                Button {
                    quizListVM.debouncedResetBookmarkedQuiz()
                } label: {
                    Image(systemName: Setup.ImageStrings.retryAction)
                }
            }
            if quizListVM.showBookmarkedQuizError {
                EmptyViewWithRetryButton {
                    quizListVM.debouncedResetBookmarkedQuiz()
                }
            } else if quizListVM.bookmarkedQuizList.isEmpty {
                EmptyViewWithNoError(title: "보관한 퀴즈가 없어요")
            } else {
                ScrollView(.horizontal) {
                    LazyHGrid(rows: gridItemLayout) {
                        ForEach(quizListVM.bookmarkedQuizList, id: \.self) { quiz in
                            BookmarkedQuizContent(quiz) {
                                quizListVM.checkToRemoveBookmarkedQuiz(quiz.id)
                            }
                            .padding(.horizontal, 8)
                            .onAppear {
                                if quizListVM.bookmarkedQuizList.last == quiz {
                                    print("Last data for list: should call more!!!")
                                    quizListVM.loadMoreBookmarkedQuiz()
                                }
                            }
                        }
                    }
                    .frame(height: Setup.Frame.profileQuizContentHGridHeight)
                    .background(Color.purple)
                }
                .scrollIndicators(.visible)
                .frame(height: Setup.Frame.profileQuizContentHeight * 2.5)
                .background(Color.orange)
            }
        }
        .background(Color.green)
        .alert("보관함 제거?", isPresented: $quizListVM.showRemoveBookmarkedQuizAlert) {
            Button(Setup.ContentStrings.confirm, role: .cancel) {
                quizListVM.debouncedUnbookmarkQuiz()
            }
            Button(Setup.ContentStrings.cancel, role: .destructive) { }
        } message: {
            Text("정말 보관함에서 제거하실 건가요?")
        }

    }
}
