//
//  ProfileView.swift
//  kiwIT
//
//  Created by Heedon on 3/11/24.
//

import SwiftUI

struct ProfileView: View {
    
    @StateObject var profileVM: ProfileViewModel
    @ObservedObject var tabViewsVM: TabViewsViewModel
    
    init(tabViewsVM: TabViewsViewModel) {
        _tabViewsVM = ObservedObject(wrappedValue: tabViewsVM)
        let profileVM = ProfileViewModel { updatedProfile in
            tabViewsVM.updateProfileFromProfileView(updatedProfile)
        }
        _profileVM = StateObject(wrappedValue: profileVM)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Image(systemName: Setup.ImageStrings.downDirection)
                        .scaledToFit()
                    Text(Setup.ContentStrings.pullToRefreshTitle)
                        .font(.custom(Setup.FontName.lineThin, size: 12))
                        .foregroundStyle(Color.textColor)
                }
                GroupBox(label: Text(Setup.ContentStrings.Profile.userInfoTitle)
                    .font(.custom(Setup.FontName.notoSansBold, size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.leading, 5), content: {
                        VStack {
                            HStack {
                                Text(tabViewsVM.profileData?.nickname ?? Setup.ContentStrings.Profile.defaultNicknameTitle)
                                    .font(.custom(Setup.FontName.galMuri11Bold, size: 18))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 10)
                                Button {
                                    profileVM.showEditNicknameAlertInView()
                                } label: {
                                    Text(Setup.ContentStrings.Profile.changeButtonTitle)
                                        .font(.custom(Setup.FontName.notoSansRegular, size: 15))
                                }
                                .padding(.trailing, 10)
                                .alert(Setup.ContentStrings.editNicknameAlertTitle, isPresented: $profileVM.showEditNicknameAlert) {
                                    TextField("타이틀",
                                              text: $profileVM.nicknameInputFromUser,
                                              prompt: Text(Setup.ContentStrings.Profile.newNicknameTextfieldPrompt)
                                    )
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                                    .foregroundStyle(Color.black)
                                    Button(Setup.ContentStrings.cancel, role: .destructive) {
                                        profileVM.resetNicknameInput()
                                    }
                                    Button(Setup.ContentStrings.confirm, role: .cancel) {
                                        profileVM.checkNicknameToUpdate()
                                    }
                                }
                                .alert(Setup.ContentStrings.editNicknameErrorAlertTitle, isPresented: $profileVM.showNicknameErrorAlert, actions: {
                                    Button(Setup.ContentStrings.confirm, role: .cancel) {
                                        profileVM.showEditNicknameAlertInView()
                                    }
                                }, message: {
                                    Text(Setup.ContentStrings.errorToTryAgainAlertMessage)
                                })
                            }
                            .padding(.vertical, 5)
                            HStack {
                                Text(Setup.ContentStrings.Profile.emailTitle)
                                Text(tabViewsVM.profileData?.email ?? Setup.ContentStrings.Profile.defaultEmailTitle)
                            }
                            .font(.custom(Setup.FontName.notoSansBold, size: 12))
                            .foregroundStyle(Color.textColor)
                            .padding(.leading, 10)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                })
                .backgroundStyle(Color.backgroundColor)
                
                GroupBox(label:
                            HStack {
                    Text(Setup.ContentStrings.Profile.lectureInfoTitle)
                        .font(.custom(Setup.FontName.notoSansBold, size: 20))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 5)
                    NavigationLink {
                        UserLectureListView(profileVM: profileVM, isLoginAvailable: $tabViewsVM.isLoginAvailable)
                    } label: {
                        Text(Setup.ContentStrings.moveToDetailButtonTitle)
                            .font(.custom(Setup.FontName.notoSansRegular, size: 15))
                    }
                    .padding(.trailing, 5)
                }, content: {
                    VStack {
                        if profileVM.showCompletedLectureListError {
                            EmptyViewWithRetryButton {
                                profileVM.debouncedRequestCompletedLectureList()
                            }
                        } else if profileVM.completedLectureList.isEmpty {
                            EmptyViewWithNoError(title: Setup.ContentStrings.Profile.noneOfCompletedLectureTitle)
                        } else {
                            ProfileContent(profileVM.completedLectureList[0].title, overlayTitle: Setup.ContentStrings.Profile.recentlyCompletedLectureTitle)
                        }
                        if profileVM.showBookmarkedLectureListError {
                            EmptyViewWithRetryButton {
                                profileVM.debouncedRequestBookmarkedLectureList()
                            }
                        } else if profileVM.bookmarkedLectureList.isEmpty {
                            EmptyViewWithNoError(title: Setup.ContentStrings.Profile.noneOfBookmarkedLectureTitle)
                        } else {
                            ProfileContent(profileVM.bookmarkedLectureList[0].title, overlayTitle: Setup.ContentStrings.Profile.recentlyBookmarkedTitle)
                        }
                    }
                    .padding(.vertical, 8)
                })
                .backgroundStyle(Color.backgroundColor)
                
