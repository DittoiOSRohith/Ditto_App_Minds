//
//  HamburgerTableCellView.swift
//  Ditto
//
//  Created by Abiya Joy on 28/04/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit

class HamburgerTableCellView: UITableViewCell {
    //MARK: UI COMPONENT OUTLETS 
    @IBOutlet weak var hamCellLabel: UILabel!
    @IBOutlet weak var hamCellImage: UIImageView!
    @IBOutlet weak var hamArrowButton: UIButton!
    @IBOutlet weak var hamImageLeadingConstrint: NSLayoutConstraint!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
