//
//  IconsController.swift
//  Chic Pass
//
//  Created by Applichic on 12/9/20.
//

import UIKit

class IconsController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var iconCollectionView: UICollectionView!
    
    var selectedIcon = -1
    var iconColor = UIColor.systemBlue
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iconCollectionView.dataSource = self
        iconCollectionView.delegate = self
        isModalInPresentation = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        icons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "iconCell", for: indexPath as IndexPath)
                as! IconCollectionViewCell
        
        cell.icon.image = UIImage(systemName: icons[indexPath.row])
        
        if selectedIcon == indexPath.row {
            cell.icon.tintColor = UIColor.white
            cell.view.backgroundColor = iconColor
        } else {
            cell.icon.tintColor = UIColor.label
            cell.view.backgroundColor = UIColor.systemBackground
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIcon = indexPath.row
        iconCollectionView.reloadData()
        NotificationCenter.default.post(name: .changeIcon, object: icons[indexPath.row])
    }
}
