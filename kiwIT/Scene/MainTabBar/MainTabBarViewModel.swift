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

//MARK: - 1. Keychain에 Token 존재 여부 확인
//MARK: - 1-a. 존재 O --> Request Refresh Token으로 Token Availability 파악
//MARK: - 1-a-1. Updated Token: 새로운 Token으로 update, 원하는 작업 Request
//MARK: - 1-a-2. Refresh Token Error: 토큰 만료 등 에러 --> (토큰 삭제 혹은 놔두고) LoginView
//MARK: - 1-b. No Token --> LoginView

//MARK: - id 찾아서 저장된 token 찾기 --> token으로 프로필 요청: 성공하면 로그인 성공
//MARK: - Invalid Access Token --> Refresh Token request: 성공하면 다시 프로필 요청, 성공하면 로그인 성공
//MARK: - Invalid Refresh Token --> 저장된 token 삭제, 저장된 userdefaults id 삭제, 로그인 화면 이동하기

final class MainTabBarViewModel: ObservableObject, RefreshTokenHandler {
    
    typealias ActionType = BasicViewModelAction
    
    @Published var userProfileData: ProfileResponse?
    @Published var isUserLoggedIn = false
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        print("DEBUG - MainTabBarViewModel initialized")
        checkSignInStatus()
        print("DEBUG - End of MainTabBarViewModel initialization")
    }
    
    private func checkSignInStatus() {
        guard let tokenData = AuthManager.shared.checkTokenData() else {
            print("No Saved Id or Token. Should Sign In!!!")
            self.isUserLoggedIn = false
            return
        }
        requestProfile(tokenData.0, userId: tokenData.1)
    }
    
    private func requestProfile(_ current: UserTokenValue, userId: String) {
        NetworkManager.shared.request(type: ProfileResponse.self, api: .profileCheck(request: AuthorizationRequest(access: current.access)), errorCase: .profileCheck)
            .sink { completion in
                if case .failure(let error) = completion {
                    if let profileError = error as? NetworkError {
                        switch profileError {
                        case .invalidRequestBody(_):
                            print("This user doesn't exist in MainTabsViewModel Initiailzation: \(profileError.description)")
                            self.isUserLoggedIn = false
                        case .invalidToken(_):
                            print("Access Token is not available in MainTabsViewModel Initiailzation: \(profileError.description)")
                            self.requestRefreshToken(current, userId: userId, action: .profile)
                        default:
                            print("Profile Check Error in MainTabsViewModel Initiailzation: \(profileError.description)")
                            self.isUserLoggedIn = false
                        }
                    } else {
                        print("Profile Request Error for other reason in MainTabsViewModel Initiailzation: \(error.localizedDescription)")
                        self.isUserLoggedIn = false
                    }
                }
            } receiveValue: { response in
                print("Getting Profile Data from Server! Available Saved Token!")
                self.userProfileData = response
                self.isUserLoggedIn = true
            }
            .store(in: &self.cancellables)
    }
    
    func handleRefreshTokenSuccess(response: UserTokenValue, userId: String, action: ActionType) {
        print("Call ProfileRequest Again!!!")
        requestProfile(response, userId: userId)
    }
    
    func handleRefreshTokenError(isRefreshInvalid: Bool, userId: String) {
        //로그인 화면 이동하기
        AuthManager.shared.handleRefreshTokenExpired(userId: userId)
        isUserLoggedIn = false
    }
}
