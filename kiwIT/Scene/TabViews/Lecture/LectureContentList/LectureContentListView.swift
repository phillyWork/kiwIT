//
//  LectureView.swift
//  kiwIT
//
//  Created by Heedon on 3/11/24.
//

import SwiftUI

struct LectureContentListView: View {
    
    @StateObject var lectureContentListVM: LectureContentListViewModel
    @Binding var isLoginAvailable: Bool

    init(lectureListVM: LectureListViewModel, typeId: Int, navTitle: String, isLoginAvailable: Binding<Bool>) {
        _lectureContentListVM = StateObject(wrappedValue: LectureContentListViewModel(typeId: typeId, navTitle: navTitle, lectureType: lectureListVM.lectureType))
        self._isLoginAvailable = isLoginAvailable
    }
    
    var body: some View {
        ScrollView {
            if lectureContentListVM.showEmptyView {
                WholeEmptyView()
                    .frame(maxWidth: .infinity)
            } else {
                LazyVStack(spacing: 5) {
                    switch lectureContentListVM.lectureListType {
                    case .category:
                        ForEach(lectureContentListVM.lectureContentListCategoryType, id: \.self) { item in
                            ContentExpandableChapterItemView(itemTitle: item.title) {
                                ScrollView {
                                    LazyVStack(spacing: 5) {
                                        ForEach(item.contentList, id: \.self) { data in
                                            NavigationLink {
                                                LectureView(contentId: data.id, isLoginAvailable: $isLoginAvailable)
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
                                LectureView(contentId: item.id, isLoginAvailable: $isLoginAvailable)
                            } label: {
                                ContentNotExpandableChapterItemView(title: item.title)
                            }
                            .onAppear {
                                lectureContentListVM.checkMorePaginationNeeded(item)
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
        .alert(Setup.ContentStrings.unknownNetworkErrorAlertTitle, isPresented: $lectureContentListVM.showUnknownNetworkErrorAlert, actions: {
            ErrorAlertConfirmButton { }
        }, message: {
            Text(Setup.ContentStrings.unknownNetworkErrorAlertMessage)
        })
        .alert(Setup.ContentStrings.loginErrorAlertTitle, isPresented: $lectureContentListVM.shouldLoginAgain, actions: {
            ErrorAlertConfirmButton {
                isLoginAvailable = false
            }
        }, message: {
            Text(Setup.ContentStrings.loginErrorAlertMessage)
        })
        .onDisappear {
            lectureContentListVM.cleanUpCancellables()
        }
        //to disable pull to refresh
        .environment(\EnvironmentValues.refresh as! WritableKeyPath<EnvironmentValues, RefreshAction?>, nil)
    }
}
