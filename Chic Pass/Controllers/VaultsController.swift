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
}

class VaultsController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "vaultRow", for: indexPath) as! VaultTableViewCell
        performSegue(withIdentifier: "segue_vaults_to_home", sender: cell)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vaults.count
    }
    
    @objc private func onNewVaultDismissed(_ notification: Notification) {
        loadVaults()
    }
}

