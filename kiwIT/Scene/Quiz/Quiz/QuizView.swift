//
//  QuizView.swift
//  kiwIT
//
//  Created by Heedon on 5/4/24.
//

import SwiftUI

struct QuizView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack {
                ScrollView {
                    Text("Test")
                }
                .frame(maxWidth: .infinity)
            }
            .background(Color.backgroundColor)
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .principal) {
                Text("Quiz Title")
                    .font(.custom(Setup.FontName.phuduBold, size: 20))
            }
            ToolbarItem(placement: .topBarLeading) {
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: Setup.ImageStrings.defaultXMark2)
                })
                .tint(Color.textColor)
            }
        }
    }
}

#Preview {
    QuizView()
}
