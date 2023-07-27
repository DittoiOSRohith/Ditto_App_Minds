//
//  PatternCollectionViewCell.swift
//  JoannTraceApp
//
//  Created by Prabha Rajalakshmi N on 21/08/20.
//  Copyright © 2020 Infosys. All rights reserved.
//

import UIKit

class PatternCollectionViewCell: UICollectionViewCell {
    //MARK: UI COMPONENT OUTLETS
    @IBOutlet weak var viewIsSelected: UIView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var patternImageVeiw: UIImageView!
    @IBOutlet weak var labelMainTitle: UILabel!
    @IBOutlet weak var labelCutQuantity: UILabel!
    @IBOutlet weak var buttonIsSelected: UIButton!
    @IBOutlet weak var constraintLeadingTitleView: NSLayoutConstraint!
    @IBOutlet weak var contrastLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
