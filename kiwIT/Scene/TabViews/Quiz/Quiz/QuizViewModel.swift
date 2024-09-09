//
//  QuizViewModel.swift
//  kiwIT
//
//  Created by Heedon on 5/4/24.
//

import Foundation

import Combine

enum QuizRequestType {
    case startQuiz
    case bookmark
}

final class QuizViewModel: ObservableObject, RefreshTokenHandler {
    
    typealias ActionType = QuizRequestType
            
    @Published var isQuizCompleted = false
    
    @Published var quizData: StartQuizResponse?
    
    @Published var showStartQuizErrorAlert = false
    @Published var showBookmarkQuizErrorAlert = false
    
    @Published var showUnknownNetworkErrorAlert = false
    
    @Published var shouldLoginAgain = false
    
    @Published var quizIndex = 0
    
    @Published var isThisPreviousQuestion = false
      
    var pathString: String
    var quizGroupId: Int
    
    var recentSelectedShortAnswer = ""
    var recentSelectedMultipleChoice = 0
    var recentSelectedBoolAnswer: UserOXAnswerState = .unchosen
    
    var quizCount = 0
    var quizTypeArray: [QuizType] = []
    var userAnswerListForRequest: [QuizAnswer] = []
    
    private let requestBookmarkSubject = PassthroughSubject<Void, Never>()
    
    private var userRecentAnswer: QuizAnswer = QuizAnswer(quizId: -1, answer: "")
    private var quizIdToBookmark = -1
    
    var cancellables = Set<AnyCancellable>()
    
    init(quizGroupId: Int, pathString: String) {
        print("QuizViewModel INIT")
        self.quizGroupId = quizGroupId
        self.pathString = pathString
        bind()
        requestStartQuiz()
    }
    
    private func bind() {
        requestBookmarkSubject
            .debounce(for: .seconds(Setup.Time.debounceInterval), scheduler: RunLoop.main)
            .sink { [weak self] in
                self?.requestBookmarkQuiz()
            }
            .store(in: &cancellables)
    }
        
    func updateBookmarkedStatus(_ id: Int) {
        quizIdToBookmark = id
        debouncedBookmarkThisQuiz()
    }
    
    private func debouncedBookmarkThisQuiz() {
        requestBookmarkSubject.send(())
    }
    
