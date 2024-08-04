//
//  InterviewPastAnswersViewModel.swift
//  kiwIT
//
//  Created by Heedon on 8/4/24.
//

import Foundation

import Combine

enum InterviewPastAnswersActionType {
    case getList
}

final class InterviewPastAnswersViewModel: ObservableObject, RefreshTokenHandler {
    
    typealias ActionType = InterviewPastAnswersActionType
    
    @Published var shouldLoginAgain = false
    
    @Published var showUnknownNetworkErrorAlert = false
    
    var cancellables = Set<AnyCancellable>()
    
    func handleRefreshTokenSuccess(response: UserTokenValue, userId: String, action: InterviewPastAnswersActionType) {
        switch action {
        case .getList:
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
