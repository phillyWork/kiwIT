//
//  LectureView.swift
//  kiwIT
//
//  Created by Heedon on 3/11/24.
//

import SwiftUI

struct LectureListView: View {
    var body: some View {
    
        //Chapter에서 Toggle로 Section까지 보여주도록 설정
     
        NavigationStack {
            List(0..<100) { row in
                NavigationLink {
                    LectureView()
                } label: {
                    Text("Chapter \(row). 모두 컴퓨터에요")
                }
            }
            .navigationTitle("IT 교양")
            .navigationBarTitleDisplayMode(.inline)
        }
        
    }
}

#Preview {
    LectureListView()
}
