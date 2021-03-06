//
//  UnlockVaultController.swift
//  Chic Pass
//
//  Created by Applichic on 12/6/20.
//

import UIKit
import JGProgressHUD
import os
import LocalAuthentication

class UnlockVaultController: UIViewController {
    @IBOutlet weak var unlockButton: UIBarButtonItem!
    @IBOutlet weak var passwordTextField: UITextField!

    private var isPasswordHidden = true
    private var passwordIcon = UIImageView()

    var vault: Vault? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Keyboard dismissable with a click
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)

        unlockButton.isEnabled = true
        passwordTextField.setLeftPaddingPoints(16)
        passwordTextField.setRightPaddingPoints(16)

        // Add the password an eye icon
        let passwordIconView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        passwordIcon = UIImageView(frame: CGRect(x: 50, y: 13, width: 24, height: 24))
        passwordIcon.image = UIImage(systemName: "eye.fill")
        passwordIcon.contentMode = .scaleAspectFit
        passwordIcon.tintColor = UIColor.label
        passwordIconView.addSubview(passwordIcon)

        let passwordIconTap = UITapGestureRecognizer(target: self, action: #selector(onPasswordIconTapped(_:)))
        passwordIconView.addGestureRecognizer(passwordIconTap)

        passwordTextField.rightView = passwordIconView
        passwordTextField.rightViewMode = .always

        // Unlock through metrics if enabled
        let preferences = UserDefaults.standard
        if preferences.object(forKey: biometryKey) != nil {
            let isActive = preferences.bool(forKey: biometryKey)

            if isActive {
                if preferences.object(forKey: biometryVaultValueKey) != nil {
                    let passwordDictionary = preferences.dictionary(forKey: biometryVaultValueKey)!
                    unlockThroughMetrics(password: passwordDictionary[vault!.id!.uuidString] as! String)
                }
            }
        }
    }

    private func unlockThroughMetrics(password: String) {
        let loadingAlert = JGProgressHUD()
        let context = LAContext()

        self.unlockButton.isEnabled = false

        // Load while checking the password
        loadingAlert.textLabel.text = "Loading"
        loadingAlert.hudView.backgroundColor = UIColor.secondarySystemBackground
        loadingAlert.show(in: view)

        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Unlock your vault") {
            success, error in

            if success {
                // Create an instance for the AES
                DispatchQueue.global().async {
                    do {
                        let secret: Array<UInt8> = Array(password.utf8)
                        let _ = try Security.getAESInstance(secret: secret, reloadAes: true)

                        // Move to the main thread because a state update triggers UI changes.
                        DispatchQueue.main.async {
                            SelectedVault.data.vault = self.vault!
                            SelectedVault.data.password = password
                            loadingAlert.dismiss()
                            NotificationCenter.default.post(name: .vaultUnlocked, object: nil)
                            self.dismiss(animated: false)
                        }
                    } catch {
                        let nsError = error as NSError
                        let defaultLog = Logger()
                        defaultLog.error("Error creating an entry: \(nsError)")
                    }
                }
            } else {
                print(error?.localizedDescription ?? "Failed to authenticate")
            }
        }
    }

    @IBAction func onCancelClicked(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func onUnlockingVault(_ sender: Any) {
        unlockButton.isEnabled = false

        // Hide Keyboard
        UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)

        // Check if the password is not empty
        if passwordTextField.text!.isEmpty {
            unlockButton.isEnabled = true
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
                if self.vault != nil {
                    let signature = try Security.decryptData(key: password!, data: self.vault!.signature!, reloadAes: true)

                    if signature == Security.signature {
                        DispatchQueue.main.async {
                            SelectedVault.data.password = password!
                            SelectedVault.data.vault = self.vault!
                            loadingAlert.dismiss()
                            NotificationCenter.default.post(name: .vaultUnlocked, object: nil)
                            self.dismiss(animated: false)
                            return
                        }
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
        self.unlockButton.isEnabled = true

        let alert = UIAlertController(title: "Error", message: "The password doesn't match", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
        self.present(alert, animated: true, completion: nil)
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
