//
//  InterviewHistoryView.swift
//  kiwIT
//
//  Created by Heedon on 8/1/24.
//

import SwiftUI

struct InterviewHistoryView: View {
    
    @StateObject var interviewHistoryVM: InterviewHistoryViewModel
    
    @Binding var path: NavigationPath
    @Binding var isLoginAvailable: Bool
    
    init(interviewListVM: InterviewListViewModel, parentType: InterviewParentType, path: Binding<NavigationPath>, isLoginAvailable: Binding<Bool>) {
        self._interviewHistoryVM = StateObject(wrappedValue: InterviewHistoryViewModel(interviewListVM.selectedId, parent: parentType))
        self._path = path
        self._isLoginAvailable = isLoginAvailable
    }
    
    var body: some View {
        ScrollView {
            switch interviewHistoryVM.parentViewType {
            case .createNewInterview:
                
                ContentNotExpandableChapterItemView(title: "새로운 마음으로 시작해볼까요?")
                
                Button {
                    //MARK: - Start new Interview with checking status
                    
                } label: {
                    Text("새롭게 시작하기")
                }
            case .previouslyCreatedInterview:
                
                if interviewHistoryVM.showPastHistoryListError {
                    
                } else if interviewHistoryVM.pastHistoryList.isEmpty {
                    
                } else {
                    Button {
                        //MARK: - Start new Interview with checking status
                        
                    } label: {
                        Text("다시 하기")
                    }
                    
                    LazyVStack(spacing: 10) {
                        ForEach(interviewHistoryVM.pastHistoryList, id: \.self) { history in
                            
                            NavigationLink {
                                InterviewPastAnswersView()
                            } label: {
                                Text("Placeholder \(history.id)")
                            }

                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.backgroundColor)
        .alert(Setup.ContentStrings.loginErrorAlertTitle, isPresented: $interviewHistoryVM.shouldLoginAgain, actions: {
            ErrorAlertConfirmButton {
                isLoginAvailable = false
            }
        }, message: {
            Text(Setup.ContentStrings.loginErrorAlertMessage)
        })
        //to disable pull to refresh
        .environment(\EnvironmentValues.refresh as! WritableKeyPath<EnvironmentValues, RefreshAction?>, nil)
    }
}
