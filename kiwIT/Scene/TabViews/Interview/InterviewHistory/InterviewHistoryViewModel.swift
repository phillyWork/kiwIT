//
//  InterviewHistoryViewModel.swift
//  kiwIT
//
//  Created by Heedon on 8/3/24.
//

import Foundation

import Combine

enum InterviewParentType {
    case createNewInterview
    case previouslyCreatedInterview
}

enum InterviewHistoryActionType {
    case getPastInterviewAnswers
    case startNewInterviewRoom
}

final class InterviewHistoryViewModel: ObservableObject, RefreshTokenHandler {
   
    typealias ActionType = InterviewHistoryActionType
    
    @Published var shouldLoginAgain = false
    
    @Published var pastHistoryList: [InterviewRoomPayload] = []
    
    @Published var selectedInterviewRoomId: Int = -1
    
    @Published var showPastHistoryListError = false
    
    @Published var showUnknownNetworkErrorAlert = false
    
    var parentViewType: InterviewParentType
    var interviewId: Int
    
    var cancellables = Set<AnyCancellable>()
    
    init(_ interviewId: Int, parent: InterviewParentType) {
        self.interviewId = interviewId
        self.parentViewType = parent
        bind()
        requestPastInterviewHistoryList()
    }
    
    private func bind() {
        
    }
    
    private func requestPastInterviewHistoryList() {
        guard let tokenData = AuthManager.shared.checkTokenData() else {
            shouldLoginAgain = true
            return
        }
        
        
        
    }
    
    private func requestStartNewInterview() {
        
    }
        
    func handleRefreshTokenSuccess(response: UserTokenValue, userId: String, action: InterviewHistoryActionType) {
        switch action {
        case .getPastInterviewAnswers:
            print("")
        case .startNewInterviewRoom:
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
