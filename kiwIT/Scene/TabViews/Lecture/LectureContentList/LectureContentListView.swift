//
//  LectureView.swift
//  kiwIT
//
//  Created by Heedon on 3/11/24.
//

import SwiftUI

struct LectureContentListView: View {
    
    @StateObject var lectureContentListVM: LectureContentListViewModel
    @ObservedObject var lectureListVM: LectureListViewModel
    
    @Binding var isLoginAvailable: Bool
    
    init(lectureListVM: LectureListViewModel, typeId: Int, navTitle: String, isLoginAvailable: Binding<Bool>) {
        self.lectureListVM = lectureListVM
        _lectureContentListVM = StateObject(wrappedValue: LectureContentListViewModel(typeId: typeId, navTitle: navTitle, lectureType: lectureListVM.lectureType))
        self._isLoginAvailable = isLoginAvailable
    }
    
    var body: some View {
        ScrollView {
            if lectureContentListVM.showEmptyView {
                CustomEmptyView()
                    .frame(maxWidth: .infinity)
            } else {
                LazyVStack(spacing: 5) {
                    switch lectureListVM.lectureType {
                    case .category:
                        ForEach(lectureContentListVM.lectureContentListCategoryType, id: \.self) { item in
                            ContentExpandableChapterItemView(itemTitle: item.title) {
                                ScrollView {
                                    LazyVStack(spacing: 5) {
                                        ForEach(item.contentList, id: \.self) { data in
                                            NavigationLink {
                                                LectureView(lectureContentListVM: lectureContentListVM, contentId: data.id, isLoginAvailable: $isLoginAvailable)
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
                                LectureView(lectureContentListVM: lectureContentListVM, contentId: item.id, isLoginAvailable: $isLoginAvailable)
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
        }
        .frame(maxWidth: .infinity)
        .frame(width: Setup.Frame.devicePortraitWidth)
        .background(Color.backgroundColor)
        .navigationTitle("\(lectureContentListVM.navTitle)")
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(Color.backgroundColor, for: .navigationBar, .tabBar)
        .alert(Setup.ContentStrings.loginErrorAlertTitle, isPresented: $lectureContentListVM.shouldLoginAgain, actions: {
            ErrorAlertConfirmButton {
                isLoginAvailable = false
            }
        }, message: {
            Text(Setup.ContentStrings.loginErrorAlertMessage)
        })
//        .onChange(of: lectureContentListVM.shouldLoginAgain) { newValue in
//            if newValue {
//                print("Should Login Due to session expired in LectureContentListView")
//                isLoginAvailable = false
//            }
//        }
        //to disable pull to refresh
        .environment(\EnvironmentValues.refresh as! WritableKeyPath<EnvironmentValues, RefreshAction?>, nil)
    }
}
