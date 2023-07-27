//
//  TabCell.swift
//  JoannTraceApp
//
//  Created by Keerthana Satheesh on 17/08/20.
//  Copyright © 2020 Infosys. All rights reserved.
//

import UIKit

class TabCell: UICollectionViewCell {
    //MARK: UI COMPONENT OUTLETS
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var selectiondDividerView: UIView!
    override var isSelected: Bool {
        didSet {
            self.cellView.backgroundColor = .clear
            self.title.textColor = isSelected ? AppColor.needleGrey : CustomColor.darkGrayColor
            self.selectiondDividerView.backgroundColor = isSelected ? AppColor.safetyPinYellow : .clear
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layoutSubviews()
    }
    func setupCell(text: String) {
        self.title.text = text
        self.title.textColor = isSelected ? AppColor.needleGrey : CustomColor.darkGrayColor
        self.cellView.clipsToBounds = true
        self.selectiondDividerView.backgroundColor = isSelected ? AppColor.safetyPinYellow : .clear
    }
}
