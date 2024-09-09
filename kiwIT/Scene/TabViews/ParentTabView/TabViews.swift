//
//  TabViews.swift
//  kiwIT
//
//  Created by Heedon on 6/13/24.
//

import SwiftUI

//MARK: - Do not initialize view until its actually selected

struct LazyView<Content: View>: View {
    //get real view as function
    let build: () -> Content
    
    //init: not calling build function, save in property
    init(_ build: @autoclosure @escaping () -> Content) {
        self.build = build
    }
    
    //when actually shows on screen: calls build function, which initializes view
    var body: Content {
        build()
    }
}


struct TabViews: View {
    
    @StateObject var tabViewsVM = TabViewsViewModel()
    @ObservedObject var mainTabBarVM: MainTabBarViewModel
    
    var body: some View {
        TabView(selection: $tabViewsVM.selectedTab) {
            LazyView(HomeView(tabViewsVM: tabViewsVM))
                .tabItem {
                    Label("홈", systemImage: Setup.ImageStrings.defaultHome)
                }
                .tag(TabType.home)
            LazyView(LectureListView(tabViewsVM: tabViewsVM))
                .tabItem {
                    Label("학습", systemImage: Setup.ImageStrings.defaultLecture)
                }
                .tag(TabType.lecture)
            LazyView(QuizListView(tabViewsVM: tabViewsVM))
                .tabItem {
                    Label("퀴즈", systemImage: Setup.ImageStrings.defaultQuiz)
                }
                .tag(TabType.quiz)
//            LazyView(InterviewListView(tabViewsVM: tabViewsVM))
//                .tabItem {
//                    Label("AI면접", systemImage: Setup.ImageStrings.defaultAiInterview)
//                }
//                .tag(TabType.interview)
            LazyView(ProfileView(tabViewsVM: tabViewsVM))
                .tabItem {
                    Label("나", systemImage: Setup.ImageStrings.defaultProfile)
                }
                .tag(TabType.profile)
        }
        .tint(Color.brandColor)
        .onAppear {
            tabViewsVM.checkProfileRequest.send(mainTabBarVM.userProfileData)
        }
        .onReceive(tabViewsVM.$isLoginAvailable) { isAvailable in
            mainTabBarVM.checkLoginStatus.send(isAvailable)
        }
    }
}

#Preview {
    TabViews(mainTabBarVM: MainTabBarViewModel())
}
