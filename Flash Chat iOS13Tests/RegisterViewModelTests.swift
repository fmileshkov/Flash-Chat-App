//
//  Flash_Chat_iOS13Tests.swift
//  Flash Chat iOS13Tests
//
//  Created by Admin on 11.08.23.
//  Copyright © 2023 Angela Yu. All rights reserved.
//

import XCTest
import Combine
@testable import Flash_Chat_iOS13

final class RegisterViewModelTests: XCTestCase {

    var viewModel: RegisterViewModel!
    var mockFireStore: MockFireStoreService!
    
    override func setUp() {
        super.setUp()
        mockFireStore = MockFireStoreService()
        viewModel = RegisterViewModel(fireStoreService: mockFireStore)
    }
    
    override func tearDown() {
        super.tearDown()
        mockFireStore = nil
        viewModel = nil
    }

    func test_sendCredentials_Happy() {
        // Given
        mockFireStore.repoType = .success
        let email = "happy@email.com"
        let pass = "pass"
        
        // When
        viewModel.sendCredentials(email, pass)
        
        // Then
        XCTAssertNil(viewModel.registrationError.value)
        XCTAssertNil(mockFireStore.credentialsError)
        XCTAssertEqual(viewModel.registrationResult.value, mockFireStore.userEmail)
        XCTAssertEqual(pass, mockFireStore.userPassword)
        XCTAssertEqual(email, mockFireStore.userEmail)
    }
    
    func test_sendCredentials_Sad() {
        // Given
        mockFireStore.repoType = .failure
        let email = "sad@email.com"
        let pass = "pass"
        
        // When
        viewModel.sendCredentials(email, pass)
        
        // Then
        XCTAssertEqual(viewModel.registrationError.value, mockFireStore.credentialsError)
        XCTAssertNil(viewModel.registrationResult.value)
        XCTAssertNil(mockFireStore.userPassword)
        XCTAssertNil(mockFireStore.userEmail)
    }
    
}
