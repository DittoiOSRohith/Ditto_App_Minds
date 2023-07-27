//
//  CustomisedListCell.swift
//  Ditto
//
//  Created by Abiya Joy on 23/11/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit

class CustomisedListCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var selectionImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.selectionImage.backgroundColor = selected ? AppColor.needleGrey : .clear
    }
}
