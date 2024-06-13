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

//Token 저장 목적

final class KeyChainManager {
    
    static let shared = KeyChainManager()
    private init() { }

    //MARK: - throws로 BundleIdentifier 없거나 UserDefaults Email 가져오지 못하거나 Encoder/Decoder 활용 못하는 에러 처리 따로 필요?
    
    //새롭게 저장: 처음 계정 생성 시 혹은 계정 존재하지만 새로운 기기에서 처음 시작 시
    func create(token: UserTokenValue) -> Bool {
        do {
            let serviceName = Bundle.main.infoDictionary?[Setup.ContentStrings.serviceNameString] ?? ""
            let accountEmail = try UserDefaultsManager.shared.retrieveFromUserDefaults(forKey: Setup.UserDefaultsKeyStrings.emailString) as String
            let encodedToken = try JSONEncoder().encode(token)
           
            let query: [String: Any] = [
                kSecClass as String: kSecClassKey,
                kSecAttrService as String: serviceName as! String,
                kSecAttrAccount as String: accountEmail,
                kSecValueData as String: encodedToken
            ]
            
            let status = SecItemAdd(query as CFDictionary, nil)
            
            guard status == errSecSuccess else {
                print("Keychain Create Data Error")
                return false
            }
            
            print("status for create: \(SecCopyErrorMessageString(status, nil))")
            
            return true
        } catch {
            print("KEYCHAIN CREATE -- No Bundle Identifier, Nothing on Saved Email, or Cannot Encode Token Data")
            return false
        }
    }
    
    //저장된 데이터 불러오기
    func read() -> UserTokenValue? {
        do {
            let serviceName = Bundle.main.infoDictionary?[Setup.ContentStrings.serviceNameString] ?? ""
            let accountEmail = try UserDefaultsManager.shared.retrieveFromUserDefaults(forKey: Setup.UserDefaultsKeyStrings.emailString) as String
            
            let query: [String: Any] = [
                kSecClass as String: kSecClassKey,
                kSecAttrService as String: serviceName as! String,
                kSecAttrAccount as String: accountEmail,
                kSecMatchLimit as String: kSecMatchLimitOne,
                kSecReturnData as String: true,
                kSecReturnAttributes as String: true
            ]
            
            var item: CFTypeRef?
            let status = SecItemCopyMatching(query as CFDictionary, &item)
            
            guard status != errSecItemNotFound else {
                print("Keychain Item Not Found")
                return nil
            }
            
            guard status == errSecSuccess else {
                print("Keychain Read Data Error")
                return nil
            }
            
            print("status for read: \(SecCopyErrorMessageString(status, nil))")
            
            guard let existingItem = item as? [String: Any],
                  let tokenData = existingItem[kSecValueData as String] as? Data
            else {
                print("No Existing Data or token saved in KeyChain item")
                return nil
            }
            
            do {
                let token = try JSONDecoder().decode(UserTokenValue.self, from: tokenData)
                print("token from KeyChain: \(token)")
                return token
            } catch {
                print("Cannot Decode Token Data from KeyChain")
                return nil
            }
        } catch {
            print("KEYCHAIN READ -- No Bundle Identifier, Nothing on Saved Email")
            return nil
        }
    }
    
    //저장된 데이터 업데이트
    func update(token: UserTokenValue) -> Bool {
        do {
            let serviceName = Bundle.main.infoDictionary?[Setup.ContentStrings.serviceNameString] ?? ""
            let accountEmail = try UserDefaultsManager.shared.retrieveFromUserDefaults(forKey: Setup.UserDefaultsKeyStrings.emailString) as String
            let encodedToken = try JSONEncoder().encode(token)
           
            
            let query: [String: Any] = [
                kSecClass as String: kSecClassKey,
            ]
            
            let attributes: [String: Any] = [
                kSecAttrService as String: serviceName as! String,
                kSecAttrAccount as String: accountEmail,
                kSecValueData as String: encodedToken
            ]
            
            let status = SecItemUpdate(query as CFDictionary, attributes as CFDictionary)
            
            guard status != errSecItemNotFound else {
                print("Keychain Updated Item Not Found")
                return false
            }
            
            guard status == errSecSuccess else {
                print("Keychain Update Data Error")
                return false
            }
            
            print("status for update: \(SecCopyErrorMessageString(status, nil))")
            
            return true
        } catch {
            print("KEYCHAIN UPDATE -- No Bundle Identifier, Nothing on Saved Email, or Cannot Encode Token Data")
            return false
        }
    }
    
    //저장된 데이터 삭제
    func delete() -> Bool {
        do {
            let serviceName = Bundle.main.infoDictionary?[Setup.ContentStrings.serviceNameString] ?? ""
            let accountEmail = try UserDefaultsManager.shared.retrieveFromUserDefaults(forKey: Setup.UserDefaultsKeyStrings.emailString) as String
            
            let query: [String: Any] = [
                kSecClass as String: kSecClassKey,
                kSecAttrService as String: serviceName as! String,
                kSecAttrAccount as String: accountEmail,
            ]
                        
            let status = SecItemDelete(query as CFDictionary)
            
            //삭제: 없는 아이템 삭제 에러 상관 없음
            guard status == errSecSuccess || status == errSecItemNotFound else {
                print("Keychain Delete Data Error")
                return false
            }
            
            print("status for delete: \(SecCopyErrorMessageString(status, nil))")
            
            return true
        } catch {
            print("KEYCHAIN DELETE -- No Bundle Identifier, Nothing on Saved Email")
            return false
        }
    }
    
}
