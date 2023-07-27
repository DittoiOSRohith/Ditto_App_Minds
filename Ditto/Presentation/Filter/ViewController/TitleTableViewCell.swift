//
//  TitleTableViewCell.swift
//  Ditto
//
//  Created by Gokul Ramesh on 16/03/23.
//  Copyright © 2023 Infosys. All rights reserved.
//

import UIKit

class TitleTableViewCell: UITableViewCell {
    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var arrowBtn: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
