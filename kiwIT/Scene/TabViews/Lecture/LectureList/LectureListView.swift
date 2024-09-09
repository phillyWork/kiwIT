//
//  LectureCategoryListView.swift
//  kiwIT
//
//  Created by Heedon on 3/19/24.
//

import SwiftUI

struct LectureListView: View {
    
    @StateObject var lectureListVM = LectureListViewModel()
    @ObservedObject var tabViewsVM: TabViewsViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Pick", selection: $lectureListVM.lectureType) {
                    ForEach(LectureListType.allCases, id: \.self) {
                        Text($0.rawValue)
                    }
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, 8)
                .onChange(of: lectureListVM.lectureType) {
                    lectureListVM.updateViewByPickerSelection()
                }
                
                ScrollView {
                    VStack {
                        Image(systemName: Setup.ImageStrings.downDirection)
                            .scaledToFit()
                        Text(Setup.ContentStrings.pullToRefreshTitle)
                            .font(.custom(Setup.FontName.lineThin, size: 12))
                            .foregroundStyle(Color.textColor)
                    }
                    if (lectureListVM.showLectureList) {
                        LazyVStack(spacing: 4) {
                            switch lectureListVM.lectureType {
                            case .category:
                                ForEach(lectureListVM.lectureCategoryListData, id: \.self) { data in
                                    NavigationLink {
                                        LectureContentListView(lectureListVM: lectureListVM, typeId: data.id, navTitle: data.title, isLoginAvailable: $tabViewsVM.isLoginAvailable)
                                    } label: {
                                        LectureCategoryItemView(title: data.title, ratio: 0.75, imageUrl: data.thumbnailUrl)
                                    }
                                }
                                .frame(maxHeight: .infinity)
                            case .level:
                                ForEach(lectureListVM.lectureLevelListData, id: \.self) { data in
                                    NavigationLink {
                                        LectureContentListView(lectureListVM: lectureListVM, typeId: data.num, navTitle: data.title, isLoginAvailable: $tabViewsVM.isLoginAvailable)
                                    } label: {
                                        LectureCategoryItemView(title: data.title, ratio: 0.75)
                                    }
                                }
                                .frame(maxHeight: .infinity)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .frame(width: Setup.Frame.devicePortraitWidth, alignment: .center)
                    } else {
                        WholeEmptyView()
                            .frame(maxWidth: .infinity)
                            .frame(width: Setup.Frame.devicePortraitWidth, alignment: .center)
                    }
                }
                .scrollIndicators(.hidden)
                .navigationTitle(Setup.ContentStrings.lectureContentTitle)
                .navigationBarTitleDisplayMode(.inline)
                .toolbarBackground(Color.backgroundColor, for: .navigationBar, .tabBar)
            }
            .background(Color.backgroundColor)
        }
        .alert(Setup.ContentStrings.unknownNetworkErrorAlertTitle, isPresented: $lectureListVM.showUnknownNetworkErrorAlert, actions: {
            ErrorAlertConfirmButton { }
        }, message: {
            Text(Setup.ContentStrings.unknownNetworkErrorAlertMessage)
        })
        .alert(Setup.ContentStrings.loginErrorAlertTitle, isPresented: $lectureListVM.shouldLoginAgain, actions: {
            ErrorAlertConfirmButton {
                tabViewsVM.userLoginStatusUpdate.send(false)
            }
        }, message: {
            Text(Setup.ContentStrings.loginErrorAlertMessage)
        })
        .refreshable {
            lectureListVM.requestLectureList()
        }
    }
}

#Preview {
    LectureListView(tabViewsVM: TabViewsViewModel())
}
