//
//  LoginTests.swift
//  WorkBenchTests
//
//  Created by ketan on 16/10/19.
//  Copyright © 2019 Infosys. All rights reserved.
//

import XCTest
@testable import WorkBench

class LoginTests: XCTestCase {
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    func testLoginViewModel() {
        // Test for email validation
        let email = "q@w.com"
        XCTAssertTrue(email.isValidEmail())
        // Test for password validation
        // Minimum password character limit - 6
        let password = "123456"
        XCTAssertTrue(password.isValidPassword())
    }
}
