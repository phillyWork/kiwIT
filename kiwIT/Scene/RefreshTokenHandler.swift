//
//  BaseViewModel.swift
//  kiwIT
//
//  Created by Heedon on 7/18/24.
//

import Foundation
import Combine

//MARK: - 모든 ViewModel에서 공통 사용
protocol RefreshTokenHandler: AnyObject {
    associatedtype ActionType
    var cancellables: Set<AnyCancellable> { get set }
    func handleRefreshTokenSuccess(response: UserTokenValue, userId: String, action: ActionType)
    func handleRefreshTokenError(isRefreshInvalid: Bool, userId: String)
}

extension RefreshTokenHandler {
    
    //default refresh token method
    func requestRefreshToken(_ token: UserTokenValue, userId: String, action: ActionType) {
        NetworkManager.shared.request(type: RefreshAccessTokenResponse.self, api: .refreshToken(request: RefreshAccessTokenRequest(refreshToken: token.refresh)), errorCase: .refreshToken)
            .sink { completion in
                if case .failure(let error) = completion {
                    if let refreshError = error as? NetworkError {
                        switch refreshError {
                        case .invalidToken(_):
                            self.handleRefreshTokenError(isRefreshInvalid: true, userId: userId)
                        default:
                            self.handleRefreshTokenError(isRefreshInvalid: false, userId: userId)
                        }
                    } else {
                        self.handleRefreshTokenError(isRefreshInvalid: false, userId: userId)
                    }
                }
            } receiveValue: { response in
                KeyChainManager.shared.update(UserTokenValue(access: response.accessToken, refresh: response.refreshToken), id: userId)
                self.handleRefreshTokenSuccess(response: UserTokenValue(access: response.accessToken, refresh: response.refreshToken), userId: userId, action: action)
            }
            .store(in: &self.cancellables)
    }
    
}
