//
//  InterviewHistoryViewModel.swift
//  kiwIT
//
//  Created by Heedon on 8/3/24.
//

import Foundation

import Combine

enum InterviewHistoryActionType {
    case getPastInterviews
    case checkStatus
}

final class InterviewHistoryViewModel: ObservableObject, RefreshTokenHandler {
   
    typealias ActionType = InterviewHistoryActionType
    
    @Published var shouldLoginAgain = false
    
    @Published var showUnknownNetworkErrorAlert = false
    
    var interviewId: Int
    
    var cancellables = Set<AnyCancellable>()
    
    init(interviewId: Int) {
        self.interviewId = interviewId
        bind()
    }
    
    private func bind() {
        
    }
    
    private func requestPastInterviewHistoryList() {
        
    }
    
    private func checkStatusForPolling() {
        
    }
    
    func handleRefreshTokenSuccess(response: UserTokenValue, userId: String, action: InterviewHistoryActionType) {
        switch action {
        case .getPastInterviews:
            print("")
        case .checkStatus:
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
