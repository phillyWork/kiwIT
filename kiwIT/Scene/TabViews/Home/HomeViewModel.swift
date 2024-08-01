//
//  HomeViewModel.swift
//  kiwIT
//
//  Created by Heedon on 3/12/24.
//

import Foundation

import Combine

enum HomeViewActionType {
    case nextLecture
    case latestQuiz
}

final class HomeViewModel: ObservableObject, RefreshTokenHandler {
    
    typealias ActionType = HomeViewActionType
    
    @Published var shouldLoginAgain = false
    @Published var showUnknownNetworkErrorAlert = false
    @Published var showNextLectureError = false
    @Published var showLatestTakenQuizError = false
    
    @Published var nextLectureToStudy: LectureContentListPayload?
    @Published var latestTakenQuiz: TakenQuizResponse?
    
    private let dispatchGroup = DispatchGroup()
    
    private var actionType: HomeViewActionType = .nextLecture
    
    private let subjectNextLecture = PassthroughSubject<Void, Never>()
    private let subjectLatestTakenQuiz = PassthroughSubject<Void, Never>()
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        print("HomeViewModel INIT")
        bind()
        basicRequest()
    }
    
    private func bind() {
        subjectNextLecture
            .debounce(for: .seconds(Setup.Time.debounceInterval), scheduler: RunLoop.main)
            .sink { [weak self] in
                self?.requestNextLecture()
            }
            .store(in: &self.cancellables)
        
        subjectLatestTakenQuiz
            .debounce(for: .seconds(Setup.Time.debounceInterval), scheduler: RunLoop.main)
            .sink { [weak self] in
                self?.requestLatestQuizResult()
            }
            .store(in: &self.cancellables)
    }
    
    private func basicRequest() {
        requestNextLecture()
        dispatchGroup.notify(queue: .main) {
            print("Request Next Lecture Done!!! Requet Latest Quiz Result!!!")
            self.requestLatestQuizResult()
        }
    }
    
    func debouncedRequestNextLecture() {
        subjectNextLecture.send(())
    }
    
    func debouncedRequestLatestTakenQuiz() {
        subjectLatestTakenQuiz.send(())
    }
    
    private func requestNextLecture() {
        guard let tokenData = AuthManager.shared.checkTokenData() else {
            shouldLoginAgain = true
            return
        }
        dispatchGroup.enter()
        NetworkManager.shared.request(type: LectureContentListPayload.self, api: .nextLectureToStudyCheck(request: AuthorizationRequest(access: tokenData.0.access)), errorCase: .nextLectureToStudyCheck)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    if let nextLectureToStudyError = error as? NetworkError {
                        switch nextLectureToStudyError {
                        case .invalidRequestBody(_):
                            print("No content to study: \(nextLectureToStudyError.description)")
                            self?.dispatchGroup.leave()
                        case .invalidToken(_):
                            self?.requestRefreshToken(tokenData.0, userId: tokenData.1, action: .nextLecture)
                        default:
                            print("Getting next lecture error by network reason: \(nextLectureToStudyError.description)")
                            self?.showNextLectureError = true
                            self?.dispatchGroup.leave()
                        }
                    } else {
                        print("Getting next lecture error by other reason: \(error.localizedDescription)")
                        self?.showNextLectureError = true
                        self?.dispatchGroup.leave()
                    }
                }
            } receiveValue: { [weak self] response in
                self?.nextLectureToStudy = response
                self?.showNextLectureError = false
                self?.dispatchGroup.leave()
            }
            .store(in: &self.cancellables)
    }
    
    private func requestLatestQuizResult() {
        guard let tokenData = AuthManager.shared.checkTokenData() else {
            shouldLoginAgain = true
            return
        }
        dispatchGroup.enter()
        NetworkManager.shared.request(type: TakenQuizResponse.self, api: .latestTakenQuiz(request: AuthorizationRequest(access: tokenData.0.access)), errorCase: .latestTakenQuiz)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    if let latestTakenQuizError = error as? NetworkError {
                        switch latestTakenQuizError {
                        case .emptyBody(_):
                            print("No Quiz Taken")
                            self?.showLatestTakenQuizError = false
                        case .invalidToken(_):
                            self?.requestRefreshToken(tokenData.0, userId: tokenData.1, action: .latestQuiz)
                        default:
                            print("Getting latest taken quiz error by network reason: \(latestTakenQuizError.description)")
                            self?.showNextLectureError = true
                        }
                    } else {
                        print("Getting latest taken quiz error by other reason: \(error.localizedDescription)")
                        self?.showLatestTakenQuizError = true
                    }
                    self?.dispatchGroup.leave()
                }
            } receiveValue: { [weak self] response in
                self?.latestTakenQuiz = response
                self?.showLatestTakenQuizError = false
                self?.dispatchGroup.leave()
            }
            .store(in: &self.cancellables)
    }
    
    func handleRefreshTokenSuccess(response: UserTokenValue, userId: String, action: HomeViewActionType) {
        switch action {
        case .nextLecture:
            requestNextLecture()
        case .latestQuiz:
            requestLatestQuizResult()
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
        print("HomeViewModel DEINIT")
    }
}
