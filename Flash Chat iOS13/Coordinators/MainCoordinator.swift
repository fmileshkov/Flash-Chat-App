//
//  MainCoordinator.swift
//  Flash Chat iOS13
//
//  Created by Admin on 18.09.23.
//  Copyright © 2023 Angela Yu. All rights reserved.
//

import UIKit

protocol MainCoordinatorProtocol: AnyObject {
    
    /// This method is responsible for transitioning to the login screen within the app.
    func goToLoginScreen()
    
    /// This method is responsible for navigating to the register screen within the app.
    func goToRegisterScreen()
}

class MainCoordinator: Coordinator, MainCoordinatorProtocol {
    
    //MARK: - Properties
    private var rootViewController: UINavigationController
    
    //MARK: - Initializer
    init(rootViewController: UINavigationController) {
        self.rootViewController = rootViewController
    }
    
    //MARK: - Methods
    override func start() {
        guard let vc = WelcomeViewController.initFromStoryBoard() else { return }
        
        vc.viewModel.coordinator = self
        rootViewController.pushViewController(vc, animated: true)
    }
    
    //MARK: - MainCoordinator Protocol Methods
    func goToLoginScreen() {
        let child = LoginCoordinator(navigationController: rootViewController)
        
        addChildCoordinator(child)
        child.start()
    }
    
    func goToRegisterScreen() {
        let child = RegisterCoordinator(navigationController: rootViewController)
        
        addChildCoordinator(child)
        child.start()
    }
    
}
