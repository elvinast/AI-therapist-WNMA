////
////  AuthStatusManagerTests.swift
////  Radiant
////
////  Created by Ben Dreyer on 5/5/23.
////
//
//import XCTest
//import FirebaseAuth
//import FirebaseCore
//import Radiant
//
//final class AuthStatusManagerTests: XCTestCase {
//
//    override func setUpWithError() throws {
//        // Put setup code here. This method is called before the invocation of each test method in the class.
//        super.setUp()
//        let radiantApp = RadiantApp()
//        let didFinishLaunchingWithOptions = radiantApp.delegate.application(UIApplication(), didFinishLaunchingWithOptions: nil)
//
//    }
//
//    override func tearDownWithError() throws {
//        // Put teardown code here. This method is called after the invocation of each test method in the class.
//        super.tearDown()
//    }
//
//
////    func testLoginWithEmail() throws {
////        // Arange
////        try setUpWithError()
////        let authStatusManager = AuthStatusManager()
////        authStatusManager.email = "testemail@google.com"
////        authStatusManager.password = "123456"
////
////        // Act
////        authStatusManager.loginWithEmail()
////
////        // Result
////        XCTAssertTrue(authStatusManager.isLoggedIn)
////    }
////
////    func testLoginWithEmailNullEmail() {
////        // Arange
////        let authStatusManager = AuthStatusManager()
////        authStatusManager.password = "123456"
////
////        // Act
////        authStatusManager.loginWithEmail()
////
////        // Result
////        XCTAssertFalse(authStatusManager.isLoggedIn)
////    }
////
////    func testLoginWithEmailExistingEmail() {
////        // Arange
////        let authStatusManager = AuthStatusManager()
////        authStatusManager.email = "1@2.com"
////
////        // Act
////        authStatusManager.loginWithEmail()
////
////        // Result
////        XCTAssertFalse(authStatusManager.isLoggedIn)
////    }
////
////    func testLoginWithEmailNullPassword() {
////        // Arange
////        let authStatusManager = AuthStatusManager()
////        authStatusManager.email = "testemail@google.com"
////
////        // Act
////        authStatusManager.loginWithEmail()
////
////        // Result
////        XCTAssertFalse(authStatusManager.isLoggedIn)
////    }
//}
