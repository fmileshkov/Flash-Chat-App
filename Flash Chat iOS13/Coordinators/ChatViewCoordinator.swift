//
//  ChatViewCoordinator.swift
//  Flash Chat iOS13
//
//  Created by Admin on 18.09.23.
//  Copyright © 2023 Angela Yu. All rights reserved.
//

import UIKit

class ChatViewCoordinator: Coordinator, BaseViewControllerDelegate {
    
    //MARK: - Properties
    var navigationController: UINavigationController
    
    //MARK: - Initializer
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    override func start() {
        guard let vc = ChatViewController.initFromStoryBoard() else { return }
        
        vc.deleagte = self
        vc.chatViewModel = ChatViewModel(fireStoreService: FireStoreService.shared, coordinator: self)
        navigationController.pushViewController(vc, animated: true)
    }
    
    func viewControllerIsUnloaded() {
        finish()
    }
    
}
