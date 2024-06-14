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

//MARK: - KeyChain: 앱 삭제 후 재설치해도 값은 저장된 그대로 존재

//MARK: - iCloud로 공유 가능하도록 설정 가능 (서로 다른 디바이스에서 해당 앱 활용할 시)
//kSecAttrSynchronizable


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
           
            let query = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: serviceName as! String,
                kSecAttrAccount: accountEmail,
                kSecValueData: encodedToken
            ] as CFDictionary
            
            let status = SecItemAdd(query, nil)
            
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
            
            let query = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: serviceName as! String,
                kSecAttrAccount: accountEmail,
                kSecMatchLimit: kSecMatchLimitOne,
                kSecReturnData: true,
                kSecReturnAttributes as String: true
            ] as CFDictionary
            
            var item: CFTypeRef?
            let status = SecItemCopyMatching(query, &item)
            
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
           
            let query = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: serviceName as! String,
                kSecAttrAccount: accountEmail
            ] as CFDictionary
            
            let attributes = [
                kSecValueData: encodedToken
            ] as CFDictionary
            
            let status = SecItemUpdate(query, attributes)
            
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
            
            let query = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: serviceName as! String,
                kSecAttrAccount: accountEmail,
            ] as CFDictionary
                        
            let status = SecItemDelete(query)
            
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
    
    //For App Launched First Time
    func deleteAll() -> Bool {
        var deletionCount = 0
        let secClass = [kSecClassGenericPassword, kSecClassInternetPassword, kSecClassCertificate, kSecClassKey, kSecClassIdentity]
        secClass.forEach {
            let status = SecItemDelete([
                kSecClass: $0,
                kSecAttrSynchronizable: kSecAttrSynchronizableAny
            ] as CFDictionary)
            if status != errSecSuccess && status != errSecItemNotFound {
                //Error while removing class $0
                print("Error While Removing Whole -- class: \($0)")
            } else {
                deletionCount += 1
            }
        }
        return deletionCount == secClass.count ? true : false
    }
    
}
