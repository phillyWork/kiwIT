//
//  QuizMultipleChoiceButtonLabel.swift
//  kiwIT
//
//  Created by Heedon on 5/13/24.
//

import SwiftUI

struct QuizMultipleChoiceButtonLabel: View {
    
    var choiceLabel: String
    
    var body: some View {
        Text(choiceLabel)
            .font(.custom(Setup.FontName.phuduSemiBold, size: 20))
            .foregroundStyle(Color.textColor)
            .frame(width: Setup.Frame.quizContentMultipleChoiceButtonWidth,
                   height: Setup.Frame.quizContentMultipleChoiceButtonHeight)
            .border(Color.textColor)
    }
}
