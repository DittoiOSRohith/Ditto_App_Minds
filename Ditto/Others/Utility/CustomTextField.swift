//
//  CustomTextField.swift
//  JoannTraceApp
//
//  Created by Sanchu Bose on 05/08/20.
//  Copyright © 2020 Infosys. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    override open func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == #selector(self.paste(_:)) || action == #selector(self.copy(_:)) || action == #selector(self.cut(_:)) || action == #selector(self.select(_:)) || action == #selector(self.selectAll(_:)) {
            return false
        }
        return super.canPerformAction(action, withSender: sender)
    }
}
class SearchTextField: UITextField {
    let padding = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 21)
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.inset(by: padding)
    }
}
