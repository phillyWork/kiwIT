//
//  InterviewViewModel.swift
//  kiwIT
//
//  Created by Heedon on 7/21/24.
//

import Foundation

import Combine

enum InterviewActionType {
    case startInterview
    
}

//MARK: - Setup for Polling (when user is on other view or app is in background)

//MARK: - Should Notify when user is on other view --> NotificationCenter

//MARK: - when app is on background: Background mode and background fetch



//MARK: - 백그라운드 혹은 다른 뷰에서도 계속해서 request & response를 받아야 하는지 확인 필요


final class InterviewViewModel: ObservableObject, RefreshTokenHandler {
    
    typealias ActionType = InterviewActionType
    
    @Published var questionList: [InterviewQuestionPayload] = []
    
    @Published var isThisPreviousInterview = false
    
    @Published var interviewTimer: Timer?
    
    @Published var shouldLoginAgain = false
    
    @Published var showStopInterviewAlert = false
    @Published var showUnknownNetworkErrorAlert = false
    
    @Published var isInterviewDone = false
    
    private var quizIndex = -1
    
    private var userAnswers: [String] = []
    private var timeSetup: Int = -1
    
    var recentInterviewAnswer: String = ""
    
    var interviewRoomId: Int
    var cancellables: Set<AnyCancellable> = []
    
    init(_ id: Int) {
        self.interviewRoomId = id
        bind()
    }
    
    private func bind() {
        
    }
    
    func debouncedNextQuestion(_ answer: String) {
        if questionList.count > quizIndex {
            print("Update to new answer!!")
            userAnswers[quizIndex] = answer
        } else {
            print("New answer!!")
            userAnswers.append(answer)
        }
        
        if quizIndex == questionList.count-1 {
            //MARK: - 답변 완료, InterviewResultView로 이동하기
            print("Interview is all done!!!")
            isInterviewDone = true
        } else {
            //MARK: - 다음 문제로
            isInterviewDone = false
            quizIndex += 1
        }
    }
    
    func debouncedPreviousQuestion(_ answer: String) {
        if quizIndex != 0 {
            
            if answer != Setup.ContentStrings.Interview.defaultAnswerPlaceholder && !answer.isEmpty {
                
                //MARK: - 답변 업데이트 하면서 이전 문항으로 넘어가기
                
                if questionList.count > quizIndex {
                    print("Update to new answer by going to previous question!!")
                    print("previous answer: \(questionList[quizIndex])")
                    userAnswers[quizIndex] = answer
                    print("updated answer: \(questionList[quizIndex])")
                }
                
                quizIndex -= 1
                
                recentInterviewAnswer = userAnswers[quizIndex]
                print("previous answer: \(recentInterviewAnswer)")
                
                isThisPreviousInterview = true
                
            }
            
        }
    }
    
    
    //MARK: - Published 말고 send 활용?
    func recentInterviewContent() -> InterviewContentModel {
        return isThisPreviousInterview ? InterviewContentModel(index: quizIndex, count: questionList.count, question: questionList[quizIndex].question, previousAnswer: recentInterviewAnswer) : InterviewContentModel(index: quizIndex, count: questionList.count, question: questionList[quizIndex].question)
    }
    
    
    func debouncedQuestionList() {
        
    }
    
    func debouncedStopInterview() {
        //MARK: - 인터뷰 중단하기: 타이머 정지 및 나갈 의향 물을 alert 띄우기
        
    }
    
    func debouncedResumeTimer() {
        //MARK: - 타이머 재개하기
        
    }
    
    func debouncedStopTimer() {
        //MARK: - 타이머 중단
        
    }
    
    private func requestQuestionList() {
        guard let tokenData = AuthManager.shared.checkTokenData() else {
            shouldLoginAgain = true
            return
        }
        
    }
    
    
    
    
    
    
    func handleRefreshTokenSuccess(response: UserTokenValue, userId: String, action: InterviewActionType) {
        switch action {
        case .startInterview:
            print("")
            
        }
    }
    
    func handleRefreshTokenError(isRefreshInvalid: Bool, userId: String) {
        if isRefreshInvalid {
            AuthManager.shared.handleRefreshTokenExpired(userId: userId)
            shouldLoginAgain = true
        } else {
            showUnknownNetworkErrorAlert = true
        }
    }
    
    
}
