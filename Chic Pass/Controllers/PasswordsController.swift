//
//  PasswordsController.swift
//  Chic Pass
//
//  Created by Applichic on 11/30/20.
//

import UIKit

class PasswordsController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let passwords = ["Passwords", "Password", "Password", "Password", "Password", "Password", "Password", "Password", "Password", "Password", "Password", "Password", "Password", "Password", "Password", "Password", "Password", "test", "Password", "Password", "Password", "Password", "Password", "Password", "Password", "Password", "Password", "Password", "Password", "Password", "Password", "Password"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "passwordRow", for: indexPath) as! PasswordTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passwords.count
    }
}
