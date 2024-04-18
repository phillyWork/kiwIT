//
//  ContentListExpandableItemView.swift
//  kiwIT
//
//  Created by Heedon on 4/12/24.
//

import SwiftUI

//버튼 눌러서 확장

struct ContentExpandableChapterItemView<Content: View>: View {
    
    var itemTitle: String
    
    @State var contentView: () -> Content
    
    @State private var isCollapsed: Bool = true
    
    init(itemTitle: String, content: @escaping () -> Content) {
        self.itemTitle = itemTitle
        self.contentView = content
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .center) {
                Rectangle()
                    .fill(Color.shadowColor)
                    .frame(width: Setup.Frame.contentListItemWidth, height: Setup.Frame.contentListChapterItemHeight)
                    .offset(CGSize(width: Setup.Frame.contentListShadowWidthOffset, height: Setup.Frame.contentListShadowHeightOffset))
                HStack {
                    Text(itemTitle)
                        .font(.custom(Setup.FontName.phuduSemiBold, size: 18))
                        .foregroundStyle(Color.textColor)
                    Spacer()
                    Image(systemName: self.isCollapsed ?
                          Setup.ImageStrings.collapsedTriangle
                          : Setup.ImageStrings.expandedTriangle)
                    .tint(Color.textColor)
                }
                .scaleEffect(isCollapsed ? 1.0 : 0.9)
                .frame(width: Setup.Frame.contentListItemWidth,
                       height: Setup.Frame.contentListChapterItemHeight)
                .background(Color.surfaceColor)
                .offset(CGSize(width: Setup.Frame.contentListItemWidthOffset, height: Setup.Frame.contentListItemHeightOffset))
            }
            .padding(.horizontal, 10)
            .onTapGesture {
                withAnimation {
                    self.isCollapsed.toggle()
                }
            }
    
            self.contentView()
                .frame(width: Setup.Frame.contentListItemWidth,
                       height: isCollapsed ? .zero : Setup.Frame.contentListChapterItemHeight)
        }
        .padding(.bottom, 10)
    }
}

#Preview {
    ContentExpandableChapterItemView(itemTitle: "테스트용 확인 목적") {
        Text("버튼 확인용")
            .background(Color.shadowColor)
            .frame(width: Setup.Frame.contentListItemWidth)
            .offset(CGSize(width: Setup.Frame.contentListShadowWidthOffset, height: 0))
    }
}
