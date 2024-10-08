//
//  LectureViewModel.swift
//  kiwIT
//
//  Created by Heedon on 3/19/24.
//

import Foundation

import Combine

enum LectureViewActionType {
    case startLecture
    case completeLecture
    case exerciseQuestion
    case bookmarkLecture
}

final class LectureViewModel: ObservableObject, RefreshTokenHandler {
   
    typealias ActionType = LectureViewActionType
        
    @Published var showProgressViewForLoadingWeb = true
    
    @Published var showLectureExampleAlert = false
    @Published var showExampleAnswerAlert = false
    
    @Published var showUnknownNetworkErrorAlert = false
    
    @Published var isThisLectureStudiedBefore = false
    @Published var isThisLectureBookmarked = false
    @Published var showBookmarkErrorAlert = false
        
    @Published var shouldLoginAgain = false
    
    @Published var showStartLectureErrorAlertToDismiss = false
    @Published var showCompleteLectureErrorAlertToRetry = false
    @Published var showSubmitExerciseErrorAlertToRetry = false
    @Published var showBookmarkThisLectureForFirstTimeAlert = false
    
    @Published var isCompleteStudyButtonDisabled = false
    
    @Published var lectureStudyAllDone = false
        
    @Published var lectureContent: StartLectureResponse?
    
    @Published var acquiredTrophyList: [TrophyEntity] = []
    
    private let dispatchGroup = DispatchGroup()
    
    private let requestSubject = PassthroughSubject<Void, Never>()
    private let requestBookmarkSubject = PassthroughSubject<Void, Never>()
    private let statusForStudyAllDoneSubject = PassthroughSubject<Bool, Never>()
    private let requestSubmitExerciseSubject = PassthroughSubject<Void, Never>()
    
    private var userExampleAnswer = false

    var cancellables = Set<AnyCancellable>()

    var contentId: Int
    
    init(contentId: Int) {
        self.contentId = contentId
        bind()
        startLecture()
    }
    
    private func bind() {
        requestSubject
            .debounce(for: .seconds(Setup.Time.debounceInterval), scheduler: DispatchQueue.main)
            .sink { [weak self] in
                self?.checkToRequestCompleteLecture()
            }
            .store(in: &cancellables)
        
        requestBookmarkSubject
            .debounce(for: .seconds(Setup.Time.debounceInterval), scheduler: RunLoop.main)
            .sink { [weak self] in
                self?.requestBookmarkThisLecture()
            }
            .store(in: &cancellables)
        
        statusForStudyAllDoneSubject
            .sink { [weak self] status in
                self?.lectureStudyAllDone = status
            }
            .store(in: &cancellables)
        
        requestSubmitExerciseSubject
            .debounce(for: .seconds(Setup.Time.debounceInterval), scheduler: DispatchQueue.main)
            .sink { [weak self] in
                self?.requestSubmitExerciseAnswer()
            }
            .store(in: &cancellables)
    }
    
    func debounceToRequestCompleteLecture() {
        requestSubject.send(())
    }
    
    func debounceToRequestBookmarkLecture() {
        requestBookmarkSubject.send(())
    }
    
    func bookmarkThisLectureAndStudyAllDone() {
        debounceToRequestBookmarkLecture()
        dispatchGroup.notify(queue: .main) {
            self.sendToUpdateStudyAllDoneStatus(true)
        }
    }
    
    func sendToUpdateStudyAllDoneStatus(_ value: Bool) {
        statusForStudyAllDoneSubject.send(value)
    }
    
    func debounceToRequestSubmitExerciseAnswer() {
        requestSubmitExerciseSubject.send(())
    }
    
    private func startLecture() {
        guard let tokenData = AuthManager.shared.checkTokenData() else {
            shouldLoginAgain = true
            return
        }
        requestLectureContent(tokenData.0, userId: tokenData.1)
    }
    
