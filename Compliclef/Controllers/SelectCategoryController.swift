//
//  SelectCategoryController.swift
//  Chic Pass
//
//  Created by Applichic on 12/22/20.
//

import UIKit

class SelectCategoryController: UITableViewController {
    private let appDelegate = UIApplication.shared.delegate as! AppDelegate

    private var categories: [Category] = []
    var category: Category? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        isModalInPresentation = true

        categories = CategoryService.getAllCategoriesFromVault(vault: SelectedVault.data.vault)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        categories.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryRow", for: indexPath) as! CategoryTableViewCell

        let cellCategory = categories[indexPath.row]

        cell.name.text = cellCategory.name
        cell.iconView.backgroundColor = UIColor.init(hex: cellCategory.color!)
        cell.icon.image = UIImage(systemName: cellCategory.icon!)

        if cellCategory == category {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }

        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        category = categories[indexPath.row]
        NotificationCenter.default.post(name: .categorySelected, object: category)
        tableView.reloadData()
    }
    
    @IBAction func onDone(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
}
