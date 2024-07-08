//
//  ProfileViewModel.swift
//  kiwIT
//
//  Created by Heedon on 6/17/24.
//

import Foundation

import Combine

import Alamofire

private enum ProfileAction {
    case profileEdit
    case signOut
    case withdraw
    case completedLectureList
    case bookmarkedLectureList
    case takenQuizList
    case bookmarkedQuizList
    case latestAcquiredTrophy
}

final class ProfileViewModel: ObservableObject {
    
    @Published var showSessionExpiredAlert = false
    
    @Published var nicknameInputFromUser = ""
    @Published var showEditNicknameAlert = false
    @Published var showNicknameErrorAlert = false
    
    @Published var showLogoutAlert = false
    @Published var showLogoutSucceedAlert = false
    @Published var showLogoutErrorAlert = false
    
    @Published var showWithdrawAlert = false
    @Published var showWithdrawWithEmailTextfieldAlert = false
    @Published var emailToBeWithdrawn = ""
    @Published var showEmailWithdrawalErrorAlert = false
    @Published var showWithdrawErrorAlert = false
    @Published var showWithdrawSucceedAlert = false

    @Published var showCompletedLectureListError = false
    @Published var isCompleteLectureListIsEmpty = true
    
    @Published var showBookmarkedLectureListError = false
    @Published var isBookmarkedLectureListIsEmtpy = true
    
    @Published var showTakenQuizListError = false
    @Published var isTakenQuizListIsEmpty = true
    
    @Published var showBookmarkedQuizListError = false
    @Published var isBookmarkedQuizListIsEmtpy = true
    
    @Published var showLatestAcquiredTrophyError = false
    @Published var isLatestAcquiredTrophyEmpty = true
    
    @Published var showUnknownNetworkErrorAlert = false
    
    //nil로 판단하지 않기함, 어차피 1개
    @Published var completedLectureList: [CompletedOrBookmarkedLecture] = []
    @Published var bookmarkedLectureList: [CompletedOrBookmarkedLecture] = []
    
    @Published var takenQuizList: [TakenQuizResponse] = []
    @Published var bookmarkedQuizList: [BookmarkedQuizListResponse] = []

    @Published var latestAcquiredTrophy: [AcquiredTrophy] = []
    
    private let currentPageForPaginationRequest = 0
    private let dataPerRequest = 1
    
    private var debouncedNickname = ""
    private var debouncedEmail = ""
    
    private var requestSubject = PassthroughSubject<Void, Never>()      //debounce network call

    private var cancellables = Set<AnyCancellable>()
    
    var updateProfileClosure: ((ProfileResponse) -> Void)?
    
    init(updateProfileClosure: @escaping (ProfileResponse) -> Void) {
        self.updateProfileClosure = updateProfileClosure
        setupDebounce()
        requestUserData()
    }
    
    private func setupDebounce() {
        $nicknameInputFromUser
            .debounce(for: .seconds(Setup.Time.debounceInterval), scheduler: RunLoop.main)
            .sink { [weak self] debouncedValue in
                self?.debouncedNickname = debouncedValue
            }
            .store(in: &self.cancellables)
        
        $emailToBeWithdrawn
            .debounce(for: .seconds(Setup.Time.debounceInterval), scheduler: RunLoop.main)
            .sink { [weak self] debouncedValue in
                self?.debouncedEmail = debouncedValue
            }
            .store(in: &self.cancellables)
        
        requestSubject
            .debounce(for: .seconds(Setup.Time.debounceInterval), scheduler: DispatchQueue.main)
            .sink { [weak self] in
                self?.requestData()
            }
            .store(in: &cancellables)
    }
    
    func requestUserData() {
        requestSubject.send(())
    }
    
    private func requestData() {
        requestCompletedLectureList()
        requestBookmarkedLectureList()
        requestTakenQuizList()
        requestBookmarkedQuizList()
        requestLatestAcquiredTrophy()
    }
    
    func updateNickname() {
        guard let tokenData = AuthManager.shared.checkTokenData() else {
            print("No token data in ProfileView!!! Should Move to Log-In!!!")
            self.showSessionExpiredAlert = true
            return
        }
        requestProfileEdit(tokenData.0, nickname: debouncedNickname, userId: tokenData.1)
    }
    
