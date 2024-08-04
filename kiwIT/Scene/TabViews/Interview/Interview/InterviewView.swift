//
//  InterviewView.swift
//  kiwIT
//
//  Created by Heedon on 7/21/24.
//

import SwiftUI

struct InterviewView: View {
    
    @StateObject var interviewVM: InterviewViewModel
    @ObservedObject var interviewListVM: InterviewListViewModel
    
    @Binding var path: NavigationPath
    @Binding var isLoginAvailable: Bool
    
    init(interviewListVM: InterviewListViewModel, path: Binding<NavigationPath>, isLoginAvailable: Binding<Bool>) {
        self.interviewListVM = interviewListVM
        self._interviewVM = StateObject(wrappedValue: InterviewViewModel())
        self._path = path
        self._isLoginAvailable = isLoginAvailable
    }
    
    var body: some View {
        
        VStack {
            
            //MARK: - 각 인터뷰 보여주기, 버튼 액션 따라 앞 문항, 전 문항 보여주기
            
//            ForEach(<#T##data: RandomAccessCollection##RandomAccessCollection#>, id: \.self) { eachQuestion in
//                
//            }
        }
        .background {
            NavigationLink("", isActive: $interviewVM.isInterviewDone) {
                InterviewResultView()
            }
        }
        
    }
}
