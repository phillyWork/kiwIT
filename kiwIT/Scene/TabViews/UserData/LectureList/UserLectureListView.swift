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
        .alert("네트워크 오류!", isPresented: $lectureListVM.showUnknownNetworkErrorAlert, actions: {
            ErrorAlertConfirmButton { }
        }, message: {
            Text("네트워크 요청에 실패했습니다! 다시 시도해주세요!")
        })
        .alert("보관함 오류!", isPresented: $lectureListVM.showRemoveBookmarkedLectureError) {
            ErrorAlertConfirmButton { }
        } message: {
            Text("보관함 제거에 실패했습니다. 다시 시도해주세요.")
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
                Text("학습 완료 콘텐츠")
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
                EmptyViewWithNoError(title: "학습 완료한 컨텐츠가 없어요")
            } else {
                ScrollView(.horizontal) {
                    LazyHGrid(rows: gridItemLayout, spacing: 10) {
                        ForEach(lectureListVM.completedLectureList, id: \.self) { eachLecture in
                            CompletedLectureContent(eachLecture) {
                                lectureListVM.showWebView(eachLecture)
                            }
                            .padding(.horizontal, 8)
                            .onAppear {
                                if lectureListVM.completedLectureList.last == eachLecture {
                                    lectureListVM.loadMoreCompletedLecture()
                                }
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
                Text("보관한 콘텐츠")
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
                EmptyViewWithNoError(title: "보관한 학습 컨텐츠가 없어요")
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
                                if lectureListVM.bookmarkedLectureList.last == lecture {
                                    lectureListVM.loadMoreBookmarkedLecture()
                                }
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
        .alert("보관함 제거?", isPresented: $lectureListVM.showRemoveBookmarkedLectureAlert) {
            Button(Setup.ContentStrings.confirm, role: .cancel) {
                lectureListVM.debouncedUnbookmarkLecture()
            }
            Button(Setup.ContentStrings.cancel, role: .destructive) { }
        } message: {
            Text("정말로 보관함에서 제거하실 건가요?")
        }
    }
}
