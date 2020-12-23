//
//  BiometryController.swift
//  Chic Pass
//
//  Created by Applichic on 12/23/20.
//

import UIKit

extension Notification.Name {
    static var checkPasswordForBiometry: Notification.Name {
        .init(rawValue: "checkPasswordForBiometry")
    }
}

class BiometryController: UITableViewController {
    @IBOutlet weak var biometrySwitch: UISwitch!

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(
                self,
                selector: #selector(onBiometryChecked),
                name: .checkPasswordForBiometry,
                object: nil
        )

        let preferences = UserDefaults.standard

        if preferences.object(forKey: biometryKey) != nil {
            let isActive = preferences.bool(forKey: biometryKey)
            biometrySwitch.isOn = isActive
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }

    @IBAction func onBiometryChange(_ sender: Any) {
        if biometrySwitch.isOn {
            biometrySwitch.isOn = false
            performSegue(withIdentifier: "check_password_biometry", sender: nil)
        } else {
            let preferences = UserDefaults.standard
            preferences.setValue(biometrySwitch.isOn, forKey: biometryKey)
            preferences.synchronize()
        }
    }

    @objc private func onBiometryChecked(_ notification: Notification) {
        biometrySwitch.isOn = true

        let preferences = UserDefaults.standard
        preferences.setValue(biometrySwitch.isOn, forKey: biometryKey)
        preferences.synchronize()
    }
}
