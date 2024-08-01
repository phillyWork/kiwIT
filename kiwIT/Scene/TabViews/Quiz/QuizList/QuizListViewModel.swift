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

final class QuizListViewModel: ObservableObject, RefreshTokenHandler {
    
    typealias ActionType = QuizListAction
    
    @Published var shouldLoginAgain = false
    @Published var showEmptyView = true
    
    @Published var isCompletedQuizListLoading = true
    
    @Published var showUnknownNetworkErrorAlert = false
    
    @Published var quizListData: [QuizGroupPayload] = []
        
    private var alreadyTakenQuizList: [TakenQuizResponse] = []
    
    private var currentPageQuizListRequest = 0
    private var canRequestMoreQuizList = true
    
    private var currentPageCompletedQuizListRequest = 0
    private var canRequestMoreCompletedQuizList = true
    
    private let dataPerQuizListRequest = 30
    
    private var isQuizGroupSelected = false
    
    private var selectedQuizId = -1
    
    private let requestSubject = PassthroughSubject<Void, Never>()
    private let requestUserSelectionSubject = PassthroughSubject<Bool, Never>()
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        print("QuizListViewModel INIT")
        bind()
        requestQuizList()
    }
    
    private func bind() {
        requestSubject
            .debounce(for: .seconds(Setup.Time.debounceInterval), scheduler: DispatchQueue.main)
            .sink { [weak self] in
                self?.requestQuizList()
            }
            .store(in: &cancellables)
        
        requestUserSelectionSubject
            .sink { [weak self] value in
                self?.isQuizGroupSelected = value
            }
            .store(in: &cancellables)
    }
    
    func updateSelectedQuiz(_ id: Int) {
        requestUserSelectionSubject.send(true)
        selectedQuizId = id
    }
    
    func dismissFromQuiz() {
        requestUserSelectionSubject.send(false)
    }
    
    func checkMorePaginationNeeded(_ eachQuizGroup: QuizGroupPayload) {
        if quizListData.last == eachQuizGroup {
            print("Last data for list: should call more!!!")
            loadMoreQuizList()
        }
    }
    
    private func requestQuizList() {
        guard let tokenData = AuthManager.shared.checkTokenData() else {
            print("Should Login Again!!!")
            shouldLoginAgain = true
            return
        }
        NetworkManager.shared.request(type: [QuizGroupPayload].self, api: .quizListCheck(request: QuizGroupListRequest(access: tokenData.0.access, next: currentPageQuizListRequest, limit: dataPerQuizListRequest)), errorCase: .quizListCheck)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    if let quizListError = error as? NetworkError {
                        switch quizListError {
                        case .invalidRequestBody(_):
                            print("quiz list error by Query String Error: \(quizListError.description)")
                            self?.showEmptyView = true
                        case .invalidToken(_):
                            self?.requestRefreshToken(tokenData.0, userId: tokenData.1, action: .requestQuizList)
                        default:
                            print("quiz list error by Network Error: \(quizListError.description)")
                            self?.showEmptyView = true
                        }
                    } else {
                        print("quiz list error by other reason: \(error.localizedDescription)")
                        self?.showEmptyView = true
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
    
    private func loadMoreQuizList() {
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
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    if let completedQuizListError = error as? NetworkError {
                        switch completedQuizListError {
                        case .invalidToken(_):
                            self?.requestRefreshToken(tokenData.0, userId: tokenData.1, action: .requestCompletedQuizList)
                        default:
                            print("Completed Quiz List Error by Network: \(completedQuizListError.description)")
                            self?.canRequestMoreCompletedQuizList = false
                        }
                    } else {
                        print("Completed Quiz List Error for other reason: \(error.localizedDescription)")
                        self?.canRequestMoreCompletedQuizList = false
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
    
    func getSelectedQuizGroupId() -> Int? {
        return selectedQuizId != -1 ? selectedQuizId : nil
    }
    
    func handleRefreshTokenSuccess(response: UserTokenValue, userId: String, action: QuizListAction) {
        switch action {
        case .requestQuizList:
            requestQuizList()
        case .requestCompletedQuizList:
            requestCompletedQuizList()
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
    
    func checkRetakeQuiz() {
        if isQuizGroupSelected {
            print("Getting back from QuizResultView!!!")
            resetPaginationToRefreshQuizList()
        }
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
