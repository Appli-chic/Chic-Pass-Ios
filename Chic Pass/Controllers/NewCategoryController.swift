//
//  NewCategoryController.swift
//  Chic Pass
//
//  Created by Applichic on 12/8/20.
//

import UIKit
import os
import JGProgressHUD

extension Notification.Name {
    static var changeIcon: Notification.Name {
        .init(rawValue: "changeIcon")
    }
}

class NewCategoryController: UITableViewController, UIColorPickerViewControllerDelegate,
        UICollectionViewDataSource, UICollectionViewDelegate {

    private let appDelegate = UIApplication.shared.delegate as! AppDelegate

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var colorCollection: UICollectionView!
    @IBOutlet weak var iconCollection: UICollectionView!
    
    private var color: UIColor = UIColor.systemBlue
    private var iconName = "house.fill"
    private var iconsPreview = icons[0...10]
    private var colorsPreview = colors

    override func viewDidLoad() {
        super.viewDidLoad()

        colorCollection.dataSource = self
        colorCollection.delegate = self
        iconCollection.dataSource = self
        iconCollection.delegate = self

        NotificationCenter.default.addObserver(
                self,
                selector: #selector(onIconChanged),
                name: .changeIcon,
                object: nil
        )
    }

    @IBAction func onAddingCategory(_ sender: Any) {
        if nameTextField.text != nil && nameTextField.text!.isEmpty {
            let alert = UIAlertController(title: "Error", message: "The name must not be empty", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Default action"), style: .default))
            present(alert, animated: true, completion: nil)
            return
        }

        // Showing a loading alert
        let loadingAlert = JGProgressHUD()
        loadingAlert.textLabel.text = "Loading"
        loadingAlert.hudView.backgroundColor = UIColor.secondarySystemBackground
        loadingAlert.show(in: view)

        // Prepare to add the category to the local database
        let context = appDelegate.persistentContainer.viewContext
        let name = nameTextField.text!

        // Adding the category
        DispatchQueue.global().async {
            do {
                let category = Category(context: context)
                category.id = UUID.init()
                category.name = name
                category.icon = self.iconName
                category.color = self.color.toHex()
                category.createdAt = Date()
                category.updatedAt = Date()
                category.vault = SelectedVault.data.vault

                try context.save()

                DispatchQueue.main.async {
                    loadingAlert.dismiss()
                    NotificationCenter.default.post(name: .categoryCreated, object: nil)
                    self.dismiss(animated: true)
                }
            } catch {
                DispatchQueue.main.async {
                    let nsError = error as NSError
                    let defaultLog = Logger()
                    defaultLog.error("Error creating a category: \(nsError)")

                    loadingAlert.dismiss()
                }
            }
        }
    }

    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true)
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        // Choosing an icon
        if indexPath.section == 1 && indexPath.row == 0 {
            performSegue(withIdentifier: "choose_icon", sender: nil)
        }

        // Choosing a color had been clicked
        if indexPath.section == 1 && indexPath.row == 1 {
            let picker = UIColorPickerViewController()
            picker.delegate = self
            present(picker, animated: true, completion: nil)
        }
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == colorCollection {
            return colorsPreview.count
        } else {
            return iconsPreview.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == colorCollection {
            // Managing colors collection
            let colorCell = collectionView.dequeueReusableCell(withReuseIdentifier: "colorCell", for: indexPath) as! ColorCollectionViewCell

            if color == colorsPreview[indexPath.row] {
                colorCell.colorOutlineView.layer.borderWidth = 2
                colorCell.colorOutlineView.layer.borderColor = colorsPreview[indexPath.row].cgColor
            } else {
                colorCell.colorOutlineView.layer.borderColor = UIColor.clear.cgColor
            }

            colorCell.colorView.backgroundColor = colorsPreview[indexPath.row]

            return colorCell
        } else {
            // Managing icons collection
            let iconCell = collectionView.dequeueReusableCell(withReuseIdentifier: "iconCell", for: indexPath) as! NewCategoryIconCollectionViewCell

            iconCell.iconView.image = UIImage(systemName: iconsPreview[indexPath.row])

            if iconName == iconsPreview[indexPath.row] {
                iconCell.colorView.backgroundColor = color
                iconCell.iconView.tintColor = UIColor.white
            } else {
                iconCell.colorView.backgroundColor = UIColor.secondarySystemBackground
                iconCell.iconView.tintColor = UIColor.label
            }

            return iconCell
        }
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == colorCollection {
            color = colorsPreview[indexPath.row]
        } else {
            iconName = iconsPreview[indexPath.row]
        }
        
        colorCollection.reloadData()
        iconCollection.reloadData()
    }

    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        color = viewController.selectedColor

        if colorsPreview.firstIndex(of: color) == nil {
            colorsPreview[0] = color
        }

        colorCollection.reloadData()
        iconCollection.reloadData()
    }

    @objc private func onIconChanged(_ notification: Notification) {
        iconName = notification.object as! String
        
        if iconsPreview.firstIndex(of: iconName) == nil {
            iconsPreview[0] = iconName
        }
        
        colorCollection.reloadData()
        iconCollection.reloadData()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "choose_icon" {
            let iconsController = segue.destination as! IconsController
            iconsController.selectedIcon = icons.firstIndex(of: iconName)!
            iconsController.iconColor = color
        }
    }
}
