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
    @State private var isUserLoggedIn = false
    
    @State private var shouldShowLoginView = false
    
    var body: some View {
        
        //로그인 여부 체크
        if (isUserLoggedIn) {
            TabView {
                HomeView()
                LectureCategoryListView()
                QuizView()
                AIInterviewView()
                ProfileView()
            }
            .tint(Color.purple)
        } else {
            SocialLoginView()
        }
    }
}

#Preview {
    MainTabBarView()
}
