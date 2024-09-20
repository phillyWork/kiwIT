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
    
    @Published var pastAnswerList: [PastAnswerPaylaod] = []
    
    @Published var shouldLoginAgain = false
    
    @Published var showPastAnswersError = false
    
    @Published var showUnknownNetworkErrorAlert = false
    
    private let pastAnswersListSubject = PassthroughSubject<Void, Never>()
    
    
    var interviewRoomId: Int
    
    var cancellables = Set<AnyCancellable>()
    
    init(_ id: Int) {
        self.interviewRoomId = id
        bind()
    }
    
    private func bind() {
        pastAnswersListSubject
            .debounce(for: .seconds(Setup.Time.debounceInterval), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.requestPastAnswersList()
            }
            .store(in: &self.cancellables)
    }
    
    func debouncedPastAnswers() {
        pastAnswersListSubject.send(())
    }
    
    private func requestPastAnswersList() {
        
    }
    
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
