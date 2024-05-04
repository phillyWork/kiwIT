//
//  ContentView.swift
//  kiwIT
//
//  Created by Heedon on 3/10/24.
//

import SwiftUI

//조건 추가 scene 필요?

struct MainTabBarView: View {
    
    //viewmodel에서 판단, 이동 예정
    @State private var isUserLoggedIn = true
    
    @State private var shouldShowLoginView = false
    
//    init() {
//        UINavigationBar.appearance().backgroundColor = UIColor(named: "backgroundColor")
//        let navBarAppearance = UINavigationBarAppearance()
//        // 객체 생성
//        navBarAppearance.backgroundColor = UIColor(named: "backgroundColor")
//        navBarAppearance.shadowColor = .clear
//        // 객체 속성 변경
//        UINavigationBar.appearance().standardAppearance = navBarAppearance
//        UINavigationBar.appearance().compactAppearance = navBarAppearance
//        UINavigationBar.appearance().scrollEdgeAppearance = navBarAppearance
//        // 생성한 객체를 각각의 appearance에 할당
//    }
    
    var body: some View {
        //로그인 여부 체크
        if (isUserLoggedIn) {
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
        } else {
            SocialLoginView()
        }
    }
}

#Preview {
    MainTabBarView()
}
