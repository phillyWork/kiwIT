//
//  InterviewPastAnswersView.swift
//  kiwIT
//
//  Created by Heedon on 8/1/24.
//

import SwiftUI

struct InterviewPastAnswersView: View {
    
    @StateObject private var interviewPastAnswersVM: InterviewPastAnswersViewModel
    
    init(_ roomId: Int) {
        _interviewPastAnswersVM = StateObject(wrappedValue: InterviewPastAnswersViewModel(roomId))
    }
    
    var body: some View {
        ScrollView {
            if interviewPastAnswersVM.showPastAnswersError {
                EmptyViewWithRetryButton {
                    interviewPastAnswersVM.debouncedPastAnswers()
                }
            } else if interviewPastAnswersVM.pastAnswerList.isEmpty {
                ProgressView {
                    Text("로딩 중...")
                }
            } else {
                LazyVStack {
                    ForEach(interviewPastAnswersVM.pastAnswerList, id: \.self) { content in
                        ContentExpandableChapterItemView(itemTitle: content.question.question) {
                            ScrollView {
                                LazyVStack(spacing: 10) {
                                    //MARK: - 유저 답안
                                    Text(content.myAnswer)
                                    //MARK: - 모범 답안
                                    Text(content.question.modelAnswer)
                                }
                            }
                        }
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
        .background(Color.backgroundColor)
        //to disable pull to refresh
        .environment(\EnvironmentValues.refresh as! WritableKeyPath<EnvironmentValues, RefreshAction?>, nil)
    }
}

#Preview {
    InterviewPastAnswersView(3)
}
