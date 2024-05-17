//
//  QuizView.swift
//  kiwIT
//
//  Created by Heedon on 3/11/24.
//

import SwiftUI

struct QuizListView: View {
    
    //option 버튼으로 북마크 기능 추가 필요
    
    var body: some View {
        
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 4) {
                    ForEach(1...50, id: \.self) { row in
                        NavigationLink {
                            QuizView()
                        } label: {
                            QuizListItem(title: "기본 Quiz", ratio: 0.85)
                        }
                    }
                    .frame(maxHeight: .infinity)
                }
                .frame(maxWidth: .infinity)
                .frame(width: Setup.Frame.devicePortraitWidth, alignment: .center)
            }
            .scrollIndicators(.hidden)
            .background(Color.backgroundColor)
            .navigationTitle("퀴즈")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.backgroundColor, for: .navigationBar, .tabBar)
        }
        .refreshable {
            print("Refresh to update Quiz Result!!!")
        }
    }
}

#Preview {
    QuizListView()
}
