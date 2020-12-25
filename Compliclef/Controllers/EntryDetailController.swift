//
//  EntryDetailController.swift
//  Chic Pass
//
//  Created by Applichic on 12/24/20.
//

import UIKit
import os

class EntryDetailController: UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var categoryLabel: UILabel!

    private var isPasswordHidden = true
    private var passwordIcon = UIImageView()

    var entry: Entry? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        if entry != nil {
            title = entry?.name
            nameTextField.text = entry?.name
            emailTextField.text = entry?.login
            categoryLabel.text = entry?.category?.name
            decryptPasswordAndDisplay()
        }

        // Add the password an eye icon
        let passwordIconView = UIView(frame: CGRect(x: 0, y: 0, width: 60, height: 50))
        passwordIcon = UIImageView(frame: CGRect(x: 20, y: 13, width: 24, height: 24))
        passwordIcon.image = UIImage(systemName: "eye.fill")
        passwordIcon.contentMode = .scaleAspectFit
        passwordIcon.tintColor = UIColor.systemBlue
        passwordIconView.addSubview(passwordIcon)

        let passwordIconTap = UITapGestureRecognizer(target: self, action: #selector(onPasswordIconTapped(_:)))
        passwordIconView.addGestureRecognizer(passwordIconTap)

        passwordTextField.rightView = passwordIconView
        passwordTextField.rightViewMode = .always
        passwordTextField.delegate = self
    }

    func decryptPasswordAndDisplay() {
        do {
            let password = try Security.decryptData(key: SelectedVault.data.password, data: entry!.password!, reloadAes: false)
            passwordTextField.text = password
        } catch {
            let nsError = error as NSError
            let defaultLog = Logger()
            defaultLog.error("Error decrypting a password: \(nsError)")
        }
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

        passwordTextField.colorizePassword(password: passwordTextField.text!)
    }

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == passwordTextField {
            copyToClipboard()
        }

        return false
    }

    private func copyToClipboard() {
        let pasteboard = UIPasteboard.general
        pasteboard.string = passwordTextField.text
        showToast(message: "Password copied", font: .systemFont(ofSize: 14.0))
    }

    func showToast(message: String, font: UIFont) {

        let toastLabel = UILabel(frame: CGRect(
                x: view.frame.size.width / 2 - 75,
                y: view.frame.size.height / 2,
                width: 150,
                height: 45)
        )

        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center;
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds = true
        view.addSubview(toastLabel)
        UIView.animate(withDuration: 3.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: { (isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 3
        } else {
            return 1
        }
    }

    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true)
    }

    @IBAction func onEdit(_ sender: Any) {

    }

}
