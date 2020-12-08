//
//  IconsController.swift
//  Chic Pass
//
//  Created by Applichic on 12/9/20.
//

import UIKit

class IconsController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var iconCollectionView: UICollectionView!
    
    let icons = ["house.fill", "house.fill", "house.fill", "house.fill", "house.fill", "house.fill", "house.fill", "house.fill", "house.fill", "house.fill", "house.fill", "house.fill"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        iconCollectionView.dataSource = self
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return icons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "iconCell", for: indexPath as IndexPath) as! IconCollectionViewCell
        
        cell.icon.image = UIImage(systemName: icons[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("You selected cell #\(indexPath.item)!")
    }
}
