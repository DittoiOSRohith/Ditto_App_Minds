//
//  HomeCollectionViewCell.swift
//  JoannTraceApp
//
//  Created by Infosys on 03/08/20.
//  Copyright © 2020 Infosys. All rights reserved.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    //MARK: UI COMPONENT OUTLETS
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var progressViews: ProgressBar!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var iconImageVeiw: UIImageView!
    @IBOutlet weak var centerImage: UIImageView!
    @IBOutlet weak var trialLbl: UILabel!
    @IBOutlet weak var subscribedLbl: UILabel!
    @IBOutlet weak var addToFolderImg: UIImageView!
    @IBOutlet weak var addToFavoritesImg: UIButton!
    @IBOutlet weak var renameOrDeleteView: UIView!
    @IBOutlet weak var pausedLbl: UILabel!
    //MARK: VARIABLE DECLARATION
    var selectionItem: (() -> Void)?
    var closeItem: (() -> Void)?
    var renameItem: (() -> Void)?
    var deleteItem: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    @IBAction func addTo(_ sender: UIButton) {  // Add to Folder in Pattern Library screen
        if let btnAction = self.selectionItem {
            btnAction()
        }
    }
    @IBAction func close(_ sender: UIButton) {  // Close popup
        if let btnAction = self.closeItem {
            btnAction()
        }
    }
    @IBAction func renameFolder(_ sender: UIButton) {  // Rename folder in My Folder section
        if let btnAction = self.renameItem {
            btnAction()
        }
    }
    @IBAction func deleteFolder(_ sender: UIButton) {  // Delete folder in My Folder section
        if let btnAction = self.deleteItem {
            btnAction()
        }
    }
}
