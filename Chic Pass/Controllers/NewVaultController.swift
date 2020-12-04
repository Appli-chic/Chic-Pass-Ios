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
    
    @IBOutlet weak var weakView: UIView!
    @IBOutlet weak var mediumView: UIView!
    @IBOutlet weak var goodView: UIView!
    @IBOutlet weak var veryGoodView: UIView!
    
    private var isPasswordHidden = true
    private var passwordIcon = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        addButton.isEnabled = false
        nameTextField.setLeftPaddingPoints(16)
        nameTextField.setRightPaddingPoints(16)
        passwordTextField.setLeftPaddingPoints(16)
        passwordTextField.setRightPaddingPoints(16)
        
        nameTextField.addTarget(self, action: #selector(onTextFieldsChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(onTextFieldsChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(onPasswordStrengthChange(_:)), for: .editingChanged)
        
        // Add the password an eye icon
        let passwordIconView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        passwordIcon = UIImageView(frame:CGRect(x: 50, y: 13, width: 24, height: 24))
        passwordIcon.image = UIImage(systemName: "eye.fill")
        passwordIcon.contentMode = .scaleAspectFit
        passwordIcon.tintColor = UIColor.label
        passwordIconView.addSubview(passwordIcon)
        
        let passwordIconTap = UITapGestureRecognizer(target: self, action: #selector(self.onPasswordIconTapped(_:)))
        passwordIconView.addGestureRecognizer(passwordIconTap)
        
        passwordTextField.rightView = passwordIconView
        passwordTextField.rightViewMode = .always
    }

    @IBAction func onCancelClicked(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func onPasswordIconTapped(_ sender: UITapGestureRecognizer? = nil) {
        isPasswordHidden = !isPasswordHidden
        
        if isPasswordHidden {
            passwordTextField.isSecureTextEntry = true
            passwordIcon.image = UIImage(systemName: "eye.fill")
        } else {
            passwordTextField.isSecureTextEntry = false
            passwordIcon.image = UIImage(systemName: "eye.slash.fill")
        }
    }
    
    @objc func onTextFieldsChange(_ textField: UITextField) {
        if nameTextField.hasText && passwordTextField.hasText {
            addButton.isEnabled = true
        } else {
            addButton.isEnabled = false
        }
    }
    
    @objc func onPasswordStrengthChange(_ textField: UITextField) {
        if textField.text == nil || textField.text!.isEmpty {
            weakView.backgroundColor = UIColor.secondarySystemBackground
            mediumView.backgroundColor = UIColor.secondarySystemBackground
            goodView.backgroundColor = UIColor.secondarySystemBackground
            veryGoodView.backgroundColor = UIColor.secondarySystemBackground
        } else if textField.text!.count <= 6 {
            weakView.backgroundColor = UIColor.red
            mediumView.backgroundColor = UIColor.secondarySystemBackground
            goodView.backgroundColor = UIColor.secondarySystemBackground
            veryGoodView.backgroundColor = UIColor.secondarySystemBackground
        } else if textField.text!.count <= 12 {
            weakView.backgroundColor = UIColor.orange
            mediumView.backgroundColor = UIColor.orange
            goodView.backgroundColor = UIColor.secondarySystemBackground
            veryGoodView.backgroundColor = UIColor.secondarySystemBackground
        }  else if textField.text!.count <= 16 {
            weakView.backgroundColor = UIColor.green
            mediumView.backgroundColor = UIColor.green
            goodView.backgroundColor = UIColor.green
            veryGoodView.backgroundColor = UIColor.secondarySystemBackground
        } else {
            weakView.backgroundColor = UIColor.green
            mediumView.backgroundColor = UIColor.green
            goodView.backgroundColor = UIColor.green
            veryGoodView.backgroundColor = UIColor.green
        }
    }
}
