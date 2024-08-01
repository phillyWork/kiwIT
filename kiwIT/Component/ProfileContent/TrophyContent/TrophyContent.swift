//
//  Trophy.swift
//  kiwIT
//
//  Created by Heedon on 6/5/24.
//

import SwiftUI

struct TrophyContent: View {
    
    var trophy: TrophyEntity
    var achievedDate: String?
    
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .fill(Color.shadowColor)
                .frame(width: Setup.Frame.trophyContentWidth, height: Setup.Frame.trophyContentHeight)
                .offset(CGSize(width: Setup.Frame.contentListShadowWidthOffset, height: Setup.Frame.contentListShadowHeightOffset))
            HStack {
                AsyncImage(url: URL(string: trophy.imageUrl)) { image in
                    image.resizable()
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: Setup.Frame.trophyContentHeight, height: Setup.Frame.trophyContentHeight)
                .grayscale(achievedDate != nil ? 0.0 : 1.0)
                
                VStack {
                    Text(trophy.title)
                    Text("\(trophy.type.description): \(trophy.threshold)")
                        .font(.custom(Setup.FontName.notoSansMedium, size: 12))
                    if let date = achievedDate {
                        Text("획득 날짜: \(date)")
                            .font(.custom(Setup.FontName.lineRegular, size: 12))
                            .padding(.vertical, 10)
                    }
                }
                .foregroundStyle(achievedDate != nil ? Color.black : Color.textColor)
                .frame(maxWidth: .infinity)
            }
            .frame(width: Setup.Frame.trophyContentWidth, height: Setup.Frame.trophyContentHeight)
            .background(achievedDate != nil ? Color.brandBlandColor : Color.surfaceColor)
            .offset(CGSize(width: Setup.Frame.contentListItemWidthOffset, height: Setup.Frame.contentListItemHeightOffset))
        }
    }
}

#Preview {
    VStack {
        TrophyContent(trophy: TrophyEntity(id: 12, title: "지금까지 수고한 당신, 최고에요!", imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQHZCbqRAGGwuZYEDajBgZx1zUgTdqBwfwVZw&s", type: .totalContentStudied, threshold: 100), achievedDate: "2024-02-11")
        TrophyContent(trophy: TrophyEntity(id: 14, title: "이정도로 해낼 줄이야!", imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQHZCbqRAGGwuZYEDajBgZx1zUgTdqBwfwVZw&s", type: .totalContentStudied, threshold: 300))
    }
}
