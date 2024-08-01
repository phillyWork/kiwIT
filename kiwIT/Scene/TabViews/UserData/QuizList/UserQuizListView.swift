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
        ScrollView {
            TakenQuizSection(quizListVM: quizListVM, gridItemLayout: gridItemLayoutForTakenQuiz)
            BookmarkedQuizSection(quizListVM: quizListVM, gridItemLayout: gridItemLayoutForBookmarkedQuiz)
        }
        .frame(maxWidth: .infinity)
        .background(Color.backgroundColor)
        .scrollIndicators(.hidden)
        .alert(Setup.ContentStrings.unknownNetworkErrorAlertTitle, isPresented: $quizListVM.showUnknownNetworkErrorAlert, actions: {
            ErrorAlertConfirmButton { }
        }, message: {
            Text(Setup.ContentStrings.unknownNetworkErrorAlertMessage)
        })
        .alert(Setup.ContentStrings.removeBookmarkedContentErrorAlertTitle, isPresented: $quizListVM.showRemoveBookmarkedQuizError) {
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
            if newValue {
                profileVM.removeThisBookmarkedQuiz(quizListVM.idForToBeRemovedQuiz)
            }
        }
        //to disable pull to refresh
        .environment(\EnvironmentValues.refresh as! WritableKeyPath<EnvironmentValues, RefreshAction?>, nil)
    }
}

struct TakenQuizSection: View {
    
    @ObservedObject var quizListVM: UserQuizListViewModel
    let gridItemLayout: [GridItem]
    
    var body: some View {
        VStack {
            HStack {
                Text("문제 풀이 완료 콘텐츠")
                    .font(.custom(Setup.FontName.notoSansBold, size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 10)
                Button {
                    quizListVM.debouncedResetTakenQuiz()
                } label: {
                    Image(systemName: Setup.ImageStrings.retryAction)
                }
                .padding(.trailing, 10)
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
                                    quizListVM.checkToLoadMoreCompletedQuizGroup(quizGroup)
                                }
                        }
                    }
                    .frame(height: Setup.Frame.profileQuizContentHGridHeight)
                    .scrollTargetLayout()
                }
                .frame(height: Setup.Frame.profileQuizContentHScrollHeight)
                .scrollTargetBehavior(.viewAligned)
                .scrollIndicators(.visible)
            }
        }
        .frame(height: Setup.Frame.profileContentEquallyDivide)
    }
}

struct BookmarkedQuizSection: View {
    
    @ObservedObject var quizListVM: UserQuizListViewModel
    let gridItemLayout: [GridItem]
    
    var body: some View {
        VStack {
            HStack {
                Text("보관한 콘텐츠")
                    .font(.custom(Setup.FontName.notoSansBold, size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 10)
                Button {
                    quizListVM.debouncedResetBookmarkedQuiz()
                } label: {
                    Image(systemName: Setup.ImageStrings.retryAction)
                }
                .padding(.trailing, 10)
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
                                quizListVM.checkToLoadMoreBookmarkedQuiz(quiz)
                            }
                        }
                    }
                    .frame(height: Setup.Frame.profileQuizContentHGridHeight)
                    .scrollTargetLayout()
                }
                .frame(height: Setup.Frame.profileQuizContentHScrollHeight)
                .scrollTargetBehavior(.viewAligned)
                .scrollIndicators(.visible)
            }
        }
        .frame(height: Setup.Frame.profileContentEquallyDivide)
        .alert(Setup.ContentStrings.removeBookmarkedContentAlertTitle, isPresented: $quizListVM.showRemoveBookmarkedQuizAlert) {
            Button(Setup.ContentStrings.confirm, role: .cancel) {
                quizListVM.debouncedUnbookmarkQuiz()
            }
            Button(Setup.ContentStrings.cancel, role: .destructive) { }
        } message: {
            Text("정말 보관함에서 제거하실 건가요?")
        }

    }
}
