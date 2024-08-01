//
//  UserLectureListViewModel.swift
//  kiwIT
//
//  Created by Heedon on 7/5/24.
//

import Foundation

import Combine

enum DetailedLectureActionType {
    case completedList
    case bookmarkedList
    case unbookmark
}

final class UserLectureListViewModel: ObservableObject, RefreshTokenHandler {

    typealias ActionType = DetailedLectureActionType
    
    @Published var shouldLoginAgain = false
    
    @Published var showUnknownNetworkErrorAlert = false
    @Published var showCompletedLectureError = false
    @Published var showBookmarkedLectureError = false
    @Published var showRemoveBookmarkedLectureError = false
    
    @Published var showRemoveBookmarkedLectureAlert = false
    
    @Published var showSheetWebView = false
    
    @Published var completedLectureList: [CompletedOrBookmarkedLecture] = []
    @Published var bookmarkedLectureList: [CompletedOrBookmarkedLecture] = []
    
    @Published var shouldUpdateProfileVM = false
    
    private let dataPerLectureRequest = 30
    private var currentPageForBookmarkedLecture = 0
    private var currentPageForCompletedLecture = 0
    
    private var canLoadMoreBookmarkedLecture = true
    private var canLoadMoreCompletedLecture = true
    
    private let requestReloadCompletedLecture = PassthroughSubject<Void, Never>()
    private let requestReloadBookmarkedLecture = PassthroughSubject<Void, Never>()
    private let requestBookmarkButtonTapped = PassthroughSubject<Void, Never>()
    
    var cancellables = Set<AnyCancellable>()
    
    var urlForSheetWebView = ""
    var idForToBeRemovedLecture = -1
    
    init() {
        bind()
        requestCompletedLecture()
        requestBookmarkedLecture()
    }
    
    private func bind() {
        requestReloadCompletedLecture
            .debounce(for: .seconds(Setup.Time.debounceInterval), scheduler: RunLoop.main)
            .sink { [weak self] in
                self?.resetCompletedLecture()
            }
            .store(in: &self.cancellables)
        
        requestReloadBookmarkedLecture
            .debounce(for: .seconds(Setup.Time.debounceInterval), scheduler: RunLoop.main)
            .sink { [weak self] in
                self?.resetBookmarkedLecture()
            }
            .store(in: &self.cancellables)
        
        requestBookmarkButtonTapped
            .debounce(for: .seconds(Setup.Time.debounceInterval), scheduler: RunLoop.main)
            .sink { [weak self] in
                self?.requestUnbookmarkLecture()
            }
            .store(in: &self.cancellables)
    }
    
    func debouncedResetCompletedLecture() {
        requestReloadCompletedLecture.send(())
    }
    
    func debouncedResetBookmarkedLecture() {
        requestReloadBookmarkedLecture.send(())
    }
    
    func debouncedUnbookmarkLecture() {
        requestBookmarkButtonTapped.send()
    }

    func showWebView(_ lecture: CompletedOrBookmarkedLecture) {
        urlForSheetWebView = lecture.payloadUrl
        showSheetWebView = true
    }
    
    func checkToRemoveBookmarkedLecture(_ id: Int) {
        idForToBeRemovedLecture = id
        showRemoveBookmarkedLectureAlert = true
    }
    
    func checkToLoadMoreCompletedLecturePagination(_ eachLecture: CompletedOrBookmarkedLecture) {
        if completedLectureList.last == eachLecture {
            loadMoreCompletedLecture()
        }
    }
    
    func checkToLoadMoreBookmarkedLecturePagination(_ lecture: CompletedOrBookmarkedLecture) {
        if bookmarkedLectureList.last == lecture {
            loadMoreBookmarkedLecture()
        }

    }
    
    private func requestCompletedLecture() {
        guard let tokenData = AuthManager.shared.checkTokenData() else {
            print("Should Login Again!!!")
            shouldLoginAgain = true
            return
        }
        NetworkManager.shared.request(type: [CompletedOrBookmarkedLecture].self, api: .completedLectureListCheck(request: CompletedLectureListCheckRequest(access: tokenData.0.access, next: currentPageForCompletedLecture, limit: dataPerLectureRequest, byLevel: true)), errorCase: .completedLectureListCheck)
            .sink { completion in
                if case .failure(let error) = completion {
                    if let completedLectureError = error as? NetworkError {
                        switch completedLectureError {
                        case .invalidToken(_):
                            self.requestRefreshToken(tokenData.0, userId: tokenData.1, action: .completedList)
                        default:
                            print("Completed Lecture List Error for Network Reason: \(completedLectureError.description)")
                            self.showCompletedLectureError = true
                        }
                    } else {
                        print("Completed Lecture List Error for other reason: \(error.localizedDescription)")
                        self.showCompletedLectureError = true
                    }
                }
            } receiveValue: { response in
                self.completedLectureList.append(contentsOf: response)
                self.canLoadMoreCompletedLecture = response.count >= self.dataPerLectureRequest
                self.showCompletedLectureError = false
            }
            .store(in: &self.cancellables)
    }
    
