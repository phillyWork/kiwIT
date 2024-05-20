//
//  ContentSectionTItleView.swift
//  kiwIT
//
//  Created by Heedon on 4/11/24.
//

import SwiftUI

struct ContentSectionTitleView: View {
    
    var title: String
    
    var body: some View {
        Text(title)
            .padding()
            .frame(maxWidth: .infinity)
            .font(.custom(Setup.FontName.galMuri11Bold, size: 28))
//            .font(.custom(Setup.FontName.lineThin, size: 40))
            .foregroundStyle(Color.textColor)
    }
}

#Preview {
    ContentSectionTitleView(title: "Hello, There!")
}