    private func requestStartQuiz() {
        guard let tokenData = AuthManager.shared.checkTokenData() else {
            shouldLoginAgain = true
            return
        }
        NetworkManager.shared.request(type: StartQuizResponse.self, api: .startTakingQuiz(request: StartQuizRequest(quizGroupId: quizGroupId, access: tokenData.0.access)), errorCase: .startTakingQuiz)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    if let startQuizError = error as? NetworkError {
                        switch startQuizError {
                        case .invalidToken(_):
                            self?.requestRefreshToken(tokenData.0, userId: tokenData.1, action: .startQuiz)
                        default:
                            self?.showStartQuizErrorAlert = true
                        }
                    } else {
                        self?.showStartQuizErrorAlert = true
                    }
                }
            } receiveValue: { [weak self] response in
                self?.quizData = response
                self?.quizCount = response.quizList.count
            }
            .store(in: &self.cancellables)
    }
    
    private func requestBookmarkQuiz() {
        guard let tokenData = AuthManager.shared.checkTokenData() else {
            shouldLoginAgain = true
            return
        }
        NetworkManager.shared.request(type: BookmarkQuizResponse.self, api: .bookmarkQuiz(request: BookmarkQuizRequest(quizId: quizIdToBookmark, access: tokenData.0.access)), errorCase: .bookmarkQuiz)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    if let bookmarkQuizError = error as? NetworkError {
                        switch bookmarkQuizError {
                        case .invalidRequestBody(_):
                            self?.showBookmarkQuizErrorAlert = true
                        case .invalidToken(_):
                            self?.requestRefreshToken(tokenData.0, userId: tokenData.1, action: .bookmark)
                        default:
                            self?.showBookmarkQuizErrorAlert = true
                        }
                    } else {
                        self?.showBookmarkQuizErrorAlert = true
                    }
                }
            } receiveValue: { response in
                if let quizData = self.quizData {
                    self.quizData?.quizList[self.quizIndex].kept = !(quizData.quizList[self.quizIndex].kept)
                } else {
                    self.showBookmarkQuizErrorAlert = true
                }
            }
            .store(in: &self.cancellables)
    }
    
    func updateMultipleChoice(_ userAnswer: Int) {
        //0인 경우, 선택하지 않았음으로 서버에서 틀린 답 처리
        if let quizData = quizData {
            let answer = QuizAnswer(quizId: quizData.quizList[quizIndex].id, answer: "\(userAnswer)")
        
            if userAnswerListForRequest.count > quizIndex {
                userAnswerListForRequest[quizIndex].answer = String(userAnswer)
            } else {
                userAnswerListForRequest.append(answer)
            }
            
            isThisPreviousQuestion = false
            if userAnswerListForRequest.count == quizCount {
                isQuizCompleted = true
            } else {
                isQuizCompleted = false
                quizIndex += 1
                if userAnswerListForRequest.count >= quizIndex+1 {
                    userRecentAnswer = userAnswerListForRequest[quizIndex]
                    getPreviousAnswer(userRecentAnswer, quizType: quizData.quizList[quizIndex].type)
                }
            }
        }
    }
    
    func updateShortAnswer(_ userAnswer: String) {
        if let quizData = quizData {
            let answer = QuizAnswer(quizId: quizData.quizList[quizIndex].id, answer: userAnswer)
            
            if userAnswerListForRequest.count > quizIndex {
                userAnswerListForRequest[quizIndex].answer = userAnswer
            } else {
                userAnswerListForRequest.append(answer)
            }
            
            isThisPreviousQuestion = false
            if userAnswerListForRequest.count == quizCount {
                isQuizCompleted = true
            } else {
                isQuizCompleted = false
                quizIndex += 1
                if userAnswerListForRequest.count >= quizIndex+1 {
                    userRecentAnswer = userAnswerListForRequest[quizIndex]
                    getPreviousAnswer(userRecentAnswer, quizType: quizData.quizList[quizIndex].type)
                }
            }
        }
    }
    
    func updateOXAnswer(_ userAnswer: Bool) {
        if let quizData = quizData {
            let answer = QuizAnswer(quizId: quizData.quizList[quizIndex].id, answer: "\(userAnswer)")
            
            if userAnswerListForRequest.count > quizIndex {
                userAnswerListForRequest[quizIndex].answer = "\(userAnswer)"
            } else {
                userAnswerListForRequest.append(answer)
            }
            
            isThisPreviousQuestion = false
            if userAnswerListForRequest.count == quizCount {
                isQuizCompleted = true
            } else {
                isQuizCompleted = false
                quizIndex += 1
                if userAnswerListForRequest.count >= quizIndex+1 {
                    userRecentAnswer = userAnswerListForRequest[quizIndex]
                    getPreviousAnswer(userRecentAnswer, quizType: quizData.quizList[quizIndex].type)
                }
            }
        }
    }
    
    func checkToRemoveSelected() {
        if quizIndex != 0 {
            removeLatestUserAnswer()
        }
    }
    
    private func removeLatestUserAnswer() {
        if let quizData = quizData {
            quizIndex -= 1
            
            userRecentAnswer = userAnswerListForRequest[quizIndex]
            
            getPreviousAnswer(userRecentAnswer, quizType: quizData.quizList[quizIndex].type)
        }
    }
    
    private func getPreviousAnswer(_ userAnswer: QuizAnswer, quizType: QuizType) {
        switch quizType {
        case .multipleChoice:
            recentSelectedMultipleChoice = Int(userAnswer.answer)!
        case .trueOrFalse:
            recentSelectedBoolAnswer = userAnswer.answer == "true" ? .chosenTrue : .chosenFalse
        case .shortAnswer:
            recentSelectedShortAnswer = userAnswer.answer
        }
        isThisPreviousQuestion = true
    }
    
    func checkRetakeQuiz() {
        if quizIndex != 0 {
            resetQuiz()
        }
    }
    
    private func resetQuiz() {
        quizIndex = 0
        userRecentAnswer = QuizAnswer(quizId: -1, answer: "")
        recentSelectedBoolAnswer = .unchosen
        recentSelectedMultipleChoice = 0
        recentSelectedShortAnswer = ""
        userAnswerListForRequest.removeAll()
        isQuizCompleted = false
    }
    
    func handleRefreshTokenSuccess(response: UserTokenValue, userId: String, action: QuizRequestType) {
        switch action {
        case .startQuiz:
            requestStartQuiz()
        case .bookmark:
            debouncedBookmarkThisQuiz()
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
    
    deinit {
        print("QuizViewModel DEINIT")
    }
    
}
