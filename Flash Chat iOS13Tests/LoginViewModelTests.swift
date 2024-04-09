//
//  LoginViewModelTests.swift
//  Flash Chat iOS13Tests
//
//  Created by Admin on 11.08.23.
//  Copyright © 2023 Angela Yu. All rights reserved.
//

import XCTest
import Combine
@testable import Flash_Chat_iOS13

final class LoginViewModelTests: XCTestCase {

    var viewModel: LoginViewModel!
    var mockFireStore: MockFireStoreService!
    
    override func setUp() {
        super.setUp()
        mockFireStore = MockFireStoreService()
        viewModel = LoginViewModel(fireStoreService: mockFireStore)
    }
    
    override func tearDown() {
        super.tearDown()
        mockFireStore = nil
        viewModel = nil
    }
    
    
    func test_sendCredentials_Happy() {
        // Given
        let email = "oniq@abv.bg"
        let pass = "1234"
        mockFireStore.repoType = .success
        
        // When
        viewModel.sendCredentials(email, pass)
        
        // Then
        XCTAssertNil(viewModel.logInError.value)
        XCTAssertNil(mockFireStore.credentialsError)
        XCTAssertEqual(viewModel.logInResult.value, email)
        XCTAssertEqual(pass, mockFireStore.userPassword)
        XCTAssertEqual(email, mockFireStore.userEmail)
    }
    
    func test_sendCredentials_Sad() {
        // Given
        mockFireStore.repoType = .failure
        let email = "sad@email.bg"
        let pass = "1234"
        
        // When
        viewModel.sendCredentials(email, pass)
        
        // Then
        XCTAssertEqual(viewModel.logInError.value, mockFireStore.credentialsError)
        XCTAssertNil(viewModel.logInResult.value)
        XCTAssertNil(mockFireStore.userEmail)
        XCTAssertNil(mockFireStore.userPassword)
    }

}
