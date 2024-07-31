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
                    Text("당겨서 새로고침")
                        .font(.custom(Setup.FontName.lineThin, size: 12))
                        .foregroundStyle(Color.textColor)
                }
                GroupBox(label: Text("유저 정보")
                    .font(.custom(Setup.FontName.notoSansBold, size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading), content: {
                        VStack {
                            HStack {
                                Text(tabViewsVM.profileData?.nickname ?? "Anonymous User")
                                    .font(.custom(Setup.FontName.galMuri11Bold, size: 18))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading, 10)
                                Button {
                                    profileVM.showEditNicknameAlert.toggle()
                                } label: {
                                    Text("변경하기")
                                        .font(.custom(Setup.FontName.notoSansRegular, size: 15))
                                }
                                .padding(.trailing, 10)
                                .alert("닉네임 수정", isPresented: $profileVM.showEditNicknameAlert) {
                                    TextField("타이틀",
                                              text: $profileVM.nicknameInputFromUser,
                                              prompt: Text("새로운 닉네임을 입력해주세요.")
                                    )
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                                    .foregroundStyle(Color.black)
                                    Button(Setup.ContentStrings.cancel, role: .destructive) {
                                        profileVM.nicknameInputFromUser.removeAll()
                                    }
                                    Button(Setup.ContentStrings.confirm, role: .cancel) {
                                        if profileVM.nicknameInputFromUser.isEmpty {
                                            profileVM.showNicknameErrorAlert = true
                                        } else {
                                            profileVM.debouncedRequestProfileEdit()
                                        }
                                    }
                                }
                                .alert("오류", isPresented: $profileVM.showNicknameErrorAlert, actions: {
                                    Button(Setup.ContentStrings.confirm, role: .cancel) {
                                        profileVM.showEditNicknameAlert = true
                                    }
                                }, message: {
                                    Text("오류 발생! 다시 시도해주세요.")
                                })
                            }
                            .padding(.vertical, 5)
                            HStack {
                                Text("Email:")
                                Text(tabViewsVM.profileData?.email ?? "Example Email")
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
                    Text("학습 근황")
                        .font(.custom(Setup.FontName.notoSansBold, size: 20))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 5)
                    NavigationLink {
                        UserLectureListView(profileVM: profileVM, isLoginAvailable: $tabViewsVM.isLoginAvailable)
                    } label: {
                        Text("더 보기")
                            .font(.custom(Setup.FontName.notoSansRegular, size: 15))
                    }
                    .padding(.trailing, 5)
                }, content: {
                    VStack {
                        if profileVM.showCompletedLectureListError {
                            EmptyViewWithRetryButton {
                                profileVM.debouncedRequestCompletedLectureList()
                            }
                        } else {
                            if profileVM.isCompleteLectureListIsEmpty {
                                EmptyViewWithNoError(title: "아직 완료한 학습 컨텐츠가 없어요")
                            } else {
                                ProfileContent(profileVM.completedLectureList[0].title, overlayTitle: "학습 완료:")
                            }
                        }
                        
                        if profileVM.showBookmarkedLectureListError {
                            EmptyViewWithRetryButton {
                                profileVM.debouncedRequestBookmarkedLectureList()
                            }
                        } else {
                            if profileVM.isBookmarkedLectureListIsEmtpy {
                                EmptyViewWithNoError(title: "보관한 학습 컨텐츠가 없어요")
                            } else {
                                ProfileContent(profileVM.bookmarkedLectureList[0].title, overlayTitle: "보관 완료:")
                            }
                        }
                    }
                    .padding(.vertical, 8)
                })
                .backgroundStyle(Color.backgroundColor)
                
                GroupBox(label: HStack {
                    Text("퀴즈 근황")
                        .font(.custom(Setup.FontName.notoSansBold, size: 20))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 5)
                    NavigationLink {
                        UserQuizListView(profileVM: profileVM, isLoginAvailable: $tabViewsVM.isLoginAvailable)
                    } label: {
                        Text("더 보기")
                            .font(.custom(Setup.FontName.notoSansRegular, size: 15))
                    }
                    .padding(.trailing, 5)
                }, content: {
                    VStack {
                        if profileVM.showTakenQuizListError {
                            EmptyViewWithRetryButton {
                                profileVM.debouncedRequestTakenQuizList()
                            }
                        } else {
                            if profileVM.isTakenQuizListIsEmpty {
                                EmptyViewWithNoError(title: "아직 푼 퀴즈가 있지 않아요")
                            } else {
                                ProfileContent(profileVM.takenQuizList[0].title, overlayTitle: "문제 풀이 완료:")
                            }
                        }
                        if profileVM.showBookmarkedQuizListError {
                            EmptyViewWithRetryButton {
                                profileVM.debouncedRequestBookmarkedQuizList()
                            }
                        } else {
                            if profileVM.isBookmarkedQuizListIsEmtpy {
                                EmptyViewWithNoError(title: "보관한 퀴즈가 없어요")
                            } else {
                                ProfileContent(profileVM.bookmarkedQuizList[0].question, overlayTitle: "보관 완료:")
                            }
                        }
                    }
                })
                .backgroundStyle(Color.backgroundColor)
                
                GroupBox(label: Text("인터뷰 현황"), content: {
                    VStack {
                        Text("구독 AI 인터뷰 진행 상황 나타내기")
                            .font(.custom(Setup.FontName.notoSansBold, size: 20))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 5)
                    }
                })
                .backgroundStyle(Color.backgroundColor)
                
                GroupBox(label:
                            HStack {
                    Text("획득한 도전 과제")
                        .font(.custom(Setup.FontName.notoSansBold, size: 20))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 5)
                    NavigationLink {
                        TrophyListView(profileVM: profileVM)
                    } label: {
                        Text("더 보기")
                            .font(.custom(Setup.FontName.notoSansRegular, size: 15))
                    }
                    .padding(.trailing, 5)
                }, content: {
                    VStack {
                        if profileVM.showLatestAcquiredTrophyError {
                            EmptyViewWithRetryButton {
                                profileVM.debouncedRequestLatestAcquiredTrophy()
                            }
                        } else {
                            if profileVM.isLatestAcquiredTrophyEmpty {
                                EmptyViewWithNoError(title: "아직 획득한 트로피가 없어요")
                            } else {
                                //MARK: - 트로피 영역 가장 최근 획득한 트로피 보여주기
                                Text("test")
                            }
                        }
                    }
                })
                .backgroundStyle(Color.backgroundColor)
                
                Spacer()
                
                VStack(alignment: .center, spacing: 15) {
                    ShrinkAnimationButtonView(title: Setup.ContentStrings.Profile.signOutTitle, font: Setup.FontName.galMuri11Bold, color: Color.brandBlandColor) {
                        profileVM.showLogoutAlert.toggle()
                    }
                    .alert(Setup.ContentStrings.Profile.signOutTitle, isPresented: $profileVM.showLogoutAlert, actions: {
                        Button(Setup.ContentStrings.confirm, role: .cancel) {
                            profileVM.debouncedSignOut()
                        }
                        Button(Setup.ContentStrings.cancel, role: .destructive) { }
                    }, message: {
                        Text("정말로 로그아웃 하실 건가요?")
                    })
                    .alert("로그아웃 성공!", isPresented: $profileVM.showLogoutSucceedAlert, actions: {
                        Button {
                            tabViewsVM.userLoginStatusUpdate.send(false)
                        } label: {
                            Text(Setup.ContentStrings.confirm)
                        }
                    }, message: {
                        Text("로그인 화면으로 이동합니다.")
                    })
                    .alert("로그아웃 에러!", isPresented: $profileVM.showLogoutErrorAlert) {
                        ErrorAlertConfirmButton { }
                    } message: {
                        Text("로그아웃에 실패했습니다. 다시 시도해주세요.")
                    }

                    ShrinkAnimationButtonView(title: Setup.ContentStrings.Profile.withdrawTitle, font: Setup.FontName.galMuri11Bold, color: Color.errorHighlightColor) {
                        profileVM.showWithdrawAlert.toggle()
                    }
                    .alert(Setup.ContentStrings.Profile.withdrawTitle, isPresented: $profileVM.showWithdrawAlert, actions: {
                        Button(Setup.ContentStrings.confirm, role: .cancel) {
                            profileVM.showWithdrawWithEmailTextfieldAlert.toggle()
                        }
                        Button(Setup.ContentStrings.cancel, role: .destructive) { }
                    }, message: {
                        Text("정말로 탈퇴하실 건가요?")
                    })
                    .alert("회원 탈퇴 확인", isPresented: $profileVM.showWithdrawWithEmailTextfieldAlert, actions: {
                        TextField("가입한 이메일", text: $profileVM.emailToBeWithdrawn, prompt: Text(tabViewsVM.profileData?.email ?? "Email"))
                            .foregroundStyle(Color.black)
                        Button(Setup.ContentStrings.confirm, role: .cancel) {
                            if profileVM.emailToBeWithdrawn.isEmpty {
                                profileVM.showEmailWithdrawalErrorAlert = true
                            } else {
                                profileVM.debouncedWithdraw()
                            }
                        }
                        Button(Setup.ContentStrings.cancel, role: .destructive) {
                            profileVM.emailToBeWithdrawn.removeAll()
                        }
                    }, message: {
                        Text("정말 탈퇴하실 의향이시라면 가입한 이메일을 입력해주세요.")
                    })
                    .alert("잘못된 입력입니다!", isPresented: $profileVM.showEmailWithdrawalErrorAlert) {
                        //탈퇴의 불편함 일부러 제공 (탈퇴 유도 막기...)
                        Button(Setup.ContentStrings.confirm, role: .cancel) { }
                    }
                    .alert("탈퇴 실패", isPresented: $profileVM.showWithdrawErrorAlert, actions: {
                        ErrorAlertConfirmButton { }
                    }, message: {
                        Text("회원 탈퇴에 실패했습니다. 다시 시도해주세요.")
                    })
                    .alert("탈퇴 완료", isPresented: $profileVM.showWithdrawSucceedAlert, actions: {
                        Button {
                            tabViewsVM.userLoginStatusUpdate.send(false)
                        } label: {
                            Text(Setup.ContentStrings.confirm)
                        }
                    }, message: {
                        Text("회원 탈퇴 절차에 완료했습니다. 30일 이후 완전히 탈퇴처리되며, 그 이전에는 비활성화 유저로 관리됩니다. 감사합니다.")
                    })
                }
                .padding(.vertical, 4)
            }
            .frame(maxWidth: .infinity)
            .background(Color.backgroundColor)
            .navigationTitle(Setup.ContentStrings.profileTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.backgroundColor, for: .navigationBar, .tabBar)
            .alert("네트워크 오류!", isPresented: $profileVM.showUnknownNetworkErrorAlert, actions: {
                ErrorAlertConfirmButton { }
            }, message: {
                Text("네트워크 요청에 실패했습니다! 다시 시도해주세요!")
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
