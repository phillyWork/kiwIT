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
    
    private var requestSubject = PassthroughSubject<Void, Never>()
    private var requestBookmarkSubject = PassthroughSubject<Void, Never>()
    
    private var userExampleAnswer = false

    var cancellables = Set<AnyCancellable>()

    var contentId: Int
    
    init(contentId: Int) {
        self.contentId = contentId
        setupDebounce()
        startLecture()
    }
    
    private func setupDebounce() {
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
    }
    
    func debounceToRequestCompleteLecture() {
        print("debounceToRequestCompleteLecture called")
        requestSubject.send(())
    }
    
    func debounceToRequestBookmarkLecture() {
        print("debounceToRequestBookmarkLecture called")
        requestBookmarkSubject.send(())
    }
    
    private func startLecture() {
        guard let tokenData = AuthManager.shared.checkTokenData() else {
            print("Should Login Again!!!")
            shouldLoginAgain = true
            return
        }
        requestLectureContent(tokenData.0, userId: tokenData.1)
    }
    
    private func requestLectureContent(_ token: UserTokenValue, userId: String) {
        NetworkManager.shared.request(type: StartLectureResponse.self, api: .startOfLecture(request: HandleLectureRequest(contentId: contentId, access: token.access)), errorCase: .startOfLecture)
            .sink { completion in
                if case .failure(let error) = completion {
                    if let startLectureError = error as? NetworkError {
                        switch startLectureError {
                        case .invalidToken(_):
                            self.requestRefreshToken(token, userId: userId, action: .startLecture)
                        default:
                            print("Start Lecture Error for network reason: \(startLectureError.description)")
                            self.showStartLectureErrorAlertToDismiss = true
                        }
                    } else {
                        print("start lecture error for other reason: \(error.localizedDescription)")
                        self.showStartLectureErrorAlertToDismiss = true
                    }
                }
            } receiveValue: { response in
                print("Start Lecture Right Away!!!")
                self.lectureContent = response
                if let alreadyTaken = response.contentStudied {
                    self.isThisLectureStudiedBefore = true
                    self.isThisLectureBookmarked = alreadyTaken.kept
                }
            }
            .store(in: &self.cancellables)
    }
    
    private func checkToRequestCompleteLecture() {
        if isThisLectureStudiedBefore {
            print("lecture studied before, showing example alert")
            self.showLectureExampleAlert = true
        } else {
            print("Requesting complete lecture content")
            isCompleteStudyButtonDisabled = true
            requestCompleteLectureContent()
        }
    }
    
    private func requestCompleteLectureContent() {
        guard let tokenData = AuthManager.shared.checkTokenData() else {
            print("Should Login Again!!!")
            shouldLoginAgain = true
            return
        }
        NetworkManager.shared.request(type: CompleteLectureResponse.self, api: .completionOfLecture(request: HandleLectureRequest(contentId: contentId, access: tokenData.0.access)), errorCase: .completionOfLecture)
            .sink { completion in
                if case .failure(let error) = completion {
                    if let completeLectureError = error as? NetworkError {
                        switch completeLectureError {
                        case .invalidToken(_):
                            self.requestRefreshToken(tokenData.0, userId: tokenData.1, action: .completeLecture)
                        default:
                            print("Complete Lecture Error for network reason: \(completeLectureError.description)")
                            self.showCompleteLectureErrorAlertToRetry = true
                        }
                    } else {
                        print("Complete Lecture Error for other reason: \(error.localizedDescription)")
                        self.showCompleteLectureErrorAlertToRetry = true
                    }
                }
            } receiveValue: { response in
                print("completed this lecture: \(response)")
                if !response.trophyAwardedList.isEmpty {
                    self.acquiredTrophyList = response.trophyAwardedList
                } else {
                    self.showLectureExampleAlert = true
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
            print("Should Login Again!!!")
            shouldLoginAgain = true
            return
        }
        NetworkManager.shared.request(type: BasicCompleteLectureContentPayload.self, api: .exerciseForLecture(request: ExerciseForLectureRequest(contentId: contentId, access: tokenData.0.access, answer: userExampleAnswer)), errorCase: .exerciseForLecture)
            .sink { completion in
                if case .failure(let error) = completion {
                    if let submitExerciseError = error as? NetworkError {
                        switch submitExerciseError {
                        case .invalidRequestBody(_):
                            print("Need User Answer for submit exercise: \(submitExerciseError.description)")
                            self.showSubmitExerciseErrorAlertToRetry = true
                        case .invalidToken(_):
                            self.requestRefreshToken(tokenData.0, userId: tokenData.1, action: .exerciseQuestion)
                        default:
                            print("Submit Exercise Error for network reason: \(submitExerciseError.description)")
                            self.showSubmitExerciseErrorAlertToRetry = true
                        }
                    } else {
                        print("Complete Lecture Error for other reason: \(error.localizedDescription)")
                        self.showSubmitExerciseErrorAlertToRetry = true
                    }
                }
            } receiveValue: { response in
                print("Submit Exercise Complete! - \(response)")
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
            print("Should Login Again!!!")
            shouldLoginAgain = true
            return
        }
        NetworkManager.shared.request(type: CompleteLectureResponse.self, api: .bookmarkLecture(request: HandleLectureRequest(contentId: contentId, access: tokenData.0.access)), errorCase: .bookmarkLecture)
            .sink { completion in
                if case .failure(let error) = completion {
                    if let bookmarkLectureError = error as? NetworkError {
                        switch bookmarkLectureError {
                        case .invalidRequestBody(_):
                            print("Bookmark Lecture Error for Failure: \(bookmarkLectureError.description)")
                            self.showBookmarkErrorAlert = true
                            self.isThisLectureBookmarked = false
                        case .invalidToken(_):
                            self.requestRefreshToken(tokenData.0, userId: tokenData.1, action: .bookmarkLecture)
                        default:
                            print("Bookmark Lecture Error for Network Reason: \(bookmarkLectureError.description)")
                            self.showBookmarkErrorAlert = true
                            self.isThisLectureBookmarked = false
                        }
                    } else {
                        print("Bookmark Lecture Error for other reason: \(error.localizedDescription)")
                        self.showBookmarkErrorAlert = true
                        self.isThisLectureBookmarked = false
                    }
                }
            } receiveValue: { response in
                print("Received Response for Bookmark result: \(response)")
                self.isThisLectureBookmarked = response.kept
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
        print("Cancellables count: \(cancellables.count)")
    }
    
    deinit {
        print("LectureViewModel DEINIT")
    }
    
}
