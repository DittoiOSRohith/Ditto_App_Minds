//
//  ReferenceSpliceLayout.swift
//  Ditto
//
//  Created by Shefrin Hakeem on 31/05/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit

@objc protocol SaveAndExitDelegate {
    func updateRefLayoutViewForFabric(fabricSelected: String, isSplice: Bool)
    func bringZoomUpPopUp()
    func questionMarkPopUp()
}
class ReferenceSpliceLayout: UIView {
    var delegate: SaveAndExitDelegate?
    //MARK: UI COMPONENT OUTLETS
    @IBOutlet weak var referenceImageView: UIImageView!
    @IBOutlet weak var fourtyFiveLabel: UILabel!
    @IBOutlet weak var fourtyFiveNapLabel: UILabel!
    @IBOutlet weak var sixtyLable: UILabel!
    @IBOutlet weak var sixtyNapLabel: UILabel!
    @IBOutlet weak var fourtyButton: UIButton!
    @IBOutlet weak var spliceButtonView: UIView!
    @IBOutlet weak var spliceButton: UIButton!
    @IBOutlet weak var fourtyFiveView: UIView!
    @IBOutlet weak var sixtyButton: UIButton!
    @IBOutlet weak var sixtyView: UIView!
    var fourtyFiveTapped: Bool = false
    var sixtyTapped: Bool = false
    var spliceTapped: Bool = false
    //MARK: VARIABLE DECLARATION
    var spliceImage = UIImage()
    var contentView: UIView!
    var isSpliceEnabled = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.nibSetup()
        if self.isSpliceEnabled {   // Code to enable and disable splice button
            self.enableSplice()
        } else {
            self.disableSpliceButton()
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.nibSetup()
    }
    func disableSpliceButton() {   // Code to disable Splice button
        self.isSpliceEnabled = false
        self.spliceButton.setTitleColor(.lightGray, for: .normal)
        self.spliceButtonView.backgroundColor = CustomColor.wsReferenceGrayColor
    }
    func enableSplice() {    // Code to disable Splice button
        self.isSpliceEnabled = true
        self.spliceButton.setTitleColor(.white, for: .normal)
        self.spliceButtonView.backgroundColor  = UIColor.black
    }
    private func nibSetup() {
        self.setNeedsLayout()
        self.layoutIfNeeded()
        self.contentView = self.loadViewFromNib()
        self.contentView.frame = self.bounds
        self.contentView.translatesAutoresizingMaskIntoConstraints = true
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(self.contentView)
    }
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: ReusableCellIdentifiers.referenceSpliceLayoutIdentifier, bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        return nibView!
    }
    //MARK: UI COMPONENT ACTION
    @IBAction func fourtyFiveButtonClicked(_ sender: Any) {   // First Button(45 / 20) tap handling
        self.fourtyFiveLabel.textColor = UIColor.white
        self.fourtyFiveNapLabel.textColor = UIColor.white
        self.fourtyFiveView.backgroundColor = UIColor.black
        self.fourtyFiveTapped = true
        self.sixtyTapped = false
        self.spliceTapped = false
        self.delegate?.updateRefLayoutViewForFabric(fabricSelected: ReferenceLayoutType.fourtyfive, isSplice: false)
    }
    @IBAction func referenceImageTapped(_ sender: Any) {   // Reference image tap for zoom functionality
        self.delegate?.bringZoomUpPopUp()
    }
    @IBAction func sixtyButtonClicked(_ sender: Any) {   // Second Button(60 / 45) tap handling
        self.sixtyLable.textColor = UIColor.white
        self.sixtyNapLabel.textColor = UIColor.white
        self.sixtyView.backgroundColor = UIColor.black
        self.fourtyFiveTapped = false
        self.sixtyTapped = true
        self.spliceTapped = false
        self.delegate?.updateRefLayoutViewForFabric(fabricSelected: ReferenceLayoutType.sixty, isSplice: false)
    }
    @IBAction func spliceButtonClicked(_ sender: Any) {   // Splice Button tap handling
        if self.isSpliceEnabled {
            self.spliceButtonView.backgroundColor = UIColor.black
            self.spliceButton.setTitleColor(UIColor.white, for: .normal)
            self.fourtyFiveTapped = false
            self.sixtyTapped = false
            self.spliceTapped = true
            self.referenceImageView.image = spliceImage
            self.delegate?.updateRefLayoutViewForFabric(fabricSelected: ReferenceLayoutType.sixty, isSplice: true)
            self.delegate?.updateRefLayoutViewForFabric(fabricSelected: ReferenceLayoutType.fourtyfive, isSplice: true)
        }
    }
    @IBAction func questionMarkButtonClicked(_ sender: Any) {   // Question Mark Button tap handling
        self.delegate?.questionMarkPopUp()
    }
}