    private func loadMoreCompletedLecture() {
        guard canLoadMoreCompletedLecture else { return }
        currentPageForCompletedLecture += 1
        requestCompletedLecture()
    }

    private func requestBookmarkedLecture() {
        guard let tokenData = AuthManager.shared.checkTokenData() else {
            print("Should Login Again!!!")
            shouldLoginAgain = true
            return
        }
        NetworkManager.shared.request(type: [CompletedOrBookmarkedLecture].self, api: .bookmarkedLectureCheck(request: BookmarkedLectureCheckRequest(access: tokenData.0.access, next: currentPageForBookmarkedLecture, limit: dataPerLectureRequest)), errorCase: .bookmarkedLectureCheck)
            .sink { completion in
                if case .failure(let error) = completion {
                    if let bookmarkedLectureError = error as? NetworkError {
                        switch bookmarkedLectureError {
                        case .invalidToken(_):
                            self.requestRefreshToken(tokenData.0, userId: tokenData.1, action: .bookmarkedList)
                        default:
                            print("Bookmarked Lecture List Error for network reason: \(bookmarkedLectureError.description)")
                            self.showBookmarkedLectureError = true
                        }
                    } else {
                        print("Bookmarked Lecture List Error for other reason: \(error.localizedDescription)")
                        self.showBookmarkedLectureError = true
                    }
                }
            } receiveValue: { response in
                self.bookmarkedLectureList.append(contentsOf: response)
                self.canLoadMoreBookmarkedLecture = response.count >= self.dataPerLectureRequest
                self.showBookmarkedLectureError = false
            }
            .store(in: &self.cancellables)
    }
    
    private func loadMoreBookmarkedLecture() {
        guard canLoadMoreBookmarkedLecture else { return }
        currentPageForBookmarkedLecture += 1
        requestBookmarkedLecture()
    }
    
    private func resetCompletedLecture() {
        completedLectureList.removeAll()
        currentPageForCompletedLecture = 0
        requestCompletedLecture()
    }
    
    private func resetBookmarkedLecture() {
        bookmarkedLectureList.removeAll()
        currentPageForBookmarkedLecture = 0
        requestBookmarkedLecture()
    }
    
    private func requestUnbookmarkLecture() {
        guard let tokenData = AuthManager.shared.checkTokenData() else {
            print("Should Login Again!!!")
            shouldLoginAgain = true
            return
        }
        NetworkManager.shared.request(type: BookmarkLectureResponse.self, api: .bookmarkLecture(request: HandleLectureRequest(contentId: idForToBeRemovedLecture, access: tokenData.0.access)), errorCase: .bookmarkLecture)
            .sink { completion in
                if case .failure(let error) = completion {
                    if let bookmarkLectureError = error as? NetworkError {
                        switch bookmarkLectureError {
                        case .invalidRequestBody(_):
                            print("Can't find lecture content: \(bookmarkLectureError.description)")
                            self.showRemoveBookmarkedLectureError = true
                        case .invalidToken(_):
                            self.requestRefreshToken(tokenData.0, userId: tokenData.1, action: .unbookmark)
                        default:
                            print("Un-Bookmark Lecture Error for network reason: \(bookmarkLectureError.description)")
                            self.showRemoveBookmarkedLectureError = true
                        }
                    } else {
                        print("Un-Bookmark Lecture Error for other reason: \(error.localizedDescription)")
                        self.showRemoveBookmarkedLectureError = true
                    }
                }
            } receiveValue: { response in
                self.bookmarkedLectureList = self.bookmarkedLectureList.filter { $0.id != response.contentId }
                self.shouldUpdateProfileVM = true
            }
            .store(in: &self.cancellables)
    }
    
    func handleRefreshTokenSuccess(response: UserTokenValue, userId: String, action: DetailedLectureActionType) {
        switch action {
        case .completedList:
            self.requestCompletedLecture()
        case .bookmarkedList:
            self.requestBookmarkedLecture()
        case .unbookmark:
            self.requestUnbookmarkLecture()
        }
    }
    
    func handleRefreshTokenError(isRefreshInvalid: Bool, userId: String) {
        if isRefreshInvalid {
            AuthManager.shared.handleRefreshTokenExpired(userId: userId)
            //로그인 화면 이동하기
            shouldLoginAgain = true
        } else {
            showUnknownNetworkErrorAlert = true
        }
    }

    func cleanUpCancellables() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        print("Cancellables count: \(cancellables.count)")
    }
    
    deinit {
        print("UserLectureListViewModel DEINIT")
    }
    
}
