//
//  HomeView.swift
//  kiwIT
//
//  Created by Heedon on 3/11/24.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var homeVM = HomeViewModel()
    @ObservedObject var tabViewsVM: TabViewsViewModel
        
    var body: some View {
        NavigationStack {
            ScrollView {
                
                //MARK: - 유저 닉네임 및 환영 문구 작성...
                
                //MARK: - 다음 학습할 진도 내용만 보여주기 --> 학습하기 버튼 탭: 학습 탭으로 이동하기
               
                //MARK: - 카테고리 내 자동 선택 및 해당 학습 컨텐츠 보여주기 가능?
                
                //MARK: - 가장 최근 퀴즈 결과 --> 퀴즈 풀기 버튼 탭: 퀴즈 탭으로 이동하기
                
                VStack {
                    VStack {
                        Text("Profile Data id: \(tabViewsVM.profileData?.id)")
                        Text("Profile Data nickname: \(tabViewsVM.profileData?.nickname)")
                        Text("Profile Data email: \(tabViewsVM.profileData?.email)")
                    }
                    .frame(width: Setup.Frame.shrinkAnimationButtonWidth, height: Setup.Frame.shrinkAnimationButtonHeight)
                    .background(Color.green)
                    .onTapGesture {
                        print("Move to Lecture Content")
                    }
                                        
                    Spacer(minLength: 50)
                    
                    VStack {
                        Text("Quiz")
                        Text("최근 Quiz 점수 내역")
                    }
                    .background(Color.pink)
                    
                    Spacer(minLength: 50)
                    
                    
                }
                //Navigation title 외에 다른 표시 방법 찾기 필요
                .frame(maxHeight: .infinity)
                .frame(width: Setup.Frame.devicePortraitWidth)
                .navigationTitle(Setup.ContentStrings.appTitle)
                .navigationBarTitleDisplayMode(.large)
            }
            .scrollIndicators(.hidden)
            .background(Color.backgroundColor)
            .toolbarBackground(Color.backgroundColor, for: .navigationBar, .tabBar)
        }
        .alert("네트워크 오류!", isPresented: $homeVM.showUnknownNetworkErrorAlert, actions: {
            ErrorAlertConfirmButton { }
        }, message: {
            Text("네트워크 요청에 실패했습니다! 다시 시도해주세요!")
        })
        .onAppear {
            homeVM.checkProfile(with: tabViewsVM.profileData)
        }
    }
}

#Preview {
    HomeView(tabViewsVM: TabViewsViewModel())
}
