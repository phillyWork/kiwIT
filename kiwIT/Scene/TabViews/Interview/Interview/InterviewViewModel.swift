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
    case hangOn
    
}

//MARK: - Setup for Polling (when user is on other view or app is in background)

//MARK: - Should Notify when user is on other view --> NotificationCenter

//MARK: - when app is on background: Background mode and background fetch


final class InterviewViewModel: ObservableObject, RefreshTokenHandler {
   
    typealias ActionType = InterviewActionType
    
    @Published var shouldLoginAgain = false
    
    
    var cancellables: Set<AnyCancellable> = []
    
    init() {
        
    }
    
    private func startPolling() {
        
    }
    
    func handleRefreshTokenSuccess(response: UserTokenValue, userId: String, action: InterviewActionType) {
        switch action {
        case .startInterview:
            print("")
        case .hangOn:
            print("")
        }
    }
    
    func handleRefreshTokenError(isRefreshInvalid: Bool, userId: String) {
        if isRefreshInvalid {
            AuthManager.shared.handleRefreshTokenExpired(userId: userId)
            shouldLoginAgain = true
        }
    }
    
}
