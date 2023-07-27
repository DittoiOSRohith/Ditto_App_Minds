//
//  FaqAnswerTableViewCell.swift
//  Ditto
//
//  Created by Gaurav Rajan on 07/05/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit

class FaqAnswerTableViewCell: UITableViewCell {
    // MARK: UI COMPONENT OUTLETS
    @IBOutlet weak var lblANswer: UILabel!
    @IBOutlet weak var viewBottomBorder: UILabel!
    @IBOutlet weak var watchVideoView: UIView!
    @IBOutlet weak var shareView: UIView!
    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var innerView: UIView!
    @IBOutlet weak var bottomConstratintForShadow: NSLayoutConstraint!
    @IBOutlet weak var stackViewHeightConstraint: NSLayoutConstraint!
    // MARK: VARIABLE DECLARATION
    var watchVideoBtnAction: (() -> Void)?
    var shareBtnAction: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        self.watchVideoView.layer.borderColor = UIColor.black.cgColor
        self.watchVideoView.layer.borderWidth = 1
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    // MARK: UI COMPONENT ACTIONS 
    @IBAction func watchVideoAction(_ sender: Any) {   // Watch video button action
        if let btnAction = self.watchVideoBtnAction {
            btnAction()
        }
    }
    @IBAction func shareAction(_ sender: Any) {   // Share video button action
        if let btnAction = self.shareBtnAction {
            btnAction()
        }
    }
}
