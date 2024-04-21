//
//  ContentSectionView.swift
//  kiwIT
//
//  Created by Heedon on 4/17/24.
//

import SwiftUI

struct ContentSectionItemView: View {
    
    @State var label: () -> Text
    
    var body: some View {
        self.label()
            .lineLimit(2)
            .font(.custom(Setup.FontName.phuduSemiBold, size: 14))
            .foregroundStyle(Color.white)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.horizontal, 10)
    }
}

#Preview {
    ContentSectionItemView {
        Text("Example")
    }
}
