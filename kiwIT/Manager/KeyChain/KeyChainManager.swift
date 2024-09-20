//
//  KeyChainManager.swift
//  kiwIT
//
//  Created by Heedon on 6/13/24.
//

import Foundation

import Security

struct UserTokenValue: Codable {
    var access: String
    var refresh: String
}

//KeyChain: 앱 삭제 후 재설치해도 값은 저장된 그대로 존재
//iCloud로 공유 가능하도록 설정 가능 (서로 다른 디바이스에서 해당 앱 활용할 시)
//kSecAttrSynchronizable

final class KeyChainManager {
    
    static let shared = KeyChainManager()
    private init() { }
    
    func create(_ token: UserTokenValue, id: String) {
        do {
            let serviceName = Setup.KeyChainKeyStrings.serviceName
            let encodedData = try JSONEncoder().encode(token)
            
            let query = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: serviceName,
                kSecAttrAccount: id,
                kSecValueData: encodedData
            ] as CFDictionary
            
            let status = SecItemAdd(query, nil)
            
            guard status == errSecSuccess else {
                return
            }
        } catch {
            print("KEYCHAIN CREATE Error with JSONEncoder")
        }
    }
    
    func read(_ id: String) -> UserTokenValue? {
        let serviceName = Setup.KeyChainKeyStrings.serviceName
        
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: serviceName,
            kSecAttrAccount: id,
            kSecReturnData: true,
            kSecReturnAttributes as String: true
        ] as CFDictionary
        
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query, &item)
        
        guard status != errSecItemNotFound else {
            return nil
        }
        
        guard status == errSecSuccess else {
            return nil
        }
        
        guard let existingItem = item as? [String: Any],
              let tokenData = existingItem[kSecValueData as String] as? Data
        else {
            return nil
        }
        
        do {
            let token = try JSONDecoder().decode(UserTokenValue.self, from: tokenData)
            return token
        } catch {
            return nil
        }
    }
        
    func update(_ newToken: UserTokenValue, id: String) -> Bool {
        do {
            let serviceName = Setup.KeyChainKeyStrings.serviceName
            let encodedData = try JSONEncoder().encode(newToken)
                        
            let query = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: serviceName,
                kSecAttrAccount: id
            ] as CFDictionary
            
            let attributes = [
                kSecValueData: encodedData
            ] as CFDictionary
            
            let status = SecItemUpdate(query, attributes)
            
            guard status != errSecItemNotFound else {
                return false
            }
            
            guard status == errSecSuccess else {
                return false
            }
            return true
        } catch {
            return false
        }
    }
    
    func delete(_ id: String) {
        let serviceName = Setup.KeyChainKeyStrings.serviceName
        
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: serviceName,
            kSecAttrAccount: id,
        ] as CFDictionary
        
        let status = SecItemDelete(query)
        
        //삭제: 없는 아이템 삭제 에러 상관 없음
        guard status == errSecSuccess || status == errSecItemNotFound else {
            return
        }
    }
        
    func deleteAll() {
        let secClass = [kSecClassGenericPassword, kSecClassInternetPassword, kSecClassCertificate, kSecClassKey, kSecClassIdentity]
        secClass.forEach {
            let status = SecItemDelete([
                kSecClass: $0,
                kSecAttrSynchronizable: kSecAttrSynchronizableAny
            ] as CFDictionary)
            if status != errSecSuccess && status != errSecItemNotFound {
                //Error while removing class $0
                print("Error While Removing Whole -- class: \($0)")
            }
        }
    }
    
}
