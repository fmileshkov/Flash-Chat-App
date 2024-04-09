//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var titleLabel: UILabel!
    
    //MARK: - Properties
    let viewModel: WelcomeViewModel = WelcomeViewModel()
    
    //MARK: - IBActions
    @IBAction private func registerButtonTapped(_ sender: UIButton) {
        viewModel.coordinator?.goToRegisterScreen()
    }
    
    @IBAction private func logInButtonTapped(_ sender: UIButton) {
        viewModel.coordinator?.goToLoginScreen()
    }
    
}
