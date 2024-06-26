//
//  LectureCategoryListViewModel.swift
//  kiwIT
//
//  Created by Heedon on 3/19/24.
//

import Foundation

import Combine

final class LectureListViewModel: ObservableObject {
    
    @Published var isLoginAvailable = true
    @Published var showLectureList = false

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
    
    func requestLectureList() {
        requestSubject.send(())
    }
    
    private func setupDebounce() {
        requestSubject
            .debounce(for: .seconds(Setup.Time.debounceInterval), scheduler: DispatchQueue.main)
            .sink { [weak self] in
                self?.performRequestLectureList()
            }
            .store(in: &cancellables)
    }
    
    func performRequestLectureList() {
        guard let tokenData = checkTokenData() else {
            print("Should Login Again!!!")
            isLoginAvailable = false
            return
        }
        
        switch lectureType {
        case .category:
            requestLectureListBasedOnCategory(tokenData.0, userId: tokenData.1)
        case .level:
            requestLectureListBasedOnLevel(tokenData.0, userId: tokenData.1)
        }
    }
    
    private func checkTokenData() -> (UserTokenValue, String)? {
        do {
            let userId = try UserDefaultsManager.shared.retrieveFromUserDefaults(forKey: Setup.UserDefaultsKeyStrings.userIdString) as String
            guard let tokenData = KeyChainManager.shared.read(userId) else {
                print("No Saved Token")
                return nil
            }
            return (tokenData, userId)
        } catch {
            print("No Id to check token!!!")
            return nil
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
                            self.handleRefreshTokenExpired(userId: userId)
                        default:
                            print("Other Network Error for getting refreshed token in lecture categorylistviewmodel: \(refreshError.description)")
                            self.handleRefreshTokenExpired(userId: userId)
                        }
                    } else {
                        print("Other Error for getting refreshed token in lecture categorylistviewmodel: \(error.localizedDescription)")
                        self.handleRefreshTokenExpired(userId: userId)
                    }
                }
            } receiveValue: { response in
                print("Getting Refreshed Token")
                self.requestLectureList()
            }
            .store(in: &self.cancellables)
    }
    
    private func handleRefreshTokenExpired(userId: String) {
        print("To Remove User Data and Move to SignIn")
        //저장된 token 삭제,
        KeyChainManager.shared.delete(userId)
        //저장된 userdefaults id 삭제
        UserDefaultsManager.shared.deleteFromUserDefaults(forKey: Setup.UserDefaultsKeyStrings.userIdString)
        //로그인 화면 이동하기
        self.isLoginAvailable = false
    }
    
}
