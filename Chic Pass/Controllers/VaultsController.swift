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
        return .init(rawValue: "newVaultDismissed")
    }
    
    static var vaultUnlocked: Notification.Name {
        return .init(rawValue: "vaultUnlocked")
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
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Vault>(entityName: "Vault")
        
        do {
            vaults = try managedContext.fetch(fetchRequest)
        } catch {
            let nsError = error as NSError
            let defaultLog = Logger()
            defaultLog.error("Error while fetching vaults: \(nsError)")
        }
        
        tableView.reloadData()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "vaultRow", for: indexPath) as! VaultTableViewCell
        cell.name.text = vaults[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vault = vaults[indexPath.row]
        performSegue(withIdentifier: "segue_vaults_to_unlock", sender: vault)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vaults.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let deletedAlert = UIAlertController(title: "Warning", message: "All the passwords contained in this vault will be deleted too", preferredStyle: UIAlertController.Style.alert)

            deletedAlert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: { (action: UIAlertAction!) in
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
        let context = appDelegate.persistentContainer.viewContext
        
        do {
            context.delete(vaults[indexPath.row])
            try context.save()
            vaults.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        } catch {
            let nsError = error as NSError
            let defaultLog = Logger()
            defaultLog.error("Error deleting a vault: \(nsError)")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segue_vaults_to_unlock" && sender is Vault {
            let unlockVaultController = segue.destination as! UnlockVaultController
            unlockVaultController.vault = sender as? Vault
        }
    }
}

