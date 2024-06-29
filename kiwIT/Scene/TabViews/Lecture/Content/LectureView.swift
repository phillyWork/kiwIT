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
    
    //MARK: - 오른쪽 Button: 완료 및 보관함 버튼
    //MARK: - 완료 버튼: Alert로 Example 문제와 O, X 버튼 --> 정답 여부 alert --> 확인 시 학습 완료 및 webview 닫기
    //MARK: - 보관함 버튼: 해당 학습 컨텐츠 보관하기 처리
    
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
                Button(action: {
                    dismiss()
                }, label: {
                    Image(systemName: Setup.ImageStrings.defaultXMark2)
                })
                .tint(Color.textColor)
            }
            ToolbarItemGroup(placement: .primaryAction) {
                Button(action: {
                    lectureVM.showLectureExampleAlert = true
                }, label: {
                    Text("학습 완료")
                })
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
                        Text("확인")
                    }
                } message: {
                    Text(lectureVM.checkExampleAnswer() ? "참 잘했어요!" : "정답은 \(lectureVM.lectureContent?.answer)입니다.")
                }
                
                Button(action: {
                    print("bookmark this lecture!!!")
                    lectureVM.isThisLectureBookmarked.toggle()
                    
                    //MARK: - 버튼 누를 때마다 bookmark 처리 함수 호출 --> Debounce 혹은 throttle 활용 방안?
                    
                }, label: {
                    Image(systemName: lectureVM.isThisLectureBookmarked ? Setup.ImageStrings.bookmarked : Setup.ImageStrings.bookmarkNotYet)
                })
            }
        }
        .alert("학습 시작 오류!!!", isPresented: $lectureVM.showStartLectureErrorAlertToDismiss, actions: {
            Button(action: {
                dismiss()
            }, label: {
                Text("확인")
                    .foregroundStyle(Color.errorHighlightColor)
            })
        }, message: {
            Text("컨텐츠를 불러오는 데 오류가 발생했습니다. 다시 시도해주세요.")
        })
        .alert("학습 완료 오류!!!", isPresented: $lectureVM.showCompleteLectureErrorAlertToRetry, actions: {
            Button(action: {
//                lectureVM.showCompleteLectureErrorAlertToRetry = false
            }, label: {
                Text("확인")
                    .foregroundStyle(Color.errorHighlightColor)
            })
        }, message: {
            Text("학습 완료 처리에 실패했습니다. 다시 시도해주세요.")
        })
        .alert("예제 제출 오류!!!", isPresented: $lectureVM.showSubmitExerciseErrorAlertToRetry, actions: {
            Button(action: {
                self.lectureVM.showExampleAnswerAlert = true
            }, label: {
                Text("확인")
                    .foregroundStyle(Color.errorHighlightColor)
            })
        }, message: {
            Text("예제 풀이 등록에 실패했습니다. 다시 시도해주세요.")
        })
        .alert("로그인 오류!", isPresented: $lectureVM.shouldLoginAgain, actions: {
            Button(action: {
                isLoginAvailable = false
            }, label: {
                Text("확인")
                    .foregroundStyle(Color.errorHighlightColor)
            })
        }, message: {
            Text("세션이 만료되어 다시 로그인해주세요!")
        })
        .onChange(of: lectureVM.lectureStudyAllDone) { newValue in
            if newValue {
                dismiss()
            }
        }
    }
}
