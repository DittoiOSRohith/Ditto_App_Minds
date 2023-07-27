//
//  GetStartedCollectionModel.swift
//  Ditto
//
//  Created by Gaurav.rajan on 25/07/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit

class GetStartedCollectionModel: NSObject {
    var tileImage = String()
    var tileTitle = String()
    var tileDescription = String()
}
class OnboardCollectionViewCell: UICollectionViewCell {
    //MARK: UI COMPONENT OUTLETS
    @IBOutlet weak var tileTitle: UILabel!
    @IBOutlet weak var tileDescription: UILabel!
    @IBOutlet weak var tileImage: UIImageView!
    //MARK: View Life Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.layer.cornerRadius = cornerRadius
        contentView.layer.masksToBounds = true
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.shadowPath = UIBezierPath(
            roundedRect: bounds,
            cornerRadius: cornerRadius
        ).cgPath
    }
}
