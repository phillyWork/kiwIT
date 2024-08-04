//
//  InterviewResultViewModel.swift
//  kiwIT
//
//  Created by Heedon on 8/4/24.
//

import Foundation

import Combine

enum InterviewResultActionType {
    case checkToRetake
}

final class InterviewResultViewModel: ObservableObject, RefreshTokenHandler {
   
    typealias ActionType = InterviewResultActionType
   
    @Published var shouldLoginAgain = false
    
    @Published var showUnknownNetworkErrorAlert = false
    
    var cancellables = Set<AnyCancellable>()
    
    
    
    
    
    
    func handleRefreshTokenSuccess(response: UserTokenValue, userId: String, action: InterviewResultActionType) {
        switch action {
        case .checkToRetake:
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
