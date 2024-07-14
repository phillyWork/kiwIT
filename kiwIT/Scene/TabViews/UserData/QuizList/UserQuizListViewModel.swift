//
//  UserQuizListViewModel.swift
//  kiwIT
//
//  Created by Heedon on 7/5/24.
//

import Foundation

import Combine

enum QuizActionType {
    case takenQuiz
    case bookmarkedQuiz
    case unbookmark
}

final class UserQuizListViewModel: ObservableObject {
    
    @Published var shouldLoginAgain = false
    
    @Published var showUnknownNetworkErrorAlert = false
    @Published var showTakenQuizError = false
    @Published var showBookmarkedQuizError = false
    @Published var showRemoveBookmarkedQuizError = false
    
    @Published var showRemoveBookmarkedQuizAlert = false
   
    @Published var takenQuizList: [TakenQuizResponse] = []
    @Published var bookmarkedQuizList: [BookmarkedQuizListResponse] = []
    
    @Published var shouldUpdateProfileVM = false
    
    private let dataPerQuizRequest = 30
    private var currentPageForBookmarkedQuiz = 0
    private var currentPageForTakenQuiz = 0
    
    private var canLoadMoreBookmarkedQuiz = true
    private var canLoadMoreTakenQuiz = true
    
    private var requestReloadTakenQuiz = PassthroughSubject<Void, Never>()
    private var requestReloadBookmarkedQuiz = PassthroughSubject<Void, Never>()
    private var requestBookmarkButtonTapped = PassthroughSubject<Void, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    var idForToBeRemovedQuiz = -1
    
    init() {
        setupDebounce()
        requestTakenQuiz()
        requestBookmarkedQuiz()
    }
    
    private func setupDebounce() {
        requestReloadTakenQuiz
            .debounce(for: .seconds(Setup.Time.debounceInterval), scheduler: RunLoop.main)
            .sink { [weak self] in
                self?.resetTakenQuiz()
            }
            .store(in: &self.cancellables)
        
        requestReloadBookmarkedQuiz
            .debounce(for: .seconds(Setup.Time.debounceInterval), scheduler: RunLoop.main)
            .sink { [weak self] in
                self?.resetBookmarkedQuiz()
            }
            .store(in: &self.cancellables)
        
        requestBookmarkButtonTapped
            .debounce(for: .seconds(Setup.Time.debounceInterval), scheduler: RunLoop.main)
            .sink { [weak self] in
                self?.requestUnbookmarkQuiz()
            }
            .store(in: &self.cancellables)
    }
    
    func debouncedResetTakenQuiz() {
        requestReloadTakenQuiz.send(())
    }
    
    func debouncedResetBookmarkedQuiz() {
        requestReloadBookmarkedQuiz.send(())
    }
    
    func debouncedUnbookmarkQuiz() {
        requestBookmarkButtonTapped.send(())
    }
    
    func checkToRemoveBookmarkedQuiz(_ id: Int) {
        idForToBeRemovedQuiz = id
        showRemoveBookmarkedQuizAlert = true
    }
                                         
    private func resetTakenQuiz() {
        takenQuizList.removeAll()
        currentPageForTakenQuiz = 0
        requestTakenQuiz()
    }
    
    private func resetBookmarkedQuiz() {
        bookmarkedQuizList.removeAll()
        currentPageForBookmarkedQuiz = 0
        requestBookmarkedQuiz()
    }
    
    private func requestTakenQuiz() {
        guard let tokenData = AuthManager.shared.checkTokenData() else {
            print("Should Login Again!!!")
            shouldLoginAgain = true
            return
        }
        NetworkManager.shared.request(type: [TakenQuizResponse].self, api: .takenQuizListCheck(request: CheckCompletedOrBookmarkedQuizRequest(access: tokenData.0.access, next: currentPageForTakenQuiz, limit: dataPerQuizRequest)), errorCase: .takenQuizListCheck)
            .sink { completion in
                if case .failure(let error) = completion {
                    if let takenQuizError = error as? NetworkError {
                        switch takenQuizError {
                        case .invalidToken(_):
                            self.requestRefreshToken(tokenData.0, userId: tokenData.1, type: .takenQuiz)
                        default:
                            print("Taken Quiz Group Error for Network Reason: \(takenQuizError.description)")
                            self.showTakenQuizError = true
                        }
                    } else {
                        print("Taken Quiz Group Error for other reason: \(error.localizedDescription)")
                        self.showTakenQuizError = true
                    }
                }
            } receiveValue: { response in
                self.takenQuizList.append(contentsOf: response)
                self.canLoadMoreTakenQuiz = response.count >= self.dataPerQuizRequest
                self.showTakenQuizError = false
            }
            .store(in: &self.cancellables)
    }
    
    func loadMoreTakenQuiz() {
        guard canLoadMoreTakenQuiz else { return }
        currentPageForTakenQuiz += 1
        requestTakenQuiz()
    }

