//
//  ChatViewModelTests.swift
//  Flash Chat iOS13Tests
//
//  Created by Admin on 11.08.23.
//  Copyright © 2023 Angela Yu. All rights reserved.
//

import XCTest
import Combine
@testable import Flash_Chat_iOS13

final class ChatViewModelTests: XCTestCase {

    var viewModel: ChatViewModelProtocol!
    var mockFireStore: MockFireStoreService!
    
        override func setUp() {
            super.setUp()
            mockFireStore = MockFireStoreService()
            viewModel = ChatViewModel(fireStoreService: mockFireStore)
        }

        override func tearDown() {
            super.tearDown()
            mockFireStore = nil
            viewModel = nil
        }
    
    func test_senderCell_Sad() {
        // Given
        mockFireStore.repoType = .failure
        
        // When
        let data = viewModel.senderMessageAndCellDetails(0)
        
        // Then
        XCTAssertEqual(data?.senderTextMessage, mockFireStore.messageBody)
        XCTAssertFalse(mockFireStore.isCurrentSender ?? true)
    }
    
    func test_senderCell_Happy() {
        // Given
        mockFireStore.repoType = .success
        
        // When
        let data = viewModel.senderMessageAndCellDetails(0)
        
        // Then
        XCTAssertEqual(data?.senderTextMessage, mockFireStore.messageBody)
        XCTAssertTrue(mockFireStore.isCurrentSender ?? false)
    }
    
    func test_getCurrentMessagesCount() {
        // Given
        mockFireStore.messages = [Message(sender: "Happy sender", body: "Body")]
        
        // When
        let currentMessageCount = viewModel.getCurrentMessagesCount()
        
        // Then
        XCTAssertEqual(currentMessageCount, viewModel.messages.value?.count)
    }
    
    func test_logOutUser_Happy() {
        // Given
        mockFireStore.repoType = .success
        
        // When
        viewModel.logOutUser()
        
        // Then
        XCTAssertTrue(viewModel.logOutConfirmation.value)
    }
    
    func test_logOutUser_Sad() {
        // Given
        mockFireStore.repoType = .failure
        
        // When
        viewModel.logOutUser()
        
        // Then
        XCTAssertFalse(viewModel.logOutConfirmation.value)
    }
    
    func test_Init_Happy() {
        // Given
        mockFireStore.repoType = .success
        
        // When
        viewModel = ChatViewModel(fireStoreService: mockFireStore)
        
        // Then
        XCTAssertTrue(viewModel.isMessageSent.value)
        XCTAssertEqual(viewModel.messages.value, mockFireStore.messages)
    }
    
    func test_Init_Sad() {
        // Given
        mockFireStore.repoType = .failure
        
        // When
        viewModel = ChatViewModel(fireStoreService: mockFireStore)
        
        // Then
        XCTAssertFalse(viewModel.isMessageSent.value)
        XCTAssertEqual(viewModel.messages.value, mockFireStore.messages)
    }
    
    
    func test_sendMessage_Happy() {
        // Given
        let messageBody = "HappyBody"
        
        // When
        viewModel.sendNewMessage(messageBody: messageBody)
        
        // Then
        XCTAssertTrue(viewModel.isMessageSent.value)
        XCTAssertEqual(mockFireStore.messageBody, messageBody)
    }
    
    func test_sendMessage_Sad() {
        // Given
        let messageBody = "SadBody"
        mockFireStore.repoType = .failure
        
        // When
        viewModel.sendNewMessage(messageBody: messageBody)
        
        // Then
        XCTAssertFalse(viewModel.isMessageSent.value)
        XCTAssertNil(mockFireStore.messageBody)
    }

}
