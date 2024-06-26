//
//  LectureView.swift
//  kiwIT
//
//  Created by Heedon on 3/19/24.
//

import SwiftUI

struct LectureView: View {
    
    @StateObject var lectureVM = LectureViewModel()
    @ObservedObject var lectureListVM: LectureListViewModel
    
    @Environment(\.dismiss) private var dismiss
    
    //MARK: - 오른쪽 Button: 완료 및 보관함 버튼
    //MARK: - 완료 버튼: Alert로 Example 문제와 O, X 버튼 --> 정답 여부 alert --> 확인 시 학습 완료 및 webview 닫기
    //MARK: - 보관함 버튼: 해당 학습 컨텐츠 보관하기 처리
    
    //userDefaults에 저장한 font size 설정 가져오기
    //없다면 default로 14 설정
    @State private var fontSize: CGFloat = 14
    
    @State private var isPopOverPresented = false
    
    var body: some View {
        VStack {
            WebViewSetup(urlString: lectureVM.url)
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
                    Text("학습 예시 문제입니다 (예시 답안은 X).")
                }
                .alert(lectureVM.checkExampleAnswer() ? "정답입니다!" : "오답입니다!", isPresented: $lectureVM.showExampleAnswerAlert){
                    Button(role: .cancel) {
                        dismiss()
                    } label: {
                        Text("확인")
                    }
                } message: {
                    Text("정답이면 간단 해설, 오답이면 정답 설명하기")
                }
                Button(action: {
                    print("bookmark this lecture!!!")
                    lectureVM.isThisLectureBookmarked.toggle()
                    
                    //MARK: - 버튼 누를 때마다 bookmark 처리 함수 호출 --> Debounce 혹은 throttle 활용 방안?
                    
                }, label: {
                    Image(systemName: lectureVM.isThisLectureBookmarked ? Setup.ImageStrings.bookmarked : Setup.ImageStrings.bookmarkNotYet)
                })
            }
            
            //MARK: - 텍스트 크기 설정: Notion에 어떻게 전달할지 찾아보기
            //MARK: - 찾은 바로는 전달하기 어려워 보임 (노션에서 설정 다르게 하지 않는 이상?)
            
//            ToolbarItem(placement: .topBarTrailing) {
//                Button(action: {
//                    self.isPopOverPresented = true
//                }) {
//                    Image(systemName: Setup.ImageStrings.textSize)
//                        .tint(Color.textColor)
//                }
//                .popover(isPresented: $isPopOverPresented,
//                         attachmentAnchor: .point(.bottom),
//                         arrowEdge: .bottom,
//                         content: {
//
//                    //따로 다른 view로 분리?
//                    VStack {
//                        Text("폰트 크기 설정: \(Int(fontSize))")
//                            .font(.custom(Setup.FontName.notoSansThin, size: 16))
//                            .foregroundStyle(Color.textColor)
//                        Slider(value: $fontSize, in: 5...100, step: 1)
//                            .tint(Color.brandColor)
//                    }
//                    .padding()
//                    .presentationCompactAdaptation(.popover)
//
//                })
//            }
            
        }
    }
}
