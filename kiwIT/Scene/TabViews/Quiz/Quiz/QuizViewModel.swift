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

final class QuizViewModel: ObservableObject {
            
    @Published var isQuizCompleted = false
    
    @Published var quizData: StartQuizResponse?
    
    @Published var showStartQuizErrorAlert = false
    @Published var showBookmarkQuizErrorAlert = false
    @Published var showThisIsFirstQuestionAlert = false
    
    @Published var showUnknownNetworkErrorAlert = false
    
    @Published var shouldLoginAgain = false
    
    @Published var quizIndex = 0
    
    @Published var isThisPreviousQuestion = false
  
    @Published var quizType: QuizType = .multipleChoice
    
    var pathString: String
    var quizGroupId: Int
    
    var recentSelectedShortAnswer = ""
    var recentSelectedMultipleChoice = 0
    var recentSelectedBoolAnswer: UserOXAnswerState = .unchosen
    
    var quizCount = 0
    var userAnswerListForRequest: [QuizAnswer] = []
    
    private var userRecentAnswer: QuizAnswer = QuizAnswer(quizId: -1, answer: "")
    private var quizIdToBookmark = -1
    private var requestBookmarkSubject = PassthroughSubject<Void, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    init(quizGroupId: Int, pathString: String) {
        self.quizGroupId = quizGroupId
        self.pathString = pathString
        setupDebounce()
        requestStartQuiz()
    }
    
