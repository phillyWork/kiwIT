//
//  APIManager.swift
//  kiwIT
//
//  Created by Heedon on 4/29/24.
//

import Foundation

import Combine

//token, profile 관련 한번에 처리

final class AuthManager: ObservableObject {

    static let shared = AuthManager()
    private init() { }

    @Published var profile: ProfileResponse?
    
    private var cancellables = Set<AnyCancellable>()

    func refreshToken(refresh: String) {
        NetworkManager.shared.request(type: RefreshAccessTokenResponse.self, api: .refreshToken(request: RefreshAccessTokenRequest(refreshToken: refresh)), errorCase: .refreshToken)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    if error is NetworkError {
                        
                    } else {
                        
                    }
                }
            } receiveValue: { response in
                if let currentToken = KeyChainManager.shared.read() {
                    KeyChainManager.shared.update(token: UserTokenValue(access: response.accessToken, refresh: response.refreshToken))
                } else {
                    KeyChainManager.shared.create(token: UserTokenValue(access: response.accessToken, refresh: response.refreshToken))
                }
            }
            .store(in: &self.cancellables)
    }
    
}
