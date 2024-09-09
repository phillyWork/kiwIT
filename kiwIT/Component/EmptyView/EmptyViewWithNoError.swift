//
//  EmptyViewWithNoError.swift
//  kiwIT
//
//  Created by Heedon on 7/6/24.
//

import SwiftUI

struct EmptyViewWithNoError: View {
    
    var title: String
    
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .fill(Color.shadowColor)
                .frame(width: Setup.Frame.contentListItemWidth, height: Setup.Frame.contentListNotExpandableHeight)
                .offset(CGSize(width: Setup.Frame.contentListShadowWidthOffset, height: Setup.Frame.contentListShadowHeightOffset))
            HStack {
                Text(Setup.ContentStrings.emptyResultExclamationTitle)
                    .font(.custom(Setup.FontName.galMuri11Bold, size: 18))
                    .foregroundStyle(Color.red)
                Text(title)
                    .font(.custom(Setup.FontName.galMuri11Bold, size: 18))
                    .foregroundStyle(Color.textColor)
                Text(Setup.ContentStrings.emptyResultExclamationTitle)
                    .font(.custom(Setup.FontName.galMuri11Bold, size: 18))
                    .foregroundStyle(Color.red)
            }
            .frame(width: Setup.Frame.contentListItemWidth, height: Setup.Frame.contentListNotExpandableHeight)
            .background(Color.surfaceColor)
            .offset(CGSize(width: Setup.Frame.contentListItemWidthOffset, height: Setup.Frame.contentListItemHeightOffset))
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 10)
    }
}

#Preview {
    EmptyViewWithNoError(title: "테스트")
}
