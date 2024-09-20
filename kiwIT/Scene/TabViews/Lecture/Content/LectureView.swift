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
                                Text(Setup.ContentStrings.Lecture.loadingProgressTitle)
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
                    Text(lectureVM.isThisLectureStudiedBefore ? Setup.ContentStrings.Lecture.showExampleTitle : Setup.ContentStrings.Lecture.confirmStudyCompleteTitle)
                }
                .disabled(lectureVM.isCompleteStudyButtonDisabled)
                .alert(Setup.ContentStrings.exampleQuestionsAlertTitle, isPresented: $lectureVM.showLectureExampleAlert) {
                    Button(role: .cancel) {
                        lectureVM.updateAnswerAsTrue()
                    } label: {
                        Text(Setup.ContentStrings.Quiz.oxTrue)
                    }
                    Button(role: .destructive) {
                        lectureVM.updateAnswerAsFalse()
                    } label: {
                        Text(Setup.ContentStrings.Quiz.oxFalse)
                    }
                } message: {
                    Text(lectureVM.lectureContent?.exercise ?? Setup.ContentStrings.Lecture.defaultExampleQuizMessage)
                }
                .alert(lectureVM.checkExampleAnswer() ? Setup.ContentStrings.Lecture.exampleCorrectAnswerAlertTitle : Setup.ContentStrings.Lecture.exampleWrongAnswerAlertTitle, isPresented: $lectureVM.showExampleAnswerAlert) {
                    Button(role: .cancel) {
                        lectureVM.debounceToRequestSubmitExerciseAnswer()
                    } label: {
                        Text(Setup.ContentStrings.confirm)
                    }
                } message: {
                    Text(lectureVM.checkExampleAnswer() ? "참 잘했어요!" : "정답은 \(lectureVM.lectureContent?.answer)입니다.")
                }
                .alert(Setup.ContentStrings.bookmarkThisLectureAlertTitle, isPresented: $lectureVM.showBookmarkThisLectureForFirstTimeAlert) {
                    Button(role: .cancel) {
                        lectureVM.bookmarkThisLectureAndStudyAllDone()
                    } label: {
                        Text(Setup.ContentStrings.Lecture.confirmBookmarkThisLectureButtonTitle)
                    }
                    Button {
                        lectureVM.sendToUpdateStudyAllDoneStatus(true)
                    } label: {
                        Text(Setup.ContentStrings.Lecture.cancelBookmarkThisLectureButtonTitle)
                    }
                } message: {
                    Text(Setup.ContentStrings.Lecture.bookmarkThisLectureAlertMessage)
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
            Text(Setup.ContentStrings.Lecture.loadingLectureErrorAlertMessage)
        })
        .alert(Setup.ContentStrings.completeLectureErrorAlertTitle, isPresented: $lectureVM.showCompleteLectureErrorAlertToRetry, actions: {
            ErrorAlertConfirmButton { }
        }, message: {
            Text(Setup.ContentStrings.Lecture.completeLectureErrorAlertMessage)
        })
        .alert(Setup.ContentStrings.submitLectureExampleErrorAlertTitle, isPresented: $lectureVM.showSubmitExerciseErrorAlertToRetry, actions: {
            ErrorAlertConfirmButton {
                lectureVM.debounceToRequestSubmitExerciseAnswer()
            }
        }, message: {
            Text(Setup.ContentStrings.Lecture.submitExampleAnswerErrorAlertMessage)
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
            Text(Setup.ContentStrings.Lecture.bookmarkLectureErrorAlertMessage)
        })
        .onChange(of: lectureVM.lectureStudyAllDone) { newValue in
            if newValue {
                dismiss()
            }
        }
        .onDisappear {
            lectureVM.cleanUpCancellables()
        }
    }
}
