//
//  SignInMainImageView.swift
//  kiwIT
//
//  Created by Heedon on 7/26/24.
//

import SwiftUI

struct SignInMainImageView: View {
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .fill(Color.shadowColor)
                .frame(width: Setup.Frame.contentListItemWidth, height: Setup.Frame.contentListItemWidth)
                .offset(CGSize(width: 6, height: 6))
            Image(Setup.ImageStrings.signInImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: Setup.Frame.contentListItemWidth, height: Setup.Frame.contentListItemWidth)
            .offset(CGSize(width: -6, height: -6))
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 10)
    }
}

#Preview {
    SignInMainImageView()
}
