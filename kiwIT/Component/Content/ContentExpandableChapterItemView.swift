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
                    .frame(width: Setup.Frame.contentListItmeWidth, height: Setup.Frame.contentListItemHeight)
                    .offset(CGSize(width: Setup.Frame.contentListShadowWidthOffset, height: Setup.Frame.contentListShadowHeightOffset))
                HStack {
                    Text(itemTitle)
                        .font(.custom(Setup.FontName.phuduSemiBold, size: 18))
                        .foregroundStyle(Color.textColor)
                    Spacer()
                    withAnimation(.easeInOut) {
                        Image(systemName: self.isCollapsed ?
                              Setup.ImageStrings.collapsedTriangle
                              : Setup.ImageStrings.expandedTriangle)
                        .tint(Color.textColor)
                    }
                }
                .frame(width: Setup.Frame.contentListItmeWidth, height: Setup.Frame.contentListItemHeight)
                .background(Color.surfaceColor)
                .offset(CGSize(width: Setup.Frame.contentListItemWidthOffset, height: Setup.Frame.contentListItemHeightOffset))
            }
            .padding(.horizontal, 10)
            .onTapGesture {
                self.isCollapsed.toggle()
            }
            
            self.contentView()
                .frame(width: Setup.Frame.contentListItmeWidth,
                       height: isCollapsed ? .zero : Setup.Frame.contentListItemHeight)
        }
        .padding(.bottom, 10)
    }
}
