//
//  ContentTextView.swift
//  kiwIT
//
//  Created by Heedon on 3/20/24.
//

import SwiftUI

struct ContentTextView: View {
    
    var context: String
    var fontSize: CGFloat
    
    var body: some View {
        Text(context)
            .padding()
            .frame(maxWidth: .infinity)
//            .font(.custom(Setup.FontName.notoSansMedium, size: 12))
            .font(.custom(Setup.FontName.notoSansMedium, size: fontSize))
            .foregroundStyle(Color.textColor)
    }
}

#Preview {
    ContentTextView(context: "Hi there, it's me, Mario!!!!\n\n\n HI Hello!!!", fontSize: 14)
}
