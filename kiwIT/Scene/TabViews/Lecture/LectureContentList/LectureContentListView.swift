//
//  LectureView.swift
//  kiwIT
//
//  Created by Heedon on 3/11/24.
//

import SwiftUI

//struct TestData2: Identifiable {
//    let id = UUID()
//    let title: String
//    let number: Int
//    let subItems: [SectionData]
//}
//
//struct SectionData: Identifiable {
//    let id = UUID()
//    let title: String
//    let number: Int
//}

struct LectureContentListView: View {
    
    @StateObject var lectureContentListVM: LectureContentListViewModel
    @ObservedObject var lectureListVM: LectureListViewModel
    
    init(lectureListVM: LectureListViewModel, typeId: Int, navTitle: String) {
        self.lectureListVM = lectureListVM
        _lectureContentListVM = StateObject(wrappedValue: LectureContentListViewModel(typeId: typeId, navTitle: navTitle, lectureType: lectureListVM.lectureType))
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(spacing: 5) {
                switch lectureListVM.lectureType {
                case .category:
                    ForEach(lectureContentListVM.lectureContentListCategoryType, id: \.self) { item in
                        ContentExpandableChapterItemView(itemTitle: item.title) {
                            ScrollView {
                                LazyVStack(spacing: 5) {
                                    ForEach(item.contentList, id: \.self) { data in
                                        NavigationLink {
                                            LectureView(lectureContentListVM: lectureContentListVM)
                                        } label: {
                                            VStack {
                                                ContentSectionItemView {
                                                    Text("\(data.title)")
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
                            }
                            .scrollIndicators(.hidden)
                            .frame(width: Setup.Frame.contentListItemWidth)
                            .background(Color.brandTintColor)
                            .offset(CGSize(width: Setup.Frame.contentListShadowWidthOffset, height: 0))
                            .padding(.top, 0)
                        }
                    }
                case .level:
                    ForEach(lectureContentListVM.lectureContentListLevelType, id: \.self) { item in
                        NavigationLink {
                            LectureView(lectureContentListVM: lectureContentListVM)
                        } label: {
                            ContentNotExpandableChapterItemView(title: item.title)
                        }
                        .onAppear {
                            print("Check data for pagination!!!")
                            if lectureContentListVM.lectureContentListLevelType.last == item {
                                print("Last data for list: should call more!!!")
                                lectureContentListVM.loadMoreContentListLevelType()
                            }
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .frame(width: Setup.Frame.devicePortraitWidth)
        .background(Color.backgroundColor)
        .navigationTitle("\(lectureContentListVM.navTitle)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.backgroundColor, for: .navigationBar, .tabBar)
        .onChange(of: lectureContentListVM.isLoginAvailable) { newValue in
            if !newValue {
                lectureListVM.isLoginAvailable = false
            }
        }
        //to disable pull to refresh
        .environment(\EnvironmentValues.refresh as! WritableKeyPath<EnvironmentValues, RefreshAction?>, nil)
    }
}

#Preview {
    LectureContentListView(lectureListVM: LectureListViewModel(), typeId: 1, navTitle: "연습")
}
