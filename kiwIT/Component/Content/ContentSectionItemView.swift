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
            .font(.custom(Setup.FontName.phuduSemiBold, size: 14))
            .foregroundStyle(Color.textColor)
            .background(Color.surface.opacity(0.05))
            
    }
}
