//
//  ContentListItem.swift
//  kiwIT
//
//  Created by Heedon on 4/11/24.
//

import SwiftUI

struct ContentListItemView: View {

    var itemTitle: String
    
    @State private var tapped = false
    
    init(title: String) {
        self.itemTitle = title
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .fill(Color.shadowColor)
                .frame(width: Setup.Frame.contentListItmeWidth, height: Setup.Frame.contentListItemHeight)
                .offset(CGSize(width: Setup.Frame.contentListShadowWidthOffset, height: Setup.Frame.contentListShadowHeightOffset))
            HStack {
                //해당 Category 어울리는 이미지 파일 필요
                Image(systemName: Setup.ImageStrings.defaultLecture2)
                    .tint(Color.textColor)
                Text(itemTitle)
                    .font(.custom(Setup.FontName.galMuri11Bold, size: 18))
                    .foregroundStyle(Color.textColor)
            }
            .frame(width: Setup.Frame.contentListItmeWidth, height: Setup.Frame.contentListItemHeight)
            .background(Color.surfaceColor)
            .offset(CGSize(width: Setup.Frame.contentListItemWidthOffset, height: Setup.Frame.contentListItemHeightOffset))
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 10)
    }
}

#Preview {
    ContentListItemView(title: "확인")
}
