//
//  CategoriesController.swift
//  Chic Pass
//
//  Created by Applichic on 11/30/20.
//

import UIKit
import CoreData
import os

extension Notification.Name {
    static var categoryCreated: Notification.Name {
        .init(rawValue: "categoryCreated")
    }
}

class CategoriesController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    @IBOutlet weak var tableView: UITableView!
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    var categories: [Category] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(onNewVaultCreated),
            name: .categoryCreated,
            object: nil
        )
        
        tableView.dataSource = self
        searchController.obscuresBackgroundDuringPresentation = false;
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        UIBarButtonItem.appearance(whenContainedInInstancesOf:[UISearchBar.self]).tintColor = UIColor.systemBlue
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadCategories()
    }
    
    private func loadCategories() {
        categories = CategoryService.getAllCategoriesFromVault(vault: SelectedVault.data.vault)
        tableView.reloadData()
    }
    
    @objc private func onNewVaultCreated(_ notification: Notification) {
        loadCategories()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryRow", for: indexPath) as! CategoryTableViewCell
        
        let category = categories[indexPath.row]
        
        cell.name.text = category.name
        cell.iconView.backgroundColor = UIColor.init(hex: category.color!)
        cell.icon.image = UIImage(systemName: category.icon!)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            let deletedAlert = UIAlertController(title: "",
                    message: "All the passwords contained in this category will be deleted too",
                    preferredStyle: UIAlertController.Style.actionSheet)

            deletedAlert.addAction(UIAlertAction(title: "Ok", style: .destructive, handler: { (action: UIAlertAction!) in
                self.deleteCategory(indexPath: indexPath)
            }))

            deletedAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel))

            present(deletedAlert, animated: true, completion: nil)
        }
    }
    
    private func deleteCategory(indexPath: IndexPath) {
        CategoryService.deleteCategory(category: categories[indexPath.row]) {
            categories.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: UITableView.RowAnimation.automatic)
        }
    }
    
    @IBAction func onBackClicked(_ sender: Any) {
        parent?.navigationController?.popViewController(animated: true)
        parent?.navigationController?.setNavigationBarHidden(false, animated: false)
    }
}
