//
//  PatternScrollableView.swift
//  JoannTraceApp
//
//  Created by Prabha Rajalakshmi N on 12/08/20.
//  Copyright © 2020 Infosys. All rights reserved.
//

import UIKit

@objc protocol ButtonVisibilityDelegate {
    func segmentDidPress()
}

class PatternScrollableView: UIView, UIScrollViewDelegate {
    //MARK: UI COMPONENT OUTLETS
    @IBOutlet var patternsLeftArrow: UIButton?
    @IBOutlet var patternsRightArrow: UIButton?
    @IBOutlet var patternCollectionView: UICollectionView?
    @IBOutlet weak var buttonReset: UIButton!
    @IBOutlet weak var addNotesButton: UIButton!
    @IBOutlet weak var labelTotalCutCount: UILabel!
    @IBOutlet weak var labelSelectedCutCount: UILabel!
    //MARK: VARIABLE DECLARATION
    var contentView: UIView!
    var didClickAddNotes: (()->Void)?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.nibSetup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.nibSetup()
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    private func nibSetup() {
        self.setNeedsLayout()
        self.layoutIfNeeded()
        self.contentView = self.loadViewFromNib()
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.contentView.translatesAutoresizingMaskIntoConstraints = true
        addSubview(self.contentView)
    }
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: ReusableCellIdentifiers.patternScrollableViewIdentifier, bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        return nibView!
    }
    @IBAction func didClickAddNotes(_ sender: Any) {
        self.didClickAddNotes?()
    }
}