    private func requestProfileEdit(_ current: UserTokenValue, nickname: String, userId: String) {
        NetworkManager.shared.request(type: ProfileResponse.self, api: .profileEdit(request: ProfileEditRequest(access: current.access, nickname: nickname)), errorCase: .profileEdit)
            .sink { completion in
                if case .failure(let error) = completion {
                    if let profileEditError = error as? NetworkError {
                        switch profileEditError {
                        case .invalidRequestBody(_):
                            print("Cannot Update Profile Nickname in ProfileViewModel: \(profileEditError.description)")
                            self.showNicknameErrorAlert = true
                        case .invalidToken(_):
                            print("Access Token is not available in ProfileViewModel: \(profileEditError.description)")
                            self.requestRefreshToken(current, nickname: nickname, userId: userId, actionType: .profileEdit)
                        default:
                            print("Profile Update Error in ProfileViewModel: \(profileEditError.description)")
                            self.showNicknameErrorAlert = true
                        }
                    } else {
                        print("Profile Edit Request Error for other reason in ProfileViewModel: \(error.localizedDescription)")
                        self.showNicknameErrorAlert = true
                    }
                }
            } receiveValue: { response in
                print("Getting Updated Profile Data from Server! Available Saved Token!")
                self.updateProfileClosure?(response)
                self.nicknameInputFromUser.removeAll()
            }
            .store(in: &self.cancellables)
    }
    
    func requestCompletedLectureList() {
        guard let tokenData = AuthManager.shared.checkTokenData() else {
            print("No token data in ProfileView!!! Should Move to Log-In!!!")
            self.showSessionExpiredAlert = true
            return
        }
        NetworkManager.shared.request(type: [CompletedOrBookmarkedLecture].self, api: .completedLectureListCheck(request: CompletedLectureListCheckRequest(access: tokenData.0.access, next: currentPageForPaginationRequest, limit: dataPerRequest, byLevel: true)), errorCase: .completedLectureListCheck)
            .sink { completion in
                if case .failure(let error) = completion {
                    if let completeLectureListError = error as? NetworkError {
                        switch completeLectureListError {
                        case .invalidToken(_):
                            self.requestRefreshToken(tokenData.0, nickname: nil, userId: tokenData.1, actionType: .completedLectureList)
                        default:
                            print("Completed Lecture List Error by network: \(completeLectureListError.description)")
                            self.showCompletedLectureListError = true
                        }
                    } else {
                        print("Completed Lecture List Error by other reason: \(error.localizedDescription)")
                        self.showCompletedLectureListError = true
                    }
                }
            } receiveValue: { response in
                self.completedLectureList.append(contentsOf: response)
                self.showCompletedLectureListError = false
                self.isCompleteLectureListIsEmpty = self.completedLectureList.isEmpty ? true : false
            }
            .store(in: &self.cancellables)
    }
    
    func requestBookmarkedLectureList() {
        guard let tokenData = AuthManager.shared.checkTokenData() else {
            print("No token data in ProfileView!!! Should Move to Log-In!!!")
            self.showSessionExpiredAlert = true
            return
        }
        NetworkManager.shared.request(type: [CompletedOrBookmarkedLecture].self, api: .bookmarkedLectureCheck(request: BookmarkedLectureCheckRequest(access: tokenData.0.access, next: currentPageForPaginationRequest, limit: dataPerRequest)), errorCase: .bookmarkedLectureCheck)
            .sink { completion in
                if case .failure(let error) = completion {
                    if let bookmarkedLectureListError = error as? NetworkError {
                        switch bookmarkedLectureListError {
                        case .invalidToken(_):
                            self.requestRefreshToken(tokenData.0, nickname: nil, userId: tokenData.1, actionType: .bookmarkedLectureList)
                        default:
                            print("Bookmarked Lecture List Error by network: \(bookmarkedLectureListError.description)")
                            self.showBookmarkedLectureListError = true
                        }
                    } else {
                        print("Bookmarked Lecture List Error by other reason: \(error.localizedDescription)")
                        self.showBookmarkedLectureListError = true
                    }
                }
            } receiveValue: { response in
                self.bookmarkedLectureList.append(contentsOf: response)
                self.showBookmarkedLectureListError = false
                self.isBookmarkedLectureListIsEmtpy = self.bookmarkedLectureList.isEmpty ? true : false
            }
            .store(in: &self.cancellables)
    }
    
    func requestTakenQuizList() {
        guard let tokenData = AuthManager.shared.checkTokenData() else {
            print("No token data in ProfileView!!! Should Move to Log-In!!!")
            self.showSessionExpiredAlert = true
            return
        }
        NetworkManager.shared.request(type: [TakenQuizResponse].self, api: .takenQuizListCheck(request: CheckCompletedOrBookmarkedQuizRequest(access: tokenData.0.access, next: currentPageForPaginationRequest, limit: dataPerRequest)), errorCase: .takenQuizListCheck)
            .sink { completion in
                if case .failure(let error) = completion {
                    if let takenQuizListError = error as? NetworkError {
                        switch takenQuizListError {
                        case .invalidToken(_):
                            self.requestRefreshToken(tokenData.0, nickname: nil, userId: tokenData.1, actionType: .bookmarkedLectureList)
                        default:
                            print("Taken Quiz List Error by network: \(takenQuizListError.description)")
                            self.showTakenQuizListError = true
                        }
                    } else {
                        print("Taken Quiz  List Error by other reason: \(error.localizedDescription)")
                        self.showTakenQuizListError = true
                    }
                }
            } receiveValue: { response in
                self.takenQuizList.append(contentsOf: response)
                self.showTakenQuizListError = false
                self.isTakenQuizListIsEmpty = self.takenQuizList.isEmpty ? true : false
            }
            .store(in: &self.cancellables)
    }
    
