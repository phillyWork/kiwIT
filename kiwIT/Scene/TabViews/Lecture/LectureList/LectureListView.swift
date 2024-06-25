//
//  LectureView.swift
//  kiwIT
//
//  Created by Heedon on 3/11/24.
//

import SwiftUI

struct TestData2: Identifiable {
    let id = UUID()
    let title: String
    let number: Int
    let subItems: [SectionData]
}

struct SectionData: Identifiable {
    let id = UUID()
    let title: String
    let number: Int
}

struct LectureListView: View {

    
    @StateObject var lectureListVM = LectureListViewModel()
    
    //e.g.) 임시 테스트 데이터
    let items: [TestData2] = [
        TestData2(title: "모두 컴퓨터에요", number: 0, subItems: [
            SectionData(title: "왜 배우려고 하나d요요 이건 테스트입니다 하하하하하하하하하하하하하하dfdfdfddfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdfdasdasdfasdfasdfasdfasdfasdfasasdfasdfasdfasdfasdfasdfassdfsdfsdfsdfdfdf", number: 0),
            SectionData(title: "섹션 테스트입니다. 111", number: 1),
            SectionData(title: "섹션 테스트입니다. 222", number: 2),
            SectionData(title: "섹션 테스트입니다. 333", number: 3),
            SectionData(title: "섹션 테스트입니다. 444", number: 4),
            SectionData(title: "섹션 테스트입니다. 555", number: 5),
            SectionData(title: "섹션 테스트입니다. 666", number: 6),
            SectionData(title: "섹션 테스트입니다. 777", number: 7)
        ]),
        TestData2(title: "이건 왜 다르죠", number: 1, subItems: [
            SectionData(title: "왜 배우려고 하나요", number: 0),
            SectionData(title: "섹션 테스트입니다. 111", number: 1),
            SectionData(title: "섹션 테스트입니다. 222", number: 2),
            SectionData(title: "섹션 테스트입니다. 333", number: 3),
            SectionData(title: "섹션 테스트입니다. 444", number: 4),
            SectionData(title: "섹션 테스트입니다. 555", number: 5),
            SectionData(title: "섹션 테스트입니다. 666", number: 6),
            SectionData(title: "섹션 테스트입니다. 777", number: 7),
            SectionData(title: "왜 배우려고 하나요", number: 8),
            SectionData(title: "섹션 테스트입니다. 999", number: 9),
            SectionData(title: "섹션 테스트입니다. 101010", number: 10),
            SectionData(title: "섹션 테스트입니다. 111111", number: 11),
            SectionData(title: "섹션 테스트입니다. 121212", number: 12),
            SectionData(title: "섹션 테스트입니다. 131313", number: 13),
            SectionData(title: "섹션 테스트입니다. 141414", number: 14),
            SectionData(title: "섹션 테스트입니다. 151515", number: 15)
        ]),
        TestData2(title: "테스트 용 챕터입니다.", number: 2, subItems: [
            SectionData(title: "왜 배우려고 하나요", number: 0),
            SectionData(title: "섹션 테스트입니다. 111", number: 1),
            SectionData(title: "섹션 테스트입니다. 222", number: 2),
            SectionData(title: "섹션 테스트입니다. 333", number: 3),
            SectionData(title: "섹션 테스트입니다. 444", number: 4),
            SectionData(title: "섹션 테스트입니다. 555", number: 5)
        ])
    ]
    
    var body: some View {
        //Chapter에서 Toggle로 Section까지 보여주도록 설정
            ScrollView {
                ForEach(items, id: \.id) { item in
                    ContentExpandableChapterItemView(
                        itemTitle: "Chapter \(item.number). \(item.title)") {
                            ScrollView {
                                ForEach(item.subItems, id: \.id) { section in
                                    NavigationLink {
                                       LectureView(lectureListVM: lectureListVM)
                                    } label: {
                                        VStack {
                                            ContentSectionItemView {
                                                Text("Section \(section.number). \(section.title)")
                                            }
                                            Divider()
                                                .frame(minHeight: 1)
                                                .background(Color.textColor)
                                        }
                                        .offset(CGSize(width: Setup.Frame.contentListShadowWidthOffset, height: 0))
                                        .padding(.vertical, 3)
                                    }
                                }
                            }
                            .scrollIndicators(.hidden)
                            .frame(width: Setup.Frame.contentListItemWidth)
                            .background(Color.brandTintColor)
                            .offset(CGSize(width: Setup.Frame.contentListShadowWidthOffset, height: 0))
                            .padding(.top, 0)
                        }
                }
            }
            .frame(width: Setup.Frame.devicePortraitWidth)
            .frame(maxWidth: .infinity)
            .background(Color.backgroundColor)
            .navigationTitle("IT 교양")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.backgroundColor, for: .navigationBar, .tabBar)
    }
}

#Preview {
    LectureListView()
}
