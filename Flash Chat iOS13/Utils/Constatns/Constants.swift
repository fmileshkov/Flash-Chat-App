//
//  Constants.swift
//  Flash Chat iOS13
//
//  Created by Admin on 3.06.23.
//  Copyright © 2023 Angela Yu. All rights reserved.
//

//MARK: - Constants
struct Constants {
    static let writeMessagePlaceholder = "Write a message..."
    static let messageNotSendPlaceholder = "Message not send"
    static let blankString = ""
    static let cellIdentifier = "ReusableCell"
    static let cellNibName = "MessageCell"
    static let registerSegue = "RegisterToChat"
    static let loginSegue = "LoginToChat"
    static let flashChatLogoName = "⚡️FlashChat"
    static let logOutBarButton = "Log Out"
    static let credentialsError = "We ve got an credentials error"
    
    struct BrandColors {
        static let purple = "BrandPurple"
        static let lightPurple = "BrandLightPurple"
        static let blue = "BrandBlue"
        static let lighBlue = "BrandLightBlue"
    }
    
    struct FStore {
        static let collectionName = "messages"
        static let senderField = "sender"
        static let bodyField = "body"
        static let dateField = "date"
    }
    
}
