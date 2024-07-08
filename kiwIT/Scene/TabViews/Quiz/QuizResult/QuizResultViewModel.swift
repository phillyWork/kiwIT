//
//  QuizResultViewModel.swift
//  kiwIT
//
//  Created by Heedon on 5/5/24.
//

import Foundation

import Combine

final class QuizResultViewModel: ObservableObject {
    
    
    @Published var shouldLoginAgain = false

    @Published var showUnknownNetworkErrorAlert = false
    
    @Published var didFinishSubmittingAnswer = false
    

    private var alreadyTakenQuizList = [TakenQuizResponse]()
    private var currentPageCompletedQuizListRequest = 0
    private var canRequestMoreCompletedQuizList = true
        
    private let dataPerQuizListRequest = 30
    
    private var cancellables = Set<AnyCancellable>()
    
//    var groupId: String
//    var quizPayload: StartQuizResponse
//    var userAnwer: [String]
//    
//    var userAnswer = [Int: String]()

    init() {
        requestAlreadySubmittedQuiz()
    }
    
    //MARK: - 첫 제출인지 n번째 제출인지 확인 필요
    private func requestAlreadySubmittedQuiz() {
        guard let tokenData = AuthManager.shared.checkTokenData() else {
            print("Should Login Again!!!")
            shouldLoginAgain = true
            return
        }
        NetworkManager.shared.request(type: [TakenQuizResponse].self, api: .takenQuizListCheck(request: CheckCompletedOrBookmarkedQuizRequest(access: tokenData.0.access, next: currentPageCompletedQuizListRequest, limit: dataPerQuizListRequest)), errorCase: .takenQuizListCheck)
            .sink { completion in
                if case .failure(let error) = completion {
                    
                    
                    
                }
            } receiveValue: { response in
                self.alreadyTakenQuizList.append(contentsOf: response)
                self.canRequestMoreCompletedQuizList = response.count >= self.dataPerQuizListRequest
                self.loadMoreData()
            }
            .store(in: &self.cancellables)
    }
    
    private func loadMoreData() {
        guard canRequestMoreCompletedQuizList else {
            requestSubmitAnswer()
            return
        }
        currentPageCompletedQuizListRequest += 1
        requestAlreadySubmittedQuiz()
    }
    
    
    private func requestSubmitAnswer() {
        
        
        
    }
    
    
    private func requestRefreshToken(_ token: UserTokenValue, userId: String) {
        NetworkManager.shared.request(type: RefreshAccessTokenResponse.self, api: .refreshToken(request: RefreshAccessTokenRequest(refreshToken: token.refresh)), errorCase: .refreshToken)
            .sink { completion in
                if case .failure(let error) = completion {
                    if let refreshError = error as? NetworkError {
                        switch refreshError {
                        case .invalidToken(_):
                            AuthManager.shared.handleRefreshTokenExpired(userId: userId)
                            self.shouldLoginAgain = true
                        default:
                            print("Refresh Token Error for network reason: \(refreshError.description)")
//                            AuthManager.shared.handleRefreshTokenExpired(userId: userId)
//                            self.shouldLoginAgain = true
                            self.showUnknownNetworkErrorAlert = true
                        }
                    } else {
                        print("Refresh Error: \(error.localizedDescription)")
//                        AuthManager.shared.handleRefreshTokenExpired(userId: userId)
//                        self.shouldLoginAgain = true
                        self.showUnknownNetworkErrorAlert = true
                    }
                }
            } receiveValue: { response in
                KeyChainManager.shared.update(UserTokenValue(access: response.accessToken, refresh: response.refreshToken), id: userId)
                self.requestSubmitAnswer()
            }
            .store(in: &self.cancellables)
    }
}
