//
//  LectureView.swift
//  kiwIT
//
//  Created by Heedon on 3/19/24.
//

import SwiftUI

struct LectureView: View {
    
    @StateObject var lectureVM: LectureViewModel
    @ObservedObject var lectureContentListVM: LectureContentListViewModel
    
    @Binding var isLoginAvailable: Bool
    
    @Environment(\.dismiss) private var dismiss
    
    init(lectureContentListVM: LectureContentListViewModel, contentId: Int, isLoginAvailable: Binding<Bool>) {
        self.lectureContentListVM = lectureContentListVM
        _lectureVM = StateObject(wrappedValue: LectureViewModel(contentId: contentId))
        self._isLoginAvailable = isLoginAvailable
    }
    
    var body: some View {
        VStack {
            ZStack {
                if let url = lectureVM.lectureContent?.payloadUrl {
                    WebViewSetup(isLoading: $lectureVM.showProgressViewForLoadingWeb, urlString: url)
                        .opacity(lectureVM.showProgressViewForLoadingWeb ? 0 : 1)
                    if lectureVM.showProgressViewForLoadingWeb {
                        ProgressView {
                            Text("컨텐츠 가져오는 중")
                        }
                        .scaleEffect(1.5, anchor: .center)
                    }
                }
            }
            .animation(.easeInOut, value: lectureVM.showProgressViewForLoadingWeb)
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
            }
            ToolbarItemGroup(placement: .primaryAction) {
                
                //MARK: - 여러번 눌리지 않도록 처리?
                
                Button {
                    lectureVM.requestCompleteLectureContent()
                } label: {
                    Text("학습 완료")
                }
                .alert("학습 확인 문제", isPresented: $lectureVM.showLectureExampleAlert) {
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
                        Text(lectureVM.lectureContent?.exercise ?? "예시 문제입니다")
                }
                .alert(lectureVM.checkExampleAnswer() ? "정답입니다!" : "오답입니다!", isPresented: $lectureVM.showExampleAnswerAlert){
                    Button(role: .cancel) {
                        lectureVM.requestSubmitExerciseAnswer()
                    } label: {
                        Text(Setup.ContentStrings.confirm)
                    }
                } message: {
                    Text(lectureVM.checkExampleAnswer() ? "참 잘했어요!" : "정답은 \(lectureVM.lectureContent?.answer)입니다.")
                }
                
                Button {
                    lectureVM.requestBookmarkThisLecture()
                } label: {
                    Image(systemName: lectureVM.isThisLectureBookmarked ? Setup.ImageStrings.bookmarked : Setup.ImageStrings.bookmarkNotYet)
                }
            }
        }
        .alert("학습 시작 오류!!!", isPresented: $lectureVM.showStartLectureErrorAlertToDismiss, actions: {
            ErrorAlertConfirmButton {
                dismiss()
            }
        }, message: {
            Text("컨텐츠를 불러오는 데 오류가 발생했습니다. 다시 시도해주세요.")
        })
        .alert("학습 완료 오류!!!", isPresented: $lectureVM.showCompleteLectureErrorAlertToRetry, actions: {
            ErrorAlertConfirmButton {
//                lectureVM.showCompleteLectureErrorAlertToRetry = false
            }
        }, message: {
            Text("학습 완료 처리에 실패했습니다. 다시 시도해주세요.")
        })
        .alert("예제 제출 오류!!!", isPresented: $lectureVM.showSubmitExerciseErrorAlertToRetry, actions: {
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
        .alert("북마크 오류!", isPresented: $lectureVM.showBookmarkErrorAlert, actions: {
            ErrorAlertConfirmButton { }
        }, message: {
            Text("보관함 처리에 실패했습니다. 다시 시도해주세요.")
        })
        .onChange(of: lectureVM.lectureStudyAllDone) { newValue in
            if newValue {
                dismiss()
            }
        }
    }
}
