//
//  MainTabBarViewModel.swift
//  kiwIT
//
//  Created by Heedon on 6/13/24.
//

import Foundation

import Combine

final class MainTabBarViewModel: ObservableObject {
    
    @Published var isUserLoggedIn = false
    
    var cancellables = Set<AnyCancellable>()
    
    init() {
        print("DEBUG - MainTabBarViewModel initialized")
        
        //when app launches: check token - whether user is already logged in server
        checkToken()
        
        print("DEBUG - End of MainTabBarViewModel initialization")
    }
    
    //MARK: - Refactor with Keychain
    
    private func checkToken() {
       
    
//        do {
//            let savedRefreshToken = try UserDefaultsManager.shared.retrieveFromUserDefaults(forKey: "refresh") as String
//            
//            NetworkManager.shared.request(type: RefreshAccessTokenResponse.self, api: .refreshToken(request: RefreshAccessTokenRequest(refreshToken: savedRefreshToken)), errorCase: .refreshToken)
//                .sink { completion in
//                    switch completion {
//                    case .finished:
//                        break
//                    case .failure(let error):
//                        //a-1-2. refresh token is out of time --> user needs to log in again
//                        
//                        print("error: \(error)")
//                    }
//                } receiveValue: { response in
//                    print("updated token response: \(response)")
//                    //a-1-1. new access & refresh token --> user is still logged in
//                }
//                .store(in: &self.cancellables)
//            
//        } catch UserDefaultsError.noDataInUserDefaults {
//            isUserLoggedIn = false
//        } catch UserDefaultsError.cannotDecodeData {
//            UserDefaultsManager.shared.deleteFromUserDefaults(forKey: "refresh")
//            UserDefaultsManager.shared.deleteFromUserDefaults(forKey: "access")
//            isUserLoggedIn = false
//        } catch {
//            isUserLoggedIn = false
//        }
  
        
        //a. check access token lifetime via server
        if let savedToken = KeyChainManager.shared.read() {
            NetworkManager.shared.request(type: RefreshAccessTokenResponse.self, api: .refreshToken(request: RefreshAccessTokenRequest(refreshToken: savedToken.refresh)), errorCase: .refreshToken)
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        print("error: \(error)")
                        if let refreshTokenError = error as? NetworkError {
                            //a-1-2. refresh token is out of time
                            //delete existing keychain
                            if KeyChainManager.shared.delete() {
                                print("At First: Token Exists, Deleted Token, Should Login")
                            } else {
                                print("At First: Token Exists, Cannot Delete Token")
                                //MARK: - Delete Token Again or just Login Again?
                                
                            }
                        } else {
                            //a-1-3. refresh token error occurred!!!
                            if KeyChainManager.shared.delete() {
                                print("At First: Token Exists, Refresh Request Error Occurred, Deleted Token, Should Login")
                            } else {
                                print("At First: Token Exists, Refresh Request Error Occurred, Cannot Delete Token")
                                //MARK: - Delete Token Again or just Login Again?
                                
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
                        print("At First: Token Exists, Updated Token, Show HomeView")
                        self.isUserLoggedIn = true
                    } else {
                        print("At First: Token Exists, Cannot Update Token")
                        //MARK: - Update Token again or just Login Again?
                        
                    }
                }
                .store(in: &self.cancellables)
        } else {
            //a-2. no token saved in keychain/userdefaults
            //user never logged in this device or needs to log in
            self.isUserLoggedIn = false
        }
        
        
    }
    
}
