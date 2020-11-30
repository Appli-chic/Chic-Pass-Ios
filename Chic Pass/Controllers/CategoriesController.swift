//
//  CategoriesController.swift
//  Chic Pass
//
//  Created by Applichic on 11/30/20.
//

import UIKit

class CategoriesController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let tabController = self.parent as? UITabBarController {
            tabController.navigationItem.title = "Categories"
        }
    }
}
