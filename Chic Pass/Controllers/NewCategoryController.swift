//
//  NewCategoryController.swift
//  Chic Pass
//
//  Created by Applichic on 12/8/20.
//

import UIKit

class NewCategoryController: UIViewController, UIColorPickerViewControllerDelegate {
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var colorButton: UIButton!
    
    private var color: UIColor? = nil

    override func viewDidLoad() {
        super.viewDidLoad()

        nameTextField.setLeftPaddingPoints(16)
        nameTextField.setRightPaddingPoints(16)
    }
    
    @IBAction func onAddingCategory(_ sender: Any) {
        
    }
    
    @IBAction func onCancel(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func onSelectingColor(_ sender: Any) {
        let picker = UIColorPickerViewController()
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    func colorPickerViewControllerDidSelectColor(_ viewController: UIColorPickerViewController) {
        color = viewController.selectedColor
        colorButton.backgroundColor = color
    }
}
