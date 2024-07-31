//
//  LectureView.swift
//  kiwIT
//
//  Created by Heedon on 3/19/24.
//

import SwiftUI

struct LectureView: View {
    
    @StateObject var lectureVM: LectureViewModel
    @Binding var isLoginAvailable: Bool
    @Environment(\.dismiss) private var dismiss
        
    init(contentId: Int, isLoginAvailable: Binding<Bool>) {
        _lectureVM = StateObject(wrappedValue: LectureViewModel(contentId: contentId))
        self._isLoginAvailable = isLoginAvailable
    }
    
    var body: some View {
        VStack {
            ZStack {
                ZStack {
                    if let lectureContent = lectureVM.lectureContent {
                        CustomWebView(isLoading: $lectureVM.showProgressViewForLoadingWeb, urlString: lectureContent.payloadUrl)
                        if lectureVM.showProgressViewForLoadingWeb {
                            ProgressView {
                                Text("컨텐츠 불러오는 중...")
                            }
                            .scaleEffect(1.5, anchor: .center)
                        }
                    }
                }
                .animation(.easeInOut, value: lectureVM.showProgressViewForLoadingWeb)
                
                TrophyPageTabView(trophyList: lectureVM.acquiredTrophyList, buttonAction: {
                    lectureVM.handleAfterCloseNewAcquiredTrophyCard()
                })
                .opacity(lectureVM.acquiredTrophyList.isEmpty ? 0 : 1)
                
            }
        }
        .background(Color.backgroundColor)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: Setup.ImageStrings.defaultXMark2)
                }
                .tint(Color.textColor)
                .disabled(lectureVM.isCompleteStudyButtonDisabled)
            }
            ToolbarItemGroup(placement: .primaryAction) {
                Button {
                    lectureVM.debounceToRequestCompleteLecture()
                } label: {
                    Text(lectureVM.isThisLectureStudiedBefore ? "예제 보기" : "학습 완료")
                }
                .disabled(lectureVM.isCompleteStudyButtonDisabled)
                .alert(Setup.ContentStrings.exampleQuestionsAlertTitle, isPresented: $lectureVM.showLectureExampleAlert) {
                    Button(role: .cancel) {
                        lectureVM.updateAnswerAsTrue()
                    } label: {
                        Text("O")
                    }
                    Button(role: .destructive) {
                        lectureVM.updateAnswerAsFalse()
                    } label: {
                        Text("X")
                    }
                } message: {
                    Text(lectureVM.lectureContent?.exercise ?? "본문 예제 문제입니다")
                }
                .alert(lectureVM.checkExampleAnswer() ? "정답입니다!" : "오답입니다!", isPresented: $lectureVM.showExampleAnswerAlert) {
                    Button(role: .cancel) {
                        lectureVM.requestSubmitExerciseAnswer()
                    } label: {
                        Text(Setup.ContentStrings.confirm)
                    }
                } message: {
                    Text(lectureVM.checkExampleAnswer() ? "참 잘했어요!" : "정답은 \(lectureVM.lectureContent?.answer)입니다.")
                }
                .alert(Setup.ContentStrings.bookmarkThisLectureAlertTitle, isPresented: $lectureVM.showBookmarkThisLectureForFirstTimeAlert) {
                    Button(role: .cancel) {
                        lectureVM.debounceToRequestBookmarkLecture()
                        lectureVM.lectureStudyAllDone = true
                    } label: {
                        Text("네")
                    }
                    Button {
                        lectureVM.lectureStudyAllDone = true
                    } label: {
                        Text("아니요")
                    }
                } message: {
                    Text("학습 자료를 보관함에 넣을까요?")
                }
                
                if lectureVM.isThisLectureStudiedBefore {
                    Button {
                        lectureVM.debounceToRequestBookmarkLecture()
                    } label: {
                        Image(systemName: lectureVM.isThisLectureBookmarked ? Setup.ImageStrings.bookmarked : Setup.ImageStrings.bookmarkNotYet)
                    }
                }
            }
        }
        .alert(Setup.ContentStrings.unknownNetworkErrorAlertTitle, isPresented: $lectureVM.showUnknownNetworkErrorAlert, actions: {
            ErrorAlertConfirmButton { }
        }, message: {
            Text(Setup.ContentStrings.unknownNetworkErrorAlertMessage)
        })
        .alert(Setup.ContentStrings.startLectureErrorAlertTitle, isPresented: $lectureVM.showStartLectureErrorAlertToDismiss, actions: {
            ErrorAlertConfirmButton {
                dismiss()
            }
        }, message: {
            Text("컨텐츠를 불러오는 데 오류가 발생했습니다. 다시 시도해주세요.")
        })
        .alert(Setup.ContentStrings.completeLectureErrorAlertTitle, isPresented: $lectureVM.showCompleteLectureErrorAlertToRetry, actions: {
            ErrorAlertConfirmButton { }
        }, message: {
            Text("학습 완료 처리에 실패했습니다. 다시 시도해주세요.")
        })
        .alert(Setup.ContentStrings.submitLectureExampleErrorAlertTitle, isPresented: $lectureVM.showSubmitExerciseErrorAlertToRetry, actions: {
            ErrorAlertConfirmButton {
                lectureVM.showExampleAnswerAlert = true
            }
        }, message: {
            Text("예제 풀이 등록에 실패했습니다. 다시 시도해주세요.")
        })
        .alert(Setup.ContentStrings.loginErrorAlertTitle, isPresented: $lectureVM.shouldLoginAgain, actions: {
            ErrorAlertConfirmButton {
                isLoginAvailable = false
            }
        }, message: {
            Text(Setup.ContentStrings.loginErrorAlertMessage)
        })
        .alert(Setup.ContentStrings.bookmarkErrorAlertTitle, isPresented: $lectureVM.showBookmarkErrorAlert, actions: {
            ErrorAlertConfirmButton { }
        }, message: {
            Text("보관함 처리에 실패했습니다. 다시 시도해주세요.")
        })
        .onChange(of: lectureVM.lectureStudyAllDone) { newValue in
            print("lectureStudyAllDone is set to \(newValue)")
            if newValue {
                dismiss()
            }
        }
        .onDisappear {
            lectureVM.cleanUpCancellables()
        }
    }
}
