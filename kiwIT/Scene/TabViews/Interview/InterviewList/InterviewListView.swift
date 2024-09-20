//
//  GPTView.swift
//  kiwIT
//
//  Created by Heedon on 3/11/24.
//

import SwiftUI

struct InterviewListView: View {
    
    @StateObject var interviewListVM = InterviewListViewModel()
    @ObservedObject var tabViewsVM: TabViewsViewModel
    
    @State private var path = NavigationPath()
        
    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(interviewListVM.interviewList, id: \.self) { interview in
                    Button {
                        path.append("History - \(interview.id)")
                        interviewListVM.debouncedSelectedInterviewId(interview.id)
                    } label: {
                        InterviewListContent()
                    }
                    .listRowBackground(Color.backgroundColor)
                }
                .onDelete(perform: interviewListVM.deleteItems)
                .listRowSeparator(.hidden)
            }
            .listStyle(.grouped)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .scrollContentBackground(.hidden)
            .background(Color.backgroundColor)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("AI 인터뷰")
            .toolbarBackground(Color.backgroundColor, for: .navigationBar, .tabBar)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        interviewListVM.debouncedSetupCreateInterviewSheet()
                    } label: {
                        Image(systemName: Setup.ImageStrings.plusSquare)
                    }
                }
            }
            .sheet(isPresented: $interviewListVM.showCreateNewInterviewSheet) {
                CreateInterviewSheet(category: $interviewListVM.optionCategory, 
                                     level: $interviewListVM.optionLevel) { content in
                    interviewListVM.debouncedCreateInterview(content)
                }
                .presentationDragIndicator(.visible)
                .alert("옵션 불러오기 실패!", isPresented: $interviewListVM.showRetrieveInterviewOptionErrorAlert) {
                    ErrorAlertConfirmButton {
                        interviewListVM.debouncedCloseSheet()
                    }
                } message: {
                    Text("생성에 필요한 옵션을 불러오는데 실패했습니다. 다시 시도해주세요.")
                }
            }
            .alert(Setup.ContentStrings.loginErrorAlertTitle, isPresented: $interviewListVM.shouldLoginAgain, actions: {
                ErrorAlertConfirmButton {
                    tabViewsVM.userLoginStatusUpdate.send(false)
                }
            }, message: {
                Text(Setup.ContentStrings.loginErrorAlertMessage)
            })
            .navigationDestination(for: String.self) { name in
                InterviewHistoryView(interviewListVM: interviewListVM, parentType: .previouslyCreatedInterview, path: $path, isLoginAvailable: $tabViewsVM.isLoginAvailable)
            }
            .background {
                NavigationLink("", isActive: $interviewListVM.showNewlyCreatedInterview) {
                    InterviewHistoryView(interviewListVM: interviewListVM, parentType: .createNewInterview, path: $path, isLoginAvailable: $tabViewsVM.isLoginAvailable)
                }
            }
            .refreshable {
                interviewListVM.debouncedRefreshInterview()
            }
        }
    }
}

#Preview {
    InterviewListView(tabViewsVM: TabViewsViewModel())
}
