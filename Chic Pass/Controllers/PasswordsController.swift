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
    private var passwords = ["Passwords", "Password", "Password", "Password", "Password", "Password", "Password",
                             "Password", "Password", "Password", "Password", "Password", "Password", "Password",
                             "Password", "Password", "Password", "test", "Password", "Password", "Password", "Password",
                             "Password", "Password", "Password", "Password", "Password", "Password", "Password",
                             "Password", "Password", "Password"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        searchController.obscuresBackgroundDuringPresentation = false;
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        UIBarButtonItem.appearance(whenContainedInInstancesOf:[UISearchBar.self]).tintColor = UIColor.red
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "passwordRow", for: indexPath) as! PasswordTableViewCell
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return passwords.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let deletedAlert = UIAlertController(title: "Warning",
                    message: "Are you sure to delete Gmail's password",
                    preferredStyle: UIAlertController.Style.alert)

            deletedAlert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: { (action: UIAlertAction!) in
                self.deletePassword(indexPath: indexPath)
            }))

            deletedAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

            present(deletedAlert, animated: true, completion: nil)
        }
    }
    
    private func deletePassword(indexPath: IndexPath) {
        passwords.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
    }
    
    @IBAction func onBackClicked(_ sender: Any) {
        parent?.navigationController?.popViewController(animated: true)
        parent?.navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
