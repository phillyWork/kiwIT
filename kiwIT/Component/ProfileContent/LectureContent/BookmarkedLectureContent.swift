//
//  BookmarkedContent.swift
//  kiwIT
//
//  Created by Heedon on 7/8/24.
//

import SwiftUI

struct BookmarkedLectureContent: View {
    
    var lecture: CompletedOrBookmarkedLecture
    var action: () -> Void
    var bookmarkButtonAction: () -> Void
    
    init(_ lecture: CompletedOrBookmarkedLecture, tapAction: @escaping () -> Void, bookmarkAction: @escaping () -> Void) {
        self.lecture = lecture
        self.action = tapAction
        self.bookmarkButtonAction = bookmarkAction
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
                            Text("LV. \(lecture.levelNum)")
                                .font(.custom(Setup.FontName.lineBold, size: 12))
                                .foregroundStyle(Color.textColor)
                            Spacer()
                            Button {
                                bookmarkButtonAction()
                            } label: {
                                Image(systemName: Setup.ImageStrings.bookmarked)
                                    .foregroundStyle(Color.errorHighlightColor)
                            }
                        }
                        .padding(.horizontal, 8)
                        .offset(CGSize(width: 0, height: Setup.Frame.profileLectureContentOverlayTextHeightOffset))
                    }
            }
            .frame(width: Setup.Frame.profileLectureContentWidth, height: Setup.Frame.profileLectureContentHeight)
            .background(Color.surfaceColor)
            .offset(CGSize(width: -4.0, height: -4.0))
        }
    }
}

//#Preview {
//    BookmarkedLectureContent(CompletedOrBookmarkedLecture(id: 1, title: "Lecture Title", point: 100, exercise: "Exercise Quiz", answer: true, levelNum: 1, categoryChapterId: 2, payloadUrl: "https://", contentStudied: CompleteLectureResponse(userId: 22, contentId: 1, kept: true, createdAt: "2222", updatedAt: "2222"))) {
//        print("Delete Bookmark")
//    } bookmarkAction: {
//        print("Bookmark Button Tapped")
//    }
//}
