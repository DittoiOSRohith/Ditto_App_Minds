//
//  WorkDetailView.swift
//  WorkSpaceWithView
//
//  Created by Abiya Joy on 13/08/20.
//  Copyright © 2020 Abiya Joy. All rights reserved.
//

import UIKit
@objc
class UITextViewWorkaround: NSObject {
// workaround for crash fix for uiTextview for os less than 13
    static func executeWorkaround() {
        if #unavailable(iOS 13.2) {
            let className = "_UITextLayoutView"
            let theClass = objc_getClass(className)
            if theClass == nil {
                let classPair: AnyClass? = objc_allocateClassPair(UIView.self, className, 0)
                objc_registerClassPair(classPair!)
            }
        }
    }
}

class WorkDetailView: UIView {
    //MARK: UI COMPONENT OUTLETS
    @IBOutlet weak var instructionTitleHeight: NSLayoutConstraint!
    @IBOutlet weak var instructionLabel: UITextView!
    @IBOutlet weak var instructionImageView: UIImageView!
    @IBOutlet weak var instructionTitle: UILabel!
    @IBOutlet weak var watchVideoButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var pdfImageButton: UIButton!
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
        let nib = UINib(nibName: ReusableCellIdentifiers.workDetailViewIdentifier, bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        return nibView!
    }
}
