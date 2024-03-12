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
                        Image(systemName: Setup.ImageStrings.selectedLecture)
                        Text("다음에 학습할 내용")
                    }
                    .frame(width: Setup.Frame.nextContentButtonWidth, height: Setup.Frame.nextContentButtonHeight)
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
                    
                    
                }
                //Navigation title 외에 다른 표시 방법 찾기 필요
                .frame(maxHeight: .infinity)
                .navigationTitle("kiwIT")
                .navigationBarTitleDisplayMode(.large)
            }
            .scrollIndicators(.hidden)
        }
        .tabItem {
            Label("홈", systemImage: Setup.ImageStrings.defaultHome)
        }
        
    }
}

#Preview {
    HomeView()
}
