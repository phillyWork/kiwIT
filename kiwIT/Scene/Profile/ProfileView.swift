//
//  ProfileView.swift
//  kiwIT
//
//  Created by Heedon on 3/11/24.
//

import SwiftUI

struct ProfileView: View {
    
    @State private var nickname: String = "Test Nickname"
    @State private var showEditNicknameAlert = false
    @State private var showNicknameErrorAlert = false
    @State private var nicknameToBeUpdated = ""
    
    @State private var showLogoutAlert = false
    
    @State private var showWithdrawAlert = false
    @State private var showRealWithdrawAlert = false
    @State private var emailToBeWithdrawn = ""
    @State private var showEmailWithdrawalErrorAlert = false
        
    @Environment(\.dismiss) var dismiss
    
    
    //from user data (acquired trophy data)
    let tempUserAcquiredTrophyData = [
        AcquiredTrophy(id: "aaa123", trophy: TrophyEntity(id: "111111111", title: "지금까지의 노력, 최고에요!", imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQHZCbqRAGGwuZYEDajBgZx1zUgTdqBwfwVZw&s"), createdAt: "2024-02-11", updatedAt: "2024-05-23"),
        AcquiredTrophy(id: "aaa123", trophy: TrophyEntity(id: "333333333", title: "그대의 노력에 건배", imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQHZCbqRAGGwuZYEDajBgZx1zUgTdqBwfwVZw&s"), createdAt: "2024-02-11", updatedAt: "2024-05-23")
    ]

    
    var body: some View {
        NavigationStack {
            ScrollView {
                   
                HStack {
                    Text(nickname)
                        .font(.custom(Setup.FontName.notoSansBold, size: 20))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 5)
                    //수정 버튼
                    Button(action: {
                        showEditNicknameAlert.toggle()
                    }, label: {
                        Text("변경하기")
                    })
                    .padding(.trailing, 5)
                    .alert("닉네임 수정", isPresented: $showEditNicknameAlert) {
                        TextField("새로운 닉네임을 입력해주세요.", text: $nicknameToBeUpdated)
                            .foregroundStyle(Color.black)
                        Button("취소", role: .destructive) {
                            nicknameToBeUpdated = ""
                            dismiss()
                        }
                        Button("확인", role: .cancel) {
                            if nicknameToBeUpdated.isEmpty {
                                showNicknameErrorAlert = true
                            } else {
                                //Network call: update nickname
                                
                                nickname = nicknameToBeUpdated
                                nicknameToBeUpdated = ""
                            }
                        }
                    }
                    .alert("오류", isPresented: $showNicknameErrorAlert, actions: {
                        Button("확인", role: .cancel) {
                            showEditNicknameAlert = true
                        }
                    }, message: {
                        Text("빈 칸은 허용되지 않습니다.")
                    })
                }
                .border(Color.blue)

                Spacer()
                
                GroupBox {
                    VStack {
                        Text("카테고리별 학습 진도율 나타내기")
                        Text("레벨별? 학습 진도율 나타내기")
                        
                    }
                }
                
                
                Spacer()
                
                GroupBox {
                    VStack {
                        Text("기본 퀴즈 진행 상황 나타내기")
                        Text("구독 퀴즈 진행 상황 나타내기")
                    }
                }
                
                Spacer()
                
                GroupBox {
                    VStack {
                        Text("구독 AI 인터뷰 진행 상황 나타내기")
                    }
                }
                
                Spacer()
                
                GroupBox {
                    VStack {
                        HStack {
                            Text("획득한 도전 과제")
                            
                            NavigationLink {
                                TrophyListView()
                            } label: {
                                Text("더 보기")
                            }
                        }

                        HStack {
                            
                            ForEach(tempUserAcquiredTrophyData) { trophyData in
                                RecentlyAcquiredTrophy(tempImageUrlString: trophyData.trophy.imageUrl)
                            }
                            
                            if (tempUserAcquiredTrophyData.count < 5) {
                                //5개 안되는 경우: 나머지는 빈칸 이미지로 나타내기
                                //warning: 고정값 활용 필요 --> 빈 개수만큼 빈 트로피 entity 따로 만들기?
                                let count = 5 - tempUserAcquiredTrophyData.count
                                ForEach(0..<count) { num in
                                    RecentlyAcquiredTrophy(tempImageUrlString: "https://i.pinimg.com/474x/9f/d2/eb/9fd2eb8b2481dfaa37bc669c9d2b9fb4.jpg")
                                }
                            }
                        }
                    }
                }
                
                Spacer()
                
                
                //버튼 이미지 View 따로 활용
                //closure 활용, viewmodel로 전달하기
                
                GroupBox {
                    
                    VStack {
                        Button(action: {
                            showLogoutAlert.toggle()
                        }, label: {
                            Text("로그아웃")
                        })
                        .alert("회원 탈퇴", isPresented: $showLogoutAlert, actions: {
                            Button("확인", role: .cancel) {
                                //network: logout call
                                
                                print("LOG OUT!!!!")
                                
                                //로그인 화면 나타내기
                                
                            }
                            Button("취소", role: .destructive) {
                                dismiss()
                            }
                        }, message: {
                            Text("정말로 로그아웃 하실 건가요?")
                        })
                        
                        Button(action: {
                            showWithdrawAlert.toggle()
                        }, label: {
                            Text("회원 탈퇴")
                        })
                        .alert("회원 탈퇴", isPresented: $showWithdrawAlert, actions: {
                            Button("확인", role: .cancel) {
                                showRealWithdrawAlert.toggle()
                            }
                            Button("취소", role: .destructive) {
                                dismiss()
                            }
                        }, message: {
                            Text("정말로 탈퇴하실 건가요?")
                        })
                        .alert("회원 탈퇴 확인", isPresented: $showRealWithdrawAlert, actions: {
                            TextField("가입한 이메일", text: $emailToBeWithdrawn)
                                .foregroundStyle(Color.black)
                            Button("확인", role: .cancel) {
                                
                                //가입한 이메일과 다르다면 에러 나타내기
                                
                                if emailToBeWithdrawn.isEmpty {
                                    showEmailWithdrawalErrorAlert = true
                                } else {
                                    //network: 회원 탈퇴 시도하기
                                    print("Network Call to Withdraw")
                                    
                                    //로그인 화면 나타내기
                                    
                                    emailToBeWithdrawn = ""
                                }
                            }
                            Button("취소", role: .destructive) {
                                emailToBeWithdrawn = ""
                                dismiss()
                            }
                        }, message: {
                            Text("정말 탈퇴하실 의향이시라면 가입한 이메일을 입력해주세요.")
                        })
                        .alert("잘못된 입력입니다!", isPresented: $showEmailWithdrawalErrorAlert) {
                            Button("확인", role: .cancel) {
                                //탈퇴의 불편함 일부러 제공 (탈퇴 유도 막기...)
                                dismiss()
                            }
                        }
                        
                    }
                }
                
            }
            .frame(maxWidth: .infinity)
            .background(Color.backgroundColor)
            .navigationTitle("프로필 정보")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.backgroundColor, for: .navigationBar, .tabBar)
        }
        .refreshable {
            print("Pull to Refresh Profile Data!!!")
            
        }
    }
}

#Preview {
    ProfileView()
}
