//
//  PasswordsController.swift
//  Chic Pass
//
//  Created by Applichic on 11/30/20.
//

import UIKit
import os

extension Notification.Name {
    static var newEntry: Notification.Name {
        .init(rawValue: "newEntry")
    }
}

class EntryController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var tableView: UITableView!

    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    private let searchController = UISearchController(searchResultsController: nil)
    private var entries: [Entry] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(
                self,
                selector: #selector(onNewEntryCreated),
                name: .newEntry,
                object: nil
        )
        
        tableView.dataSource = self
        tableView.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false;
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        UIBarButtonItem.appearance(whenContainedInInstancesOf:[UISearchBar.self]).tintColor = UIColor.systemBlue

        loadEntries()
    }

    private func loadEntries() {
        entries = EntryService.getAllEntriesFromVault(vault: SelectedVault.data.vault)
        tableView.reloadData()
    }

    @objc private func onNewEntryCreated(_ notification: Notification) {
        loadEntries()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "passwordRow", for: indexPath) as! PasswordTableViewCell

        let entry = entries[indexPath.row]

        cell.title?.text = entry.name
        cell.email?.text = entry.login
        cell.iconBackground.backgroundColor = UIColor.init(hex: entry.category!.color!)
        cell.icon.image = UIImage(systemName: entry.category!.icon!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        entries.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let entry = entries[indexPath.row]
            let deletedAlert = UIAlertController(title: "",
                    message: "Are you sure to delete \(entry.name!)'s password",
                    preferredStyle: UIAlertController.Style.actionSheet)

            deletedAlert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: { (action: UIAlertAction!) in
                self.deleteEntry(indexPath: indexPath)
            }))

            deletedAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

            present(deletedAlert, animated: true, completion: nil)
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let entry = entries[indexPath.row]
        performSegue(withIdentifier: "entry_detail", sender: entry)
    }
    
    private func deleteEntry(indexPath: IndexPath) {
        EntryService.deleteEntry(entry: entries[indexPath.row]) {
            entries.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    
    @IBAction func onBackClicked(_ sender: Any) {
        parent?.navigationController?.popViewController(animated: true)
        parent?.navigationController?.setNavigationBarHidden(false, animated: false)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "entry_detail" && sender is Entry {
            let navController = segue.destination as! UINavigationController
            let entryDetailController = navController.topViewController as! EntryDetailController
            entryDetailController.entry = sender as? Entry
        }
    }
}
