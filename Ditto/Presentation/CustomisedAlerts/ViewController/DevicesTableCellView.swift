//
//  DevicesTableCellView.swift
//  Ditto
//
//  Created by Abiya Joy on 02/06/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit

class DevicesTableCellView: UITableViewCell {
    // MARK: UI COMPONENT OUTLETS
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var folderImageView: UIImageView!
    // MARK: View Life Cycle Methods
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
}
