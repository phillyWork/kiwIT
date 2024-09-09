//
//  NextLectureView.swift
//  kiwIT
//
//  Created by Heedon on 7/17/24.
//

import SwiftUI

struct NextLectureView: View {
    
    var nextLecture: LectureContentListPayload
    var studyAction: () -> Void
    
    var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .fill(Color.shadowColor)
                .frame(width: Setup.Frame.homeViewContentWidth, height: Setup.Frame.homeViewNextLectureHeight)
                .offset(CGSize(width: Setup.Frame.contentListShadowWidthOffset, height: Setup.Frame.contentListShadowHeightOffset))
            Text(nextLecture.title)
                .font(.custom(Setup.FontName.galMuri11Bold, size: 25))
                .foregroundStyle(Color.brandColor)
                .frame(width: Setup.Frame.homeViewContentWidth, height: Setup.Frame.homeViewNextLectureHeight)
                .background(Color.surfaceColor)
                .overlay {
                    HStack {
                        Text(Setup.ContentStrings.level + "\(nextLecture.levelNum)")
                            .font(.custom(Setup.FontName.lineBold, size: 12))
                            .foregroundStyle(Color.textColor)
                        Spacer()
                    }
                    .padding(.horizontal, 8)
                    .offset(CGSize(width: 0, height: Setup.Frame.homeViewNextLectureLevelOffsetHeight))
                }
                .overlay {
                    HStack {
                        Spacer()
                        Button {
                            studyAction()
                        } label: {
                            Text(Setup.ContentStrings.Lecture.moveToLectureButtonTitle)
                                .font(.custom(Setup.FontName.lineBold, size: 12))
                                .foregroundStyle(Color.textColor)
                        }
                    }
                    .padding(.horizontal, 8)
                    .offset(CGSize(width: 0, height: Setup.Frame.homeViewNextLectureButtonOffsetHeight))
                }
                .offset(CGSize(width: Setup.Frame.contentListItemWidthOffset, height: Setup.Frame.contentListItemHeightOffset))
        }
        .padding(.vertical, 10)
        .padding(.horizontal, 10)
    }
}

#Preview {
    NextLectureView(nextLecture: LectureContentListPayload(id: 1, title: "Lecture", point: 20, exercise: "Hi", answer: true, levelNum: 1, categoryChapterId: 3, payloadUrl: "https://")) {
        print("HiHi")
    }
}
