//
//  ViewController.swift
//  Chic Pass
//
//  Created by Applichic on 11/29/20.
//

import UIKit
import os
import CoreData

extension Notification.Name {
    static var newVaultDismissed: Notification.Name {
        .init(rawValue: "newVaultDismissed")
    }
    
    static var vaultUnlocked: Notification.Name {
        .init(rawValue: "vaultUnlocked")
    }
}

class VaultsController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    var vaults: [Vault] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onNewVaultDismissed),
            name: .newVaultDismissed,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onVaultUnlocked),
            name: .vaultUnlocked,
            object: nil
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadVaults()
    }
    
    private func loadVaults() {
        vaults = VaultService.loadVaults()
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "vaultRow", for: indexPath) as! VaultTableViewCell
        cell.name.text = vaults[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vault = vaults[indexPath.row]
        SelectedVault.data.vault = vault
        performSegue(withIdentifier: "segue_vaults_to_unlock", sender: vault)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        vaults.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let deletedAlert = UIAlertController(title: "",
                    message: "All the passwords contained in this vault will be deleted too",
                    preferredStyle: UIAlertController.Style.actionSheet)

            deletedAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action: UIAlertAction!) in
                self.deleteVault(indexPath: indexPath)
            }))

            deletedAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

            present(deletedAlert, animated: true, completion: nil)
        }
    }
    
    @objc private func onNewVaultDismissed(_ notification: Notification) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "segue_vaults_to_main", sender: nil)
        }
        
        loadVaults()
    }
    
    @objc private func onVaultUnlocked(_ notification: Notification) {
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "segue_vaults_to_main", sender: nil)
        }
    }
    
    private func deleteVault(indexPath: IndexPath) {
        VaultService.deleteVault(vault: vaults[indexPath.row]) {
            vaults.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue_vaults_to_unlock" && sender is Vault {
            let unlockVaultController = segue.destination as! UnlockVaultController
            unlockVaultController.vault = sender as? Vault
        }
    }
}

