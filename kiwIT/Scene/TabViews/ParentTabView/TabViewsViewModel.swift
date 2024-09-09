//
//  TabViewsViewModel.swift
//  kiwIT
//
//  Created by Heedon on 6/13/24.
//

import Foundation

import Combine

enum TabType: Int, CaseIterable, Hashable, Identifiable {
    case home
    case lecture
    case quiz
//    case interview
    case profile
    
    var id: Int {
        rawValue
    }
}

final class TabViewsViewModel: ObservableObject, RefreshTokenHandler {

    typealias ActionType = BasicViewModelAction
    
    //Input
    let checkProfileRequest = PassthroughSubject<ProfileResponse?, Never>()
    let selectedTabUpdate = PassthroughSubject<TabType, Never>()
    let userLoginStatusUpdate = PassthroughSubject<Bool, Never>()
    
    //Output
    @Published var profileData: ProfileResponse?
    @Published var isLoginAvailable = true
    @Published var didUpdateProfileFromOtherView = false
    @Published var selectedTab: TabType = .home
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        print("TabViewsViewModel INIT")
        bind()
    }
    
    private func bind() {
        checkProfileRequest
            .sink { [weak self] profile in
                self?.checkProfile(with: profile)
            }
            .store(in: &self.cancellables)
        
        selectedTabUpdate
            .sink { [weak self] type in
                self?.selectedTab = type
            }
            .store(in: &self.cancellables)
        
        userLoginStatusUpdate
            .sink { [weak self] newStatus in
                self?.isLoginAvailable = newStatus
            }
            .store(in: &self.cancellables)
    }
       
    private func checkProfile(with profile: ProfileResponse?) {
        if let profile = profile {
            self.profileData = profile
        } else {
            retrieveUserProfile()
        }
    }
    
    //Profile 전달되지 않음 혹은 업데이트된 프로필 필요한 경우
    private func retrieveUserProfile() {
        guard let tokenData = AuthManager.shared.checkTokenData() else {
            isLoginAvailable = false
            return
        }
        requestProfile(tokenData.0, userId: tokenData.1)
    }
    
    private func requestProfile(_ token: UserTokenValue, userId: String) {
        NetworkManager.shared.request(type: ProfileResponse.self, api: .profileCheck(request: AuthorizationRequest(access: token.access)), errorCase: .profileCheck)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    if let profileError = error as? NetworkError {
                        switch profileError {
                        case .invalidRequestBody(_):
                            self?.isLoginAvailable = false
                        case .invalidToken(_):
                            self?.requestRefreshToken(token, userId: userId, action: .profile)
                        default:
                            self?.isLoginAvailable = false
                        }
                    } else {
                        self?.isLoginAvailable = false
                    }
                }
            } receiveValue: { [weak self] response in
                self?.profileData = response
            }
            .store(in: &self.cancellables)
    }
    
    func handleRefreshTokenSuccess(response: UserTokenValue, userId: String, action: ActionType) {
        requestProfile(response, userId: userId)
    }
    
    func handleRefreshTokenError(isRefreshInvalid: Bool, userId: String) {
        AuthManager.shared.handleRefreshTokenExpired(userId: userId)
        isLoginAvailable = false
    }
        
    func updateProfileFromProfileView(_ newProfile: ProfileResponse) {
        self.profileData = newProfile
        self.didUpdateProfileFromOtherView = true
    }
    
    deinit {
        print("TabViewsViewModel DEINIT")
    }
}
