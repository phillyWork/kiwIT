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
    case interview
    case profile
    
    var id: Int {
        rawValue
    }
}

final class TabViewsViewModel: ObservableObject, RefreshTokenHandler {

    typealias ActionType = BasicViewModelAction
        
    @Published var selectedTab: TabType = .home
    @Published var profileData: ProfileResponse?
    @Published var isLoginAvailable = true
    @Published var didUpdateProfileFromOtherView = false
    
    var cancellables = Set<AnyCancellable>()
    
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
        guard let tokenData = AuthManager.shared.checkTokenData() else {
            isLoginAvailable = false
            return
        }
        requestProfile(tokenData.0, userId: tokenData.1)
    }
    
    private func requestProfile(_ token: UserTokenValue, userId: String) {
        NetworkManager.shared.request(type: ProfileResponse.self, api: .profileCheck(request: AuthorizationRequest(access: token.access)), errorCase: .profileCheck)
            .sink { completion in
                if case .failure(let error) = completion {
                    if let profileError = error as? NetworkError {
                        switch profileError {
                        case .invalidRequestBody(_):
                            print("Profile Check Error in TabViewsViewModel: \(profileError.description)")
                            self.isLoginAvailable = false
                        case .invalidToken(_):
                            print("Invalid Access token in TabViewsViewModel: \(profileError.description)")
                            self.requestRefreshToken(token, userId: userId, action: .profile)
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
    
    func handleRefreshTokenSuccess(response: UserTokenValue, userId: String, action: ActionType) {
        requestProfile(response, userId: userId)
    }
    
    func handleRefreshTokenError(isRefreshInvalid: Bool, userId: String) {
        AuthManager.shared.handleRefreshTokenExpired(userId: userId)
        isLoginAvailable = false
    }
        
    func updateProfileFromProfileView(_ newProfile: ProfileResponse) {
        print("Updated Profile: \(newProfile)")
        self.profileData = newProfile
        self.didUpdateProfileFromOtherView = true
    }
}
