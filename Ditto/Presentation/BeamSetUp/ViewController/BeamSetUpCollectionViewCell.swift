//
//  BeamSetUpCollectionViewCell.swift
//  JoannTraceApp
//
//  Created by Infosys on 03/08/20.
//  Copyright © 2020 Infosys. All rights reserved.

import UIKit

class BeamSetUpCollectionViewCell: UICollectionViewCell, UIScrollViewDelegate {
    //MARK: UI COMPONENT OUTLETS
    @IBOutlet weak var beamSetUpView: BeamSetupView!
    @IBOutlet weak var workSpaceHowToView: WorkDetailView!
    //MARK: View Life Cycle Methods
    override func awakeFromNib() {
        super.awakeFromNib()
        self.beamSetUpView.scrollView.delegate = self
        self.beamSetUpView.backgroundColor = .clear
        self.backgroundColor = .clear
        self.layoutSubviews()
        self.hideAndShowbeamSetUpDivider()
    }
    func hideAndShowbeamSetUpDivider() {
        self.beamSetUpView.scrollBottomDividerView.isHidden = true
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x > 0 {
            scrollView.contentOffset.x = 0
        }
    }
}
