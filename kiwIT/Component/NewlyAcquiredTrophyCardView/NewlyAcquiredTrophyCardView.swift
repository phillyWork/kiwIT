//
//  TrophyCardView.swift
//  kiwIT
//
//  Created by Heedon on 7/24/24.
//

import SwiftUI

struct NewlyAcquiredTrophyCardView: View {
    
    //MARK: - 이미지 및 설명 작성, 사이즈 설정
    
    var trophy: TrophyEntity
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.brandTintColor2)
                .frame(width: Setup.Frame.contentImageWidth, height: Setup.Frame.recentlyAcquiredTrophyCardViewHeight)
                .offset(CGSize(width: 4, height: 4))
            VStack(spacing: 10) {
                AsyncImage(url: URL(string: trophy.imageUrl)) { image in
                    image.resizable()
                        .frame(width: Setup.Frame.recentlyAcquiredTrophyImageWidth, height: Setup.Frame.recentlyAcquiredTrophyImageHeight)
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
                Text(trophy.title)
                    .font(.custom(Setup.FontName.galMuri11Bold, size: 20))
                Text("\(trophy.type.description): \(trophy.threshold)")
                    .font(.custom(Setup.FontName.notoSansBold, size: 12))
            }
            .frame(width: Setup.Frame.contentImageWidth, height: Setup.Frame.devicePortraitHeight * 0.45)
            .background(Color.surfaceColor)
            .offset(CGSize(width: -4, height: -4))
        }
    }
}

#Preview {
    ScrollView {
        NewlyAcquiredTrophyCardView(trophy: TrophyEntity(id: 1, title: "mocktest", imageUrl: "https://", type: .chapterClear, threshold: 300))
        NewlyAcquiredTrophyCardView(trophy: TrophyEntity(id: 1, title: "mocktest", imageUrl: "https://cdn.logojoy.com/wp-content/uploads/20230801145608/Current-Google-logo-2015-2023-600x203.png", type: .chapterClear, threshold: 300))
    }
}