    func requestBookmarkedQuizList() {
        guard let tokenData = AuthManager.shared.checkTokenData() else {
            print("No token data in ProfileView!!! Should Move to Log-In!!!")
            self.showSessionExpiredAlert = true
            return
        }
        NetworkManager.shared.request(type: [BookmarkedQuizListResponse].self, api: .bookmarkedQuizCheck(request: CheckCompletedOrBookmarkedQuizRequest(access: tokenData.0.access, next: currentPageForPaginationRequest, limit: dataPerRequest)), errorCase: .bookmarkedQuizCheck)
            .sink { completion in
                if case .failure(let error) = completion {
                    if let bookmarkedQuizListError = error as? NetworkError {
                        switch bookmarkedQuizListError {
                        case .invalidToken(_):
                            self.requestRefreshToken(tokenData.0, nickname: nil, userId: tokenData.1, actionType: .bookmarkedLectureList)
                        default:
                            print("Bookmarked Quiz List Error by network: \(bookmarkedQuizListError.description)")
                            self.showBookmarkedQuizListError = true
                        }
                    } else {
                        print("Bookmarked Quiz List Error by other reason: \(error.localizedDescription)")
                        self.showBookmarkedQuizListError = true
                    }
                }
            } receiveValue: { response in
                self.bookmarkedQuizList.append(contentsOf: response)
                self.showBookmarkedQuizListError = false
                self.isBookmarkedQuizListIsEmtpy = self.bookmarkedQuizList.isEmpty ? true : false
            }
            .store(in: &self.cancellables)
    }
    
    func requestLatestAcquiredTrophy() {
        guard let tokenData = AuthManager.shared.checkTokenData() else {
            print("No token data in ProfileView!!! Should Move to Log-In!!!")
            self.showSessionExpiredAlert = true
            return
        }
        NetworkManager.shared.request(type: AcquiredTrophy.self, api: .latestAcquiredTrophy(request: AuthorizationRequest(access: tokenData.0.access)), errorCase: .latestAcquiredTrophy)
            .sink { completion in
                if case .failure(let error) = completion {
                    if let latestAcquiredTrophyError = error as? NetworkError {
                        switch latestAcquiredTrophyError {
                        case .emptyBody(_):
                            print("Empty Body for Latest Acquired Trophy")
                            self.showLatestAcquiredTrophyError = false
                            self.isLatestAcquiredTrophyEmpty = true
                        case .invalidRequestBody(let message):
                            print("Wrong Request for Latest Acquired Trophy: \(message)")
                            self.showLatestAcquiredTrophyError = true
                        case .invalidToken(_):
                            self.requestRefreshToken(tokenData.0, nickname: nil, userId: tokenData.1, actionType: .latestAcquiredTrophy)
                        default:
                            print("Latest Acquired Trophy Error for network reason: \(latestAcquiredTrophyError.description)")
                            self.showLatestAcquiredTrophyError = true
                        }
                    } else {
                        print("Latest Acquired Trophy Error by other reason: \(error.localizedDescription)")
                        self.showLatestAcquiredTrophyError = true
                    }
                }
            } receiveValue: { response in
                self.showLatestAcquiredTrophyError = false
                self.latestAcquiredTrophy.append(response)
            }
            .store(in: &self.cancellables)
    }
    
    func signOut() {
        guard let tokenData = AuthManager.shared.checkTokenData() else {
            print("Should Login Again!!!")
            showSessionExpiredAlert = true
            return
        }
        NetworkManager.shared.request(type: Empty.self, api: .signOut(request: AuthorizationRequest(access: tokenData.0.access)), errorCase: .signOut)
            .sink { completion in
                if case .failure(let error) = completion {
                    if let signOutError = error as? NetworkError {
                        switch signOutError {
                        case .invalidToken(_):
                            self.requestRefreshToken(tokenData.0, nickname: nil, userId: tokenData.1, actionType: .signOut)
                        default:
                            print("SignOut Error by network reason: \(signOutError.description)")
                            self.showLogoutErrorAlert = true
                        }
                    } else {
                        print("SignOut Error in ProfileViewModel for other reason: \(error.localizedDescription)")
                        self.showLogoutErrorAlert = true
                    }
                }
            } receiveValue: { _ in
                print("Response for Sign Out Success!")
                //재로그인 및 다른 계정 로그인: 네트워크 콜 횟수 줄이기 목적
                AuthManager.shared.handleRefreshTokenExpired(userId: tokenData.1)
                self.showLogoutSucceedAlert = true
            }
            .store(in: &self.cancellables)
    }
    
