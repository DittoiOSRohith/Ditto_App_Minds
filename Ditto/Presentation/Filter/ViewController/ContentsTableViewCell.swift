//
//  ContentsTableViewCell.swift
//  Ditto
//
//  Created by Gokul Ramesh on 16/03/23.
//  Copyright © 2023 Infosys. All rights reserved.
//

import UIKit

class ContentsTableViewCell: UITableViewCell {
    var selectionItem: (() -> Void)?
    // MARK: - IBOutlets
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var contentSelectedBtn: UIButton!
    @IBOutlet weak var contentSelectedBtnImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    // MARK: - IBAction
    @IBAction func selectContent(_ sender: UIButton) {
        if let btnAction = self.selectionItem {
            btnAction()
        }
    }
}
