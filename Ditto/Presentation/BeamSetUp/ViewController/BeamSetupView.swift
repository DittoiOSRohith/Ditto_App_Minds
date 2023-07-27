//
//  BeamSetupView.swift
//  JoannTraceApp
//
//  Created by Infosys on 03/08/20.
//  Copyright © 2020 Infosys. All rights reserved.
//

import UIKit

class BeamSetupView: UIView, UIScrollViewDelegate {
    //MARK: UI COMPONENT OUTLETS
    @IBOutlet weak var scrollBottomDividerView: UIView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var instructionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var instructionImage: UIImageView!
    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var beamLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var watchVideoButton: UIButton!
    @IBOutlet weak var pdfImageButton: UIButton!
    @IBOutlet weak var watchVideo: UIButton!
    //MARK: VARIABLE DECLARATION
    var view: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.nibSetup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.nibSetup()
    }
    private func nibSetup() {
        self.view = self.loadViewFromNib()
        self.view.frame = bounds
        self.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.translatesAutoresizingMaskIntoConstraints = true
        self.view.backgroundColor = .clear
        addSubview(self.view)
    }
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: ReusableCellIdentifiers.beamSetupViewIdentifier, bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        nibView?.backgroundColor = .clear
        return nibView!
    }
}
