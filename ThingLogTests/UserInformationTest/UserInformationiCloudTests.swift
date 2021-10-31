//
//  UserInformationiCloudTests.swift
//  ThingLogTests
//
//  Created by hyunsu on 2021/10/31.
//

import XCTest
@testable import ThingLog

/// 유저정보를 `iCloud - KeyValueStorage`를 이용하여 테스트한다.
class UserInformationiCloudTests: XCTestCase {
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_유저정보를_업데이트하면_반영된다() {
        let model = UserInformationiCloudViewModel()
        let newUser = UserInformation(userAliasName: "asdf",
                                      userOneLineIntroduction: "asdf",
                                      isAumatedDarkMode: true)
        model.updateUserInformation(newUser)
        model.fetchUserInformation { user in
            XCTAssert(newUser.userAliasName == user?.userAliasName &&
                        newUser.isAumatedDarkMode == user?.isAumatedDarkMode &&
                        newUser.userOneLineIntroduction == user?.userOneLineIntroduction )
        }
    }
    
    func test_유저정보를_업데이트하면_subscribeUserInformationChange메소드가_호출된다() {
        timeout(0.3) { exp in
            let model = UserInformationiCloudViewModel()
            model.subscribeUserInformationChange { userInformation in
                exp.fulfill()
                XCTAssert(true)
            }
            let newUser = UserInformation(userAliasName: "asdf",
                                          userOneLineIntroduction: "asdf",
                                          isAumatedDarkMode: true)
            model.updateUserInformation(newUser)
        }
    }
}
