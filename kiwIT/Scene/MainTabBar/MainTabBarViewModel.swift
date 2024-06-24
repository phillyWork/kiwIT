//
//  MainTabBarViewModel.swift
//  kiwIT
//
//  Created by Heedon on 6/13/24.
//

import Foundation

import Combine

//MARK: - Input & Output pattern 고려해서 고칠 점 미리 생각해놓기
//MARK: - 유저한테 보여줄 에러 구분해서 화면에 나타낼 요소들 분리해서 보여주기




//MARK: - 1. Keychain에 Token 존재 여부 확인
//MARK: - 1-a. 존재 O --> Request Refresh Token으로 Token Availability 파악
//MARK: - 1-a-1. Updated Token: 새로운 Token으로 update, 원하는 작업 Request
//MARK: - 1-a-2. Refresh Token Error: 토큰 만료 등 에러 --> (토큰 삭제 혹은 놔두고) LoginView
//MARK: - 1-b. No Token --> LoginView

//MARK: - id 찾아서 저장된 token 찾기 --> token으로 프로필 요청: 성공하면 로그인 성공
//MARK: - Invalid Access Token --> Refresh Token request: 성공하면 다시 프로필 요청, 성공하면 로그인 성공
//MARK: - Invalid Refresh Token --> 저장된 token 삭제, 저장된 userdefaults id 삭제, 로그인 화면 이동하기

final class MainTabBarViewModel: ObservableObject {
    
    @Published var userProfileData: ProfileResponse?
    @Published var isUserLoggedIn = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        print("DEBUG - MainTabBarViewModel initialized")
        checkSignInStatus()
        print("DEBUG - End of MainTabBarViewModel initialization")
    }
    
    private func checkSignInStatus() {
        if let userId = try? UserDefaultsManager.shared.retrieveFromUserDefaults(forKey: Setup.UserDefaultsKeyStrings.userIdString) as String, let savedToken = KeyChainManager.shared.read(userId) {
            requestProfile(savedToken, userId: userId)
        } else {
            print("No Saved Id or Token. Should Sign In!!!")
            self.isUserLoggedIn = false
        }
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
                            self.requestRefreshToken(current, userId: userId)
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
    
    private func requestRefreshToken(_ current: UserTokenValue, userId: String) {
        NetworkManager.shared.request(type: RefreshAccessTokenResponse.self, api: .refreshToken(request: RefreshAccessTokenRequest(refreshToken: current.refresh)), errorCase: .refreshToken)
            .sink { completion in
                if case .failure(let error) = completion {
                    if let refreshError = error as? NetworkError {
                        switch refreshError {
                        case .invalidToken(_):
                            print("Invalid For Both Access and Refresh. Needs to Sign In Again")
                            self.handleRefreshTokenExpired(userId: userId)
                        default:
                            print("Refresh Token Error in MainTabsViewModel Initiailzation: \(refreshError.description)")
                            self.handleRefreshTokenExpired(userId: userId)
                        }
                    } else {
                        print("Refresh Token Error for other eason: \(error.localizedDescription) -- Needs to Sign In Again")
                        self.handleRefreshTokenExpired(userId: userId)
                    }
                }
            } receiveValue: { response in
                print("Update Token!!!")
                KeyChainManager.shared.update(UserTokenValue(access: response.accessToken, refresh: response.refreshToken), id: userId)
                
                print("Call ProfileRequest Again!!!")
                self.requestProfile(UserTokenValue(access: response.accessToken, refresh: response.refreshToken), userId: userId)
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
        self.isUserLoggedIn = false
    }
    
}