    private func requestLectureContent(_ token: UserTokenValue, userId: String) {
        NetworkManager.shared.request(type: StartLectureResponse.self, api: .startOfLecture(request: HandleLectureRequest(contentId: contentId, access: token.access)), errorCase: .startOfLecture)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    if let startLectureError = error as? NetworkError {
                        switch startLectureError {
                        case .invalidToken(_):
                            self?.requestRefreshToken(token, userId: userId, action: .startLecture)
                        default:
                            self?.showStartLectureErrorAlertToDismiss = true
                        }
                    } else {
                        self?.showStartLectureErrorAlertToDismiss = true
                    }
                }
            } receiveValue: { [weak self] response in
                self?.lectureContent = response
                if let alreadyTaken = response.contentStudied {
                    self?.isThisLectureStudiedBefore = true
                    self?.isThisLectureBookmarked = alreadyTaken.kept
                }
            }
            .store(in: &self.cancellables)
    }
    
    private func checkToRequestCompleteLecture() {
        if isThisLectureStudiedBefore {
            self.showLectureExampleAlert = true
        } else {
            isCompleteStudyButtonDisabled = true
            requestCompleteLectureContent()
        }
    }
    
    private func requestCompleteLectureContent() {
        guard let tokenData = AuthManager.shared.checkTokenData() else {
            shouldLoginAgain = true
            return
        }
        NetworkManager.shared.request(type: CompleteLectureResponse.self, api: .completionOfLecture(request: HandleLectureRequest(contentId: contentId, access: tokenData.0.access)), errorCase: .completionOfLecture)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    if let completeLectureError = error as? NetworkError {
                        switch completeLectureError {
                        case .invalidToken(_):
                            self?.requestRefreshToken(tokenData.0, userId: tokenData.1, action: .completeLecture)
                        default:
                            self?.showCompleteLectureErrorAlertToRetry = true
                        }
                    } else {
                        self?.showCompleteLectureErrorAlertToRetry = true
                    }
                }
            } receiveValue: { [weak self] response in
                if !response.trophyAwardedList.isEmpty {
                    self?.acquiredTrophyList = response.trophyAwardedList
                } else {
                    self?.showLectureExampleAlert = true
                }
            }
            .store(in: &self.cancellables)
    }
    
    func handleAfterCloseNewAcquiredTrophyCard() {
        acquiredTrophyList.removeAll()
        isCompleteStudyButtonDisabled = false
        showLectureExampleAlert = true
    }
    
    func updateAnswerAsTrue() {
        userExampleAnswer = true
        showExampleAnswerAlert = true
    }
    
    func updateAnswerAsFalse() {
        userExampleAnswer = false
        showExampleAnswerAlert = true
    }

    func checkExampleAnswer() -> Bool {
        return userExampleAnswer == lectureContent?.answer
    }
    
    func requestSubmitExerciseAnswer() {
        guard let tokenData = AuthManager.shared.checkTokenData() else {
            shouldLoginAgain = true
            return
        }
        NetworkManager.shared.request(type: BasicCompleteLectureContentPayload.self, api: .exerciseForLecture(request: ExerciseForLectureRequest(contentId: contentId, access: tokenData.0.access, answer: userExampleAnswer)), errorCase: .exerciseForLecture)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    if let submitExerciseError = error as? NetworkError {
                        switch submitExerciseError {
                        case .invalidRequestBody(_):
                            self?.showSubmitExerciseErrorAlertToRetry = true
                        case .invalidToken(_):
                            self?.requestRefreshToken(tokenData.0, userId: tokenData.1, action: .exerciseQuestion)
                        default:
                            self?.showSubmitExerciseErrorAlertToRetry = true
                        }
                    } else {
                        self?.showSubmitExerciseErrorAlertToRetry = true
                    }
                }
            } receiveValue: { response in
                if self.isThisLectureStudiedBefore {
                    self.lectureStudyAllDone = true
                } else {
                    self.showBookmarkThisLectureForFirstTimeAlert = true
                }
            }
            .store(in: &self.cancellables)
    }
    
    private func requestBookmarkThisLecture() {
        guard let tokenData = AuthManager.shared.checkTokenData() else {
            shouldLoginAgain = true
            return
        }
        dispatchGroup.enter()
        NetworkManager.shared.request(type: BookmarkLectureResponse.self, api: .bookmarkLecture(request: HandleLectureRequest(contentId: contentId, access: tokenData.0.access)), errorCase: .bookmarkLecture)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    if let bookmarkLectureError = error as? NetworkError {
                        switch bookmarkLectureError {
                        case .invalidRequestBody(_):
                            self?.showBookmarkErrorAlert = true
                            self?.isThisLectureBookmarked = false
                            self?.dispatchGroup.leave()
                        case .invalidToken(_):
                            self?.requestRefreshToken(tokenData.0, userId: tokenData.1, action: .bookmarkLecture)
                        default:
                            self?.showBookmarkErrorAlert = true
                            self?.isThisLectureBookmarked = false
                            self?.dispatchGroup.leave()
                        }
                    } else {
                        self?.showBookmarkErrorAlert = true
                        self?.isThisLectureBookmarked = false
                        self?.dispatchGroup.leave()
                    }
                }
            } receiveValue: { [weak self] response in
                self?.isThisLectureBookmarked = response.kept
                self?.dispatchGroup.leave()
            }
            .store(in: &self.cancellables)
    }
    
    func handleRefreshTokenSuccess(response: UserTokenValue, userId: String, action: LectureViewActionType) {
        switch action {
        case .startLecture:
            self.requestLectureContent(response, userId: userId)
        case .completeLecture:
            self.requestCompleteLectureContent()
        case .exerciseQuestion:
            self.requestSubmitExerciseAnswer()
        case .bookmarkLecture:
            self.requestBookmarkThisLecture()
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
    
    func cleanUpCancellables() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    deinit {
        print("LectureViewModel DEINIT")
    }
    
}
