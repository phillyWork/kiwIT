//
//  ProfileViewModel.swift
//  kiwIT
//
//  Created by Heedon on 6/17/24.
//

import Foundation

import Combine

import Alamofire

enum ProfileAction {
    case profileEdit
    case signOut
    case withdraw
    case completedLectureList
    case bookmarkedLectureList
    case takenQuizList
    case bookmarkedQuizList
}

//MARK: - 함수 구조 변경 필요

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

    @Published var showLectureListError = false
    @Published var showQuizListError = false
    
    @Published var completedLectureList: [CompletedOrBookmarkedLecture] = []
    @Published var bookmarkedLectureList: [CompletedOrBookmarkedLecture] = []
    
    @Published var takenQuizList: [TakenQuizResponse] = []
    @Published var bookmarkedQuizList: [BookmarkedQuizListResponse] = []
    
    private let currentPageForPaginationRequest = 0
    private let dataPerRequest = 3
    
    private var debouncedNickname = ""
    
    private var cancellables = Set<AnyCancellable>()
    
    var updateProfileClosure: ((ProfileResponse) -> Void)?
    
    init(updateProfileClosure: @escaping (ProfileResponse) -> Void) {
        self.updateProfileClosure = updateProfileClosure
        setupDebounce()
        requestCompletedLectureList()
        requestBookmarkedQuizList()
        requestTakenQuizList()
        requestBookmarkedQuizList()
    }
    
    private func setupDebounce() {
        $nicknameInputFromUser
            .debounce(for: .seconds(Setup.Time.debounceInterval), scheduler: RunLoop.main)
            .sink { [weak self] debouncedValue in
                self?.debouncedNickname = debouncedValue
            }
            .store(in: &self.cancellables)
    }
    
    func updateNickname() {
        do {
            let userId = try UserDefaultsManager.shared.retrieveFromUserDefaults(forKey: Setup.UserDefaultsKeyStrings.userIdString) as String
            if let token = KeyChainManager.shared.read(userId) {
                self.requestProfileEdit(token, nickname: debouncedNickname, userId: userId)
            } else {
                print("No Token in ProfileView!!! Should Move to Log-In!!!")
                self.showSessionExpiredAlert = true
            }
        } catch {
            print("No Saved id!!! Should Login!!!")
            self.showSessionExpiredAlert = true
        }
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
    
    private func requestCompletedLectureList() {
        
        
//        NetworkManager.shared.request(type: <#T##Decodable.Type#>, api: .completedLectureListCheck(request: CompletedLectureListCheckRequest(access: <#T##String#>, next: <#T##Int?#>, limit: <#T##Int?#>, byLevel: <#T##Bool?#>)), errorCase: <#T##NetworkErrorCase#>)
    }
    
    private func requestBookmarkedLectureList() {
        
    }
    
    private func requestTakenQuizList() {
        
    }
    
    private func requestBookmarkedQuizList() {
        
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
    
    private func requestRefreshToken(_ current: UserTokenValue, nickname: String?, userId: String, actionType: ProfileAction) {
        NetworkManager.shared.request(type: RefreshAccessTokenResponse.self, api: .refreshToken(request: RefreshAccessTokenRequest(refreshToken: current.refresh)), errorCase: .refreshToken)
            .sink { completion in
                if case .failure(let error) = completion {
                    if let refreshError = error as? NetworkError {
                        switch refreshError {
                        case .invalidToken(_):
                            print("Invalid For Both Access and Refresh. Needs to Sign In Again")
                            AuthManager.shared.handleRefreshTokenExpired(userId: userId)
                        default:
                            print("Refresh Token Error in MainTabsViewModel Initiailzation: \(refreshError.description)")
                            AuthManager.shared.handleRefreshTokenExpired(userId: userId)
                        }
                        //로그인 화면 이동하기
                        self.showSessionExpiredAlert = true
                    } else {
                        print("Refresh Token Error for other eason: \(error.localizedDescription) -- Needs to Sign In Again")
                        AuthManager.shared.handleRefreshTokenExpired(userId: userId)
                        //로그인 화면 이동하기
                        self.showSessionExpiredAlert = true
                    }
                }
            } receiveValue: { response in
                print("Update Token!!!")
                KeyChainManager.shared.update(UserTokenValue(access: response.accessToken, refresh: response.refreshToken), id: userId)
                //MARK: - 수정 필요
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
                }
            }
            .store(in: &self.cancellables)
    }
    
}
