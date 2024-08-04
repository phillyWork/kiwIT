//
//  InterviewPollingViewModel.swift
//  kiwIT
//
//  Created by Heedon on 8/4/24.
//

import Foundation

import Combine

enum InterviewPollingActionType {
    case checkStatus
}

final class InterviewPollingViewModel: ObservableObject, RefreshTokenHandler {

    typealias ActionType = InterviewPollingActionType
    
    var cancellables = Set<AnyCancellable>()
    
    @Published var shouldLoginAgain = false
    
    @Published var showUnknownNetworkErrorAlert = false

    @Published var pollTimer: Timer?
    
    private func startPolling() {
        pollTimer = Timer.scheduledTimer(withTimeInterval: 60.0, repeats: true) { timer in
//            pollServer()
        }
    }
    
    private func pollServer() {
        // Implement network request to poll the server
        // Update the status based on server response
        
        // when server response saying status is goodToStart: invalidate pollTimer
        // update
    }
    
    
    func handleRefreshTokenSuccess(response: UserTokenValue, userId: String, action: InterviewPollingActionType) {
        switch action {
        case .checkStatus:
            print("")
        }
    }
    
    func handleRefreshTokenError(isRefreshInvalid: Bool, userId: String) {
        if isRefreshInvalid {
            AuthManager.shared.handleRefreshTokenExpired(userId: userId)
            shouldLoginAgain = false
        } else {
            showUnknownNetworkErrorAlert = true
        }
    }
    
}