                GroupBox(label: HStack {
                    Text(Setup.ContentStrings.Profile.quizInfoTitle)
                        .font(.custom(Setup.FontName.notoSansBold, size: 20))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 5)
                    NavigationLink {
                        UserQuizListView(profileVM: profileVM, isLoginAvailable: $tabViewsVM.isLoginAvailable)
                    } label: {
                        Text(Setup.ContentStrings.moveToDetailButtonTitle)
                            .font(.custom(Setup.FontName.notoSansRegular, size: 15))
                    }
                    .padding(.trailing, 5)
                }, content: {
                    VStack {
                        if profileVM.showTakenQuizListError {
                            EmptyViewWithRetryButton {
                                profileVM.debouncedRequestTakenQuizList()
                            }
                        } else if profileVM.takenQuizList.isEmpty {
                            EmptyViewWithNoError(title: Setup.ContentStrings.Profile.noneOfCompletedQuizTitle)
                        } else {
                            ProfileContent(profileVM.takenQuizList[0].title, overlayTitle: Setup.ContentStrings.Profile.recentlyCompletedQuizTitle)
                        }
                        if profileVM.showBookmarkedQuizListError {
                            EmptyViewWithRetryButton {
                                profileVM.debouncedRequestBookmarkedQuizList()
                            }
                        } else if profileVM.bookmarkedQuizList.isEmpty {
                            EmptyViewWithNoError(title: Setup.ContentStrings.Profile.noneOfBookmarkedQuizTitle)
                        } else {
                            ProfileContent(profileVM.bookmarkedQuizList[0].question, overlayTitle: Setup.ContentStrings.Profile.recentlyBookmarkedTitle)
                        }
                    }
                })
                .backgroundStyle(Color.backgroundColor)
                
