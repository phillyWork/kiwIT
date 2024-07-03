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
                    CustomEmptyView()
                        .frame(maxWidth: .infinity)
                } else {
                    LazyVStack(spacing: 4) {
                        ForEach(quizListVM.quizListData, id: \.self) { eachQuizGroup in
                            Button {
                                path.append("Quiz-\(eachQuizGroup.id)")
                                quizListVM.updateSelectedQuizGroupId(eachQuizGroup.id)
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
                                print("Check data for pagination!!!")
                                if quizListVM.quizListData.last == eachQuizGroup {
                                    print("Last data for list: should call more!!!")
                                    quizListVM.loadMoreQuizList()
                                }
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
            .alert("로그인 오류!", isPresented: $quizListVM.shouldLoginAgain, actions: {
                ErrorAlertConfirmButton {
                    tabViewsVM.isLoginAvailable = false
                }
            }, message: {
                Text("세션 만료입니다. 다시 로그인해주세요!")
            })
//            .onChange(of: quizListVM.shouldLoginAgain) { newValue in
//                if newValue {
//                    tabViewsVM.isLoginAvailable = false
//                }
//            }
            .navigationDestination(for: String.self) { id in
                if id.hasPrefix("Quiz-") {
                    if let quizGroupId = quizListVM.getSelectedQuizGroupId() {
                        QuizView(quizListVM: quizListVM, quizGroupId: quizGroupId, pathString: id, path: $path, isLoginAvailable: $tabViewsVM.isLoginAvailable)
                    }
                }
            }
            .onAppear {
                //MARK: - 퀴즈 완료 후 되돌아 올 경우, 어떻게 처리?
                
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
