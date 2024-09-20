//
//  UserLectureListView.swift
//  kiwIT
//
//  Created by Heedon on 7/5/24.
//

import SwiftUI

struct UserLectureListView: View {
    
    @StateObject var lectureListVM = UserLectureListViewModel()
    @ObservedObject var profileVM: ProfileViewModel
    
    @Binding var isLoginAvailable: Bool
    
    private let gridItemLayout = [GridItem(.flexible()),
                                  GridItem(.flexible())]
    
    var body: some View {
        ScrollView {
            CompletedLectureSection(lectureListVM: lectureListVM, gridItemLayout: gridItemLayout)
            BookmarkedLectureSection(lectureListVM: lectureListVM, gridItemLayout: gridItemLayout)
        }
        .sheet(isPresented: $lectureListVM.showSheetWebView, content: {
            SimpleWebView(url: lectureListVM.urlForSheetWebView)
                .padding(.top, 15)
                .presentationDetents([.medium, .large])
                .presentationDragIndicator(.visible)
        })
        .frame(maxWidth: .infinity)
        .background(Color.backgroundColor)
        .scrollIndicators(.hidden)
        .alert(Setup.ContentStrings.unknownNetworkErrorAlertTitle, isPresented: $lectureListVM.showUnknownNetworkErrorAlert, actions: {
            ErrorAlertConfirmButton { }
        }, message: {
            Text(Setup.ContentStrings.unknownNetworkErrorAlertMessage)
        })
        .alert(Setup.ContentStrings.removeBookmarkedContentErrorAlertTitle, isPresented: $lectureListVM.showRemoveBookmarkedLectureError) {
            ErrorAlertConfirmButton { }
        } message: {
            Text(Setup.ContentStrings.Lecture.unbookmarkLectureErrorAlertMessage)
        }
        .alert(Setup.ContentStrings.loginErrorAlertTitle, isPresented: $lectureListVM.shouldLoginAgain) {
            ErrorAlertConfirmButton {
                isLoginAvailable = false
            }
        } message: {
            Text(Setup.ContentStrings.loginErrorAlertMessage)
        }
        .onChange(of: lectureListVM.shouldUpdateProfileVM) { newValue in
            if newValue {
                profileVM.removeThisBookmarkedLecture(lectureListVM.idForToBeRemovedLecture)
            }
        }
        //to disable pull to refresh
        .environment(\EnvironmentValues.refresh as! WritableKeyPath<EnvironmentValues, RefreshAction?>, nil)
    }
}

struct CompletedLectureSection: View {
    
    @ObservedObject var lectureListVM: UserLectureListViewModel
    let gridItemLayout: [GridItem]
    
    var body: some View {
        VStack {
            HStack {
                Text(Setup.ContentStrings.Lecture.completedLectureTitle)
                    .font(.custom(Setup.FontName.notoSansBold, size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 10)
                Button {
                    lectureListVM.debouncedResetCompletedLecture()
                } label: {
                    Image(systemName: Setup.ImageStrings.retryAction)
                }
                .padding(.trailing, 10)
            }
            if lectureListVM.showCompletedLectureError {
                EmptyViewWithRetryButton {
                    lectureListVM.debouncedResetCompletedLecture()
                }
            } else if lectureListVM.completedLectureList.isEmpty {
                EmptyViewWithNoError(title: Setup.ContentStrings.Lecture.noneOfCompletedLectureTitle)
            } else {
                ScrollView(.horizontal) {
                    LazyHGrid(rows: gridItemLayout, spacing: 10) {
                        ForEach(lectureListVM.completedLectureList, id: \.self) { eachLecture in
                            CompletedLectureContent(eachLecture) {
                                lectureListVM.showWebView(eachLecture)
                            }
                            .padding(.horizontal, 8)
                            .onAppear {
                                lectureListVM.checkToLoadMoreCompletedLecturePagination(eachLecture)
                            }
                        }
                    }
                    .frame(height: Setup.Frame.profileLectureContentHGridHeight)
                    .scrollTargetLayout()
                }
                .frame(height: Setup.Frame.profileLectureContentHScrollHeight)
                .scrollTargetBehavior(.viewAligned)
                .scrollIndicators(.visible)
            }
        }
        .frame(height: Setup.Frame.profileContentEquallyDivide)
    }
}

struct BookmarkedLectureSection: View {
    
    @ObservedObject var lectureListVM: UserLectureListViewModel
    let gridItemLayout: [GridItem]
    
    var body: some View {
        VStack {
            HStack {
                Text(Setup.ContentStrings.Lecture.bookmarkedLectureTitle)
                    .font(.custom(Setup.FontName.notoSansBold, size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 10)
                Button {
                    lectureListVM.debouncedResetBookmarkedLecture()
                } label: {
                    Image(systemName: Setup.ImageStrings.retryAction)
                }
                .padding(.horizontal, 8)
            }
            if lectureListVM.showBookmarkedLectureError {
                EmptyViewWithRetryButton {
                    lectureListVM.debouncedResetBookmarkedLecture()
                }
            } else if lectureListVM.bookmarkedLectureList.isEmpty {
                EmptyViewWithNoError(title: Setup.ContentStrings.Lecture.noneOfBookmarkedLectureTitle)
            } else {
                ScrollView(.horizontal) {
                    LazyHGrid(rows: gridItemLayout) {
                        ForEach(lectureListVM.bookmarkedLectureList, id: \.self) { lecture in
                            BookmarkedLectureContent(lecture) {
                                lectureListVM.showWebView(lecture)
                            } bookmarkAction: {
                                lectureListVM.checkToRemoveBookmarkedLecture(lecture.id)
                            }
                            .padding(.horizontal, 8)
                            .onAppear {
                                lectureListVM.checkToLoadMoreBookmarkedLecturePagination(lecture)
                            }
                        }
                    }
                    .frame(height: Setup.Frame.profileLectureContentHGridHeight)
                    .scrollTargetLayout()
                }
                .frame(height: Setup.Frame.profileLectureContentHScrollHeight)
                .scrollTargetBehavior(.viewAligned)
                .scrollIndicators(.visible)
            }
        }
        .frame(height: Setup.Frame.profileContentEquallyDivide)
        .alert(Setup.ContentStrings.removeBookmarkedContentAlertTitle, isPresented: $lectureListVM.showRemoveBookmarkedLectureAlert) {
            Button(Setup.ContentStrings.confirm, role: .cancel) {
                lectureListVM.debouncedUnbookmarkLecture()
            }
            Button(Setup.ContentStrings.cancel, role: .destructive) { }
        } message: {
            Text(Setup.ContentStrings.Lecture.unbookmarkThisLectureAlertMessage)
        }
    }
}
