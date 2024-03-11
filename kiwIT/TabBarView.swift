//
//  ContentView.swift
//  kiwIT
//
//  Created by Heedon on 3/10/24.
//

import SwiftUI

struct TabBarView: View {
    var body: some View {
        TabView {
            HomeView()
            LectureView()
            QuizView()
            AIInterviewView()
            ProfileView()
        }
        .tint(Color.purple)
    }
    
}

#Preview {
    TabBarView()
}
