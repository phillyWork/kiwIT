//
//  CompletedContent.swift
//  kiwIT
//
//  Created by Heedon on 7/5/24.
//

import SwiftUI

struct CompletedLectureContent: View {
    
    var lecture: CompletedOrBookmarkedLecture
    var action: () -> Void
    
    init(_ lecture: CompletedOrBookmarkedLecture, tapAction: @escaping () -> Void) {
        self.lecture = lecture
        self.action = tapAction
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.shadowColor)
                .frame(width: Setup.Frame.profileLectureContentWidth, height: Setup.Frame.profileLectureContentHeight)
                .offset(CGSize(width: 4.0, height: 4.0))
            Button {
                self.action()
            } label: {
                Text(lecture.title)
                    .font(.custom(Setup.FontName.galMuri11Bold, size: 20))
                    .foregroundStyle(Color.brandColor)
                    .frame(width: Setup.Frame.profileLectureContentWidth, height: Setup.Frame.profileLectureContentHeight)
                    .overlay {
                        HStack {
                            Text(Setup.ContentStrings.level + "\(lecture.levelNum)")
                                .font(.custom(Setup.FontName.lineBold, size: 12))
                                .foregroundStyle(Color.textColor)
                            Spacer()
                        }
                        .padding(.horizontal, 8)
                        .offset(CGSize(width: 0, height: Setup.Frame.profileLectureContentOverlayTextHeightOffset))
                    }
            }
            .background(Color.surfaceColor)
            .frame(width: Setup.Frame.profileLectureContentWidth, height: Setup.Frame.profileLectureContentHeight)
            .offset(CGSize(width: -4.0, height: -4.0))
            
        }
    }
}
