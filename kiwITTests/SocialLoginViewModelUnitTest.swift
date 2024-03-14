//
//  SocialLoginViewModelUnitTest.swift
//  kiwITTests
//
//  Created by Heedon on 3/12/24.
//

import XCTest

final class SocialLoginViewModelUnitTest: XCTestCase {

    var socialLoginViewModel: SocialLoginViewModel!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        socialLoginViewModel = SocialLoginViewModel()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testrequestAppleUserLogin(_ credential: ASAuthorizationCredential) {
        //Arrange
        
        //Act
        
        //Assert
        
    }
    
    
    func testCheckTokenAvailability() {
        //Arrange
        
        //Act
        
        //Assert
        
    }
    

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
