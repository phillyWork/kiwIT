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
        VStack {
            CompletedLectureSection(lectureListVM: lectureListVM, gridItemLayout: gridItemLayout)
            BookmarkedLectureSection(lectureListVM: lectureListVM, gridItemLayout: gridItemLayout)
        }
        .sheet(isPresented: $lectureListVM.showSheetWebView, content: {
            SimpleWebView(url: lectureListVM.urlForSheetWebView)
                .padding(.top, 15)
                .presentationDetents([.large, .medium])
                .presentationDragIndicator(.visible)
        })
        .frame(maxHeight: .infinity)
        .background(Color.backgroundColor)
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
            profileVM.removeThisBookmarkedLecture(lectureListVM.idForToBeRemovedLecture)
        }
        .onDisappear {
            lectureListVM.cleanUpCancellables()
        }
    }
}

struct CompletedLectureSection: View {
    
    @ObservedObject var lectureListVM: UserLectureListViewModel
    let gridItemLayout: [GridItem]
    
    var body: some View {
        VStack {
            HStack {
                Text("학습 완료 콘텐츠")
                Spacer()
                Button {
                    lectureListVM.debouncedResetCompletedLecture()
                } label: {
                    Image(systemName: Setup.ImageStrings.retryAction)
                }
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
                                    print("Last data for list: should call more!!!")
                                    lectureListVM.loadMoreCompletedLecture()
                                }
                            }
                        }
                    }
                    .frame(height: Setup.Frame.profileLectureContentHGridHeight)
                    .background(Color.red)
                }
                .scrollIndicators(.visible)
                .frame(height: Setup.Frame.profileLectureContentHeight * 2.5)
                .background(Color.orange)
            }
        }
        .background(Color.blue)
    }
}

struct BookmarkedLectureSection: View {
    
    @ObservedObject var lectureListVM: UserLectureListViewModel
    let gridItemLayout: [GridItem]
    
    var body: some View {
        VStack {
            HStack {
                Text("보관한 콘텐츠")
                Spacer()
                Button {
                    lectureListVM.debouncedResetBookmarkedLecture()
                } label: {
                    Image(systemName: Setup.ImageStrings.retryAction)
                }
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
                                    print("Last data for list: should call more!!!")
                                    lectureListVM.loadMoreBookmarkedLecture()
                                }
                            }
                        }
                    }
                    .frame(height: Setup.Frame.profileLectureContentHGridHeight)
                    .background(Color.purple)
                }
                .scrollIndicators(.visible)
                .frame(height: Setup.Frame.profileLectureContentHeight * 2.5)
                .background(Color.orange)
            }
        }
        .background(Color.green)
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
