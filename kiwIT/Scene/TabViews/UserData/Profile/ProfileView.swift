//
//  ProfileView.swift
//  kiwIT
//
//  Created by Heedon on 3/11/24.
//

import SwiftUI

//MARK: - Profile: 유저 닉네임, 학습 진도율 (학습 완료 콘텐츠 리스트, 전체 대비), 퀴즈 진도율 (퀴즈 완료 그룹 리스트, 전체 대비), 트로피 획득 내역 (전체 대비), 로그아웃, 회원탈퇴
struct ProfileView: View {
    
//    @StateObject var profileVM = ProfileViewModel()
    @StateObject var profileVM: ProfileViewModel
    @ObservedObject var tabViewsVM: TabViewsViewModel
    
    init(tabViewsVM: TabViewsViewModel) {
        _tabViewsVM = ObservedObject(wrappedValue: tabViewsVM)
        let profileVM = ProfileViewModel { updatedProfile in
            tabViewsVM.updateProfileFromProfileView(updatedProfile)
        }
        _profileVM = StateObject(wrappedValue: profileVM)
    }
    
    //Lecture, Quiz 및 여러 컨텐츠 기본 개수 및 진도 현황 관련 유저 데이터 가져와서 활용해야 함
    
    @State private var tempBasicITCategory = [
        LectureContent(id: 111, title: "교양예시1", point: 100, exercise: "연습문제1", answer: true, levelNum: 2, categoryChapterId: 111333111333),
        LectureContent(id: 112, title: "교양예시2", point: 100, exercise: "연습문제2", answer: false, levelNum: 1, categoryChapterId: 111333111333),
        LectureContent(id: 113, title: "교양예시3", point: 100, exercise: "연습문제3", answer: true, levelNum: 3, categoryChapterId: 111333111333),
        LectureContent(id: 114, title: "교양예시4", point: 100, exercise: "연습문제4", answer: true, levelNum: 0, categoryChapterId: 111333111333),
        LectureContent(id: 115, title: "교양예시5", point: 100, exercise: "연습문제5", answer: true, levelNum: 1, categoryChapterId: 111333111333),
        LectureContent(id: 116, title: "교양예시6", point: 100, exercise: "연습문제6", answer: true, levelNum: 2, categoryChapterId: 111333111333),
    ]
    
