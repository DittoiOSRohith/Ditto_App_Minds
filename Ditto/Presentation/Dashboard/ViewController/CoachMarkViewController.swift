//
//  CoachMarkViewController.swift
//  Ditto
//
//  Created by Gokul Ramesh on 19/11/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit

class CoachMarkViewController: UIViewController {
    //MARK: UI COMPONENT OUTLETS
    @IBOutlet weak var backGroundImageview: UIImageView!
    @IBOutlet weak var skipnextView: UIView!
    @IBOutlet weak var skipImg: UIImageView!
    @IBOutlet weak var nextImg: UIImageView!
    @IBOutlet weak var iPadSkipNextView: UIView!
    @IBOutlet weak var backgroundImgLeftContraint: NSLayoutConstraint!
    @IBOutlet weak var backgroundImgRightConstraints: NSLayoutConstraint!
    //MARK: VARIABLE DECLARATION
    var imgIndex = 0
    var maxImgIndex = 9
    var iPadImgs = ["pageone_tab", "pagetwo_tab", "pagethree_tab", "pagefour_tab", "pagefive_tab", "pagesix_tab", "pageseven_tab", "pageeight_tab", "pagenine_tab", "pageten_tab"]
    var iPhoneImgs = ["pageone", "pagetwo", "pagethree", "pagefour", "pagefive", "pagesix", "pageseven", "pageeight", "pagenine", "pageten"]
    //MARK: View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
        self.setBackgroundImg()
    }
    // UI Config
    func setUI() {   // setting up UI for coachmark
        self.skipnextView.isHidden = UIDevice.isPhone ? false : true
        self.iPadSkipNextView.isHidden = UIDevice.isPhone ? true : false
        self.skipImg.image = UIDevice.isPhone ? UIImage(named: ImageNames.iphoneSkipImage) : UIImage(named: ImageNames.ipadSkipImage)
        self.nextImg.image = UIDevice.isPhone ? UIImage(named: ImageNames.iphoneNextImage) : UIImage(named: ImageNames.ipadNextImage)
        if UIDevice.isPhone {
            if !UIDevice.current.hasNotch {
                self.backgroundImgLeftContraint.constant = KAppDelegate.keyWindow?.safeAreaInsets.top ?? 0
                self.backgroundImgRightConstraints.constant = KAppDelegate.keyWindow?.safeAreaInsets.bottom ?? 0
            }
        } else {
            self.backgroundImgLeftContraint.constant = -3
            self.backgroundImgRightConstraints.constant = -3
        }
    }
    func setBackgroundImg() {  // Setting background image
        self.backGroundImageview.image = UIDevice.isPhone ? UIImage(named: (self.imgIndex < self.iPhoneImgs.count) ? self.iPhoneImgs[self.imgIndex] : ImageNames.placeholderImage) : UIImage(named: (self.imgIndex < self.iPadImgs.count) ? self.iPadImgs[self.imgIndex] : ImageNames.placeholderImage)
    }
    //MARK: IBActions
    @IBAction func skipBtnClicked(_ sender: Any) { // Skip button tap on the initial coachmark screen
        CommonConst.coackmarkCompleteStatusCheck = false
        self.navigationController?.popViewController(animated: false)
    }
    @IBAction func nextBrnClicked(_ sender: Any) { // Next button tap on the initial coachmark screen
        if self.imgIndex < maxImgIndex {
            self.imgIndex += 1
            self.setBackgroundImg()
        } else {
            CommonConst.coackmarkCompleteStatusCheck = false
            self.navigationController?.popViewController(animated: false)
        }
    }
}
