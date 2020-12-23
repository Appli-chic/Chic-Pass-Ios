//
// Created by Applichic on 12/23/20.
//

import UIKit
import CoreData
import os

class VaultService {
    static func addVaultAndEncrypt(vault: Vault, onSuccess: () -> Void, onError: (_: Error) -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let context = appDelegate.persistentContainer.viewContext

        do {
            let signature = try Security.encryptData(key: vault.signature!, data: Security.signature)
            vault.signature = signature
            try context.save()
            onSuccess()
        } catch {
           onError(error)
        }
    }

    static func loadVaults() -> [Vault] {
        var vaults = [Vault]()

        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return []
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

        return vaults
    }

    static func deleteVault(vault: Vault, onDeleted: () -> Void) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }

        let context = appDelegate.persistentContainer.viewContext

        do {
            context.delete(vault)
            try context.save()
            onDeleted()
        } catch {
            let nsError = error as NSError
            let defaultLog = Logger()
            defaultLog.error("Error deleting a vault: \(nsError)")
        }
    }
}