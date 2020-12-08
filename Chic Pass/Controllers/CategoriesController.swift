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
    
    @IBAction func onBackClicked(_ sender: Any) {
        parent?.navigationController?.popViewController(animated: true)
        parent?.navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
