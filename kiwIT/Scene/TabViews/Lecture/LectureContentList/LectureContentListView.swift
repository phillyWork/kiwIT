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
    
    //MARK: - LectureListVM 사용 안함: 굳이 전달하지 않아도 됨
    
    init(lectureListVM: LectureListViewModel, typeId: Int, navTitle: String, isLoginAvailable: Binding<Bool>) {
        self.lectureListVM = lectureListVM
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
                    switch lectureListVM.lectureType {
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
        .alert("네트워크 오류!", isPresented: $lectureContentListVM.showUnknownNetworkErrorAlert, actions: {
            ErrorAlertConfirmButton { }
        }, message: {
            Text("네트워크 요청에 실패했습니다! 다시 시도해주세요!")
        })
        .alert(Setup.ContentStrings.loginErrorAlertTitle, isPresented: $lectureContentListVM.shouldLoginAgain, actions: {
            ErrorAlertConfirmButton {
                isLoginAvailable = false
            }
        }, message: {
            Text(Setup.ContentStrings.loginErrorAlertMessage)
        })
        //to disable pull to refresh
        .environment(\EnvironmentValues.refresh as! WritableKeyPath<EnvironmentValues, RefreshAction?>, nil)
    }
}
