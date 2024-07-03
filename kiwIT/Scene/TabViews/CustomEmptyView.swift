//
//  EmptyView.swift
//  kiwIT
//
//  Created by Heedon on 6/26/24.
//

import SwiftUI

struct CustomEmptyView: View {
    var body: some View {
        Text("Empty Result!!!")
            .foregroundStyle(Color.textColor)
            .background(Color.backgroundColor)
    }
}

#Preview {
    CustomEmptyView()
}
