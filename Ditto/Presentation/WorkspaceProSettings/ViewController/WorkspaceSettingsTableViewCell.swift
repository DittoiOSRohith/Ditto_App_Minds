//
//  WorkspaceSettingsTableViewCell.swift
//  Ditto
//
//  Created by Abiya Joy on 27/05/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit

class WorkspaceSettingsTableViewCell: UITableViewCell {
    // MARK: UI COMPONENT OUTLETS  
    @IBOutlet weak var settingsTitleText: UILabel!
    @IBOutlet weak var settingsStatusSwitch: UISwitch!
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        self.settingsStatusSwitch.layer.cornerRadius = 16
        self.settingsStatusSwitch.transform = CGAffineTransform(scaleX: 0.80, y: 0.80)
        self.settingsStatusSwitch.thumbTintColor = self.settingsStatusSwitch.isOn ? AppColor.safetyPinYellow : AppColor.needleGrey
        self.settingsStatusSwitch.subviews[0].subviews[0].backgroundColor = UIColor.white  // setting offTint of Switch
    }
}
