//
//  BaseViewController.swift
//  Flash Chat iOS13
//
//  Created by Admin on 19.09.23.
//  Copyright © 2023 Angela Yu. All rights reserved.
//

import UIKit

protocol BaseViewControllerDelegate: AnyObject {
    
    /// Notifying that a viewcontroller is unloaded
    func viewControllerIsUnloaded()
}

class BaseViewController: UIViewController {
    
    //MARK: - Properties
    weak var deleagte: BaseViewControllerDelegate?
    
    //MARK: - LifeCycle methods
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        deleagte?.viewControllerIsUnloaded()
    }

}
