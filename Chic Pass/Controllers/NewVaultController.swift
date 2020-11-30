//
//  NewVaultController.swift
//  Chic Pass
//
//  Created by Applichic on 11/29/20.
//

import UIKit

class NewVaultController: UIViewController {
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addButton.isEnabled = false
        nameTextField.setLeftPaddingPoints(16)
        nameTextField.setRightPaddingPoints(16)
        passwordTextField.setLeftPaddingPoints(16)
        passwordTextField.setRightPaddingPoints(16)
        
        nameTextField.addTarget(self, action: #selector(onTextFieldsChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(onTextFieldsChange(_:)), for: .editingChanged)
    }

    @IBAction func onCancelClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func onTextFieldsChange(_ textField: UITextField) {
        if nameTextField.hasText && passwordTextField.hasText {
            addButton.isEnabled = true
        } else {
            addButton.isEnabled = false
        }
    }
}
