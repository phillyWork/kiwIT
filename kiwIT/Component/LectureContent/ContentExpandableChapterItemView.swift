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
    
    //외부에서 계속해서 선택 여부 Update 필요해 보임
    //다른 chapter 선택 시, 자동으로 닫히도록
    //빈 배경 선택 시, 자동으로 닫히도록
    @State private var isCollapsed: Bool = true
    
    init(itemTitle: String, content: @escaping () -> Content) {
        self.itemTitle = itemTitle
        self.contentView = content
    }
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .center) {
                Rectangle()
                    .fill(isCollapsed ? Color.shadowColor : Color.brandTint)
                    .frame(width: Setup.Frame.contentListItemWidth, height: Setup.Frame.contentListChapterItemHeight)
                    .offset(CGSize(width: Setup.Frame.contentListShadowWidthOffset, height: Setup.Frame.contentListShadowHeightOffset))
                HStack {
                    Text(itemTitle)
                        .font(.custom(Setup.FontName.phuduSemiBold, size: 18))
                        .foregroundStyle(isCollapsed ? Color.textColor : .black)
                    Spacer()
                    Image(systemName: self.isCollapsed ?
                          Setup.ImageStrings.collapsedTriangle
                          : Setup.ImageStrings.expandedTriangle)
                    .foregroundStyle(self.isCollapsed ? Color.textColor : .black)
                }
                .scaleEffect(isCollapsed ? 1.0 : 0.87)
                .frame(width: Setup.Frame.contentListItemWidth,
                       height: Setup.Frame.contentListChapterItemHeight)
                .background(isCollapsed ? Color.surfaceColor : Color.brandBland2)
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
