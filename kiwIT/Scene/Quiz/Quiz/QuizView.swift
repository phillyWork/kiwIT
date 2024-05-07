//
//  QuizView.swift
//  kiwIT
//
//  Created by Heedon on 5/4/24.
//

import SwiftUI

struct QuizView: View {
    
    @Environment(\.dismiss) var dismiss
    
    let testData = ["1입니다", "2입니다", "3입니다", "4입니다", "5입니다"]
    
    //차후 quiz payload 받아서 하나씩 나타내기
    //답변 한 만큼 새롭게 나타나도록 하기 (개수 count 필요)
    
    @State private var itemIndex = 0
    
    var body: some View {
        NavigationStack {
            ScrollView {
                QuizContentItem(content: testData[itemIndex])
            }
            .frame(maxWidth: .infinity)
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
