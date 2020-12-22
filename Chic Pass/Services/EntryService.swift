//
// Created by Applichic on 12/22/20.
//

import UIKit
import CoreData
import os

class EntryService {
    static func getAllEntriesFromVault(vault: Vault) -> [Entry] {
        var entries = [Entry]()

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return []
        }

        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Entry>(entityName: "Entry")
        let predicate = NSPredicate(format: "vault.id == %@", vault.id!.uuidString)
        fetchRequest.predicate = predicate

        do {
            entries = try managedContext.fetch(fetchRequest)
        } catch {
            let nsError = error as NSError
            let defaultLog = Logger()
            defaultLog.error("Error while fetching entries: \(nsError)")
        }

        return entries
    }
}