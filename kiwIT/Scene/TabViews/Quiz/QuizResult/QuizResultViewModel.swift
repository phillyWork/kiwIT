//
//  QuizResultViewModel.swift
//  kiwIT
//
//  Created by Heedon on 5/5/24.
//

import Foundation

import Combine

enum QuizResultActionType {
    case submit
}

final class QuizResultViewModel: ObservableObject, RefreshTokenHandler {
    
    typealias ActionType = QuizResultActionType
    
    @Published var shouldLoginAgain = false
    
    @Published var showUnknownNetworkErrorAlert = false
    @Published var showSubmitAnswerErrorAlert = false
    @Published var showRetakeQuizErrorAlert = false
    
    @Published var didFinishSubmittingAnswer = false
    
    @Published var acquiredTrophyList: [TrophyEntity] = []
    
    private let showRetakeQuizSubject = PassthroughSubject<Bool, Never>()
    
    var cancellables = Set<AnyCancellable>()
    
    var userResult: SubmitQuizResponse?
    
    var quizTitle: String
    var quizGroupId: Int
    var totalScore: Int
    var userAnswerListForRequest: [QuizAnswer]
    var quizList: [QuizPayload]
    
    init(_ id: Int, title: String, score: Int, userAnswer: [QuizAnswer], quizList: [QuizPayload]) {
        print("QuizResultViewModel INIT")
        self.quizGroupId = id
        self.quizTitle = title
        self.totalScore = score
        self.userAnswerListForRequest = userAnswer
        self.quizList = quizList
        requestSubmitAnswer()
    }
    
    private func bind() {
        showRetakeQuizSubject
            .sink { [weak self] value in
                self?.showRetakeQuizErrorAlert = value
            }
            .store(in: &cancellables)
    }
    
    func retrySubmitAnswer() {
        cancellables.removeAll()
        requestSubmitAnswer()
    }
    
    func updateToShowRetakeErrorAlert() {
        showRetakeQuizSubject.send(true)
    }
    
    private func requestSubmitAnswer() {
        guard let tokenData = AuthManager.shared.checkTokenData() else {
            print("Should Login Again!!!")
            shouldLoginAgain = true
            return
        }
        NetworkManager.shared.request(type: SubmitQuizResponse.self, api: .submitQuizAnswers(request: SubmitQuizRequest(quizGroupId: quizGroupId, access: tokenData.0.access, answerList: userAnswerListForRequest)), errorCase: .submitQuizAnswers)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    if let submitAnswerError = error as? NetworkError {
                        switch submitAnswerError {
                        case .invalidRequestBody(_):
                            print("Invalid Answer Body: \(submitAnswerError.description)")
                            self?.showSubmitAnswerErrorAlert = true
                        case .invalidToken(_):
                            self?.requestRefreshToken(tokenData.0, userId: tokenData.1, action: .submit)
                        default:
                            print("Submit Answer Error for network reason: \(submitAnswerError.description)")
                            self?.showSubmitAnswerErrorAlert = true
                        }
                    } else {
                        print("Submit Answer Error for other reason: \(error.localizedDescription)")
                        self?.showSubmitAnswerErrorAlert = true
                    }
                }
            } receiveValue: { [weak self] response in
                self?.userResult = response
                if !response.trophyAwardedList.isEmpty {
                    self?.acquiredTrophyList = response.trophyAwardedList
                } else {
                    self?.didFinishSubmittingAnswer = true
                }
            }
            .store(in: &self.cancellables)
    }
    
    func handleAfterCloseTrophyCardView() {
        acquiredTrophyList.removeAll()
        didFinishSubmittingAnswer = true
    }
    
    func handleRefreshTokenSuccess(response: UserTokenValue, userId: String, action: QuizResultActionType) {
        requestSubmitAnswer()
    }
    
    func handleRefreshTokenError(isRefreshInvalid: Bool, userId: String) {
        if isRefreshInvalid {
            AuthManager.shared.handleRefreshTokenExpired(userId: userId)
            shouldLoginAgain = true
        } else {
            showUnknownNetworkErrorAlert = true
        }
    }
        
    deinit {
        print("QuizResultViewModel DEINIT")
    }
    
}
