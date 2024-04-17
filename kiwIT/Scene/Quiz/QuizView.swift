//
//  QuizView.swift
//  kiwIT
//
//  Created by Heedon on 3/11/24.
//

import SwiftUI

struct QuizView: View {
    var body: some View {
        
        VStack {
            Text("QuizView")
        }
        .frame(maxHeight: .infinity)
        .frame(width: Setup.Frame.devicePortraitWidth)
        .background(Color.backgroundColor)
        
    }
}

#Preview {
    QuizView()
}
