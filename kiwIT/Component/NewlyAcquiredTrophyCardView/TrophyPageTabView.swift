//
//  TrophyPageTabView.swift
//  kiwIT
//
//  Created by Heedon on 7/24/24.
//

import SwiftUI

struct TrophyPageTabView: View {
    
    var trophyList: [TrophyEntity]
    var buttonAction: () -> Void
    
    var body: some View {
        VStack {
            Spacer()
            ZStack {
                Rectangle()
                    .fill(Color.brandTintColor2)
                    .frame(width: Setup.Frame.contentImageWidth, height: Setup.Frame.recentlyAcquiredTrophyNotifyViewHeight)
                    .offset(CGSize(width: 4, height: 4))
                Text("새로운 트로피를 획득했어요")
                    .font(.custom(Setup.FontName.galMuri11Bold, size: 15))
                    .foregroundStyle(Color.textColor)
                    .frame(width: Setup.Frame.contentImageWidth, height: Setup.Frame.recentlyAcquiredTrophyNotifyViewHeight)
                    .background(Color.surfaceColor)
                    .offset(CGSize(width: -4, height: -4))
            }
            TabView {
                ForEach(trophyList, id: \.self) { trophy in
                    NewlyAcquiredTrophyCardView(trophy: trophy)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .frame(height: Setup.Frame.devicePortraitHeight * 0.6)
            ShrinkAnimationButtonView(title: "닫기", font: Setup.FontName.galMuri11Bold, color: Color.brandTintColor2) {
                buttonAction()
            }
            Spacer()
        }
        .background(Color.black.opacity(0.65).ignoresSafeArea(edges: .all))
    }
}

#Preview {
    TrophyPageTabView(trophyList: [
        TrophyEntity(id: 22, title: "mock1", imageUrl: "https://", type: .totalContentStudied, threshold: 300),
        TrophyEntity(id: 23, title: "mock2", imageUrl: "https://cdn.logojoy.com/wp-content/uploads/20230801145608/Current-Google-logo-2015-2023-600x203.png", type: .chapterClear, threshold: 15)
    ]) {
        print("close button action")
    }
}
