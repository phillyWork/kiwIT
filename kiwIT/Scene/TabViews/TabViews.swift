//
//  TabViews.swift
//  kiwIT
//
//  Created by Heedon on 6/13/24.
//

import SwiftUI

struct TabViews: View {
    
//    @StateObject var tabViewsVM: TabViewsViewModel
    @StateObject var tabViewsVM = TabViewsViewModel()
    @ObservedObject var mainTabBarVM: MainTabBarViewModel
    
//    init(tabViewsVM: TabViewsViewModel, mainTabBarVM: MainTabBarViewModel) {
//        //MARK: - view init 시점 이후에 변하지 않을 값을 넘길 때에나 의미가 있다.
//        //MARK: - 상위 view의 property가 변하더라도 하위 뷰는 알 방법이 없다.
//        self._tabViewsVM = StateObject(wrappedValue: TabViewsViewModel(mainTabBarVM.userProfileData))
//        self.mainTabBarVM = mainTabBarVM
//    }
    
//    init(mainTabBarVM: MainTabBarViewModel) {
//        self.mainTabBarVM = mainTabBarVM
//        tabViewsVM.checkProfile(with: mainTabBarVM.userProfileData)
//    }
    
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
//        .onChange(of: tabViewsVM.didUpdateProfileFromOtherView, { newValue in
//            if newValue {
//                
//            }
//        })
        .onAppear {
            tabViewsVM.checkProfile(with: mainTabBarVM.userProfileData)
        }
        .onReceive(tabViewsVM.$isTokenAvailable) { isAvailable in
            print("is available? -- \(isAvailable)")
            mainTabBarVM.isUserLoggedIn = isAvailable
        }
    }
}

#Preview {
//    TabViews(tabViewsVM: TabViewsViewModel(MainTabBarViewModel().userProfileData), mainTabBarVM: MainTabBarViewModel())
    TabViews(mainTabBarVM: MainTabBarViewModel())
}
