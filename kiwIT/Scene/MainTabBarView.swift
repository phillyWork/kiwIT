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
            //전체 탭뷰 내부 모든 폰트 동일 적용 (NavBar 및 Tabbar 제외)
            .font(Font.custom(Setup.FontName.galMuri11Bold, size: 12))
            .tint(Color.brandColor)
        } else {
            SocialLoginView()
        }
    }
}

#Preview {
    MainTabBarView()
}
