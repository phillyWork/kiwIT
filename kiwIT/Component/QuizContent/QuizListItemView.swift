//
//  QuizListItem.swift
//  kiwIT
//
//  Created by Heedon on 5/4/24.
//

import SwiftUI

struct QuizListItem: View {
    
    var itemTitle: String
    var ratioForTrapezoidWidth: CGFloat
    var highestScore: Int
    var latestScore: Int
    
    init(title: String, ratio: CGFloat, highest: Int = 0, latest: Int = 0) {
        self.itemTitle = title
        self.ratioForTrapezoidWidth = ratio
        self.highestScore = highest
        self.latestScore = latest
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            EquilateralTrapezoid(ratioForHorizonLength: ratioForTrapezoidWidth)
                .fill(Color.shadowColor)
                .frame(width: Setup.Frame.quizContentListItemWidth, height: Setup.Frame.quizContentListItemHeight)
                .offset(CGSize(width: Setup.Frame.contentShadowTrapezoidWidthOffset, height: Setup.Frame.contentShadowTrapezoidHeightOffset))
            
            EquilateralTrapezoid(ratioForHorizonLength: ratioForTrapezoidWidth)
                .fill(Color.surfaceColor)
                .frame(width: Setup.Frame.quizContentListItemWidth, height: Setup.Frame.quizContentListItemHeight)
                .overlay {
                    VStack(spacing: 20) {
                        Text(itemTitle)
                            .font(.custom(Setup.FontName.galMuri11Bold, size: 18))
                            .foregroundStyle(Color.textColor)
                        HStack {
                            Text("최고점: \(highestScore)점")
                                .font(.custom(Setup.FontName.galMuri11Bold, size: 18))
                                .foregroundStyle(Color.textColor)
                            Divider()
                                .frame(minWidth: 1.5)
                                .background(Color.textColor)
                            Text("최근: \(latestScore)점")
                                .font(.custom(Setup.FontName.galMuri11Bold, size: 18))
                                .foregroundStyle(Color.textColor)
                        }
                        .frame(height: 25)
                    }
                    //                        .offset(CGSize(width: Setup.Frame.contentCategoryTrapezoidWidthOffset, height: Setup.Frame.contentCategoryTrapezoidHeightOffset))
                }
            
            //학습 완료 보여주기 설정
            //            EquilateralTrapezoid(ratioForHorizonLength: ratioForTrapezoidWidth)
            //                .fill(.clear)
            //                .frame(width: Setup.Frame.contentListCategoryCompleteImageWidth, height: Setup.Frame.contentListCategoryCompleteImageHeight)
            //                .overlay {
            //                    Image(systemName: Setup.ImageStrings.defaultHome)
            //                    //학습 완료 나타날 것 보여줄 지 말지 설정 필요
            //                        .foregroundStyle(Color.red)
            //                }
            //                .offset(CGSize(width: Setup.Frame.contentCategoryTrapezoidCompleteWidthOffset, height: Setup.Frame.contentCategoryTrapezoidCompleteHeightOffset))
            
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 5)
    }
}

#Preview {
    QuizListItem(title: "Quiz Test", ratio: 0.9)
}
