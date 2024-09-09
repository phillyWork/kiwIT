//
//  AuthManager.swift
//  kiwIT
//
//  Created by Heedon on 6/27/24.
//

import Foundation

final class AuthManager {
    
    static let shared = AuthManager()
    private init() { }
    
    func checkTokenData() -> (UserTokenValue, String)? {
        do {
            let userId = try UserDefaultsManager.shared.retrieveFromUserDefaults(forKey: Setup.UserDefaultsKeyStrings.userIdString) as String
            guard let tokenData = KeyChainManager.shared.read(userId) else {
                return nil
            }
            return (tokenData, userId)
        } catch {
            return nil
        }
    }
    
    func handleRefreshTokenExpired(userId: String) {
        //저장된 token 삭제,
        KeyChainManager.shared.delete(userId)
        //저장된 userdefaults id 삭제
        UserDefaultsManager.shared.deleteFromUserDefaults(forKey: Setup.UserDefaultsKeyStrings.userIdString)
    }
    
}
