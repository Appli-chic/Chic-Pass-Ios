//
//  UITextField.swift
//  Chic Pass
//
//  Created by Applichic on 11/30/20.
//

import UIKit

extension UITextField {
    func setLeftPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: frame.size.height))
        leftView = paddingView
        leftViewMode = .always
    }

    func setRightPaddingPoints(_ amount: CGFloat) {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: amount, height: frame.size.height))
        rightView = paddingView
        rightViewMode = .always
    }

    func colorizePassword(password: String) {
        if !isSecureTextEntry && !password.isEmpty {
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

        if isSecureTextEntry && !password.isEmpty {
            let attributedPassword = NSMutableAttributedString.init(string: password)
            
            for index in 0...password.count - 1 {
                let range = NSRange(location: index, length: 1)
                attributedPassword.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 17), range: range)
                attributedPassword.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.label, range: range)
            }

            attributedText = attributedPassword
        }
    }
}
