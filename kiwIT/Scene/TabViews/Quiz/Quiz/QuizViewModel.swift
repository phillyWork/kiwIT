//
//  QuizViewModel.swift
//  kiwIT
//
//  Created by Heedon on 5/4/24.
//

import Foundation

import Combine

final class QuizViewModel: ObservableObject {
    
    @Published var userOXAnswer = [Bool]()
    @Published var userMultipleAnswer = [Int]()
    @Published var userShortAnswer = [String]()
        
    @Published var isQuizCompleted = false
    
    @Published var quizData: StartQuizResponse?
    
    @Published var showStartQuizErrorAlert = false
    @Published var showBookmarkQuizErrorAlert = false
    @Published var showThisIsFirstQuestionAlert = false
    
    @Published var shouldLoginAgain = false
    
    var pathString: String
    var quizGroupId: Int
    
    @Published var quizIndex = 0
    @Published var quizCount = 0
    
    var quizType: QuizType = .multipleChoice
    
    private var recentSelectedShortAnswer = ""
    private var recentSelectedMultipleChoice = -1
    private var recentSelectedBoolAnswer = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init(quizGroupId: Int, pathString: String) {
        self.quizGroupId = quizGroupId
        self.pathString = pathString
        quizSetup()
    }
    
    func quizSetup() {
//        requestStartQuiz()
    }
    
    private func requestStartQuiz() {
        guard let tokenData = AuthManager.shared.checkTokenData() else {
            print("Should Login Again!!!")
            shouldLoginAgain = true
            return
        }
        NetworkManager.shared.request(type: StartQuizResponse.self, api: .startTakingQuiz(request: StartQuizRequest(quizGroupId: quizGroupId, access: tokenData.0.access)), errorCase: .startTakingQuiz)
            .sink { completion in
                if case .failure(let error) = completion {
                    if let startQuizError = error as? NetworkError {
                        switch startQuizError {
                        case .invalidToken(_):
                            self.requestRefreshToken(tokenData.0, userId: tokenData.1)
                        default:
                            print("Start Taking Quiz Error for network reason: \(startQuizError.description)")
                            self.showStartQuizErrorAlert = true
                        }
                    } else {
                        print("Start Taking Quiz Error for other reason: \(error.localizedDescription)")
                        self.showStartQuizErrorAlert = true
                    }
                }
            } receiveValue: { response in
                self.quizData = response
                self.quizCount = response.quizList.count
                switch response.quizList.first?.type {
                case .multipleChoice: self.quizType = .multipleChoice
                case .trueOrFalse: self.quizType = .trueOrFalse
                case .shortAnswer: self.quizType = .shortAnswer
                default:
                    self.quizType = .multipleChoice
                }
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
                            AuthManager.shared.handleRefreshTokenExpired(userId: userId)
                            self.shouldLoginAgain = true
                        }
                    } else {
                        print("Category Content Error for other reason: \(error.localizedDescription)")
                        AuthManager.shared.handleRefreshTokenExpired(userId: userId)
                        self.shouldLoginAgain = true
                    }
                }
            } receiveValue: { response in
                KeyChainManager.shared.update(UserTokenValue(access: response.accessToken, refresh: response.refreshToken), id: userId)
                self.requestStartQuiz()
            }
            .store(in: &self.cancellables)
    }
    
    func updateMultipleChoice(_ selectedChoice: Int) {
        //0인 경우, 선택하지 않았음으로 틀린 답 처리
        userMultipleAnswer.append(selectedChoice)
        if userMultipleAnswer.count == quizCount {
            isQuizCompleted = true
            quizIndex = 0
            userMultipleAnswer.removeAll()
        } else {
            quizIndex += 1
        }
    }
    
    func updateShortAnswer(_ userAnswer: String) {
        userShortAnswer.append(userAnswer)
        if userShortAnswer.count == quizCount {
            isQuizCompleted = true
            quizIndex = 0
            userShortAnswer.removeAll()
        } else {
            quizIndex += 1
        }
    }
    
    func updateOXAnswer(_ userAnswer: Bool) {
        userOXAnswer.append(userAnswer)
        if userOXAnswer.count == quizCount {
            isQuizCompleted = true
            quizIndex = 0
            userOXAnswer.removeAll()
        } else {
            quizIndex += 1
        }
    }
    
    func checkToRemoveSelected() {
        if quizIndex == 0 {
            showThisIsFirstQuestionAlert = true
        } else {
            removeLatestUserAnswer()
        }
    }
    
    private func removeLatestUserAnswer() {

        //Index-1 에서의 답변 확보 및 기존 답변을 새로운 답변으로 대체하는 식의 구성

        quizIndex -= 1
        switch quizType {
        case .multipleChoice:
            recentSelectedMultipleChoice = userMultipleAnswer.remove(at: userMultipleAnswer.count - 1)
            print("After Removal in Multiple: \(recentSelectedMultipleChoice)")
        case .trueOrFalse:
            recentSelectedBoolAnswer = userOXAnswer.remove(at: userOXAnswer.count - 1)
            print("After Removal in OX: \(recentSelectedMultipleChoice)")
        case .shortAnswer:
            recentSelectedShortAnswer = userShortAnswer.remove(at: userShortAnswer.count - 1)
            print("After Removal in Short Answer: \(recentSelectedMultipleChoice)")
        }
        
    }
    
    func checkRetakeQuiz() -> Bool {
        return pathString.hasPrefix("RetakeQuiz-")
    }
    
    func resetQuiz() {
        quizIndex = 0
        switch quizType {
        case .multipleChoice:
            userMultipleAnswer.removeAll()
        case .trueOrFalse:
            userOXAnswer.removeAll()
        case .shortAnswer:
            userShortAnswer.removeAll()
        }
        isQuizCompleted = false
    }
}
