//
//  QuizOXButtonLabel.swift
//  kiwIT
//
//  Created by Heedon on 5/13/24.
//

import SwiftUI

struct QuizOXButtonLabel: View {
    
    var buttonLabel: String
    
    var body: some View {
        Text(buttonLabel)
            .font(.custom(Setup.FontName.phuduSemiBold, size: 20))
            .foregroundStyle(Color.textColor)
            .frame(width: Setup.Frame.quizContentOXButtonWidth, height: Setup.Frame.quizContentOXButtonHeight)
            .border(Color.textColor)
    }
}

#Preview {
    QuizOXButtonLabel(buttonLabel: "O")
}
