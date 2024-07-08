//
//  EmptyView.swift
//  kiwIT
//
//  Created by Heedon on 6/26/24.
//

import SwiftUI

struct WholeEmptyView: View {
    var body: some View {
        Text("Empty Result!!!")
            .foregroundStyle(Color.textColor)
            .background(Color.backgroundColor)
    }
}

#Preview {
    WholeEmptyView()
}
