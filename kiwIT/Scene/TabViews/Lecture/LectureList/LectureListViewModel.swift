//
//  LectureCategoryListViewModel.swift
//  kiwIT
//
//  Created by Heedon on 3/19/24.
//

import Foundation

import Combine

final class LectureListViewModel: ObservableObject {
    
    @Published var shouldLoginAgain = false
    @Published var showLectureList = false
    
    @Published var showUnknownNetworkErrorAlert = false

    @Published var lectureType = LectureListType.category
    
    @Published var lectureLevelListData: [LectureLevelListPayload] = []
    @Published var lectureCategoryListData: [LectureCategoryListPayload] = []
    
    private var requestSubject = PassthroughSubject<Void, Never>()      //debounce network call
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupDebounce()
        updateViewByPickerSelection()
    }
    
    func updateViewByPickerSelection() {
        switch lectureType {
        case .category:
            if lectureCategoryListData.isEmpty {
                requestLectureList()
            }
        case .level:
            if lectureLevelListData.isEmpty {
                requestLectureList()
            }
        }
    }
    
    private func setupDebounce() {
        requestSubject
            .debounce(for: .seconds(Setup.Time.debounceInterval), scheduler: DispatchQueue.main)
            .sink { [weak self] in
                self?.performRequestLectureList()
            }
            .store(in: &cancellables)
    }
    
    func requestLectureList() {
        requestSubject.send(())
    }
    
    func performRequestLectureList() {
        guard let tokenData = AuthManager.shared.checkTokenData() else {
            print("Should Login Again!!!")
            shouldLoginAgain = true
            return
        }
        switch lectureType {
        case .category:
            requestLectureListBasedOnCategory(tokenData.0, userId: tokenData.1)
        case .level:
            requestLectureListBasedOnLevel(tokenData.0, userId: tokenData.1)
        }
    }
    
    private func requestLectureListBasedOnCategory(_ token: UserTokenValue, userId: String) {
        NetworkManager.shared.request(type: [LectureCategoryListPayload].self, api: .lectureCategoryListCheck(request: AuthorizationRequest(access: token.access)), errorCase: .lectureCategoryListCheck)
            .sink { completion in
                if case .failure(let error) = completion {
                    if let lectureCategoryListError = error as? NetworkError {
                        switch lectureCategoryListError {
                        case .invalidToken(_):
                            self.requestRefreshToken(token, userId: userId)
                        default:
                            print("Getting Lecture Category List Error in Lecture Category ViewModel: \(lectureCategoryListError.description)")
                            self.showLectureList = false
                        }
                    } else {
                        print("Getting Lecture Level List Error in Lecture Category ViewModel for other reason: \(error.localizedDescription)")
                        self.showLectureList = false
                    }
                }
            } receiveValue: { response in
                print("Getting Category List!!!")
                self.lectureCategoryListData = response
                self.showLectureList = true
            }
            .store(in: &self.cancellables)
    }
    
    private func requestLectureListBasedOnLevel(_ token: UserTokenValue, userId: String) {
        NetworkManager.shared.request(type: [LectureLevelListPayload].self, api: .lectureLevelListCheck(request: AuthorizationRequest(access: token.access)), errorCase: .lectureLevelListCheck)
            .sink { completion in
                if case .failure(let error) = completion {
                    if let lectureLevelListError = error as? NetworkError {
                        switch lectureLevelListError {
                        case .invalidToken(_):
                            self.requestRefreshToken(token, userId: userId)
                        default:
                            print("Getting Lecture List Error in Lecture Category ViewModel: \(lectureLevelListError.description)")
                            self.showLectureList = false
                        }
                    } else {
                        print("Getting Lecture List Error in Lecture Category ViewModel for other reason: \(error.localizedDescription)")
                        self.showLectureList = false
                    }
                }
            } receiveValue: { response in
                print("Get Lecture List Data from Server")
                self.lectureLevelListData = response
                self.showLectureList = true
            }
            .store(in: &self.cancellables)
    }
    
    private func requestRefreshToken(_ token: UserTokenValue, userId: String) {
        NetworkManager.shared.request(type: RefreshAccessTokenResponse.self, api: .refreshToken(request: RefreshAccessTokenRequest(refreshToken: token.refresh)), errorCase: .refreshToken)
            .sink { completion in
                if case .failure(let error) = completion {
                    if let refreshError = error as? NetworkError {
                        switch refreshError {
                        case .invalidToken(_):
                            AuthManager.shared.handleRefreshTokenExpired(userId: userId)
                            self.shouldLoginAgain = true
                        default:
                            print("Other Network Error for getting refreshed token in lecture categorylistviewmodel: \(refreshError.description)")
                            self.showUnknownNetworkErrorAlert = true
                        }
                    } else {
                        print("Other Error for getting refreshed token in lecture categorylistviewmodel: \(error.localizedDescription)")
                        self.showUnknownNetworkErrorAlert = true
                    }
                }
            } receiveValue: { response in
                print("Getting Refreshed Token")
                self.requestLectureList()
            }
            .store(in: &self.cancellables)
    }
    
    func cleanUpCancellables() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
        print("Cancellables count: \(cancellables.count)")
    }
    
    deinit {
        print("LectureListViewModel DEINIT")
    }
    
}
