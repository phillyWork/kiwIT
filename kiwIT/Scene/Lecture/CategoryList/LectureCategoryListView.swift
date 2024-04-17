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
            ScrollView {
                LazyVStack(spacing: 4) {
                    ForEach(1...50, id: \.self) { row in
                        NavigationLink {
                            LectureListView()
                        } label: {
                            ContentCategoryItemView(title: "IT 교양")
                        }
                    }
                    .frame(maxHeight: .infinity)
                }
                .frame(maxWidth: .infinity)
                .frame(width: Setup.Frame.devicePortraitWidth, alignment: .center)
            }
            .scrollIndicators(.hidden)
            .background(Color.backgroundColor)
            .navigationTitle("학습 카테고리")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    LectureCategoryListView()
}
