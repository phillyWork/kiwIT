//
//  QuizView.swift
//  kiwIT
//
//  Created by Heedon on 3/11/24.
//

import SwiftUI

struct QuizListView: View {
    
    @StateObject var quizListVM = QuizListViewModel()
    @ObservedObject var tabViewsVM: TabViewsViewModel
    
    //To pop back to Quiz List
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack {
                    Image(systemName: Setup.ImageStrings.downDirection)
                        .scaledToFit()
                    Text("당겨서 새로고침")
                        .font(.custom(Setup.FontName.lineThin, size: 12))
                        .foregroundStyle(Color.textColor)
                }
                if quizListVM.showEmptyView {
                    WholeEmptyView()
                        .frame(maxWidth: .infinity)
                } else {
                    LazyVStack(spacing: 4) {
                        ForEach(quizListVM.quizListData, id: \.self) { eachQuizGroup in
                            Button {
                                path.append("Quiz-\(eachQuizGroup.id)")
                                quizListVM.updateSelectedQuiz(eachQuizGroup.id)
                            } label: {
                                if quizListVM.isCompletedQuizListLoading {
                                    QuizListItem(title: eachQuizGroup.title, ratio: 0.85)
                                } else if let takenQuiz = quizListVM.checkAlreadyTaken(eachQuizGroup.id) {
                                    QuizListItem(title: eachQuizGroup.title, ratio: 0.85, highest: takenQuiz.result.highestScore, latest: takenQuiz.result.latestScore)
                                } else {
                                    QuizListItem(title: eachQuizGroup.title, ratio: 0.85)
                                }
                            }
                            .onAppear {
                                quizListVM.checkMorePaginationNeeded(eachQuizGroup)
                            }
                        }
                        .frame(maxHeight: .infinity)
                    }
                    .frame(maxWidth: .infinity)
                    .frame(width: Setup.Frame.devicePortraitWidth, alignment: .center)
                }
            }
            .scrollIndicators(.hidden)
            .background(Color.backgroundColor)
            .navigationTitle(Setup.ContentStrings.quizContentTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.backgroundColor, for: .navigationBar, .tabBar)
            .alert(Setup.ContentStrings.unknownNetworkErrorAlertTitle, isPresented: $quizListVM.showUnknownNetworkErrorAlert, actions: {
                ErrorAlertConfirmButton { }
            }, message: {
                Text(Setup.ContentStrings.unknownNetworkErrorAlertMessage)
            })
            .alert(Setup.ContentStrings.loginErrorAlertTitle, isPresented: $quizListVM.shouldLoginAgain, actions: {
                ErrorAlertConfirmButton {
                    tabViewsVM.userLoginStatusUpdate.send(false)
                }
            }, message: {
                Text(Setup.ContentStrings.loginErrorAlertMessage)
            })
            .navigationDestination(for: String.self) { pathString in
                if pathString.hasPrefix("Quiz-") {
                    if let quizGroupId = quizListVM.getSelectedQuizGroupId() {
                        QuizView(quizListVM: quizListVM, quizGroupId: quizGroupId, pathString: pathString, path: $path, isLoginAvailable: $tabViewsVM.isLoginAvailable)
                    }
                }
            }
            .onAppear {
                quizListVM.checkRetakeQuiz()
            }
        }
        .refreshable {
            print("Refresh to update Quiz List with Result!!!")
            quizListVM.resetPaginationToRefreshQuizList()
        }
    }
}

#Preview {
    QuizListView(tabViewsVM: TabViewsViewModel())
}
