//
//  NewEntryTableViewController.swift
//  Chic Pass
//
//  Created by Applichic on 12/21/20.
//

import UIKit
import JGProgressHUD
import os

extension Notification.Name {
    static var passwordGenerated: Notification.Name {
        .init(rawValue: "passwordGenerated")
    }

    static var categorySelected: Notification.Name {
        .init(rawValue: "categorySelected")
    }
}

class NewEntryTableViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var categorySelectedLabel: UILabel!

    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private var isPasswordHidden = true
    private var passwordIcon = UIImageView()
    private var category: Category? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(
                self,
                selector: #selector(onPasswordGenerated),
                name: .passwordGenerated,
                object: nil
        )

        NotificationCenter.default.addObserver(
                self,
                selector: #selector(onCategorySelected),
                name: .categorySelected,
                object: nil
        )

        // Keyboard dismissible with a click
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
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
    }

    @objc private func onPasswordGenerated(_ notification: Notification) {
        let password = notification.object as! String
        passwordTextField.text = password
        passwordTextField.colorizePassword(password: password)
        checkAllFieldsAreFilled()
    }

    @objc private func onCategorySelected(_ notification: Notification) {
        category = notification.object as? Category
        categorySelectedLabel.text = category?.name
        checkAllFieldsAreFilled()
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

    @objc func onTextFieldsChange(_ textField: UITextField) {
        checkAllFieldsAreFilled()
    }

    private func checkAllFieldsAreFilled() {
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            performSegue(withIdentifier: "search_categories", sender: category)
        }
    }

    @IBAction func onAddingEntry(_ sender: Any) {
        saveButton.isEnabled = false

        // Hide Keyboard
        UIApplication.shared.sendAction(#selector(UIApplication.resignFirstResponder), to: nil, from: nil, for: nil)

        // Showing a loading alert
        let loadingAlert = JGProgressHUD()
        loadingAlert.textLabel.text = "Loading"
        loadingAlert.hudView.backgroundColor = UIColor.secondarySystemBackground
        loadingAlert.show(in: view)

        // Prepare to add the vault to the local database
        let context = appDelegate.persistentContainer.viewContext
        let name = nameTextField.text
        let password = passwordTextField.text
        let login = emailTextField.text

        DispatchQueue.global().async {
            let entry = Entry(context: context)
            let uuid = UUID()
            entry.id = uuid
            entry.name = name
            entry.password = password
            entry.login = login
            entry.category = self.category
            entry.vault = SelectedVault.data.vault
            entry.createdAt = Date()
            entry.updatedAt = Date()

            EntryService.addEntryAndEncrypt(entry: entry, onSuccess: {
                DispatchQueue.main.async {
                    loadingAlert.dismiss()
                    NotificationCenter.default.post(name: .newEntry, object: nil)
                    self.dismiss(animated: false)
                }
            }, onError: { error in
                DispatchQueue.main.async {
                    let nsError = error as NSError
                    let defaultLog = Logger()
                    defaultLog.error("Error creating an entry: \(nsError)")

                    loadingAlert.dismiss()
                    self.saveButton.isEnabled = true
                }
            })
        }
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "search_categories" && sender is Category? {
            let selectCategoryController = segue.destination as! SelectCategoryController
            selectCategoryController.category = sender as? Category
        }
    }
}
