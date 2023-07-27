//
//  FaqHeaderTableViewCell.swift
//  Ditto
//
//  Created by Gaurav Rajan on 06/05/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit

class FaqHeaderTableViewCell: UITableViewCell {
    // MARK: UI COMPONENT OUTLETS 
    @IBOutlet weak var lblQuestion: UILabel!
    @IBOutlet weak var btnIsSelected: UIButton!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var viewIfOpen: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
