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
                HomeView()
                    .tabItem {
                        Label("홈", systemImage: Setup.ImageStrings.defaultHome)
                    }
                LectureCategoryListView()
                    .tabItem {
                        Label("학습", systemImage: Setup.ImageStrings.defaultLecture)
                    }
                QuizListView()
                    .tabItem {
                        Label("퀴즈", systemImage: Setup.ImageStrings.defaultQuiz)
                    }
                AIInterviewView()
                    .tabItem {
                        Label("AI면접", systemImage: Setup.ImageStrings.defaultAiInterview)
                    }
                ProfileView()
                    .tabItem {
                        Label("나", systemImage: Setup.ImageStrings.defaultProfile)
                    }
        }
        .tint(Color.brandColor)
    }
}

#Preview {
    TabViews(mainTabBarVM: MainTabBarViewModel())
}
