//
//  TopIconButton.swift
//  Ditto
//
//  Created by Gaurav.rajan on 09/06/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit

@IBDesignable class TopIconButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        let kTextTopPadding: CGFloat = 8.0
        var titleLabelFrame = self.titleLabel!.frame
        let labelSize = titleLabel!.sizeThatFits(CGSize(width: self.contentRect(forBounds: self.bounds).width, height: CGFloat.greatestFiniteMagnitude))
        var imageFrame = self.imageView!.frame
        let fitBoxSize = CGSize(width: max(imageFrame.size.width, labelSize.width), height: labelSize.height + kTextTopPadding + imageFrame.size.height)
        let fitBoxRect = self.bounds.insetBy(dx: (self.bounds.size.width - fitBoxSize.width)/2, dy: (self.bounds.size.height - fitBoxSize.height)/2)
        imageFrame.origin.y = fitBoxRect.origin.y
        imageFrame.origin.x = fitBoxRect.midX - (imageFrame.size.width/2)
        self.imageView!.frame = imageFrame
        // Adjust the label size to fit the text, and move it below the image
        titleLabelFrame.size.width = labelSize.width
        titleLabelFrame.size.height = labelSize.height
        titleLabelFrame.origin.x = (self.frame.size.width / 2) - (labelSize.width / 2)
        titleLabelFrame.origin.y = fitBoxRect.origin.y + imageFrame.size.height + kTextTopPadding
        self.titleLabel!.frame = titleLabelFrame
        self.titleLabel!.textAlignment = .center
    }
}
