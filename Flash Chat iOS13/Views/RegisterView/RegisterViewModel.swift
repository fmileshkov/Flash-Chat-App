//
//  RegisterViewModel.swift
//  Flash Chat iOS13
//
//  Created by Admin on 9.08.23.
//  Copyright © 2023 Angela Yu. All rights reserved.
//

import Foundation
import Combine

protocol RegisterViewModelProtocol {
    
    /// A subject that holds the result value as an optional string and emits updates to its subscribers.
    var registrationResult: CurrentValueSubject<String?, Never> { get }
    
    /// A subject that holds the result value as an optional string of the error and emits updates to its subscribers.
    var registrationError: CurrentValueSubject<String?, Never> { get }
    
    /// This method is used to send registration credentials and initiate the registration process.
    /// - Parameters:
    ///   - email: The email of the user for registration.
    ///   - password: The password of the user for registration.
    func sendCredentials(_ email: String, _ password: String)
}

class RegisterViewModel: RegisterViewModelProtocol {
    
    //MARK: - Properties
    private let fireStoreService: FireStoreServiceProtocol
    var registrationResult: CurrentValueSubject<String?, Never> = CurrentValueSubject(nil)
    var registrationError: CurrentValueSubject<String?, Never> = CurrentValueSubject(nil)
    private weak var coordinator: RegisterCoordinatorProtocol?
    
    //MARK: - Initializer
    init(fireStoreService: FireStoreServiceProtocol, coordinator: RegisterCoordinatorProtocol?) {
        self.fireStoreService = fireStoreService
        self.coordinator = coordinator
    }
    
    //MARK: - RegisterViewModelProtocol
    func sendCredentials(_ email: String, _ password: String) {
        fireStoreService.registerNewUser(email, password) { [weak self] newUserID, error in
            guard error == nil else {
                self?.registrationError.send(Constants.credentialsError)
                return
            }
            
            self?.registrationResult.send(newUserID)
            self?.coordinator?.proceedToChatViewScreen()
        }
    }
    
}
