//
// Created by Applichic on 12/23/20.
//

import UIKit

extension UITextView {
    func colorizePassword(password: String) {
        if !password.isEmpty {
            let attributedPassword = NSMutableAttributedString.init(string: password)

            for index in 0...password.count - 1 {
                let range = NSRange(location: index, length: 1)

                if uppercase.contains(String(password.character(at: index)!)) {
                    attributedPassword.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemBlue, range: range)
                } else if numbers.contains(String(password.character(at: index)!)) {
                    attributedPassword.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.systemGreen, range: range)
                } else {
                    attributedPassword.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.label, range: range)
                }

                attributedPassword.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 17), range: range)
            }

            attributedText = attributedPassword
        }
    }
}
