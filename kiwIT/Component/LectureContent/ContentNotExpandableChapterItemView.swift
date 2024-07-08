//
//  ContentListItem.swift
//  kiwIT
//
//  Created by Heedon on 4/11/24.
//

import SwiftUI

struct ContentNotExpandableChapterItemView: View {

    var itemTitle: String
    
    init(title: String) {
        self.itemTitle = title
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .fill(Color.shadowColor)
                .frame(width: Setup.Frame.contentListItemWidth, height: Setup.Frame.contentListNotExpandableHeight)
                .offset(CGSize(width: Setup.Frame.contentListShadowWidthOffset, height: Setup.Frame.contentListShadowHeightOffset))
            HStack {
                Text(itemTitle)
                    .font(.custom(Setup.FontName.galMuri11Bold, size: 18))
                    .foregroundStyle(Color.textColor)
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
    ContentNotExpandableChapterItemView(title: Setup.ContentStrings.confirm)
}
