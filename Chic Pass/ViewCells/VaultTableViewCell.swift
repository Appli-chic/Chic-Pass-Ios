//
//  VaultTableViewCell.swift
//  Chic Pass
//
//  Created by Applichic on 11/29/20.
//

import UIKit

class VaultTableViewCell: UITableViewCell {
    @IBOutlet weak var view: UIView!
    @IBOutlet weak var roundedView: UIView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roundedView.layer.cornerRadius = 12
        let margins = UIEdgeInsets(top: 0, left: 0, bottom: 16, right: 0)
        contentView.frame = contentView.frame.inset(by: margins)
    }

}
