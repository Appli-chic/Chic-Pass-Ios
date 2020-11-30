//
//  PasswordsController.swift
//  Chic Pass
//
//  Created by Applichic on 11/30/20.
//

import UIKit

class PasswordsController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let tabController = self.parent as? UITabBarController {
            tabController.navigationItem.title = "Passwords"
        }
    }
}
