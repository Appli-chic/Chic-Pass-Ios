//
// Created by Applichic on 12/22/20.
//

import UIKit
import CoreData
import os

class CategoryService {
    static func getAllCategoriesFromVault(vault: Vault) -> [Category] {
        var categories = [Category]()

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return []
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Category>(entityName: "Category")
        let predicate = NSPredicate(format: "vault.id == %@", vault.id!.uuidString)
        fetchRequest.predicate = predicate

        do {
            categories = try managedContext.fetch(fetchRequest)
        } catch {
            let nsError = error as NSError
            let defaultLog = Logger()
            defaultLog.error("Error while fetching categories: \(nsError)")
        }

        return categories
    }
}