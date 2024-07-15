//
//  TabViewsViewModel.swift
//  kiwIT
//
//  Created by Heedon on 6/13/24.
//

import Foundation

import Combine

final class TabViewsViewModel: ObservableObject {

    @Published var profileData: ProfileResponse?
    @Published var isLoginAvailable = true
    @Published var didUpdateProfileFromOtherView = false
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        print("TabViewsViewModel INIT")
    }
    
    func checkProfile(with profile: ProfileResponse?) {
        if let profile = profile {
            self.profileData = profile
            print("Passed Profile Data: \(profileData)")
        } else {
            print("No Profile Data Passed!!!")
            retrieveUserProfile()
        }
    }
    
    //Profile 전달되지 않음 혹은 업데이트된 프로필 필요한 경우
    private func retrieveUserProfile() {
        do {
            let userId = try UserDefaultsManager.shared.retrieveFromUserDefaults(forKey: Setup.UserDefaultsKeyStrings.userIdString) as String
            if let token = KeyChainManager.shared.read(userId) {
                self.requestProfile(token, userId: userId)
            } else {
                print("No Token Saved in KeyChain in TabsViewModel!!!")
                isLoginAvailable = false
            }
        } catch {
            print("No Saved Id to check Token!!!")
            isLoginAvailable = false
        }
    }
    
    private func requestProfile(_ token: UserTokenValue, userId: String) {
        NetworkManager.shared.request(type: ProfileResponse.self, api: .profileCheck(request: AuthorizationRequest(access: token.access)), errorCase: .profileCheck)
            .sink { completion in
                if case .failure(let error) = completion {
                    if let profileError = error as? NetworkError {
                        switch profileError {
                        case .invalidRequestBody(_):
                            print("Profile Check Error in TabViewsViewModel: \(profileError.description)")
                        case .invalidToken(_):
                            print("Invalid Access token in TabViewsViewModel: \(profileError.description)")
                            self.requestRefreshToken(token, userId: userId)
                        default:
                            print("Profile Check Error in TabViewsViewModel: \(profileError.description)")
                            self.isLoginAvailable = false
                        }
                    } else {
                        print("Profile Check Error in TabViewsViewModel for other reason: \(error.localizedDescription)")
                        self.isLoginAvailable = false
                    }
                }
            } receiveValue: { response in
                print("Profile Response: \(response)")
                self.profileData = response
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
                            print("Invalid For Both Access and Refresh. Needs to Sign In Again")
                            AuthManager.shared.handleRefreshTokenExpired(userId: userId)
                            //로그인 화면 이동하기
                            self.isLoginAvailable = false
                        default:
                            print("Refresh Token Error in MainTabsViewModel Initiailzation: \(refreshError.description)")
                            AuthManager.shared.handleRefreshTokenExpired(userId: userId)
                            //로그인 화면 이동하기
                            self.isLoginAvailable = false
                        }
                    } else {
                        print("Refresh Token Error for other eason: \(error.localizedDescription) -- Needs to Sign In Again")
                        AuthManager.shared.handleRefreshTokenExpired(userId: userId)
                        //로그인 화면 이동하기
                        self.isLoginAvailable = false
                    }
                }
            } receiveValue: { response in
                print("Update Token!!!")
                self.updateToken(response, userId: userId)
            }
            .store(in: &self.cancellables)
    }
    
    private func updateToken(_ token: RefreshAccessTokenResponse, userId: String) {
        KeyChainManager.shared.update(UserTokenValue(access: token.accessToken, refresh: token.refreshToken), id: userId)
        print("Call ProfileRequest Again!!!")
        self.requestProfile(UserTokenValue(access: token.accessToken, refresh: token.refreshToken), userId: userId)
    }
    
    func updateProfileFromProfileView(_ newProfile: ProfileResponse) {
        print("Updated Profile: \(newProfile)")
        self.profileData = newProfile
        self.didUpdateProfileFromOtherView = true
    }
}
