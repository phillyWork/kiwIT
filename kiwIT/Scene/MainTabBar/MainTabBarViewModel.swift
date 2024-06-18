//
//  MainTabBarViewModel.swift
//  kiwIT
//
//  Created by Heedon on 6/13/24.
//

import Foundation

import Combine

//MARK: - 기능 순서
//MARK: - 1. Keychain에 Token 존재 여부 확인
//MARK: - 1-a. 존재 O --> Request Refresh Token으로 Token Availability 파악
//MARK: - 1-a-1. Updated Token: 새로운 Token으로 update, 원하는 작업 Request
//MARK: - 1-a-2. Refresh Token Error: 토큰 만료 등 에러 --> (토큰 삭제 혹은 놔두고) LoginView
//MARK: - 1-b. No Token --> LoginView

final class MainTabBarViewModel: ObservableObject {
    
    @Published var isUserLoggedIn = false
    @Published var userProfileData: ProfileResponse?

    let profileUpdateSubject = PassthroughSubject<ProfileResponse, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        print("DEBUG - MainTabBarViewModel initialized")
        
        //when app launches: check token - whether user is already logged in server or not
        checkToken()
        
        print("DEBUG - End of MainTabBarViewModel initialization")
    }
    
    private func checkToken() {
        //a. check access token lifetime via server
        if let savedToken = KeyChainManager.shared.read() {
            NetworkManager.shared.request(type: RefreshAccessTokenResponse.self, api: .refreshToken(request: RefreshAccessTokenRequest(refreshToken: savedToken.refresh)), errorCase: .refreshToken)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("error: \(error)")
                        
                        //MARK: - 지우는 과정 고민해봐야함: 로그아웃하고 다시 로그인하고 로그아웃할 경우 저장된 키체인값 없어서 의도와 다른 로그아웃 루트 탐
                        
                        if error is NetworkError {
                            //a-1-2. refresh token is out of time
                            //delete existing keychain
                            if KeyChainManager.shared.delete() {
                                print("At First: Token Exists, Deleted Token, Should Login")
                            } else {
                                print("At First: Token Exists, Cannot Delete Token")
                                KeyChainManager.shared.deleteAll()
                            }
                        } else {
                            //a-1-3. refresh token error occurred!!!
                            if KeyChainManager.shared.delete() {
                                print("At First: Token Exists, Refresh Request Error Occurred, Deleted Token, Should Login")
                            } else {
                                print("At First: Token Exists, Refresh Request Error Occurred, Cannot Delete Token")
                                KeyChainManager.shared.deleteAll()
                            }
                        }
                        //user needs to log in again
                        self.isUserLoggedIn = false
                    }
                } receiveValue: { response in
                    print("updated token response: \(response)")
                    //a-1-1. new updated access & refresh token
                    //update token data, user is still logged in
                    if KeyChainManager.shared.update(token: UserTokenValue(access: response.accessToken, refresh: response.refreshToken)) {
                        print("At First: Token Exists, Updated Token")
                    } else {
                        print("At First: Token Exists, Cannot Update Token")
                        KeyChainManager.shared.create(token: UserTokenValue(access: response.accessToken, refresh: response.refreshToken))
                        //token Update 불가능해도 토큰 체크 시 다시 요청하면서 처리해야 하므로 넘어가기
                    }
                    self.isUserLoggedIn = true
                }
                .store(in: &self.cancellables)
        } else {
            //a-2. no token saved in keychain/userdefaults
            //user never logged in this device or needs to log in
            print("No Saved Token At First. Needs to Log In")
            self.isUserLoggedIn = false
        }
    }
}
