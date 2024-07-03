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
                HStack {
                    Text(tabViewsVM.profileData?.nickname ?? "Anonymous User")
                        .font(.custom(Setup.FontName.notoSansBold, size: 20))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 10)
                    Button {
                        profileVM.showEditNicknameAlert.toggle()
                    } label: {
                        Text("변경하기")
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
                                profileVM.updateNickname()
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
                .padding(.bottom, 5)
                
                Spacer()
                
                //MARK: - 학습 완료 및 북마크 컨텐츠 보여주기
                
                //MARK: - 학습 완료한 컨텐츠 3 ~ 5개 보여주기, 더보기 --> View 이동: 완료한 컨텐츠 보여주기, 누르면 학습 화면으로 이동
                
                //MARK: - 북마크 한 컨텐츠 목록 보여주고 더보기 --> View 이동: 북마크한 컨텐츠, 누르면 학습 화면으로 이동
                //MARK: - 학습 완료되면 학습 완료한 컨텐츠 목록에도 추가하기
                
                GroupBox(label: Text("학습 진도율").font(.custom(Setup.FontName.phuduRegular, size: 20)), content: {
                    VStack {
                        
                        
                        Text("레벨별? 학습 진도율 나타내기 (Header 역할)")
                    }
                    .padding(.vertical, 8)
                })
                .backgroundStyle(Color.surfaceColor)
                
                Spacer()
                
                //MARK: - 완료한 퀴즈 그룹 목록 및 북마크 한 퀴즈 나타내기
                
                //MARK: - 완료한 퀴즈 기록 최근 5개 보여주기 --> 더보기: View 이동, 과거 기록 보여주기
                
                //MARK: - 북마크 한 퀴즈 목록 5개 보여주기 --> 더보기: View 이동, 퀴즈 개별 목록 답변과 같이 보여주기 (유저 답변은 보여주지 않기)
                
                
                GroupBox(label: Text("퀴즈 현황"), content: {
                    VStack {
                        Text("기본 퀴즈 진행 상황 나타내기 (Header 역할)")
                        
                        
                    }
                })
                .backgroundStyle(Color.surfaceColor)
                
                Spacer()
                
                GroupBox(label: Text("인터뷰 현황"), content: {
                    VStack {
                        Text("구독 AI 인터뷰 진행 상황 나타내기 (Header 역할)")
                        

                        
                    }
                })
                .backgroundStyle(Color.surfaceColor)
                
                Spacer()
                
                GroupBox(label:
                            HStack {
                    Text("획득한 도전 과제")
                    NavigationLink {
                        TrophyListView()
                    } label: {
                        Text("더 보기")
                    }
                }, content: {
                    HStack {
                        
                    Text("test")
                        
                    }
                })
                .backgroundStyle(Color.surfaceColor)
                
                VStack {
                    ShrinkAnimationButtonView(title: Setup.ContentStrings.Profile.signOutTitle, color: Color.brandBlandColor) {
                        profileVM.showLogoutAlert.toggle()
                    }
                    .alert(Setup.ContentStrings.Profile.signOutTitle, isPresented: $profileVM.showLogoutAlert, actions: {
                        Button(Setup.ContentStrings.confirm, role: .cancel) {
                            profileVM.signOut()
                        }
                        Button(Setup.ContentStrings.cancel, role: .destructive) { }
                    }, message: {
                        Text("정말로 로그아웃 하실 건가요?")
                    })
                    .alert("로그아웃 성공!", isPresented: $profileVM.showLogoutSucceedAlert, actions: {
                        Button {
                            tabViewsVM.isLoginAvailable = false
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

                    Spacer()
                    
                    ShrinkAnimationButtonView(title: Setup.ContentStrings.Profile.withdrawTitle, color: Color.errorHighlightColor) {
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
                        TextField("가입한 이메일", text: $profileVM.emailToBeWithdrawn)
                            .foregroundStyle(Color.black)
                        Button(Setup.ContentStrings.confirm, role: .cancel) {
                            if profileVM.emailToBeWithdrawn.isEmpty {
                                profileVM.showEmailWithdrawalErrorAlert = true
                            } else {
                                profileVM.withdraw()
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
                            tabViewsVM.isLoginAvailable = false
                        } label: {
                            Text(Setup.ContentStrings.confirm)
                        }
                    }, message: {
                        Text("회원 탈퇴 절차에 완료했습니다. 30일 이후 완전히 탈퇴처리되며, 그 이전에는 비활성화 유저로 관리됩니다. 감사합니다.")
                    })
                }
                .padding(.top, 8)
            }
            .frame(maxWidth: .infinity)
            .background(Color.backgroundColor)
            .navigationTitle(Setup.ContentStrings.profileTitle)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.backgroundColor, for: .navigationBar, .tabBar)
            .alert(Setup.ContentStrings.loginErrorAlertTitle, isPresented: $profileVM.showSessionExpiredAlert, actions: {
                ErrorAlertConfirmButton {
                    tabViewsVM.isLoginAvailable = false
                }
            }, message: {
                Text(Setup.ContentStrings.loginErrorAlertMessage)
            })
        }
        .refreshable {
            print("Pull to Refresh Profile Data!!!")
            
        }
    }
}

#Preview {
    ProfileView(tabViewsVM: TabViewsViewModel())
}
