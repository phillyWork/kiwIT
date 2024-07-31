//
//  HomeView.swift
//  kiwIT
//
//  Created by Heedon on 3/11/24.
//

import SwiftUI

//MARK: - HomeView 구성

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
                        Text("오늘도 화이팅이에요!")
                        Text(tabViewsVM.profileData?.nickname ?? "닉네임")
                            .lineLimit(1)
                    }
                    .font(.custom(Setup.FontName.notoSansMedium, size: 12))
                    .frame(maxWidth: .infinity, alignment: Alignment.leading)
                })
                .backgroundStyle(Color.backgroundColor)
                
                GroupBox(label: HStack {
                    Text("다음 학습 진도")
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
                        EmptyViewWithNoError(title: "오른쪽 상단 버튼을 눌러 다시 시도해주세요")
                    } else if let nextLectureToStudy = homeVM.nextLectureToStudy {
                        NextLectureView(nextLecture: nextLectureToStudy) {
                            tabViewsVM.selectedTabUpdate.send(.lecture)
                        }
                    } else {
                        EmptyViewWithNoError(title: "학습을 시작해주세요")
                    }
                })
                .backgroundStyle(Color.backgroundColor)
                
                GroupBox(label: HStack {
                    Text("최근 퀴즈 결과")
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
                        EmptyViewWithNoError(title: "오른쪽 상단 버튼을 눌러 다시 시도해주세요")
                    } else if let latestTakenQuiz = homeVM.latestTakenQuiz {
                        LatestTakenQuizView(latestTakenQuiz: latestTakenQuiz) {
                            tabViewsVM.selectedTabUpdate.send(.quiz)
                        }
                    } else {
                        EmptyViewWithNoError(title: "가장 최근에 푼 퀴즈가 없어요")
                    }
                })
                .backgroundStyle(Color.backgroundColor)
            }
            .frame(maxWidth: .infinity)
            .scrollIndicators(.hidden)
            .background(Color.backgroundColor)
            .toolbarBackground(Color.backgroundColor, for: .navigationBar, .tabBar)
        }
        .alert("네트워크 오류!", isPresented: $homeVM.showUnknownNetworkErrorAlert, actions: {
            ErrorAlertConfirmButton { }
        }, message: {
            Text("네트워크 요청에 실패했습니다! 다시 시도해주세요!")
        })
        .alert("로그인 오류", isPresented: $homeVM.shouldLoginAgain) {
            ErrorAlertConfirmButton {
                tabViewsVM.userLoginStatusUpdate.send(false)
            }
        } message: {
            Text("세션 만료입니다. 다시 로그인해주세요!")
        }
    }
}

#Preview {
    HomeView(tabViewsVM: TabViewsViewModel())
}
