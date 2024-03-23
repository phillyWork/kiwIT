//
//  ContentTextView.swift
//  kiwIT
//
//  Created by Heedon on 3/20/24.
//

import SwiftUI

struct ContentTextView: View {
    
    var context: String
    
    var body: some View {
        Text(context)
            .padding()
            .frame(maxWidth: .infinity)
    }
}

#Preview {
    ContentTextView(context: "Hi there, it's me, Mario!!!!\n\n\n HI Hello!!!")
}
