//
//  ContentListItem.swift
//  kiwIT
//
//  Created by Heedon on 4/11/24.
//

import SwiftUI

struct ContentCategoryItemView: View {

    var itemTitle: String
    
    init(title: String) {
        self.itemTitle = title
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .fill(Color.shadowColor)
                .frame(width: Setup.Frame.contentListItemWidth, height: Setup.Frame.contentListCategoryItemHeight)
                .offset(CGSize(width: Setup.Frame.contentListShadowWidthOffset, height: Setup.Frame.contentListShadowHeightOffset))
            HStack {
                //해당 Category 어울리는 이미지 파일 필요
                Image(systemName: Setup.ImageStrings.defaultLecture2)
                    .tint(Color.textColor)
//                    .frame(width: Setup.Frame.contentListCategoryImageWidth, height: Setup.Frame.contentListCategoryImageHeight)
                    .border(Color.textColor)
                Text(itemTitle)
                    .font(.custom(Setup.FontName.galMuri11Bold, size: 18))
                    .foregroundStyle(Color.textColor)
            }
            .frame(width: Setup.Frame.contentListItemWidth, height: Setup.Frame.contentListCategoryItemHeight)
            .background(Color.surfaceColor)
            .offset(CGSize(width: Setup.Frame.contentListItemWidthOffset, height: Setup.Frame.contentListItemHeightOffset))
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 10)
    }
}

#Preview {
    ContentCategoryItemView(title: "확인")
}
