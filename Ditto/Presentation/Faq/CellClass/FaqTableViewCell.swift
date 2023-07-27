//
//  FaqTableViewCell.swift
//  Ditto
//
//  Created by Gaurav Rajan on 06/05/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit

class FaqTableViewCell: UITableViewCell {
    // MARK: UI COMPONENT OUTLETS
    @IBOutlet weak var viewBottomBorder: UILabel!
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var labelShortDescription: UILabel!
    @IBOutlet weak var imageViewSubAnswer: UIImageView!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var bottomConstratintForShadow: NSLayoutConstraint!
    @IBOutlet weak var innerView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
