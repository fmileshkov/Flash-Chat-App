//
//  LoginCoordinator.swift
//  Flash Chat iOS13
//
//  Created by Admin on 18.09.23.
//  Copyright © 2023 Angela Yu. All rights reserved.
//

import UIKit

protocol LoginCoordinatorProtocol: AnyObject {
    
    /// This method is responsible for transitioning to the chat view screen within the app.
    func proceedToChatViewScreen()
}

class LoginCoordinator: Coordinator, BaseViewControllerDelegate, LoginCoordinatorProtocol {
    
    //MARK: - Properties
    var navigationController: UINavigationController
    
    //MARK: - Initializer
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    //MARK: - Methods
    override func start() {
        guard let vc = LoginViewController.initFromStoryBoard() else { return }
        
        vc.deleagte = self
        vc.loginViewModel = LoginViewModel(fireStoreService: FireStoreService.shared, coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    //MARK: - LoginCoordinator Protocol
    func proceedToChatViewScreen() {
        let child = ChatViewCoordinator(navigationController: navigationController)
        
        addChildCoordinator(child)
        child.start()
    }
    
    //MARK: - BaseViewController Delegate Method
    func viewControllerIsUnloaded() {
        finish()
    }
    
}
