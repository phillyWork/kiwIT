//
//  QuizView.swift
//  kiwIT
//
//  Created by Heedon on 3/11/24.
//

import SwiftUI

struct QuizView: View {
    var body: some View {
        Text("QuizView")
            .tabItem {
                Label("퀴즈", systemImage: Setup.ImageStrings.defaultQuiz)
            }
    }
}

#Preview {
    QuizView()
}
