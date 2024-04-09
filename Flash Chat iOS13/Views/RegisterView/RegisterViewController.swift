//
//  RegisterViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import Combine

class RegisterViewController: BaseViewController {
    
    // MARK: - IBOutlets
    @IBOutlet private weak var emailTextfield: UITextField!
    @IBOutlet private weak var passwordTextfield: UITextField!
    @IBOutlet private weak var errorMessageLabel: UILabel!
    
    //MARK: - Properties
    var registerViewModel: RegisterViewModelProtocol?
    private var cancellables: [AnyCancellable] = []
    
    //MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpBinders()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    //MARK: - IBActions
    @IBAction private func registerButtonPressed(_ sender: UIButton) {
        guard let email = emailTextfield.text,
              let password = passwordTextfield.text else { return }
        
        registerViewModel?.sendCredentials(email, password)
    }
    
    //MARK: - Private Methods
    private func setUpBinders() {
        registerViewModel?.registrationResult
            .dropFirst()
            .sink { [weak self] userId in
                guard let self,
                      userId != nil else {
                    self?.errorMessageLabel.text = Constants.credentialsError
                    self?.errorMessageLabel.isHidden = false
                    return
                }
                
                self.errorMessageLabel.isHidden = true
            }.store(in: &cancellables)
        
        registerViewModel?.registrationError
            .sink { [weak self] error in
                guard let self,
                      error != nil else {
                    return }
                
                self.errorMessageLabel.text = error
                self.errorMessageLabel.isHidden = false
            }.store(in: &cancellables)
    }
    
}
