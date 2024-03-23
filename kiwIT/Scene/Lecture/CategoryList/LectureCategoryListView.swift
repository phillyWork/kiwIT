//
//  LectureCategoryListView.swift
//  kiwIT
//
//  Created by Heedon on 3/19/24.
//

import SwiftUI

struct LectureCategoryListView: View {
    var body: some View {
        
        //searchbar 대신 toggle이나 다른 버튼으로 레벨별/카테고리별 보여주도록 설정
        
        NavigationStack {
            List(0..<100) { row in
                NavigationLink {
                    LectureListView()
                } label: {
                    Text("IT 교양")
                }
            }
            .navigationTitle("학습 카테고리")
            .navigationBarTitleDisplayMode(.inline)
        }
        .tabItem {
            Label("학습", systemImage: Setup.ImageStrings.defaultLecture)
        }
    }
}

#Preview {
    LectureCategoryListView()
}
