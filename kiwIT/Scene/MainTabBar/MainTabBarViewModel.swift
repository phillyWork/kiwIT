//
//  MainTabBarViewModel.swift
//  kiwIT
//
//  Created by Heedon on 6/13/24.
//

import Foundation

import Combine

enum BasicViewModelAction {
    case profile
}

//1. Keychain에 Token 존재 여부 확인
//1-a. 존재 O --> Request Refresh Token으로 Token Availability 파악
//1-a-1. Updated Token: 새로운 Token으로 update, 원하는 작업 Request
//1-a-2. Refresh Token Error: 토큰 만료 등 에러 --> (토큰 삭제 혹은 놔두고) LoginView
//1-b. No Token --> LoginView

//id 찾아서 저장된 token 찾기 --> token으로 프로필 요청: 성공하면 로그인 성공
//Invalid Access Token --> Refresh Token request: 성공하면 다시 프로필 요청, 성공하면 로그인 성공
//Invalid Refresh Token --> 저장된 token 삭제, 저장된 userdefaults id 삭제, 로그인 화면 이동하기

final class MainTabBarViewModel: ObservableObject, RefreshTokenHandler {
    
    typealias ActionType = BasicViewModelAction
    
    //Input
    let checkLoginStatus = PassthroughSubject<Bool, Never>()
    let userProfileInput = PassthroughSubject<ProfileResponse?, Never>()
    
    //Output
    @Published var userProfileData: ProfileResponse?
    @Published var isUserLoggedIn = false
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        print("DEBUG - MainTabBarViewModel initialized")
        bind()
        checkSignInStatus()
    }
    
    private func bind() {
        checkLoginStatus
            .sink { [weak self] isAvailable in
                self?.isUserLoggedIn = isAvailable
            }
            .store(in: &self.cancellables)
        
        userProfileInput
            .sink { [weak self] profile in
                self?.userProfileData = profile
            }
            .store(in: &self.cancellables)
    }
    
    private func checkSignInStatus() {
        guard let tokenData = AuthManager.shared.checkTokenData() else {
            self.isUserLoggedIn = false
            return
        }
        requestProfile(tokenData.0, userId: tokenData.1)
    }
    
    private func requestProfile(_ current: UserTokenValue, userId: String) {
        NetworkManager.shared.request(type: ProfileResponse.self, api: .profileCheck(request: AuthorizationRequest(access: current.access)), errorCase: .profileCheck)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    if let profileError = error as? NetworkError {
                        switch profileError {
                        case .invalidRequestBody(_):
                            self?.isUserLoggedIn = false
                        case .invalidToken(_):
                            self?.requestRefreshToken(current, userId: userId, action: .profile)
                        default:
                            self?.isUserLoggedIn = false
                        }
                    } else {
                        self?.isUserLoggedIn = false
                    }
                }
            } receiveValue: { [weak self] response in
                self?.userProfileData = response
                self?.isUserLoggedIn = true
            }
            .store(in: &self.cancellables)
    }
    
    func handleRefreshTokenSuccess(response: UserTokenValue, userId: String, action: ActionType) {
        requestProfile(response, userId: userId)
    }
    
    func handleRefreshTokenError(isRefreshInvalid: Bool, userId: String) {
        //로그인 화면 이동하기
        AuthManager.shared.handleRefreshTokenExpired(userId: userId)
        isUserLoggedIn = false
    }
    
    deinit {
        print("MainTabBarViewModel DEINIT")
    }
}
