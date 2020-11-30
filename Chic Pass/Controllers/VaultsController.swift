//
//  ViewController.swift
//  Chic Pass
//
//  Created by Applichic on 11/29/20.
//

import UIKit

class VaultsController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    let vaults = ["Personal", "Work"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "vaultRow", for: indexPath) as! VaultTableViewCell
        cell.name.text = vaults[indexPath.row]
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.dequeueReusableCell(withIdentifier: "vaultRow", for: indexPath) as! VaultTableViewCell
        performSegue(withIdentifier: "segue_vaults_to_home", sender: cell)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return vaults.count
    }
}

