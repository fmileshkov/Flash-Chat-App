//
//  LoginViewModel.swift
//  Flash Chat iOS13
//
//  Created by Admin on 9.08.23.
//  Copyright © 2023 Angela Yu. All rights reserved.
//

import Foundation
import Combine

protocol LoginViewModelProtocol: AnyObject {
    
    /// A subject that holds the result value as an optional string and emits updates to its subscribers.
    var logInResult: CurrentValueSubject<String?, Never> { get }
    
    /// A subject that holds the result value as an optional string of the error and emits updates to its subscribers.
    var logInError: CurrentValueSubject<String?, Never> { get }
    
    /// This method is used to send login credentials and initiate the login process.
    /// - Parameters:
    ///   - email: The email of the user for login.
    ///   - password: The password of the user for login.
    func sendCredentials(_ email: String, _ password: String)
}

class LoginViewModel: LoginViewModelProtocol {
    
    //MARK: - Properties
    private let fireStoreService: FireStoreServiceProtocol
    var logInResult: CurrentValueSubject<String?, Never> = CurrentValueSubject(nil)
    var logInError: CurrentValueSubject<String?, Never> = CurrentValueSubject(nil)
    private weak var coordinator: LoginCoordinator?
    
    //MARK: - Initializer
    init(fireStoreService: FireStoreServiceProtocol, coordinator: LoginCoordinator?) {
        self.fireStoreService = fireStoreService
        self.coordinator = coordinator
    }
    
    //MARK: - LoginViewModelProtocol
    func sendCredentials(_ email: String, _ password: String) {
        fireStoreService.signIn(email, password) {  [weak self] userEmail, error in
            guard error == nil else {
                self?.logInError.send(Constants.credentialsError)
                return
            }
            
            self?.logInResult.send(userEmail)
            self?.coordinator?.proceedToChatViewScreen()
        }
    }
    
}
