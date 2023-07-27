//
//  Ext+Segment+UIView.swift
//  Ditto
//
//  Created by Gaurav Rajan on 27/05/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit

class SquareSegmentedControl: UISegmentedControl {
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = 0
        let titleTextAttributes1 = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.setTitleTextAttributes(titleTextAttributes1, for: .selected)
    }
}
extension UIView {
    func animateToSenderPostion( sender: UIControl ) {
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: .beginFromCurrentState, animations: {
            self.frame.origin.x = sender.frame.minX
            self.layoutIfNeeded()
            self.setNeedsLayout()
            self.setNeedsDisplay()
            self.setNeedsUpdateConstraints()
        }, completion: nil)
    }
}
extension UISegmentedControl {
    func removeBorders() {
        setBackgroundImage(imageWithColor(color: backgroundColor!), for: .normal, barMetrics: .default)
        setBackgroundImage(imageWithColor(color: tintColor!), for: .selected, barMetrics: .default)
        setDividerImage(imageWithColor(color: UIColor.gray), forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
    }
    // create a 1x1 image with this color
    fileprivate func imageWithColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
