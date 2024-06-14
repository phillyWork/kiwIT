//
//  KeyChainManagerTest.swift
//  kiwITTests
//
//  Created by Heedon on 6/14/24.
//

import XCTest

final class KeyChainManagerTest: XCTestCase {

    private let keychainManager = KeyChainManager.shared
    
    let service = "kiwit"
    
    let email1 = "Test1@abc.com"
    var email1Token = UserTokenValue(access: "111111111", refresh: "222222222")
    
    let email2 = "Test2@def.com"
    var email2Token = UserTokenValue(access: "333333333", refresh: "444444444")
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCreateToKeychain() throws {
        //Arrange
        do {
            let token1 = try JSONEncoder().encode(email1Token)
            let query1 = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: service,
                kSecAttrAccount: email1,
                kSecValueData: token1
            ] as CFDictionary
            //Act
            let email1TokenStatus = SecItemAdd(query1, nil)
            //Assert
            XCTAssertEqual(email1TokenStatus, errSecSuccess, "Email1 Not Created In KeyChain: \(SecCopyErrorMessageString(email1TokenStatus, nil))")
            
        } catch {
            print("Cannot Encode Email1Token")
        }
        
        //Arrange
        do {
            let token2 = try JSONEncoder().encode(email1Token)
            let query2 = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: service,
                kSecAttrAccount: email2,
                kSecValueData: token2
            ] as CFDictionary
            //Act
            let email2TokenStatus = SecItemAdd(query2, nil)
            //Assert
            XCTAssertEqual(email2TokenStatus, errSecSuccess, "Email2 Not Created In KeyChain: \(SecCopyErrorMessageString(email2TokenStatus, nil))")
            
        } catch {
            print("Cannot Encode Email2Token")
        }
        
    }
    
    func testReadKeyChain() throws {
        //Arrange
        let query1 = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: email1,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecReturnData: true,
            kSecReturnAttributes as String: true
        ] as CFDictionary
        
        var item: CFTypeRef?
        
        //Act
        let status1 = SecItemCopyMatching(query1, &item)
        
        //Assert
        XCTAssertNotEqual(status1, errSecItemNotFound, "Keychain Item Email1 Not Found")
        XCTAssertEqual(status1, errSecSuccess, "Key Chain Read Email1 Error -- \(SecCopyErrorMessageString(status1, nil))")
                
        guard let existingItem = item as? [String: Any],
              let tokenData = existingItem[kSecValueData as String] as? Data
        else {
            print("No Existing Data or token saved in KeyChain item")
            return
        }
        
        do {
            let token = try JSONDecoder().decode(UserTokenValue.self, from: tokenData)
            print("Email1 token from KeyChain: \(token)")
        } catch {
            print("Cannot Decode Email1 Token Data from KeyChain")
        }
        
        let query2 = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: email2,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecReturnData: true,
            kSecReturnAttributes as String: true
        ] as CFDictionary
        
        //Act
        let status2 = SecItemCopyMatching(query2, &item)
        
        //Assert
        XCTAssertNotEqual(status2, errSecItemNotFound, "Keychain Item Email2 Not Found")
        XCTAssertEqual(status2, errSecSuccess, "Key Chain Read Email2 Error -- \(SecCopyErrorMessageString(status2, nil))")
                
        guard let existingItem = item as? [String: Any],
              let tokenData = existingItem[kSecValueData as String] as? Data
        else {
            print("No Existing Data or token saved in KeyChain item")
            return
        }
        
        do {
            let token = try JSONDecoder().decode(UserTokenValue.self, from: tokenData)
            print("Email2 token from KeyChain: \(token)")
        } catch {
            print("Cannot Decode Email2 Token Data from KeyChain")
        }
    }
    
    func testUpdateDataInKeychain() throws {
        
        //Arrange
        email1Token.access = "abababababababab"
        email1Token.refresh = "cdcdcdcdcdcdcdcd"
        
        do {
            let encodedToken = try JSONEncoder().encode(email1Token)
            
            let query1 = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: service,
                kSecAttrAccount: email1
            ] as CFDictionary
            
            let attributes1 = [
                kSecValueData: encodedToken
            ] as CFDictionary
            
            //Act
            let email1Status = SecItemUpdate(query1, attributes1)
            
            //Assert
            XCTAssertNotEqual(email1Status, errSecItemNotFound, "Keychain Updated Email1 Not Found")
            XCTAssertEqual(email1Status, errSecSuccess, "Keychain Update Email1 Data Error - \(SecCopyErrorMessageString(email1Status, nil))")
            
        } catch {
            print("Cannot Encode Email1Token")
        }
        
        //Arrange
        email2Token.access = "xyxyxyxyxyxyxyxyxy"
        email2Token.refresh = "zwzwzwzwzwzwzwzwzw"
        
        do {
            let encodedToken = try JSONEncoder().encode(email2Token)
            
            let query2 = [
                kSecClass: kSecClassGenericPassword,
                kSecAttrService: service,
                kSecAttrAccount: email2
            ] as CFDictionary
            
            let attributes2 = [
                kSecValueData: encodedToken
            ] as CFDictionary
            
            //Act
            let email2Status = SecItemUpdate(query2, attributes2)
            
            //Assert
            XCTAssertNotEqual(email2Status, errSecItemNotFound, "Keychain Updated Email2 Not Found")
            XCTAssertEqual(email2Status, errSecSuccess, "Keychain Update Email2 Data Error - \(SecCopyErrorMessageString(email2Status, nil))")
            
        } catch {
            print("Cannot Encode Email1Token")
        }
    }
    
    func testReadKeyChainAfterUpdate() throws {
        //Arrange
        let query1 = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: email1,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecReturnData: true,
            kSecReturnAttributes as String: true
        ] as CFDictionary
        
        var item: CFTypeRef?
        
        //Act
        let status1 = SecItemCopyMatching(query1, &item)
        
        //Assert
        XCTAssertNotEqual(status1, errSecItemNotFound, "Keychain Item Email1 Not Found")
        XCTAssertEqual(status1, errSecSuccess, "Key Chain Read Email1 Error -- \(SecCopyErrorMessageString(status1, nil))")
                
        guard let existingItem = item as? [String: Any],
              let tokenData = existingItem[kSecValueData as String] as? Data
        else {
            print("No Existing Data or token saved in KeyChain item")
            return
        }
        
        do {
            let token = try JSONDecoder().decode(UserTokenValue.self, from: tokenData)
            print("Email1 token from KeyChain: \(token)")
        } catch {
            print("Cannot Decode Email1 Token Data from KeyChain")
        }
        
        let query2 = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: email2,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecReturnData: true,
            kSecReturnAttributes as String: true
        ] as CFDictionary
        
        //Act
        let status2 = SecItemCopyMatching(query2, &item)
        
        //Assert
        XCTAssertNotEqual(status2, errSecItemNotFound, "Keychain Item Email2 Not Found")
        XCTAssertEqual(status2, errSecSuccess, "Key Chain Read Email2 Error -- \(SecCopyErrorMessageString(status2, nil))")
                
        guard let existingItem = item as? [String: Any],
              let tokenData = existingItem[kSecValueData as String] as? Data
        else {
            print("No Existing Data or token saved in KeyChain item")
            return
        }
        
        do {
            let token = try JSONDecoder().decode(UserTokenValue.self, from: tokenData)
            print("Email2 token from KeyChain: \(token)")
        } catch {
            print("Cannot Decode Email2 Token Data from KeyChain")
        }
        
    }
    
    func testDeleteEmail1InKeyChain() throws {
        //Arrange
        let query1 = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: email1,
        ] as CFDictionary
        
        //Act
        let status1 = SecItemDelete(query1)
        
        //Assert
        XCTAssertEqual(status1, errSecSuccess, "KeyChain Email1 Deletion Error")
        
        if status1 != errSecSuccess {
            XCTAssertEqual(status1, errSecItemNotFound, "Error: After Deletion, KeyChain Email1 Still Found -- \(SecCopyErrorMessageString(status1, nil))")
        }
    }
    
    func testReadAfterEmail1Deletion() throws {
        let query1 = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: email1,
            kSecMatchLimit: kSecMatchLimitOne,
            kSecReturnData: true,
            kSecReturnAttributes as String: true
        ] as CFDictionary
        
        var item: CFTypeRef?
        
        //Act
        let status1 = SecItemCopyMatching(query1, &item)
        
        //Assert
        XCTAssertEqual(status1, errSecItemNotFound, "Even After Deletion, Somehow item is found")
    }
    
    func testDeleteWhole() throws {
        //Arrange
        var deletionCount = 0
        let secClass = [kSecClassGenericPassword, kSecClassInternetPassword, kSecClassCertificate, kSecClassKey, kSecClassIdentity]
        
        //Act
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
        
        //Assert
        XCTAssertEqual(deletionCount, secClass.count, "Cannot Delete Whole Class Items")
    }

    func testReadAfterDeleteWholeKeychain() throws {
        //Arrange
        let query1 = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: email1
        ] as CFDictionary
        
        let query2 = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: email2,
        ] as CFDictionary
        
        var item: CFTypeRef?
        
        //Act
        let email1TokenStatus = SecItemCopyMatching(query1, &item)
        let email2TokenStatus = SecItemCopyMatching(query2, &item)
        
        //Assert
        XCTAssertEqual(email1TokenStatus, errSecItemNotFound, "Even After Delete Whole, Email1 Found In KeyChain: \(SecCopyErrorMessageString(email1TokenStatus, nil))")
        XCTAssertEqual(email2TokenStatus, errSecItemNotFound, "Even After Delete Whole, Email2 Found In KeyChain: \(SecCopyErrorMessageString(email2TokenStatus, nil))")
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
