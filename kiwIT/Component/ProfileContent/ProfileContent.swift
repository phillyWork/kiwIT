//
//  ProfileLectureContent.swift
//  kiwIT
//
//  Created by Heedon on 7/10/24.
//

import SwiftUI

struct ProfileContent: View {
    
    var title: String
    var overlayTitle: String
    
    init(_ title: String, overlayTitle: String) {
        self.title = title
        self.overlayTitle = overlayTitle
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.shadowColor)
                .frame(width: Setup.Frame.contentListItemWidth, height: Setup.Frame.profileContentHeight)
                .offset(CGSize(width: 4.0, height: 4.0))
            Text(title)
                .font(.custom(Setup.FontName.galMuri11Bold, size: 20))
                .foregroundStyle(Color.brandColor)
                .frame(width: Setup.Frame.contentListItemWidth, height: Setup.Frame.profileContentHeight)
                .background(Color.surfaceColor)
                .offset(CGSize(width: -4.0, height: -4.0))
                .overlay {
                    HStack {
                        Text(overlayTitle)
                            .font(.custom(Setup.FontName.lineBold, size: 12))
                            .foregroundStyle(Color.textColor)
                        Spacer()
                    }
                    .padding(.horizontal, 8)
                    .offset(CGSize(width: 0, height: Setup.Frame.profileLectureContentOverlayTextHeightOffset))
                }
        }
        .padding(.vertical, 8)
    }
}

#Preview {
    ProfileContent("test", overlayTitle: "학습 완료:")
}
