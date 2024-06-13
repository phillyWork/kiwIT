//
//  HomeView.swift
//  kiwIT
//
//  Created by Heedon on 3/11/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    VStack {
                        Image(systemName: Setup.ImageStrings.defaultLecture3)
                        Text("다음에 학습할 내용")
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
                    
                    ForEach(0..<5) { i in
                        Text("다시 학습해볼 컨텐츠 랜덤하게 보이기: \(i+1)번째")
                            .background(Color.blue)
                    }
                    
                    //가로 스크롤로 카테고리 별 컨텐츠 보여주기 가능하도록?
                 
                    //test for content tabbar color
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: Setup.Frame.contentImageWidth, height: Setup.Frame.contentImageHeight)
                    
                }
                //Navigation title 외에 다른 표시 방법 찾기 필요
                .frame(maxHeight: .infinity)
                .frame(width: Setup.Frame.devicePortraitWidth)
                .navigationTitle("kiwIT")
                .navigationBarTitleDisplayMode(.large)
            }
            .scrollIndicators(.hidden)
            .background(Color.backgroundColor)
            .toolbarBackground(Color.backgroundColor, for: .navigationBar, .tabBar)
        }
    }
}

#Preview {
    HomeView()
}
