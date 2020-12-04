//
//  MainTabBarController.swift
//  Chic Pass
//
//  Created by Applichic on 12/4/20.
//

import UIKit

class MainTabBarController: UITabBarController {
    @IBOutlet weak var addItem: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if item.tag == 0 || item.tag == 1 {
            addItem.isEnabled = true
            addItem?.tintColor = UIColor.red
        } else {
            addItem.isEnabled = false
            addItem?.tintColor = UIColor.clear
        }
    }
}
