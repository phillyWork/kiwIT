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
    
    init(interviewListVM: InterviewListViewModel) {
        self._interviewVM = StateObject(wrappedValue: InterviewViewModel())
        self.interviewListVM = interviewListVM
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    InterviewView(interviewListVM: InterviewListViewModel(ProfileResponse(id: 1, email: "str", nickname: "str", point: 2, plan: .premium, status: .activated)))
}
