//
//  LoginViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Combine

class LoginViewController: BaseViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var emailTextfield: UITextField!
    @IBOutlet private weak var passwordTextfield: UITextField!
    @IBOutlet private weak var errorMessageLabel: UILabel!
    
    //MARK: - Properties
    var loginViewModel: LoginViewModelProtocol?
    private var cancellables: [AnyCancellable] = []
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        sendCredentials()
        setUpBinders()
    }
    
    //MARK: - IBActions
    @IBAction private func logInButtonPressed(_ sender: UIButton) {
        sendCredentials()
    }
    
    func sendCredentials() {
        guard let email = emailTextfield.text,
              let password = passwordTextfield.text else { return }
        
        loginViewModel?.sendCredentials(email, password)
    }
    
    //MARK: - Private methods
    private func setUpBinders() {
        loginViewModel?.logInResult
            .dropFirst()
            .sink { [weak self] userEmail in
                guard let self,
                      userEmail != nil else {
                    self?.errorMessageLabel.text = Constants.credentialsError
                    self?.errorMessageLabel.isHidden = false
                    return
                }
                
                self.errorMessageLabel.isHidden = true
//                self.loginViewModel?.coordinator?.proceedToChatViewScreen()
            }.store(in: &cancellables)
        
        loginViewModel?.logInError
            .sink { [weak self] error in
                guard let self,
                      error != nil else {
                    return }
                
                self.errorMessageLabel.text = error
                self.errorMessageLabel.isHidden = false
            }.store(in: &cancellables)
    }
    
}

