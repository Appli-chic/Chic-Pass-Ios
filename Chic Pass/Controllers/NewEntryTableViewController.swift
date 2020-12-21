//
//  NewEntryTableViewController.swift
//  Chic Pass
//
//  Created by Applichic on 12/21/20.
//

import UIKit

class NewEntryTableViewController: UITableViewController {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
    @IBAction func onGeneratingPassword(_ sender: Any) {
    }
    
    @IBAction func onAddingEntry(_ sender: Any) {
    }
    
    @IBAction func onCancel(_ sender: Any) {
    }
}
