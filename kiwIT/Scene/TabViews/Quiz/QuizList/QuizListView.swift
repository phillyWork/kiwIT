//
//  QuizView.swift
//  kiwIT
//
//  Created by Heedon on 3/11/24.
//

import SwiftUI

//MARK: - Quiz: 퀴즈 리스트, 내역 조회, 퀴즈 시작, 퀴즈 보관, 결과
struct QuizListView: View {
    
    @StateObject var quizListVM = QuizListViewModel()
    @ObservedObject var tabViewsVM: TabViewsViewModel
    
    //option 버튼으로 북마크 기능 추가 필요 및 새롭게 만들기 버튼 필요
    
    //To pop back to Quiz List
//    @State private var path: [String] = []
    @State private var path = NavigationPath()
    
    var body: some View {
        
        NavigationStack(path: $path) {
            ScrollView {
                LazyVStack(spacing: 4) {
                    //Quiz payload 받아와서 개수만큼 생성, 각 quiz의 Id로 구분하기
                    ForEach(1...5, id: \.self) { row in
                        
                        Button(action: {
                            path.append("Quiz-\(row)")
                            print("path in QuizListView: \(path)")
                        }, label: {
                            QuizListItem(title: "기본 Quiz", ratio: 0.85)
                        })
//                        .navigationDestination(for: String.self) { id in
//                            if id.hasPrefix("Quiz-") {
//                                QuizView(path: $path, quizID: id)
//                            }
//                        }
                        
                    }
                    .frame(maxHeight: .infinity)
                }
                .frame(maxWidth: .infinity)
                .frame(width: Setup.Frame.devicePortraitWidth, alignment: .center)
            }
            .scrollIndicators(.hidden)
            .background(Color.backgroundColor)
            .navigationTitle("퀴즈")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.backgroundColor, for: .navigationBar, .tabBar)
            .navigationDestination(for: String.self) { id in
                //navigationDestination shouldn't be around the destination view
                if id.hasPrefix("Quiz-") {
                    //퀴즈에 따라 다른 id 같이 전달 필요
                    QuizView(path: $path, quizID: id)
                }
            }
            .onAppear {
                //update quiz result & update to server
                
            }
        }
        .refreshable {
            print("Refresh to update Quiz Result!!!")
            
        }
    }
}

#Preview {
//    QuizListView(tabViewsVM: TabViewsViewModel(MainTabBarViewModel().userProfileData))
    QuizListView(tabViewsVM: TabViewsViewModel())
}
