//
//  HomeView.swift
//  kiwIT
//
//  Created by Heedon on 3/11/24.
//

import SwiftUI

struct HomeView: View {
    
    @StateObject var homeVM = HomeViewModel()
    @ObservedObject var tabViewsVM: TabViewsViewModel
    
    var body: some View {
        NavigationStack {
            ScrollView {
                GroupBox(label: Text("\(Setup.ContentStrings.homeViewNavTitle.randomElement()!)")
                    .font(.custom(Setup.FontName.galMuri11Bold, size: 35))
                    .multilineTextAlignment(.leading)
                    .padding(.vertical, 8), content: {
                    HStack {
                        Text(Setup.ContentStrings.Home.cheerUpText)
                        Text(tabViewsVM.profileData?.nickname ?? Setup.ContentStrings.Profile.defaultNicknameTitle)
                            .lineLimit(1)
                    }
                    .font(.custom(Setup.FontName.notoSansMedium, size: 12))
                    .frame(maxWidth: .infinity, alignment: Alignment.leading)
                })
                .backgroundStyle(Color.backgroundColor)
                
                GroupBox(label: HStack {
                    Text(Setup.ContentStrings.Home.nextLectureTitle)
                        .font(.custom(Setup.FontName.notoSansBold, size: 20))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 5)
                    Spacer()
                    Button {
                        homeVM.debouncedRequestNextLecture()
                    } label: {
                        Image(systemName: Setup.ImageStrings.retryAction)
                    }
                    .padding(.trailing, 5)
                }, content: {
                    if homeVM.showNextLectureError {
                        EmptyViewWithNoError(title: Setup.ContentStrings.Home.tryAgainButtonTitle)
                    } else if let nextLectureToStudy = homeVM.nextLectureToStudy {
                        NextLectureView(nextLecture: nextLectureToStudy) {
                            tabViewsVM.selectedTabUpdate.send(.lecture)
                        }
                    } else {
                        EmptyViewWithNoError(title: Setup.ContentStrings.Home.noneOfCompletedLectureTitle)
                    }
                })
                .backgroundStyle(Color.backgroundColor)
                
                GroupBox(label: HStack {
                    Text(Setup.ContentStrings.Home.latestQuizResultTitle)
                        .font(.custom(Setup.FontName.notoSansBold, size: 20))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 5)
                    Spacer()
                    Button {
                        homeVM.debouncedRequestLatestTakenQuiz()
                    } label: {
                        Image(systemName: Setup.ImageStrings.retryAction)
                    }
                    .padding(.trailing, 5)
                }, content: {
                    if homeVM.showLatestTakenQuizError {
                        EmptyViewWithNoError(title: Setup.ContentStrings.Home.tryAgainButtonTitle)
                    } else if let latestTakenQuiz = homeVM.latestTakenQuiz {
                        LatestTakenQuizView(latestTakenQuiz: latestTakenQuiz) {
                            tabViewsVM.selectedTabUpdate.send(.quiz)
                        }
                    } else {
                        EmptyViewWithNoError(title: Setup.ContentStrings.Home.noneOfTakenQuizTitle)
                    }
                })
                .backgroundStyle(Color.backgroundColor)
            }
            .frame(maxWidth: .infinity)
            .scrollIndicators(.hidden)
            .background(Color.backgroundColor)
            .toolbarBackground(Color.backgroundColor, for: .navigationBar, .tabBar)
        }
        .alert(Setup.ContentStrings.unknownNetworkErrorAlertTitle, isPresented: $homeVM.showUnknownNetworkErrorAlert, actions: {
            ErrorAlertConfirmButton { }
        }, message: {
            Text(Setup.ContentStrings.unknownNetworkErrorAlertMessage)
        })
        .alert(Setup.ContentStrings.loginErrorAlertTitle, isPresented: $homeVM.shouldLoginAgain) {
            ErrorAlertConfirmButton {
                tabViewsVM.userLoginStatusUpdate.send(false)
            }
        } message: {
            Text(Setup.ContentStrings.loginErrorAlertMessage)
        }
    }
}

#Preview {
    HomeView(tabViewsVM: TabViewsViewModel())
}