//                GroupBox(label: Text("인터뷰 현황"), content: {
//                    VStack {
//                        Text("구독 AI 인터뷰 진행 상황 나타내기")
//                            .font(.custom(Setup.FontName.notoSansBold, size: 20))
//                            .frame(maxWidth: .infinity, alignment: .leading)
//                            .padding(.leading, 5)
//                    }
//                })
//                .backgroundStyle(Color.backgroundColor)
                
                GroupBox(label:
                            HStack {
                    Text(Setup.ContentStrings.Profile.acquiredTrophyInfoTitle)
                        .font(.custom(Setup.FontName.notoSansBold, size: 20))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 5)
                    NavigationLink {
                        TrophyListView(isLoginAvailable: $tabViewsVM.isLoginAvailable)
                    } label: {
                        Text(Setup.ContentStrings.moveToDetailButtonTitle)
                            .font(.custom(Setup.FontName.notoSansRegular, size: 15))
                    }
                    .padding(.trailing, 5)
                }, content: {
                    VStack {
                        if profileVM.showLatestAcquiredTrophyError {
                            EmptyViewWithRetryButton {
                                profileVM.debouncedRequestLatestAcquiredTrophy()
                            }
                        } else if profileVM.latestAcquiredTrophy.isEmpty {
                            EmptyViewWithNoError(title: Setup.ContentStrings.Profile.noneOfAcquiredTrophyTitle)
                        } else {
                            TrophyContent(trophy: profileVM.latestAcquiredTrophy[0].trophy, achievedDate: profileVM.latestAcquiredTrophy[0].creationCompactDate)
                                .padding(.horizontal, 5)
                        }
                    }
                })
                .backgroundStyle(Color.backgroundColor)
                
                Spacer()
                
                VStack(alignment: .center, spacing: 15) {
                    ShrinkAnimationButtonView(title: Setup.ContentStrings.Profile.signOutTitle, font: Setup.FontName.galMuri11Bold, color: Color.brandTintColor2) {
                        profileVM.showAlertInView(.logout)
                    }
                    .alert(Setup.ContentStrings.Profile.signOutTitle, isPresented: $profileVM.showLogoutAlert, actions: {
                        Button(Setup.ContentStrings.confirm, role: .cancel) {
                            profileVM.debouncedSignOut()
                        }
                        Button(Setup.ContentStrings.cancel, role: .destructive) { }
                    }, message: {
                        Text(Setup.ContentStrings.Profile.signOutCheckAlertMessage)
                    })
                    .alert(Setup.ContentStrings.logoutSuccessAlertTitle, isPresented: $profileVM.showLogoutSucceedAlert, actions: {
                        Button {
                            tabViewsVM.userLoginStatusUpdate.send(false)
                        } label: {
                            Text(Setup.ContentStrings.confirm)
                        }
                    }, message: {
                        Text(Setup.ContentStrings.Profile.moveToLoginViewAlertMessage)
                    })
                    .alert(Setup.ContentStrings.logoutErrorAlertTitle, isPresented: $profileVM.showLogoutErrorAlert) {
                        ErrorAlertConfirmButton { }
                    } message: {
                        Text(Setup.ContentStrings.Profile.signOutErrorAlertMessage)
                    }

                    ShrinkAnimationButtonView(title: Setup.ContentStrings.Profile.withdrawTitle, font: Setup.FontName.galMuri11Bold, color: Color.errorHighlightColor) {
                        profileVM.showAlertInView(.checkToWithdraw)
                    }
                    .alert(Setup.ContentStrings.Profile.withdrawTitle, isPresented: $profileVM.showWithdrawAlert, actions: {
                        Button(Setup.ContentStrings.confirm, role: .cancel) {
                            profileVM.showAlertInView(.withdrawTextfield)
                        }
                        Button(Setup.ContentStrings.cancel, role: .destructive) { }
                    }, message: {
                        Text(Setup.ContentStrings.Profile.withdrawCheckAlertMessage)
                    })
                    .alert(Setup.ContentStrings.withdrawEmailTextfieldAlertTitle, isPresented: $profileVM.showWithdrawWithEmailTextfieldAlert, actions: {
                        TextField(Setup.ContentStrings.Profile.withdrawEmailTextFieldTitle, text: $profileVM.emailToBeWithdrawn, prompt: Text(tabViewsVM.profileData?.email ?? Setup.ContentStrings.Profile.withdrawEmailTextFieldPrompt))
                            .foregroundStyle(Color.black)
                        Button(Setup.ContentStrings.confirm, role: .cancel) {
                            if profileVM.emailToBeWithdrawn.isEmpty {
                                profileVM.showAlertInView(.withdrawEmailError)
                            } else {
                                profileVM.debouncedWithdraw()
                            }
                        }
                        Button(Setup.ContentStrings.cancel, role: .destructive) {
                            profileVM.emailToBeWithdrawn.removeAll()
                        }
                    }, message: {
                        Text(Setup.ContentStrings.Profile.withdrawEmailTextFieldAlertMessage)
                    })
                    .alert(Setup.ContentStrings.withdrawEmailInputErrorAlertTitle, isPresented: $profileVM.showEmailWithdrawalErrorAlert) {
                        //탈퇴의 불편함 일부러 제공 (탈퇴 유도 막기...)
                        Button(Setup.ContentStrings.confirm, role: .cancel) { }
                    }
                    .alert(Setup.ContentStrings.withdrawErrorAlertTitle, isPresented: $profileVM.showWithdrawErrorAlert, actions: {
                        ErrorAlertConfirmButton { }
                    }, message: {
                        Text(Setup.ContentStrings.Profile.withdrawErrorAlertMessage)
                    })
                    .alert(Setup.ContentStrings.withdrawSuccessAlertTitle, isPresented: $profileVM.showWithdrawSucceedAlert, actions: {
                        Button {
                            tabViewsVM.userLoginStatusUpdate.send(false)
                        } label: {
                            Text(Setup.ContentStrings.confirm)
                        }
                    }, message: {
                        Text(Setup.ContentStrings.Profile.withdrawSuccessAlertMessage)
                    })
                }
                .padding(.vertical, 4)
            }
            .frame(maxWidth: .infinity)
            .background(Color.backgroundColor)
            .navigationTitle(Setup.ContentStrings.profileTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.backgroundColor, for: .navigationBar, .tabBar)
            .alert(Setup.ContentStrings.unknownNetworkErrorAlertTitle, isPresented: $profileVM.showUnknownNetworkErrorAlert, actions: {
                ErrorAlertConfirmButton { }
            }, message: {
                Text(Setup.ContentStrings.unknownNetworkErrorAlertMessage)
            })
            .alert(Setup.ContentStrings.loginErrorAlertTitle, isPresented: $profileVM.showSessionExpiredAlert, actions: {
                ErrorAlertConfirmButton {
                    tabViewsVM.userLoginStatusUpdate.send(false)
                }
            }, message: {
                Text(Setup.ContentStrings.loginErrorAlertMessage)
            })
        }
        .refreshable {
            profileVM.pullToRefresh()
        }
    }
}

#Preview {
    ProfileView(tabViewsVM: TabViewsViewModel())
}
