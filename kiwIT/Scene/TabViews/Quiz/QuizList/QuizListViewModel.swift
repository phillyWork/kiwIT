//
//  QuizListViewModel.swift
//  kiwIT
//
//  Created by Heedon on 5/4/24.
//

import Foundation

import Combine

enum QuizListAction {
    case requestQuizList
    case requestCompletedQuizList
}

final class QuizListViewModel: ObservableObject {
    
    @Published var shouldLoginAgain = false
    @Published var showEmptyView = true
    
    @Published var isCompletedQuizListLoading = true
    
    @Published var showUnknownNetworkErrorAlert = false
    
    @Published var isQuizGroupSelected = false

    @Published var quizListData: [QuizGroupPayload] = []
        
    private var alreadyTakenQuizList: [TakenQuizResponse] = []
    
    private var currentPageQuizListRequest = 0
    private var canRequestMoreQuizList = true
    
    private var currentPageCompletedQuizListRequest = 0
    private var canRequestMoreCompletedQuizList = true
        
    private let dataPerQuizListRequest = 30
    
    private var selectedQuizId = -1
    
    private var requestSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        print("QuizListViewModel INIT")
        setupDebounce()
        requestQuizList()
    }
    
    private func setupDebounce() {
        requestSubject
            .debounce(for: .seconds(Setup.Time.debounceInterval), scheduler: DispatchQueue.main)
            .sink { [weak self] in
                self?.requestQuizList()
            }
            .store(in: &cancellables)
    }
    
    private func requestQuizList() {
        guard let tokenData = AuthManager.shared.checkTokenData() else {
            print("Should Login Again!!!")
            shouldLoginAgain = true
            return
        }
        NetworkManager.shared.request(type: [QuizGroupPayload].self, api: .quizListCheck(request: QuizGroupListRequest(access: tokenData.0.access, next: currentPageQuizListRequest, limit: dataPerQuizListRequest)), errorCase: .quizListCheck)
            .sink { completion in
                if case .failure(let error) = completion {
                    if let quizListError = error as? NetworkError {
                        switch quizListError {
                        case .invalidRequestBody(_):
                            print("quiz list error by Query String Error: \(quizListError.description)")
                            self.showEmptyView = true
                        case .invalidToken(_):
                            self.requestRefreshToken(tokenData.0, userId: tokenData.1, type: .requestQuizList)
                        default:
                            print("quiz list error by Network Error: \(quizListError.description)")
                            self.showEmptyView = true
                        }
                    } else {
                        print("quiz list error by other reason: \(error.localizedDescription)")
                        self.showEmptyView = true
                    }
                }
            } receiveValue: { response in
                self.quizListData.append(contentsOf: response)
                self.canRequestMoreQuizList = response.count >= self.dataPerQuizListRequest
                self.showEmptyView = false
                if self.canRequestMoreCompletedQuizList {
                    self.requestCompletedQuizList()
                } else {
                    print("About to show completed quiz list in requestQuizList")
                    self.isCompletedQuizListLoading = false
                }
            }
            .store(in: &self.cancellables)
    }
    
    func loadMoreQuizList() {
        guard canRequestMoreQuizList else { return }
        print("About to load more quiz list!!!")
        currentPageQuizListRequest += 1
        requestQuizList()
    }
    
    func requestCompletedQuizList() {
        guard let tokenData = AuthManager.shared.checkTokenData() else {
            print("Should Login Again!!!")
            shouldLoginAgain = true
            return
        }
        NetworkManager.shared.request(type: [TakenQuizResponse].self, api: .takenQuizListCheck(request: CheckCompletedOrBookmarkedQuizRequest(access: tokenData.0.access, next: currentPageCompletedQuizListRequest, limit: dataPerQuizListRequest)), errorCase: .takenQuizListCheck)
            .sink { completion in
                if case .failure(let error) = completion {
                    if let completedQuizListError = error as? NetworkError {
                        switch completedQuizListError {
                        case .invalidToken(_):
                            self.requestRefreshToken(tokenData.0, userId: tokenData.1, type: .requestCompletedQuizList)
                        default:
                            print("Completed Quiz List Error by Network: \(completedQuizListError.description)")
                            
                        }
                    } else {
                        print("Completed Quiz List Error for other reason: \(error.localizedDescription)")
                        
                    }
                }
            } receiveValue: { response in
                self.alreadyTakenQuizList.append(contentsOf: response)
                self.canRequestMoreCompletedQuizList = response.count >= self.dataPerQuizListRequest
                self.loadMoreCompletedQuizList()
            }
            .store(in: &self.cancellables)
    }
    
    private func loadMoreCompletedQuizList() {
        guard canRequestMoreCompletedQuizList else {
            self.isCompletedQuizListLoading = false
            return
        }
        print("About to Load More Completed Quiz Content!!!")
        currentPageCompletedQuizListRequest += 1
        requestCompletedQuizList()
    }
    
    func checkAlreadyTaken(_ id: Int) -> TakenQuizResponse? {
        return alreadyTakenQuizList.filter { $0.id == id }.last
    }
    
    private func requestRefreshToken(_ token: UserTokenValue, userId: String, type: QuizListAction) {
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
                        print("Category Content Error for other reason: \(error.localizedDescription)")
//                        AuthManager.shared.handleRefreshTokenExpired(userId: userId)
//                        self.shouldLoginAgain = true
                        self.showUnknownNetworkErrorAlert = true
                    }
                }
            } receiveValue: { response in
                KeyChainManager.shared.update(UserTokenValue(access: response.accessToken, refresh: response.refreshToken), id: userId)
                switch type {
                case .requestQuizList:
                    self.requestQuizList()
                case .requestCompletedQuizList:
                    self.requestCompletedQuizList()
                }
            }
            .store(in: &self.cancellables)
    }
    
    func updateSelectedQuizGroupId(_ id: Int) {
        selectedQuizId = id
    }
    
    func getSelectedQuizGroupId() -> Int? {
        return selectedQuizId != -1 ? selectedQuizId : nil
    }
    
    func resetPaginationToRefreshQuizList() {
        currentPageQuizListRequest = 0
        currentPageCompletedQuizListRequest = 0
        quizListData.removeAll()
        alreadyTakenQuizList.removeAll()
        canRequestMoreQuizList = true
        canRequestMoreCompletedQuizList = true
        isQuizGroupSelected = false
        isCompletedQuizListLoading = true
        showEmptyView = true
        requestSubject.send()
    }
    
}
