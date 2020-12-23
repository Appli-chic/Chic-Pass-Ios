//
//  CheckPasswordController.swift
//  Chic Pass
//
//  Created by Applichic on 12/23/20.
//

import UIKit
import os
import JGProgressHUD

class CheckPasswordController: UITableViewController {
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var checkButton: UIBarButtonItem!
    
    private var isPasswordHidden = true
    private var passwordIcon = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Keyboard dismissible with a click
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        // Add the password an eye icon
        let passwordIconView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        passwordIcon = UIImageView(frame:CGRect(x: 50, y: 13, width: 24, height: 24))
        passwordIcon.image = UIImage(systemName: "eye.fill")
        passwordIcon.contentMode = .scaleAspectFit
        passwordIcon.tintColor = UIColor.systemBlue
        passwordIconView.addSubview(passwordIcon)
        
        let passwordIconTap = UITapGestureRecognizer(target: self, action: #selector(self.onPasswordIconTapped(_:)))
        passwordIconView.addGestureRecognizer(passwordIconTap)
        
        passwordTextField.rightView = passwordIconView
        passwordTextField.rightViewMode = .always
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func onCheck(_ sender: Any) {
        checkButton.isEnabled = false
        
        // Check if the password is not empty
        if passwordTextField.text!.isEmpty {
            checkButton.isEnabled = true
            let alert = UIAlertController(title: "Error", message: "The password must not be empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
            present(alert, animated: true, completion: nil)
            
            return
        }
        
        // Load while checking the password
        let loadingAlert = JGProgressHUD()
        loadingAlert.textLabel.text = "Loading"
        loadingAlert.hudView.backgroundColor = UIColor.secondarySystemBackground
        loadingAlert.show(in: view)
        
        // Check the password
        let password = passwordTextField.text
        
        DispatchQueue.global().async {
            do {
                let signature = try Security.decryptData(key: password!, data: SelectedVault.data.vault.signature!, reloadAes: false)
                
                if signature == Security.signature {
                    DispatchQueue.main.async {
                        let preferences = UserDefaults.standard

                        if preferences.object(forKey: biometryVaultValueKey) == nil {
                            // Create first value
                            var data = [String : String]()
                            data[SelectedVault.data.vault.id!.uuidString] = password
                            preferences.setValue(data, forKey: biometryVaultValueKey)
                            preferences.synchronize()
                        } else {
                            // Update value
                            var data = preferences.dictionary(forKey: biometryVaultValueKey)!
                            data[SelectedVault.data.vault.id!.uuidString] = password
                            preferences.setValue(data, forKey: biometryVaultValueKey)
                            preferences.synchronize()
                        }

                        loadingAlert.dismiss()
                        NotificationCenter.default.post(name: .checkPasswordForBiometry, object: nil)
                        self.dismiss(animated: false)
                        return
                    }
                }
                
                // Password isn't the right one
                DispatchQueue.main.async {
                    self.showAlertPasswordDontMatch(loadingAlert: loadingAlert)
                }
            } catch {
                DispatchQueue.main.async {
                    let nsError = error as NSError
                    let defaultLog = Logger()
                    defaultLog.error("Error unlocking vault: \(nsError)")
                    
                    self.showAlertPasswordDontMatch(loadingAlert: loadingAlert)
                }
            }
        }
    }
    
    private func showAlertPasswordDontMatch(loadingAlert: JGProgressHUD) {
        loadingAlert.dismiss()
        checkButton.isEnabled = true
        
        let alert = UIAlertController(title: "Error", message: "The password doesn't match", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
        present(alert, animated: true, completion: nil)
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
}
