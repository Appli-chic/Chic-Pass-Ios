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
    "!", "@", "#", "%", "&", "*", ","
];

class GeneratePasswordController: UITableViewController {
    @IBOutlet weak var passwordTextView: UITextView!
    @IBOutlet weak var passwordStrength: PaddingLabel!
    @IBOutlet weak var charactersSlider: UISlider!
    @IBOutlet weak var uppercaseSwitch: UISwitch!
    @IBOutlet weak var digitsSwitch: UISwitch!
    @IBOutlet weak var symbolsSwitch: UISwitch!
    @IBOutlet weak var charactersLabel: UILabel!

    var previousNumberCharacters: Int = 20

    override func viewDidLoad() {
        super.viewDidLoad()

        charactersSlider.value = Float(previousNumberCharacters)
        generatePassword()

        // Listeners
        charactersSlider.addTarget(self, action: #selector(onNbCharactersChanged), for: UIControl.Event.valueChanged)
        uppercaseSwitch.addTarget(self, action: #selector(optionsChanged), for: UIControl.Event.valueChanged)
        digitsSwitch.addTarget(self, action: #selector(optionsChanged), for: UIControl.Event.valueChanged)
        symbolsSwitch.addTarget(self, action: #selector(optionsChanged), for: UIControl.Event.valueChanged)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        4
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        if section == 0 || section == 1 || section == 3 {
            return 1
        } else if section == 2 {
            return 3
        }

        return 0
    }

    @objc func onNbCharactersChanged() {
        if previousNumberCharacters != Int(charactersSlider.value) {
            previousNumberCharacters = Int(charactersSlider.value)
            charactersLabel.text = String(describing: Int(charactersSlider.value))
            generatePassword()
        }
    }

    @objc func optionsChanged() {
        charactersLabel.text = String(describing: Int(charactersSlider.value))
        generatePassword()
    }

    @IBAction func onRegenerate(_ sender: Any) {
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
        passwordTextView.text = password
        NotificationCenter.default.post(name: .passwordGenerated, object: passwordTextView.text)
        setPasswordStrength()
        tableView.reloadSections(IndexSet(integersIn: 0...0), with: .none)
    }

    private func setPasswordStrength() {
        if previousNumberCharacters <= 6 {
            passwordStrength.text = "Weak"
            passwordStrength.backgroundColor = UIColor.systemRed
        } else if previousNumberCharacters <= 10 {
            passwordStrength.text = "Medium"
            passwordStrength.backgroundColor = UIColor.systemOrange
        } else if previousNumberCharacters <= 13 {
            passwordStrength.text = "Good"
            passwordStrength.backgroundColor = UIColor.systemGreen
        } else {
            passwordStrength.text = "Very Good"
            passwordStrength.backgroundColor = UIColor.systemGreen
        }
    }

    private func getCharacterFromDictionary(dictionary: [String]) -> String {
        let index = Int.random(in: 0..<dictionary.count)
        return dictionary[index]
    }
    
    @IBAction func onValidated(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
}
