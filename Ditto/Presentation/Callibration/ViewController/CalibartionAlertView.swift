//
//  CalibartionAlertView.swift
//  JoannTraceApp
//
//  Created by Shefrin Hakeem on 14/08/20.
//  Copyright © 2020 Infosys. All rights reserved.
//

import UIKit

class CalibartionAlertView: UIView {
    //MARK: UI COMPONENT OUTLETS
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var lauchCameraButton: UIButton!
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
        addSubview(self.view)
    }
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: ReusableCellIdentifiers.calibartionAlertViewIdentifier, bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        return nibView!
    }
}
