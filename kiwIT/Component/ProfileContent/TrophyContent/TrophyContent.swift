//
//  Trophy.swift
//  kiwIT
//
//  Created by Heedon on 6/5/24.
//

import SwiftUI

struct TrophyContent: View {
    
//    var acquiredTrophyData: AcquiredTrophy
    
//    var trophyData: TrophyEntity
    
    var tempTrophyTitle: String
    var tempTrophyExplanation: String
    var tempImageUrlString: String
    var achievedDate: String?

    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .fill(achievedDate != nil ? Color.shadowColor : .clear)
                .frame(width: Setup.Frame.trophyContentWidth, height: Setup.Frame.trophyContentHeight)
                .offset(CGSize(width: Setup.Frame.contentListShadowWidthOffset, height: Setup.Frame.contentListShadowHeightOffset))
            HStack {
                AsyncImage(url: URL(string: tempImageUrlString)) { image in
                    //ViewModel에서 변환 처리?
                    
                    //                let renderer = ImageRenderer(content: image)
                    //                if let uiImage = renderer.uiImage {
                    //                    self.imageForExpandable = uiImage
                    //                }
                    
                    image.resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: Setup.Frame.trophyContentHeight, height: Setup.Frame.trophyContentHeight)
                .grayscale(achievedDate != nil ? 0.0 : 1.0)
                
                VStack {
                    Text(tempTrophyTitle)
                    Text(tempTrophyExplanation)
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
        TrophyContent(tempTrophyTitle: "지금까지 수고한 당신, 최고에요!", tempTrophyExplanation: "누적 학습시간 100시간 돌파", tempImageUrlString: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQHZCbqRAGGwuZYEDajBgZx1zUgTdqBwfwVZw&s", achievedDate: "2024-02-11")
        TrophyContent(tempTrophyTitle: "이정도로 해낼 줄이야!", tempTrophyExplanation: "누적 학습시간 300시간 돌파", tempImageUrlString: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQHZCbqRAGGwuZYEDajBgZx1zUgTdqBwfwVZw&s")
    }
}
