//
//  EachInterviewContent.swift
//  kiwIT
//
//  Created by Heedon on 7/21/24.
//

import SwiftUI

struct PastInterviewListContent: View {
    
    var pastInterview: InterviewRoomPayload
    
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
                    Text(pastInterview.creationCompactDate)
                        .font(.custom(Setup.FontName.galMuri11Bold, size: 15))
                }
                .overlay {
                    Text("채점: \(pastInterview.score)")
                        .font(.custom(Setup.FontName.notoSansRegular, size: 12))
                        .offset(CGSize(width: Setup.Frame.pastInterviewAnswerListScoreWidthOffset, height: Setup.Frame.pastInterviewAnswerListScoreHeightOffset))
                }
                .offset(CGSize(width: -4, height: -4))
        }
    }
}

#Preview {
    PastInterviewListContent(pastInterview: InterviewRoomPayload(id: 2, score: 20, createdAt: "2022-03-21", updatedAt: "2023-03-02"))
}
