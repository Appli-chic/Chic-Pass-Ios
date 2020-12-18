//
//  IconsController.swift
//  Chic Pass
//
//  Created by Applichic on 12/9/20.
//

import UIKit

class IconsController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    @IBOutlet weak var iconCollectionView: UICollectionView!
    
    let icons = ["house.fill", "doc.text.fill", "terminal.fill", "book.closed.fill", "graduationcap.fill", "globe",
                 "music.note", "bubble.left.and.bubble.right.fill", "envelope.fill", "cart.fill", "creditcard.fill",
                 "briefcase.fill", "puzzlepiece.fill", "building.columns.fill", "key.fill", "map.fill", "play.tv.fill",
                 "bus.fill", "tram.fill", "cross.fill", "pills.fill", "film.fill", "photo.on.rectangle.angled",
                 "gamecontroller.fill", "paintpalette.fill", "chart.bar.fill", "atom", "gift.fill", "airplane",
                 "lightbulb.fill", "dollarsign.circle.fill"]
    
    var selectedIcon = -1
    
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
            cell.icon.tintColor = UIColor.systemBlue
            cell.view.backgroundColor = UIColor.secondarySystemBackground
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
