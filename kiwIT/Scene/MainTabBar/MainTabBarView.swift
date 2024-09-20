//
//  ContentView.swift
//  kiwIT
//
//  Created by Heedon on 3/10/24.
//

import SwiftUI

struct MainTabBarView: View {
    
    //로그아웃 및 회원탈퇴 시에, 다시 로그인 화면 띄워야 함으로, root level에서 계속 체크하고 있기
    @StateObject var mainTabBarVM = MainTabBarViewModel()
    
    var body: some View {
        //로그인 여부 체크
        if (mainTabBarVM.isUserLoggedIn) {
            LazyView(TabViews(mainTabBarVM: mainTabBarVM))
        } else {
            LazyView(SocialLoginView(mainTabBarVM: mainTabBarVM))
        }
    }
}

#Preview {
    MainTabBarView()
}