    func withdraw() {
        guard let tokenData = AuthManager.shared.checkTokenData() else {
            print("Should Login Again!!!")
            showSessionExpiredAlert = true
            return
        }
        
        guard tokenData.1 == debouncedEmail else {
            print("Email is Not Same To Withdraw")
            showWithdrawAlert = true
            return
        }
        
        NetworkManager.shared.request(type: Empty.self, api: .withdraw(request: AuthorizationRequest(access: tokenData.0.access)), errorCase: .withdraw)
            .sink { completion in
                if case .failure(let error) = completion {
                    if let withdrawError = error as? NetworkError {
                        switch withdrawError {
                        case .invalidRequestBody(_):
                            print("Cannot withdraw user from db: \(withdrawError.description)")
                            self.showWithdrawAlert = true
                        case .invalidToken(_):
                            self.requestRefreshToken(tokenData.0, nickname: nil, userId: tokenData.1, actionType: .withdraw)
                        default:
                            print("Withdraw Error by network: \(withdrawError.description)")
                            self.showWithdrawAlert = true
                        }
                    } else {
                        print("Withdraw Error by other reason: \(error.localizedDescription)")
                        self.showWithdrawAlert = true
                    }
                }
            } receiveValue: { _ in
                self.emailToBeWithdrawn.removeAll()
                AuthManager.shared.handleRefreshTokenExpired(userId: tokenData.1)
                self.showWithdrawSucceedAlert = true
            }
            .store(in: &self.cancellables)
    }
    
    func pullToRefresh() {
        completedLectureList.removeAll()
        bookmarkedLectureList.removeAll()
        takenQuizList.removeAll()
        bookmarkedQuizList.removeAll()
        latestAcquiredTrophy.removeAll()
        requestUserData()
    }
    
    private func requestRefreshToken(_ current: UserTokenValue, nickname: String?, userId: String, actionType: ProfileAction) {
        NetworkManager.shared.request(type: RefreshAccessTokenResponse.self, api: .refreshToken(request: RefreshAccessTokenRequest(refreshToken: current.refresh)), errorCase: .refreshToken)
            .sink { completion in
                if case .failure(let error) = completion {
                    if let refreshError = error as? NetworkError {
                        switch refreshError {
                        case .invalidToken(_):
                            print("Invalid For Both Access and Refresh. Needs to Sign In Again")
                            AuthManager.shared.handleRefreshTokenExpired(userId: userId)
                            //로그인 화면 이동하기
                            self.showSessionExpiredAlert = true
                        default:
                            print("Refresh Token Error in MainTabsViewModel Initiailzation: \(refreshError.description)")
//                            AuthManager.shared.handleRefreshTokenExpired(userId: userId)
                            self.showUnknownNetworkErrorAlert = true
                        }
                    } else {
                        print("Refresh Token Error for other eason: \(error.localizedDescription) -- Needs to Sign In Again")
//                        AuthManager.shared.handleRefreshTokenExpired(userId: userId)
                        //로그인 화면 이동하기
//                        self.showSessionExpiredAlert = true
                        self.showUnknownNetworkErrorAlert = true
                    }
                }
            } receiveValue: { response in
                print("Update Token!!!")
                KeyChainManager.shared.update(UserTokenValue(access: response.accessToken, refresh: response.refreshToken), id: userId)
                switch actionType {
                case .profileEdit:
                    self.requestProfileEdit(UserTokenValue(access: response.accessToken, refresh: response.refreshToken), nickname: nickname!, userId: userId)
                case .signOut:
                    self.signOut()
                case .withdraw:
                    self.withdraw()
                case .completedLectureList:
                    self.requestCompletedLectureList()
                case .bookmarkedLectureList:
                    self.requestBookmarkedLectureList()
                case .takenQuizList:
                    self.requestTakenQuizList()
                case .bookmarkedQuizList:
                    self.requestBookmarkedQuizList()
                case .latestAcquiredTrophy:
                    self.requestLatestAcquiredTrophy()
                }
            }
            .store(in: &self.cancellables)
    }
    
    func removeThisBookmarkedLecture(_ id: Int) {
        if bookmarkedLectureList.map({ $0.id }).contains(id) {
            bookmarkedLectureList.removeAll()
            isBookmarkedLectureListIsEmtpy = true
        }
    }
    
}
