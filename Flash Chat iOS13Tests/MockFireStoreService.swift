//
//  MockFireStoreService.swift
//  Flash Chat iOS13Tests
//
//  Created by Admin on 11.08.23.
//  Copyright © 2023 Angela Yu. All rights reserved.
//

import Foundation
import Combine
import FirebaseAuth
import FirebaseFirestore
@testable import Flash_Chat_iOS13

enum MockFireStoreServiceType {
    case failure
    case success
}

enum MockMyError: Error {
    case runtimeError(String)
}

class MockFireStoreService: FireStoreServiceProtocol {

    var messages: [Message] = []
    var messageBody: String?
    var currentUser: String?
    var userEmail: String?
    var userPassword: String?
    var cellIndex: Int?
    var isCurrentSender: Bool?
    var credentialsError: String?
    var repoType: MockFireStoreServiceType
    
    init(repoType: MockFireStoreServiceType = .success) {
        self.repoType = repoType
    }
    
    func getMessageDetails(_ atIndex: Int) -> (sender: Bool, messageText: String)? {
        switch repoType {
        case .failure:
            messageBody = "failure message"
            isCurrentSender = false
            return (isCurrentSender ?? false, messageBody ?? "")
        case .success:
            messageBody = "success message"
            isCurrentSender = true
            return (isCurrentSender ?? true, messageBody ?? "")
        }
    }
    
    func loadMessages(_ completion: @escaping (Bool, [Flash_Chat_iOS13.Message]) -> Void) {
        switch repoType {
        case .failure:
            completion(false, messages)
        case .success:
            messages = [Message(sender: "Message send", body: "Message body is okay")]
            completion(true, messages)
        }
    }
    
    func logOutUser(_ completion: (Bool) -> Void) {
        switch repoType {
        case .success:
            completion(true)
        case .failure:
            completion(false)
        }
    }
    
    func sendNewMessage(messageBody: String, _ completion: @escaping (Bool) -> Void) {
        switch repoType {
        case .failure:
            completion(false)
        case .success:
            self.messageBody = messageBody
            completion(true)
        }
    }
    
    func getCurrentUser() -> String? {
        switch repoType {
        case .success:
            currentUser = "Oniq"
            return currentUser
        case .failure:
            currentUser = nil
            return nil
        }
    }

    
    func signIn(_ email: String, _ password: String, _ completion: @escaping (String?, Error?) -> Void) {
        switch repoType {
        case .failure:
            userEmail = nil
            self.userPassword = nil
            credentialsError = "We ve got an credentials error"
            completion(nil, MockMyError.runtimeError(credentialsError ?? ""))
        case .success:
            userEmail = email
            self.userPassword = password
            completion(email, nil)
        }
    }
    
    func registerNewUser(_ email: String, _ password: String, _ completion: @escaping (String?, Error?) -> Void) {
        switch repoType {
        case .failure:
            userEmail = nil
            userPassword = nil
            credentialsError = "We ve got an credentials error"
            completion(nil, MockMyError.runtimeError(credentialsError ?? ""))
        case .success:
            userEmail = email
            userPassword = password
            completion(email, nil)
        }
    }

}
