//
//  NewVaultController.swift
//  Chic Pass
//
//  Created by Applichic on 11/29/20.
//

import UIKit
import os
import JGProgressHUD

class NewVaultController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    
    @IBOutlet weak var weakView: UIView!
    @IBOutlet weak var mediumView: UIView!
    @IBOutlet weak var goodView: UIView!
    @IBOutlet weak var veryGoodView: UIView!
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var isPasswordHidden = true
    private var passwordIcon = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Keyboard dismissable with a click
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        // Init the components
        addButton.isEnabled = false
        nameTextField.setLeftPaddingPoints(16)
        nameTextField.setRightPaddingPoints(16)
        nameTextField.delegate = self
        passwordTextField.setLeftPaddingPoints(16)
        passwordTextField.setRightPaddingPoints(16)
        passwordTextField.delegate = self
        repeatPasswordTextField.setLeftPaddingPoints(16)
        repeatPasswordTextField.setRightPaddingPoints(16)
        repeatPasswordTextField.delegate = self
        
        nameTextField.addTarget(self, action: #selector(onTextFieldsChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(onTextFieldsChange(_:)), for: .editingChanged)
        repeatPasswordTextField.addTarget(self, action: #selector(onTextFieldsChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(onPasswordStrengthChange(_:)), for: .editingChanged)
        
        passwordTextField.textContentType = .oneTimeCode
        repeatPasswordTextField.textContentType = .oneTimeCode
        
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
    
    @IBAction func onAddClicked(_ sender: Any) {
        addButton.isEnabled = false
        var errorMessage = ""
        
        if passwordTextField.text!.count < 6 {
            errorMessage = "The password must be at least 6 characters"
        }
        
        if passwordTextField.text != repeatPasswordTextField.text {
            errorMessage = "The passwords must be identical"
        }
        
        if errorMessage.isEmpty {
            addVault()
        } else {
            addButton.isEnabled = true
            let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
            present(alert, animated: true, completion: nil)
        }
    }
    
    func addVault() {
        // Hide Keyboard
        UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)

        // Showing a loading alert
        let loadingAlert = JGProgressHUD()
        loadingAlert.textLabel.text = "Loading"
        loadingAlert.hudView.backgroundColor = UIColor.secondarySystemBackground
        loadingAlert.show(in: self.view)
        
        // Prepare to add the vault to the local database
        let context = appDelegate.persistentContainer.viewContext
        let vaultName = nameTextField.text
        let password = passwordTextField.text
        
        DispatchQueue.global().async {
            do {
                let signature = try Security.encryptData(key: password!, data: Security.signature)

                let vault = Vault(context: context)
                let uuid = UUID()
                vault.id = uuid
                vault.name = vaultName
                vault.signature = signature
                vault.createdAt = Date()
                vault.updatedAt = Date()

                try context.save()
                
                DispatchQueue.main.async {
                    SelectedVault.data.vault = vault
                    SelectedVault.data.password = password!
                    loadingAlert.dismiss()
                    NotificationCenter.default.post(name: .newVaultDismissed, object: nil)
                    self.dismiss(animated: false)
                }
            } catch {
                DispatchQueue.main.async {
                    let nsError = error as NSError
                    let defaultLog = Logger()
                    defaultLog.error("Error creating a vault: \(nsError)")
                    
                    loadingAlert.dismiss()
                    self.addButton.isEnabled = true
                }
            }
        }
    }

    @IBAction func onCancelClicked(_ sender: Any) {
        dismiss(animated: true)
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
        if nameTextField.hasText && passwordTextField.hasText && repeatPasswordTextField.hasText {
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
        } else if textField.text!.count < 6 {
            weakView.backgroundColor = UIColor.red
            mediumView.backgroundColor = UIColor.secondarySystemBackground
            goodView.backgroundColor = UIColor.secondarySystemBackground
            veryGoodView.backgroundColor = UIColor.secondarySystemBackground
        } else if textField.text!.count < 10 {
            weakView.backgroundColor = UIColor.orange
            mediumView.backgroundColor = UIColor.orange
            goodView.backgroundColor = UIColor.secondarySystemBackground
            veryGoodView.backgroundColor = UIColor.secondarySystemBackground
        }  else if textField.text!.count < 13 {
            weakView.backgroundColor = UIColor.yellow
            mediumView.backgroundColor = UIColor.yellow
            goodView.backgroundColor = UIColor.yellow
            veryGoodView.backgroundColor = UIColor.secondarySystemBackground
        } else {
            weakView.backgroundColor = UIColor.green
            mediumView.backgroundColor = UIColor.green
            goodView.backgroundColor = UIColor.green
            veryGoodView.backgroundColor = UIColor.green
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let nextTag = textField.tag + 1

        if let nextResponder = textField.superview?.viewWithTag(nextTag) {
            nextResponder.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }

        return true
    }
}
