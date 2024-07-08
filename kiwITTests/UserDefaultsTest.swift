//
//  UserDefaultsTest.swift
//  kiwITTests
//
//  Created by Heedon on 3/12/24.
//

import XCTest

final class UserDefaultsTest: XCTestCase {
    
    //MARK: - Test UserDefaults with email for now
    
    private let userdefaultsManager = UserDefaultsManager.shared
    
    let emailAccount = "testABC@abc.com"
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    
    func testRetrieveFromUserDefaultsFailure() throws {
        //Arrange
//        userdefaultsManager.deleteFromUserDefaults(forKey: accessKey)
//        userdefaultsManager.deleteFromUserDefaults(forKey: refreshKey)
        
//        let expectedAccess = accessToken
//        let expectedRefresh = refreshToken
        
        //Act
        
        //Assert
//        do {
//            let retrievedAccess = try userdefaultsManager.retrieveFromUserDefaults(forKey: accessKey) as String
//            XCTAssertEqual(retrievedAccess, expectedAccess, "Access Token Not Equal / No Access Token")
//        } catch {
//            print("No Access Token")
//            UserDefaultsError.noDataInUserDefaults
//        }
//        
//        do {
//            let retrievedRefresh = try userdefaultsManager.retrieveFromUserDefaults(forKey: refreshKey) as String
//            XCTAssertEqual(retrievedRefresh, expectedRefresh, "Refresh Token Not Equal / No Refresh Token")
//        } catch {
//            print("No Refresh Token")
//            UserDefaultsError.noDataInUserDefaults
//        }
    }
    
    func testSaveToUserDefaults() {
        //Arrange
        
        //Act
//        let saveAccessResult = userdefaultsManager.saveToUserDefaults(newValue: accessToken, forKey: accessKey)
//        let saveRefreshResult = userdefaultsManager.saveToUserDefaults(newValue: refreshToken, forKey: refreshKey)
        
        //Assert
//        XCTAssertTrue(saveAccessResult, "Successfully saved access token to userDefaults")
//        XCTAssertTrue(saveRefreshResult, "Successfully saved refresh token to userDefaults")
    }
    
    func testRetrieveFromUserDefaultsSuccess() throws {
        
        //Arrange
//        userdefaultsManager.saveToUserDefaults(newValue: accessToken, forKey: accessKey)
//        userdefaultsManager.saveToUserDefaults(newValue: refreshToken, forKey: refreshKey)
//        
//        let expectedAccess = accessToken
//        let expectedRefresh = refreshToken
        
        //Act
        
        //Assert
       
//        do {
//            let retrievedAccess = try userdefaultsManager.retrieveFromUserDefaults(forKey: accessKey) as String
//            XCTAssertEqual(retrievedAccess, expectedAccess, "Access Token Not Equal / No Access Token")
//        } catch {
//            print("No Access Token")
//            UserDefaultsError.noDataInUserDefaults
//        }
        
//        do {
//            let retrievedRefresh = try userdefaultsManager.retrieveFromUserDefaults(forKey: refreshKey) as String
//            XCTAssertEqual(retrievedRefresh, expectedRefresh, "Refresh Token Not Equal / No Refresh Token")
//        } catch {
//            print("No Refresh Token")
//            UserDefaultsError.noDataInUserDefaults
//        }
        
       
    }
    
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
}
