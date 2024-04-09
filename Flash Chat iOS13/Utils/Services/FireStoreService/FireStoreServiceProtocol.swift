//
//  FireStoreServiceProtocol.swift
//  Flash Chat iOS13
//
//  Created by Admin on 15.08.23.
//  Copyright © 2023 Angela Yu. All rights reserved.
//

import Foundation

//MARK: - FireStoreServiceProtocol
protocol FireStoreServiceProtocol {

    /// This method is used to load messages from Firestore collection.
    /// - Parameter completion: A closure that takes a boolean value indicating if the loading was successful and an array of Message objects.
    func loadMessages(_ completion: @escaping (Bool, [Message]) -> Void)
    
    /// This method is used to log out the current user.
    /// - Parameter completion: A closure that takes a boolean value indicating if the logout was successful.
    func logOutUser(_ completion: (Bool) -> Void)
    
    /// This method is used to send a new message to the Firestore collection.
    /// - Parameters:
    ///   - messageBody: The body text of the message to be sent.
    ///   - completion: A closure that takes a boolean value indicating if the sending was successful.
    func sendNewMessage(messageBody: String, _ completion: @escaping (Bool) -> Void)
    
    /// This method retrieves the email of the current user.
    /// - Parameter completion: A closure that takes a string representing the email of the current user.
    func getCurrentUser() -> String?
    
    /// This method is used to sign in a user with the provided email and password.
    /// - Parameters:
    ///   - email: The email of the user to sign in.
    ///   - password: The password of the user to sign in.
    ///   - completion: A closure that takes an optional string representing the email of the signed-in user, or nil if the sign-in was unsuccessful.
    func signIn(_ email: String, _ password: String, _ completion: @escaping (String?, Error?) -> Void)
    
    /// This method is used to register a new user with the provided email and password.
    /// - Parameters:
    ///   - email: The email of the user to register.
    ///   - password: The password of the user to register.
    ///   - completion: A closure that takes an optional string representing the UID of the registered user, or nil if the registration was unsuccessful.
    func registerNewUser(_ email: String, _ password: String, _ completion: @escaping (String?, Error?) -> Void)
    
    /// This method fetches the message data at the specified index.
    /// - Parameter atIndex: The index of the message in the messages array.
    /// - Returns: A tuple containing a boolean value indicating if the current user is the sender of the message and the message text, or `nil` if the index is out of range or the current user is not available.
    func getMessageDetails(_ atIndex: Int) -> (sender: Bool, messageText: String)?
}