    private func requestBookmarkedQuiz() {
        guard let tokenData = AuthManager.shared.checkTokenData() else {
            print("Should Login Again!!!")
            shouldLoginAgain = true
            return
        }
        NetworkManager.shared.request(type: [BookmarkedQuizListResponse].self, api: .bookmarkedQuizCheck(request: CheckCompletedOrBookmarkedQuizRequest(access: tokenData.0.access, next: currentPageForBookmarkedQuiz, limit: dataPerQuizRequest)), errorCase: .bookmarkedQuizCheck)
            .sink { completion in
                if case .failure(let error) = completion {
                    if let bookmarkedQuizError = error as? NetworkError {
                        switch bookmarkedQuizError {
                        case .invalidToken(_):
                            self.requestRefreshToken(tokenData.0, userId: tokenData.1, type: .bookmarkedQuiz)
                        default:
                            print("Bookmarked Quiz List Error for network reason: \(bookmarkedQuizError.description)")
                            self.showBookmarkedQuizError = true
                        }
                    } else {
                        print("Bookmarked Quiz List Error for other reason: \(error.localizedDescription)")
                        self.showBookmarkedQuizError = true
                    }
                }
            } receiveValue: { response in
                self.bookmarkedQuizList.append(contentsOf: response)
                self.canLoadMoreBookmarkedQuiz = response.count >= self.dataPerQuizRequest
                self.showBookmarkedQuizError = false
            }
            .store(in: &self.cancellables)
    }
    
    func loadMoreBookmarkedQuiz() {
        guard canLoadMoreBookmarkedQuiz else { return }
        currentPageForBookmarkedQuiz += 1
        requestBookmarkedQuiz()
    }
    
    private func requestUnbookmarkQuiz() {
        guard let tokenData = AuthManager.shared.checkTokenData() else {
            print("Should Login Again!!!")
            shouldLoginAgain = true
            return
        }
        NetworkManager.shared.request(type: BookmarkQuizResponse.self, api: .bookmarkQuiz(request: BookmarkQuizRequest(quizId: idForToBeRemovedQuiz, access: tokenData.0.access)), errorCase: .bookmarkQuiz)
            .sink { completion in
                if case .failure(let error) = completion {
                    if let bookmarkQuizError = error as? NetworkError {
                        switch bookmarkQuizError {
                        case .invalidRequestBody(_):
                            print("Can't find quiz content: \(bookmarkQuizError.description)")
                            self.showRemoveBookmarkedQuizError = true
                        case .invalidToken(_):
                            self.requestRefreshToken(tokenData.0, userId: tokenData.1, type: .unbookmark)
                        default:
                            print("Un-Bookmark Quiz Error for network reason: \(bookmarkQuizError.description)")
                            self.showRemoveBookmarkedQuizError = true
                        }
                    } else {
                        print("Un-Bookmark Quiz Error for other reason: \(error.localizedDescription)")
                        self.showRemoveBookmarkedQuizError = true
                    }
                }
            } receiveValue: { response in
                self.bookmarkedQuizList = self.bookmarkedQuizList.filter { $0.id != response.quizId }
                self.shouldUpdateProfileVM = true
            }
            .store(in: &self.cancellables)
    }
    
    private func requestRefreshToken(_ token: UserTokenValue, userId: String, type: QuizActionType) {
        NetworkManager.shared.request(type: RefreshAccessTokenResponse.self, api: .refreshToken(request: RefreshAccessTokenRequest(refreshToken: token.refresh)), errorCase: .refreshToken)
            .sink { completion in
                if case .failure(let error) = completion {
                    if let refreshError = error as? NetworkError {
                        switch refreshError {
                        case .invalidToken(_):
                            print("Invalid For Both Access and Refresh. Needs to Sign In Again")
                            AuthManager.shared.handleRefreshTokenExpired(userId: userId)
                            //로그인 화면 이동하기
                            self.shouldLoginAgain = true
                        default:
                            print("Refresh Token Error in MainTabsViewModel Initiailzation: \(refreshError.description)")
                            self.showUnknownNetworkErrorAlert = true
                        }
                    } else {
                        print("Refresh Token Error for other eason: \(error.localizedDescription)")
                        self.showUnknownNetworkErrorAlert = true
                    }
                }
            } receiveValue: { response in
                KeyChainManager.shared.update(UserTokenValue(access: response.accessToken, refresh: response.refreshToken), id: userId)
                switch type {
                case .takenQuiz:
                    self.requestTakenQuiz()
                case .bookmarkedQuiz:
                    self.requestBookmarkedQuiz()
                case .unbookmark:
                    self.requestUnbookmarkQuiz()
                }
            }
            .store(in: &self.cancellables)
    }
    
    func cleanUpCancellables() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        print("Cancellables count: \(cancellables.count)")
    }
    
    deinit {
        print("UserQuizListViewModel DEINIT")
    }
    
    
}


