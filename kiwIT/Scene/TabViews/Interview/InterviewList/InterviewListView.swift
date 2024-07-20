//
//  GPTView.swift
//  kiwIT
//
//  Created by Heedon on 3/11/24.
//

import SwiftUI

struct InterviewListView: View {
    
    @StateObject var interviewListVM: InterviewListViewModel
    @ObservedObject var tabViewsVM: TabViewsViewModel
    
    @State private var path = NavigationPath()
    
    init(tabViewsVM: TabViewsViewModel) {
        self.tabViewsVM = tabViewsVM
        self._interviewListVM = StateObject(wrappedValue: InterviewListViewModel(tabViewsVM.profileData))
    }
    
    @State var names = ["Jack", "Simon", "Sam", "Trinity", "Hello"]
    
    var body: some View {
        NavigationStack(path: $path) {
            List {
                ForEach(names, id: \.self) { name in
                    Button {
                        path.append(name)
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
                        interviewListVM.debouncedCheckStatus()
                    } label: {
                        Image(systemName: Setup.ImageStrings.plusSquare)
                    }
                }
            }
            .sheet(isPresented: $interviewListVM.showCreateNewInterviewSheet) {
                CreateInterviewSheet { content in
                    interviewListVM.debouncedCreateInterview(content)
                }
                .presentationDragIndicator(.visible)
            }
            .navigationDestination(for: String.self) { name in
                InterviewView()
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
