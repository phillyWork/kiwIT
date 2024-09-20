//
//  InterviewView.swift
//  kiwIT
//
//  Created by Heedon on 7/21/24.
//

import SwiftUI

struct InterviewView: View {
    
    @StateObject var interviewVM: InterviewViewModel
    @ObservedObject var interviewHistoryVM: InterviewHistoryViewModel
    
    @Binding var path: NavigationPath
    @Binding var isLoginAvailable: Bool
    
    @Environment(\.dismiss) private var dismiss
    
    init(interviewHistoryVM: InterviewHistoryViewModel, path: Binding<NavigationPath>, isLoginAvailable: Binding<Bool>) {
        self.interviewHistoryVM = interviewHistoryVM
        self._interviewVM = StateObject(wrappedValue: InterviewViewModel(interviewHistoryVM.selectedInterviewRoomId))
        self._path = path
        self._isLoginAvailable = isLoginAvailable
    }
    
    var body: some View {
        VStack {
            InterviewContent(interview: interviewVM.recentInterviewContent()) { type in
                switch type {
                case .nextInterview(let string):
                    interviewVM.debouncedNextQuestion(string)
                case .previousInterview(let string):
                    interviewVM.debouncedPreviousQuestion(string)
                }
            }
        }
        .background {
            NavigationLink("", isActive: $interviewVM.isInterviewDone) {
                InterviewResultView(path: $path, isLoginAvaialble: $isLoginAvailable)
            }
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    interviewVM.debouncedStopInterview()
                } label: {
                    Image(systemName: Setup.ImageStrings.defaultXMark2)
                }
                .tint(Color.textColor)
                .alert("일시 정지", isPresented: $interviewVM.showStopInterviewAlert) {
                    Button {
                        interviewVM.debouncedStopTimer()
                        dismiss()
                    } label: {
                        Text("확인")
                    }
                    Button {
                        interviewVM.debouncedResumeTimer()
                    } label: {
                        Text("취소")
                    }
                } message: {
                    Text("인터뷰를 정말 중단하실 건가요?")
                }
            }
        }
    }
}
