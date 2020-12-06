//
//  PasswordTableViewCell.swift
//  Chic Pass
//
//  Created by Applichic on 12/6/20.
//

import UIKit

class PasswordTableViewCell: UITableViewCell {
    @IBOutlet weak var iconBackground: UIView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var email: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
