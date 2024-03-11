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
            .tabItem {
                Label("학습", systemImage: Setup.ImageStrings.defaultLecture)
            }
    }
}

#Preview {
    LectureView()
}
