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

//MARK: - API 수정 완료 시: 실제 학습 시작 및 완료, 예제 문제 처리 테스트하기


final class LectureViewModel: ObservableObject {
    
    @Published var showProgressViewForLoadingWeb = true
    
    @Published var showLectureExampleAlert = false
    @Published var showExampleAnswerAlert = false
    
    @Published var isThisLectureBookmarked = false
    @Published var showBookmarkErrorAlert = false
        
    @Published var shouldLoginAgain = false
    
    @Published var showStartLectureErrorAlertToDismiss = false
    @Published var showCompleteLectureErrorAlertToRetry = false
    @Published var showSubmitExerciseErrorAlertToRetry = false
    
    @Published var lectureStudyAllDone = false
        
    private var userExampleAnswer = false

    private var cancellables = Set<AnyCancellable>()
    
    var contentId: Int
    var lectureContent: StartLectureResponse?
    var completeLecture: CompleteLectureResponse?
    
    init(contentId: Int) {
        self.contentId = contentId
        startLecture()
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
                            self.requestRefreshToken(.startLecture, token: token, userId: userId)
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
                self.showProgressViewForLoadingWeb = false
                if let alreadyTaken = response.contentStudied {
                    self.isThisLectureBookmarked = alreadyTaken.kept
                }
            }
            .store(in: &self.cancellables)
    }
    
    //MARK: - 동일 콘텐츠 두 번째 요청부터 400 에러 발생
    
    func requestCompleteLectureContent() {
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
                            self.requestRefreshToken(.completeLecture, token: tokenData.0, userId: tokenData.1)
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
                self.completeLecture = response
                self.showLectureExampleAlert = true
            }
            .store(in: &self.cancellables)
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
        NetworkManager.shared.request(type: CompleteLectureResponse.self, api: .exerciseForLecture(request: ExerciseForLectureRequest(contentId: contentId, access: tokenData.0.access, answer: userExampleAnswer)), errorCase: .exerciseForLecture)
            .sink { completion in
                if case .failure(let error) = completion {
                    if let submitExerciseError = error as? NetworkError {
                        switch submitExerciseError {
                        case .invalidRequestBody(_):
                            print("Need User Answer for submit exercise: \(submitExerciseError.description)")
                            self.showSubmitExerciseErrorAlertToRetry = true
                        case .invalidToken(_):
                            self.requestRefreshToken(.exerciseQuestion, token: tokenData.0, userId: tokenData.1)
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
                self.lectureStudyAllDone = true
            }
            .store(in: &self.cancellables)

    }
    
    func requestRefreshToken(_ type: LectureViewActionType, token: UserTokenValue, userId: String) {
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
                print("Update Token!!!")
                KeyChainManager.shared.update(UserTokenValue(access: response.accessToken, refresh: response.refreshToken), id: userId)
                switch type {
                case .startLecture:
                    self.requestLectureContent(UserTokenValue(access: response.accessToken, refresh: response.refreshToken), userId: userId)
                case .completeLecture:
                    self.requestCompleteLectureContent()
                case .exerciseQuestion:
                    self.requestSubmitExerciseAnswer()
                case .bookmarkLecture:
                    self.requestBookmarkThisLecture()
                }
            }
            .store(in: &self.cancellables)
    }

    //MARK: - 버튼 누를 때마다 bookmark 처리 함수 호출 --> Debounce 혹은 throttle 활용 방안?
    
    func requestBookmarkThisLecture() {
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
                            self.requestRefreshToken(.bookmarkLecture, token: tokenData.0, userId: tokenData.1)
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
    
    
    
}
