//
//  ChatViewModel.swift
//  Flash Chat iOS13
//
//  Created by Admin on 11.08.23.
//  Copyright © 2023 Angela Yu. All rights reserved.
//

import Foundation
import Combine

protocol ChatViewModelProtocol {
    /// Logs out the current user.
    func logOutUser()
    
    /// Sends a new message to the Firestore collection.
    /// - Parameter messageBody: The body text of the message to be sent.
    func sendNewMessage(messageBody: String)

    /// A subject that emits a Boolean value indicating if a message has been successfully sent.
    var isMessageSent: CurrentValueSubject<Bool, Never> { get }
    
    /// A subject that emits an optional `Error` object representing any errors that occur.
    var error: CurrentValueSubject<Error?, Never> { get }
    
    /// A subject that emits an optional array of `Message` objects representing the loaded messages.
    var messages: CurrentValueSubject<[Message]?, Never> { get }
    
    /// A subject that emits a Boolean value indicating if the user has confirmed the logout action.
    var logOutConfirmation: CurrentValueSubject<Bool, Never> { get }
    
    /// Returns the sender text message and message cell model at the specified index.
    /// - Parameter atIndex: The index of the message in the messages array.
    /// - Returns: A tuple containing the sender text message and message cell model, or `nil` if the index is out of range or the data is unavailable.
    func senderMessageAndCellDetails(_ atIndex: Int) -> (senderTextMessage: String, messageCellModel: MessageCellModel)?
    
    /// Returns the current count of messages.
    /// - Returns: The count of messages, or `nil` if the messages array is unavailable.
    func getCurrentMessagesCount() -> Int?
}

class ChatViewModel: ChatViewModelProtocol {
    
    //MARK: - Properties
    private let fireStoreService: FireStoreServiceProtocol
    var logOutConfirmation: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)
    var messages: CurrentValueSubject<[Message]?, Never> = CurrentValueSubject(nil)
    var error: CurrentValueSubject<Error?, Never> = CurrentValueSubject(nil)
    var isMessageSent: CurrentValueSubject<Bool, Never> = CurrentValueSubject(false)
    private weak var coordinator: ChatViewCoordinator?
    
    //MARK: - Initializer
    init(fireStoreService: FireStoreServiceProtocol, coordinator: ChatViewCoordinator?) {
        self.fireStoreService = fireStoreService
        self.coordinator = coordinator
        loadMessages()
    }
    
    //MARK: - ChatViewModelProtocol
    func getCurrentMessagesCount() -> Int? {
        guard let messegesCount = messages.value?.count else { return nil}
        
        return messegesCount
    }

    func senderMessageAndCellDetails(_ atIndex: Int) -> (senderTextMessage: String, messageCellModel: MessageCellModel)? {
        guard let messageModelData = fireStoreService.getMessageDetails(atIndex) else { return nil }
        
        let messageCellData = prepareMessageCell(messageModelData.sender)
        let messageText = messageModelData.messageText
        return (messageText, messageCellData)
    }
    
    func sendNewMessage(messageBody: String) {
        fireStoreService.sendNewMessage(messageBody: messageBody) { [weak self] isMessageSend in
            self?.isMessageSent.send(isMessageSend)
        }
    }
    
    private func loadMessages() {
        fireStoreService.loadMessages { [weak self] isMessegeSend, messagesArray in
            self?.isMessageSent.send(isMessegeSend)
            self?.messages.send(messagesArray)
        }
    }
    
    func logOutUser() {
        fireStoreService.logOutUser { [weak self] isUserLoggedOut in
            self?.logOutConfirmation.send(isUserLoggedOut)
        }
    }
    
    //MARK: - Private Methods
    private func prepareMessageCell( _ isMessageFromSender: Bool) -> MessageCellModel {
        var cell: MessageCellModel
        isMessageFromSender
        ? (cell = MessageCellModel(messageBubbleBgColor: Constants.BrandColors.lightPurple,
                                    messageLableTextColor: Constants.BrandColors.purple,
                                    rightAvatarImageHide: false,
                                    avatarImageViewHide: true))
        : (cell = MessageCellModel(messageBubbleBgColor: Constants.BrandColors.lighBlue,
                                    messageLableTextColor: Constants.BrandColors.blue,
                                    rightAvatarImageHide: true,
                                    avatarImageViewHide: false))
        return cell
    }
    
}
