//
//  GeneratePasswordController.swift
//  Chic Pass
//
//  Created by Applichic on 12/22/20.
//

import UIKit

let characters = [
    "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t",
    "u", "v", "w", "x", "y", "z"
];

let uppercase = [
    "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T",
    "U", "V", "W", "X", "Y", "Z"
];

let numbers = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"];

let specialCharacters = [
    "!", "@", "#", "$", "%", "^", "&", "*", "(", ")", "-", "_", "+", "=", "{", "[", "}", "]", "|", "\\", ":",
    ";", "\"", "'", ",", "<", ".", ">", "/", "?", "`", "~"
];

class GeneratePasswordController: UITableViewController {
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var charactersSlider: UISlider!
    @IBOutlet weak var uppercaseSwitch: UISwitch!
    @IBOutlet weak var digitsSwitch: UISwitch!
    @IBOutlet weak var symbolsSwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()
        generatePassword()

        // Listeners
        charactersSlider.addTarget(self, action: #selector(optionsChanged), for: UIControl.Event.valueChanged)
        uppercaseSwitch.addTarget(self, action: #selector(optionsChanged), for: UIControl.Event.valueChanged)
        digitsSwitch.addTarget(self, action: #selector(optionsChanged), for: UIControl.Event.valueChanged)
        symbolsSwitch.addTarget(self, action: #selector(optionsChanged), for: UIControl.Event.valueChanged)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//

        if section == 0 || section == 1 {
            return 1
        } else if section == 2 {
            return 3
        }

        return 0
    }

    @objc func optionsChanged() {
        tableView.footerView(forSection: 1)?.textLabel?.text = String(describing: charactersSlider.value)
        generatePassword()
    }

    private func generatePassword() {
        var password = ""
        var dictionary = [String]()
        dictionary.append(contentsOf: characters)

        if uppercaseSwitch.isOn {
            dictionary.append(contentsOf: uppercase)
        }

        if digitsSwitch.isOn {
            dictionary.append(contentsOf: numbers)
        }

        if symbolsSwitch.isOn {
            dictionary.append(contentsOf: specialCharacters)
        }

        // Create the password
        for _ in 0...Int(charactersSlider.value) {
            password += getCharacterFromDictionary(dictionary: dictionary)
        }

        // Show the password
        passwordTextField.text = password
    }

    private func getCharacterFromDictionary(dictionary: [String]) -> String {
        let index = Int.random(in: 0..<dictionary.count)
        return dictionary[index]
    }
}
