//
//  NewEntryTableViewController.swift
//  Chic Pass
//
//  Created by Applichic on 12/21/20.
//

import UIKit

class NewEntryTableViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!

    private var isPasswordHidden = true
    private var passwordIcon = UIImageView()
    private var category: Category? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        // Keyboard dismissible with a click
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)

        saveButton.isEnabled = false
        nameTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self

        nameTextField.addTarget(self, action: #selector(onTextFieldsChange(_:)), for: .editingChanged)
        emailTextField.addTarget(self, action: #selector(onTextFieldsChange(_:)), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(onTextFieldsChange(_:)), for: .editingChanged)

        passwordTextField.textContentType = .oneTimeCode

        // Add the password an eye icon
        let passwordIconView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        passwordIcon = UIImageView(frame: CGRect(x: 60, y: 13, width: 24, height: 24))
        passwordIcon.image = UIImage(systemName: "eye.fill")
        passwordIcon.contentMode = .scaleAspectFit
        passwordIcon.tintColor = UIColor.systemBlue
        passwordIconView.addSubview(passwordIcon)

        let passwordIconTap = UITapGestureRecognizer(target: self, action: #selector(onPasswordIconTapped(_:)))
        passwordIconView.addGestureRecognizer(passwordIconTap)

        passwordTextField.rightView = passwordIconView
        passwordTextField.rightViewMode = .always
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
        if nameTextField.hasText && emailTextField.hasText && passwordTextField.hasText && category != nil {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 4
        } else {
            return 1
        }
    }

    @IBAction func onGeneratingPassword(_ sender: Any) {
    }

    @IBAction func onAddingEntry(_ sender: Any) {
    }

    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true)
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == nameTextField {
            emailTextField.becomeFirstResponder()
        } else if textField == emailTextField {
            passwordTextField.becomeFirstResponder()
        } else {
            textField.resignFirstResponder()
        }

        return true
    }
}
