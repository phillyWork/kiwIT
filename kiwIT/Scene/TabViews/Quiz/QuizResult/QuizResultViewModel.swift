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
    @Published var showSubmitAnswerErrorAlert = false
    @Published var showRetakeQuizErrorAlert = false
    
    @Published var didFinishSubmittingAnswer = false
    
    private var cancellables = Set<AnyCancellable>()

    var userResult: SubmitQuizResponse?
    
    var quizGroupId: Int
    var userAnswerListForRequest: [QuizAnswer]
    var quizList: [QuizPayload]
    
    init(_ id: Int, userAnswer: [QuizAnswer], quizList: [QuizPayload]) {
        self.quizGroupId = id
        self.userAnswerListForRequest = userAnswer
        self.quizList = quizList
        requestSubmitAnswer()
    }
    
    func retrySubmitAnswer() {
        cancellables.removeAll()
        requestSubmitAnswer()
    }
    
    private func requestSubmitAnswer() {
        guard let tokenData = AuthManager.shared.checkTokenData() else {
            print("Should Login Again!!!")
            shouldLoginAgain = true
            return
        }
        NetworkManager.shared.request(type: SubmitQuizResponse.self, api: .submitQuizAnswers(request: SubmitQuizRequest(quizGroupId: quizGroupId, access: tokenData.0.access, answerList: userAnswerListForRequest)), errorCase: .submitQuizAnswers)
            .sink { completion in
                if case .failure(let error) = completion {
                    if let submitAnswerError = error as? NetworkError {
                        switch submitAnswerError {
                        case .invalidRequestBody(_):
                            print("Invalid Answer Body: \(submitAnswerError.description)")
                            self.showSubmitAnswerErrorAlert = true
                        case .invalidToken(_):
                            self.requestRefreshToken(tokenData.0, userId: tokenData.1)
                        default:
                            print("Submit Answer Error for network reason: \(submitAnswerError.description)")
                            self.showSubmitAnswerErrorAlert = true
                        }
                    } else {
                        print("Submit Answer Error for other reason: \(error.localizedDescription)")
                        self.showSubmitAnswerErrorAlert = true
                    }
                }
            } receiveValue: { response in
                self.userResult = response
                self.didFinishSubmittingAnswer = true
            }
            .store(in: &self.cancellables)
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
                            self.showUnknownNetworkErrorAlert = true
                        }
                    } else {
                        print("Refresh Error: \(error.localizedDescription)")
                        self.showUnknownNetworkErrorAlert = true
                    }
                }
            } receiveValue: { response in
                KeyChainManager.shared.update(UserTokenValue(access: response.accessToken, refresh: response.refreshToken), id: userId)
                self.requestSubmitAnswer()
                self.requestSubmitAnswer()
            }
            .store(in: &self.cancellables)
    }
    
    func cleanUpCancellables() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        print("Cancellables count: \(cancellables.count)")
    }
    
    deinit {
        print("QuizResultViewModel DEINIT")
    }
    
}