    private func setupDebounce() {
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
                            self.requestRefreshToken(tokenData.0, userId: tokenData.1, actionType: .startQuiz)
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
                default: self.quizType = .multipleChoice
                }
            }
            .store(in: &self.cancellables)
    }
    
    private func requestBookmarkQuiz() {
        guard let tokenData = AuthManager.shared.checkTokenData() else {
            print("Should Login Again!!!")
            shouldLoginAgain = true
            return
        }
        NetworkManager.shared.request(type: BookmarkQuizResponse.self, api: .bookmarkQuiz(request: BookmarkQuizRequest(quizId: quizIdToBookmark, access: tokenData.0.access)), errorCase: .bookmarkQuiz)
            .sink { completion in
                if case .failure(let error) = completion {
                    if let bookmarkQuizError = error as? NetworkError {
                        switch bookmarkQuizError {
                        case .invalidRequestBody(_):
                            print("Wrong Quiz Id error: \(bookmarkQuizError.description)")
                            self.showBookmarkQuizErrorAlert = true
                        case .invalidToken(_):
                            self.requestRefreshToken(tokenData.0, userId: tokenData.1, actionType: .bookmark)
                        default:
                            print("Bookmark Quiz Error by network reason: \(bookmarkQuizError.description)")
                            self.showBookmarkQuizErrorAlert = true
                        }
                    } else {
                        print("BookmarkQuiz Error by other reason: \(error.localizedDescription)")
                        self.showBookmarkQuizErrorAlert = true
                    }
                }
            } receiveValue: { response in
                if let quizData = self.quizData {
                    self.quizData?.quizList[self.quizIndex].kept = !(quizData.quizList[self.quizIndex].kept)
                } else {
                    print("No Quiz Data to update bookmark data!!!")
                    self.showBookmarkQuizErrorAlert = true
                }
            }
            .store(in: &self.cancellables)
    }
    
    private func requestRefreshToken(_ token: UserTokenValue, userId: String, actionType: QuizRequestType) {
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
                        print("Category Content Error for other reason: \(error.localizedDescription)")
                        self.showUnknownNetworkErrorAlert = true
                    }
                }
            } receiveValue: { response in
                KeyChainManager.shared.update(UserTokenValue(access: response.accessToken, refresh: response.refreshToken), id: userId)
                switch actionType {
                case .startQuiz:
                    self.requestStartQuiz()
                case .bookmark:
                    self.debouncedBookmarkThisQuiz()
                }
            }
            .store(in: &self.cancellables)
    }
    
    func updateMultipleChoice(_ userAnswer: Int) {
        //0인 경우, 선택하지 않았음으로 서버에서 틀린 답 처리
        if let quizData = quizData {
            let answer = QuizAnswer(quizId: quizData.quizList[quizIndex].id, answer: "\(userAnswer)")
        
            if userAnswerListForRequest.count > quizIndex {
                print("Update to new answer!!")
                userAnswerListForRequest[quizIndex].answer = String(userAnswer)
            } else {
                print("New answer!!")
                userAnswerListForRequest.append(answer)
            }
            
            isThisPreviousQuestion = false
            if userAnswerListForRequest.count == quizCount {
                print("Quiz is all done!!!")
                isQuizCompleted = true
            } else {
                isQuizCompleted = false
                quizIndex += 1
                quizType = quizData.quizList[quizIndex].type
                if userAnswerListForRequest.count >= quizIndex+1 {
                    print("There's already answered answer!")
                    print("userAnswerListForRequest count: \(userAnswerListForRequest.count)")
                    print("quizIndex: \(quizIndex)")
                    userRecentAnswer = userAnswerListForRequest[quizIndex]
                    getPreviousAnswer(userRecentAnswer, quizType: quizType)
                } else {
                    print("There's no answer. Should Get New Answer from user!")
                    print("userAnswerListForRequest count: \(userAnswerListForRequest.count)")
                    print("quizIndex: \(quizIndex)")
                }
            }
        }
    }
    
    func updateShortAnswer(_ userAnswer: String) {
        
        if let quizData = quizData {
            let answer = QuizAnswer(quizId: quizData.quizList[quizIndex].id, answer: userAnswer)
            
            if userAnswerListForRequest.count > quizIndex {
                print("Update to new answer!!")
                userAnswerListForRequest[quizIndex].answer = userAnswer
            } else {
                print("New answer!!")
                userAnswerListForRequest.append(answer)
            }
            
            isThisPreviousQuestion = false
            if userAnswerListForRequest.count == quizCount {
                print("Quiz is all done!!!")
                isQuizCompleted = true
            } else {
                isQuizCompleted = false
                quizIndex += 1
                quizType = quizData.quizList[quizIndex].type
                if userAnswerListForRequest.count >= quizIndex+1 {
                    print("There's already answered answer!")
                    print("userAnswerListForRequest count: \(userAnswerListForRequest.count)")
                    print("quizIndex: \(quizIndex)")
                    userRecentAnswer = userAnswerListForRequest[quizIndex]
                    getPreviousAnswer(userRecentAnswer, quizType: quizType)
                } else {
                    print("There's no answer. Should Get New Answer from user!")
                    print("userAnswerListForRequest count: \(userAnswerListForRequest.count)")
                    print("quizIndex: \(quizIndex)")
                }
            }
        }
    }
    
    func updateOXAnswer(_ userAnswer: Bool) {
        if let quizData = quizData {
            let answer = QuizAnswer(quizId: quizData.quizList[quizIndex].id, answer: "\(userAnswer)")
            
            if userAnswerListForRequest.count > quizIndex {
                print("Update to new answer!!")
                userAnswerListForRequest[quizIndex].answer = "\(userAnswer)"
            } else {
                print("New answer!!")
                userAnswerListForRequest.append(answer)
            }
            
            isThisPreviousQuestion = false
            if userAnswerListForRequest.count == quizCount {
                print("Quiz is all done!!!")
                isQuizCompleted = true
            } else {
                isQuizCompleted = false
                quizIndex += 1
                quizType = quizData.quizList[quizIndex].type
                if userAnswerListForRequest.count >= quizIndex+1 {
                    print("There's already answered answer!")
                    print("userAnswerListForRequest count: \(userAnswerListForRequest.count)")
                    print("quizIndex: \(quizIndex)")
                    userRecentAnswer = userAnswerListForRequest[quizIndex]
                    getPreviousAnswer(userRecentAnswer, quizType: quizType)
                } else {
                    print("There's no answer. Should Get New Answer from user!")
                    print("userAnswerListForRequest count: \(userAnswerListForRequest.count)")
                    print("quizIndex: \(quizIndex)")
                }
            }
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
        if let quizData = quizData {
            quizIndex -= 1
            
            userRecentAnswer = userAnswerListForRequest[quizIndex]
            print("Previous Answer: \(userRecentAnswer)")
            
            quizType = quizData.quizList[quizIndex].type
            print("Previous Quiz Type: \(quizType)")

            getPreviousAnswer(userRecentAnswer, quizType: quizType)
        }
    }
    
    private func getPreviousAnswer(_ userAnswer: QuizAnswer, quizType: QuizType) {
        switch quizType {
        case .multipleChoice:
            recentSelectedMultipleChoice = Int(userAnswer.answer)!
            print("Previous Answer in Multiple: \(recentSelectedMultipleChoice)")
        case .trueOrFalse:
            recentSelectedBoolAnswer = userAnswer.answer == "true" ? .chosenTrue : .chosenFalse
            print("Previous Answer in OX: \(recentSelectedBoolAnswer)")
        case .shortAnswer:
            recentSelectedShortAnswer = userAnswer.answer
            print("Previous Answer in Short Answer: \(recentSelectedShortAnswer)")
        }
        isThisPreviousQuestion = true
    }
    
    func checkRetakeQuiz() -> Bool {
        return pathString.hasPrefix("RetakeQuiz-")
    }
    
    func resetQuiz() {
        quizIndex = 0
        userRecentAnswer = QuizAnswer(quizId: -1, answer: "")
        userAnswerListForRequest.removeAll()
        print("Quiz Reset done!!")
        isQuizCompleted = false
    }
    
    func cleanUpCancellables() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        print("Cancellables count: \(cancellables.count)")
    }
    
    deinit {
        print("QuizViewModel DEINIT")
    }
    
}
