//
//  MetricsController.swift
//  Chic Pass
//
//  Created by Applichic on 11/30/20.
//

import UIKit

class MetricsController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let tabController = self.parent as? UITabBarController {
            tabController.navigationItem.title = "Metrics"
        }
    }
}
