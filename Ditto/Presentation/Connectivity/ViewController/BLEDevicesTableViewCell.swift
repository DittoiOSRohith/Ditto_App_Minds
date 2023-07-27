//
//  BLEDevicesTableViewCell.swift
//  JoannTraceApp
//
//  Created by Sanchu Bose on 26/08/20.
//  Copyright © 2020 Infosys. All rights reserved.
//

import UIKit

class BLEDevicesTableViewCell: UITableViewCell {
    //MARK: UI COMPONENT OUTLETS
    @IBOutlet weak var msinView: UIView!
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var connectingLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
