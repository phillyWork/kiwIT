//
//  TabViews.swift
//  kiwIT
//
//  Created by Heedon on 6/13/24.
//

import SwiftUI

struct TabViews: View {
    
    @StateObject var tabViewsVM = TabViewsViewModel()
    @ObservedObject var mainTabBarVM: MainTabBarViewModel
        
    var body: some View {
        TabView {
                HomeView(tabViewsVM: tabViewsVM)
                    .tabItem {
                        Label("홈", systemImage: Setup.ImageStrings.defaultHome)
                    }
                LectureCategoryListView(tabViewsVM: tabViewsVM)
                    .tabItem {
                        Label("학습", systemImage: Setup.ImageStrings.defaultLecture)
                    }
                QuizListView(tabViewsVM: tabViewsVM)
                    .tabItem {
                        Label("퀴즈", systemImage: Setup.ImageStrings.defaultQuiz)
                    }
                AIInterviewView(tabViewsVM: tabViewsVM)
                    .tabItem {
                        Label("AI면접", systemImage: Setup.ImageStrings.defaultAiInterview)
                    }
                ProfileView(tabViewsVM: tabViewsVM)
                    .tabItem {
                        Label("나", systemImage: Setup.ImageStrings.defaultProfile)
                    }
        }
        .tint(Color.brandColor)
        .onAppear {
            tabViewsVM.checkProfile(with: mainTabBarVM.userProfileData)
        }
        .onReceive(tabViewsVM.$isLoginAvailable) { isAvailable in
            print("is available? -- \(isAvailable)")
            mainTabBarVM.isUserLoggedIn = isAvailable
        }
    }
}

#Preview {
    TabViews(mainTabBarVM: MainTabBarViewModel())
}
