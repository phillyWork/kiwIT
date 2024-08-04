//
//  InterviewContent.swift
//  kiwIT
//
//  Created by Heedon on 8/4/24.
//

import SwiftUI

enum InterviewContentActionType {
    case nextInterview(String)
    case previousInterview
}

struct InterviewContentModel {
    var index: Int
    var count: Int
    var question: String
}

struct InterviewContent: View {
    
    @State private var userAnswer = "당신의 답변은?"
    
    var interview: InterviewContentModel
    var interviewAction: (InterviewContentActionType) -> Void
    
    init(_ userAnswer: String = "당신의 답변은?", interview: InterviewContentModel, action: @escaping (InterviewContentActionType) -> Void) {
        self.userAnswer = userAnswer
        self.interview = interview
        self.interviewAction = action
    }
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.backgroundColor)
                .frame(width: Setup.Frame.devicePortraitWidth * 0.8, height: Setup.Frame.devicePortraitHeight * 0.7)
                .offset(CGSize(width: 4, height: 4))
            VStack {
                Text(interview.question)
                    .font(.custom(Setup.FontName.lineRegular, size: 25))
                    .multilineTextAlignment(.leading)
                    .frame(height: Setup.Frame.devicePortraitHeight * 0.05)
                    .background(Color.red)
                TextEditor(text: $userAnswer)
                    .foregroundStyle(Color.textColor)
                    .frame(width: Setup.Frame.devicePortraitWidth * 0.65, height: Setup.Frame.devicePortraitHeight * 0.4)
                    .colorMultiply(Color.yellow.opacity(0.7))
                    .padding()
                HStack {
                    if (interview.index != 0) {
                        Spacer()
                        Button {
                            print("Tap this button to go back to previous interview")
                            self.interviewAction(.previousInterview)
                        } label: {
                            Text("이전으로")
                        }
                    }
                    Spacer()
                    Button {
                        print("Tap this button to move to next question")
                        self.interviewAction(.nextInterview(userAnswer))
                    } label: {
                        Text(interview.index == interview.count - 1 ? "제출하기" : "다음으로")
                    }
                    Spacer()
                }
            }
            .frame(width: Setup.Frame.devicePortraitWidth * 0.8, height: Setup.Frame.devicePortraitHeight * 0.7)
            .background(Color.surfaceColor)
            .offset(CGSize(width: -4, height: -4))
        }
    }
}

#Preview {
    InterviewContent("과거 대답", interview: InterviewContentModel(index: 2, count: 3, question: "인터뷰 질문1")) { action in
        switch action {
        case .nextInterview(let answer):
            print("next question!!!")
        case .previousInterview:
            print("previous question!!!")
        }
    }
}
