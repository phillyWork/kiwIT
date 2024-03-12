//
//  LectureView.swift
//  kiwIT
//
//  Created by Heedon on 3/11/24.
//

import SwiftUI

struct LectureView: View {
    var body: some View {
        Text("LectureView")
            
        
        //searchbar 대신 toggle이나 다른 버튼으로 레벨별/카테고리별 보여주도록 설정
        
            //Level --> Chapter
        //Chapter에서 Toggle로 SEction까지 보여주도록 설정
        
        
            .tabItem {
                Label("학습", systemImage: Setup.ImageStrings.defaultLecture)
            }
        
        
        //콘텐츠 학습 완료: 스크롤 맨 마지막 버튼에서 학습 완료되었다고 버튼 눌러야 확인 완료
        
        
    }
}

#Preview {
    LectureView()
}
