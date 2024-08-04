//
//  EachInterviewContent.swift
//  kiwIT
//
//  Created by Heedon on 7/21/24.
//

import SwiftUI

struct PastInterviewListContent: View {
    
    //var pastInterviewHistory: PastInterviewHistory
    
    var body: some View {
        ZStack {
            EquilateralTrapezoid(ratioForHorizonLength: 0.75)
                .fill(Color.backgroundColor)
                .frame(width: Setup.Frame.contentListItemWidth, height: Setup.Frame.contentListCategoryItemHeight)
                .offset(CGSize(width: 4, height: 4))
            EquilateralTrapezoid(ratioForHorizonLength: 0.75)
                .fill(Color.surfaceColor)
                .frame(width: Setup.Frame.contentListItemWidth, height: Setup.Frame.contentListCategoryItemHeight)
                .overlay {
                    Text("Hi")
                }
                .offset(CGSize(width: -4, height: -4))
        }
    }
}

#Preview {
    PastInterviewListContent()
}
