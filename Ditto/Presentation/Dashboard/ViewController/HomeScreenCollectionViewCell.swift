//
//  HomeScreenCollectionViewCell.swift
//  Ditto
//
//  Created by Sanchu Bose on 05/05/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit

class HomeScreenCollectionViewCell: UICollectionViewCell {
    //MARK: UI COMPONENT OUTLETS
    @IBOutlet weak var cellfrontView: UIView!
    @IBOutlet weak var backgroungImageView: UIImageView!
    @IBOutlet weak var infotextLabel: UILabel!
    @IBOutlet weak var infotextSubLabel: UILabel!
    @IBOutlet weak var patternLibView: UIView!
    @IBOutlet weak var patternLibraryTitle: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
