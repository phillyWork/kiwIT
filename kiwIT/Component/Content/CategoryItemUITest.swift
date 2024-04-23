//
//  CategoryItemUITest.swift
//  kiwIT
//
//  Created by Heedon on 4/18/24.
//

import SwiftUI

struct CategoryItemUITest: View {
    
    var itemTitle: String
    var ratioForTrapezoidWidth: CGFloat
    
    @State private var isTapped: Bool = false
    
    init(title: String, ratio: CGFloat) {
        self.itemTitle = title
        self.ratioForTrapezoidWidth = ratio
    }
    
    var body: some View {
        ZStack(alignment: .center) {
            EquilateralTrapezoid(ratioForHorizonLength: ratioForTrapezoidWidth)
                .fill(Color.shadowColor)
                .frame(width: Setup.Frame.contentListItemWidth, height: Setup.Frame.contentListCategoryItemHeight)
                .offset(CGSize(width: Setup.Frame.contentShadowTrapezoidWidthOffset, height: Setup.Frame.contentShadowTrapezoidHeightOffset))
            
            EquilateralTrapezoid(ratioForHorizonLength: ratioForTrapezoidWidth)
                .fill(Color.surfaceColor)
                .frame(width: Setup.Frame.contentListItemWidth, height: Setup.Frame.contentListCategoryItemHeight)
                .overlay {
                    HStack(alignment: .center) {
                        //해당 Category 어울리는 이미지 파일 필요
                        Image(systemName: Setup.ImageStrings.defaultLecture2)
                            .tint(Color.textColor)
                            .border(Color.textColor)
                        Text(itemTitle)
                            .font(.custom(Setup.FontName.galMuri11Bold, size: 18))
                            .foregroundStyle(Color.textColor)
                    }
                    .offset(CGSize(width: Setup.Frame.contentCategoryTrapezoidWidthOffset, height: Setup.Frame.contentCategoryTrapezoidHeightOffset))
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
    CategoryItemUITest(title: "테스트", ratio: 0.75)
}
