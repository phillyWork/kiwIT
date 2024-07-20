//
//  InterviewContent.swift
//  kiwIT
//
//  Created by Heedon on 7/21/24.
//

import SwiftUI

struct InterviewListContent: View {
    
    //MARK: - Interview data
    
    //var interview: InterviewListContent
    
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .fill(Color.shadowColor)
                .frame(width: Setup.Frame.contentListItemWidth, height: Setup.Frame.contentListNotExpandableHeight)
                .offset(CGSize(width: Setup.Frame.contentListShadowWidthOffset, height: Setup.Frame.contentListShadowHeightOffset))
            Text("Title to show hisdfsdf hi hi hsdfsdfi hi hi hi sdfsdsdfsdffsdfhi hi hsdfsdfi hi sdfsdfshi hihi hi hi hi hi")
                .font(.custom(Setup.FontName.galMuri11Bold, size: 20))
                .foregroundStyle(Color.textColor)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .background(Color.red)
                .padding(.leading, 5)
                .frame(width: Setup.Frame.contentListItemWidth, height: Setup.Frame.contentListNotExpandableHeight, alignment: .leading)
                .background(Color.surfaceColor)
                .overlay {
                    VStack(alignment: .leading) {
                        Text("문항 수: 20")
                            .font(.custom(Setup.FontName.notoSansLight, size: 12))
                        Text("생성: 2024-07-20")
                            .font(.custom(Setup.FontName.notoSansLight, size: 12))
                    }
                    .background(Color.purple)
                    .offset(CGSize(width: Setup.Frame.contentImageWidth/3, height: Setup.Frame.contentListNotExpandableHeight/3))
                }
                .offset(CGSize(width: Setup.Frame.contentListItemWidthOffset, height: Setup.Frame.contentListItemHeightOffset))
            
        }
        .padding(10)
        .background(Color.yellow)
    }
}

#Preview {
    InterviewListContent()
}
