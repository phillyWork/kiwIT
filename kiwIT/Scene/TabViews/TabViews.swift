//
//  TabViews.swift
//  kiwIT
//
//  Created by Heedon on 6/13/24.
//

import SwiftUI

enum TabType: Int, Hashable, CaseIterable, Identifiable {
    case home
    case lecture
    case quiz
    case interview
    case profile
    
    var id: Int {
        rawValue
    }
}

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
    
    @State private var selectedTab: TabType = .home
    
    var body: some View {
        TabView(selection: $selectedTab) {
            LazyView(HomeView(tabViewsVM: tabViewsVM))
                .tabItem {
                    Label("홈", systemImage: Setup.ImageStrings.defaultHome)
                }
                .tag(TabType.home)
            LazyView(LectureListView(tabViewsVM: tabViewsVM))
                .tabItem {
                    Label("학습", systemImage: Setup.ImageStrings.defaultLecture)
                }
                .tag(TabType.home)
            LazyView(QuizListView(tabViewsVM: tabViewsVM))
                .tabItem {
                    Label("퀴즈", systemImage: Setup.ImageStrings.defaultQuiz)
                }
                .tag(TabType.home)
            LazyView(AIInterviewView(tabViewsVM: tabViewsVM))
                .tabItem {
                    Label("AI면접", systemImage: Setup.ImageStrings.defaultAiInterview)
                }
                .tag(TabType.home)
            LazyView(ProfileView(tabViewsVM: tabViewsVM))
                .tabItem {
                    Label("나", systemImage: Setup.ImageStrings.defaultProfile)
                }
                .tag(TabType.home)
        }
        .tint(Color.brandColor)
        .onAppear {
            tabViewsVM.checkProfile(with: mainTabBarVM.userProfileData)
        }
        .onReceive(tabViewsVM.$isLoginAvailable) { isAvailable in
            print("is login available? -- \(isAvailable) in TabViews")
            mainTabBarVM.isUserLoggedIn = isAvailable
        }
    }
}

#Preview {
    TabViews(mainTabBarVM: MainTabBarViewModel())
}
