//
//  Storyboard.swift
//  Flash Chat iOS13
//
//  Created by Admin on 1.06.23.
//  Copyright © 2023 Angela Yu. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    
    /// instanciateFromStoryBoard
    /// - Parameter name: Name of the storyboard
    /// - Returns: Storyboard
    static func initFromStoryBoard(_ storyBoardName: String = "Main") -> Self? {
        let storyboard = UIStoryboard(name: storyBoardName, bundle: nil)
        let controller =
        storyboard.instantiateViewController(withIdentifier: String(describing: self))
        return controller as? Self
    }

}