    @State private var tempUserTakenBasicITCategory = [
        LectureContent(id: 111, title: "교양예시1", point: 100, exercise: "연습문제1", answer: true, levelNum: 2, categoryChapterId: 111333111333),
        LectureContent(id: 112, title: "교양예시2", point: 100, exercise: "연습문제2", answer: false, levelNum: 1, categoryChapterId: 111333111333),
    ]
    
    
    //from user data (acquired trophy data)
    var tempUserAcquiredTrophyData = [
        AcquiredTrophy(id: "aaa123", trophy: TrophyEntity(id: "111111111", title: "지금까지의 노력, 최고에요!", imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQHZCbqRAGGwuZYEDajBgZx1zUgTdqBwfwVZw&s"), createdAt: "2024-02-11", updatedAt: "2024-05-23"),
        AcquiredTrophy(id: "aaa123", trophy: TrophyEntity(id: "333333333", title: "그대의 노력에 건배", imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQHZCbqRAGGwuZYEDajBgZx1zUgTdqBwfwVZw&s"), createdAt: "2024-02-11", updatedAt: "2024-05-23")
    ]
    
    //acquired가 5개 안되는 경우
    var tempEmptyTrophy = [
        TrophyEntity(id: "zzzzzz", title: "빈 트로피", imageUrl: "https://i.pinimg.com/474x/9f/d2/eb/9fd2eb8b2481dfaa37bc669c9d2b9fb4.jpg"),
        TrophyEntity(id: "zzzzzz", title: "빈 트로피", imageUrl: "https://i.pinimg.com/474x/9f/d2/eb/9fd2eb8b2481dfaa37bc669c9d2b9fb4.jpg"),
        TrophyEntity(id: "zzzzzz", title: "빈 트로피", imageUrl: "https://i.pinimg.com/474x/9f/d2/eb/9fd2eb8b2481dfaa37bc669c9d2b9fb4.jpg"),
    ]

    
    var body: some View {
        NavigationStack {
            ScrollView {
                HStack {
                    Text(tabViewsVM.profileData?.nickname ?? "Anonymous User")
                        .font(.custom(Setup.FontName.notoSansBold, size: 20))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.leading, 10)
                    Button(action: {
                        profileVM.showEditNicknameAlert.toggle()
                    }, label: {
                        Text("변경하기")
                    })
                    .padding(.trailing, 10)
                    .alert("닉네임 수정", isPresented: $profileVM.showEditNicknameAlert) {
                        TextField("타이틀",
                                  text: $profileVM.nicknameInputFromUser,
                                  prompt: Text("새로운 닉네임을 입력해주세요.")
                        )
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .foregroundStyle(Color.black)
                        Button("취소", role: .destructive) {
                            profileVM.nicknameInputFromUser.removeAll()
                        }
                        Button("확인", role: .cancel) {
                            if profileVM.nicknameInputFromUser.isEmpty {
                                profileVM.showNicknameErrorAlert = true
                            } else {
                                profileVM.updateNickname()
                                
//                                profileVM.updateNickname { updatedProfile in
//                                    tabViewsVM.updateProfileFromProfileView(updatedProfile)
//                                    profileVM.nicknameInputFromUser.removeAll()
//                                }
                            }
                        }
                    }
                    .alert("오류", isPresented: $profileVM.showNicknameErrorAlert, actions: {
                        Button("확인", role: .cancel) {
                            profileVM.showEditNicknameAlert = true
                        }
                    }, message: {
                        Text("오류 발생! 다시 시도해주세요.")
                    })
                }
                .padding(.bottom, 5)
                
                Spacer()
                
                GroupBox(label: Text("학습 진도율").font(.custom(Setup.FontName.phuduRegular, size: 20)), content: {
                    VStack {
                        
                        Text("카테고리별 진도율 나타내기 (Header 역할)")
                        
                        ProgressView(value: Double($tempUserTakenBasicITCategory.count) / Double($tempBasicITCategory.count)) {
                            Text("IT교양")
                                .font(.custom(Setup.FontName.notoSansThin, size: 15))
                        }
                        ProgressView(value: Double($tempUserTakenBasicITCategory.count) / Double($tempBasicITCategory.count)) {
                            Text("자료구조 & 알고리즘")
                                .font(.custom(Setup.FontName.notoSansThin, size: 15))
                        }
                        ProgressView(value: Double($tempUserTakenBasicITCategory.count) / Double($tempBasicITCategory.count)) {
                            Text("운영체제")
                                .font(.custom(Setup.FontName.notoSansThin, size: 15))
                        }
                        ProgressView(value: Double($tempUserTakenBasicITCategory.count) / Double($tempBasicITCategory.count)) {
                            Text("컴퓨터구조")
                                .font(.custom(Setup.FontName.notoSansThin, size: 15))
                        }
                        ProgressView(value: Double($tempUserTakenBasicITCategory.count) / Double($tempBasicITCategory.count)) {
                            Text("추가 진도")
                                .font(.custom(Setup.FontName.notoSansThin, size: 15))
                        }
                        
                        Text("레벨별? 학습 진도율 나타내기 (Header 역할)")
                    }
                    .padding(.vertical, 8)
                })
                .backgroundStyle(Color.surfaceColor)
                
                Spacer()
                
                GroupBox(label: Text("퀴즈 현황"), content: {
                    VStack {
                        Text("기본 퀴즈 진행 상황 나타내기 (Header 역할)")
                        ProgressView(value: Double($tempUserTakenBasicITCategory.count) / Double($tempBasicITCategory.count)) {
                            Text("기본 퀴즈 01")
                                .font(.custom(Setup.FontName.notoSansThin, size: 15))
                        }
                        ProgressView(value: Double($tempUserTakenBasicITCategory.count) / Double($tempBasicITCategory.count)) {
                            Text("기본 퀴즈 02")
                                .font(.custom(Setup.FontName.notoSansThin, size: 15))
                        }
                        
                        Text("구독 퀴즈 진행 상황 나타내기 (Header 역할)")
                        ProgressView(value: Double($tempUserTakenBasicITCategory.count) / Double($tempBasicITCategory.count)) {
                            Text("구독 퀴즈 01")
                                .font(.custom(Setup.FontName.notoSansThin, size: 15))
                        }
                    }
                })
                .backgroundStyle(Color.surfaceColor)
                
                Spacer()
                
                GroupBox(label: Text("인터뷰 현황"), content: {
                    VStack {
                        Text("구독 AI 인터뷰 진행 상황 나타내기 (Header 역할)")
                        
                        ProgressView(value: Double($tempUserTakenBasicITCategory.count) / Double($tempBasicITCategory.count)) {
                            Text("Swift 모의 면접 질문 01")
                                .font(.custom(Setup.FontName.notoSansThin, size: 15))
                        }
                        
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
                        ForEach(tempUserAcquiredTrophyData) { trophyData in
                            RecentlyAcquiredTrophy(tempImageUrlString: trophyData.trophy.imageUrl)
                        }
                        if (tempUserAcquiredTrophyData.count < 5) {
                            ForEach(tempEmptyTrophy) { trophy in
                                RecentlyAcquiredTrophy(tempImageUrlString: trophy.imageUrl)
                            }
                        }
                    }
                })
                .backgroundStyle(Color.surfaceColor)
                
                VStack {
                    ShrinkAnimationButtonView(title: "로그아웃", color: Color.brandBlandColor) {
                        profileVM.showLogoutAlert.toggle()
                    }
                    .alert("로그 아웃", isPresented: $profileVM.showLogoutAlert, actions: {
                        Button("확인", role: .cancel) {
                            profileVM.signOut { didSucceed in
                                if didSucceed {
                                    print("LOG OUT!!!!")
                                    //로그인 화면 나타내기
                                    tabViewsVM.isLoginAvailable = false
                                }
                            }
                        }
                        Button("취소", role: .destructive) { }
                    }, message: {
                        Text("정말로 로그아웃 하실 건가요?")
                    })
                    
                    Spacer()
                    
                    ShrinkAnimationButtonView(title: "회원 탈퇴", color: Color.errorHighlightColor) {
                        profileVM.showWithdrawAlert.toggle()
                    }
                    .alert("회원 탈퇴", isPresented: $profileVM.showWithdrawAlert, actions: {
                        Button("확인", role: .cancel) {
                            profileVM.showRealWithdrawAlert.toggle()
                        }
                        Button("취소", role: .destructive) { }
                    }, message: {
                        Text("정말로 탈퇴하실 건가요?")
                    })
                    .alert("회원 탈퇴 확인", isPresented: $profileVM.showRealWithdrawAlert, actions: {
                        TextField("가입한 이메일", text: $profileVM.emailToBeWithdrawn)
                            .foregroundStyle(Color.black)
                        Button("확인", role: .cancel) {
                            
                            //가입한 이메일과 다르다면 에러 나타내기
                            
                            if profileVM.emailToBeWithdrawn.isEmpty {
                                profileVM.showEmailWithdrawalErrorAlert = true
                            } else {
                                //MARK: - WithDraw 메서드 작성
//                                profileVM.withdraw()
                                
                                //로그인 화면 나타내기
                                
                                profileVM.emailToBeWithdrawn.removeAll()
                            }
                        }
                        Button("취소", role: .destructive) {
                            profileVM.emailToBeWithdrawn.removeAll()
                        }
                    }, message: {
                        Text("정말 탈퇴하실 의향이시라면 가입한 이메일을 입력해주세요.")
                    })
                    .alert("잘못된 입력입니다!", isPresented: $profileVM.showEmailWithdrawalErrorAlert) {
                        //탈퇴의 불편함 일부러 제공 (탈퇴 유도 막기...)
                        Button("확인", role: .cancel) { }
                    }
                }
                .padding(.top, 8)
            }
            .frame(maxWidth: .infinity)
            .background(Color.backgroundColor)
            .navigationTitle("프로필 정보")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.backgroundColor, for: .navigationBar, .tabBar)
            .alert("로그인 오류!", isPresented: $profileVM.showSessionExpiredAlert, actions: {
                Button("확인", role: .cancel) {
                    tabViewsVM.isLoginAvailable = false
                }
            }, message: {
                Text("세션이 만료되었어요. 다시 로그인해주세요.")
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
