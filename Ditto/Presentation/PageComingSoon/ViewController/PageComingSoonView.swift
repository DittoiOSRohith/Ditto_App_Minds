//
//  PageCommingSoonView.swift
//  PatternsBuy
//
//  Created by Shefrin Hakeem on 19/08/20.
//  Copyright © 2020 Abiya Joy. All rights reserved.
//

import UIKit

class PageComingSoonView: UIView {
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
        let nib = UINib(nibName: ReusableCellIdentifiers.pageComingSoonViewIdentifier, bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        return nibView!
    }
}
