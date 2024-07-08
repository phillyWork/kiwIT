//
//  EmptyViewWithRetryButton.swift
//  kiwIT
//
//  Created by Heedon on 7/5/24.
//

import SwiftUI

struct EmptyViewWithRetryButton: View {
    
    var action: () -> ()
    
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .fill(Color.shadowColor)
                .frame(width: Setup.Frame.contentListItemWidth, height: Setup.Frame.contentListNotExpandableHeight)
                .offset(CGSize(width: Setup.Frame.contentListShadowWidthOffset, height: Setup.Frame.contentListShadowHeightOffset))
            Button {
                action()
            } label: {
                VStack {
                    Image(systemName: Setup.ImageStrings.retryAction)
                        .foregroundStyle(Color.errorHighlightColor)
                        .padding()
                    Text("다시 시도하기")
                        .font(.custom(Setup.FontName.galMuri11Bold, size: 18))
                        .foregroundStyle(Color.textColor)
                }
                .frame(width: Setup.Frame.contentListItemWidth, height: Setup.Frame.contentListNotExpandableHeight)
            }
            .background(Color.surfaceColor)
            .offset(CGSize(width: Setup.Frame.contentListItemWidthOffset, height: Setup.Frame.contentListItemHeightOffset))
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 10)
    }
}

#Preview {
    EmptyViewWithRetryButton {
        print("Action")
    }
}
