//
//  WorkspaceAreaView.swift
//  JoannTraceApp
//
//  Created by Prabha Rajalakshmi N on 16/08/20.
//  Copyright © 2020 Infosys. All rights reserved.
//

import UIKit
import QuartzCore

protocol spliceDelegate: AnyObject {
    func spliceImage(withTag: SpliceConstant)
}
protocol mirrorDelegate: AnyObject {
    func mirrorDone(done: Bool, imgV: UIImageView, isMirrorV: Bool)
    func mirrorAlertCancelTap(imgV: UIImageView)
}
protocol rotateDelegate: AnyObject {
    func rotateDropDownTapped()
}

class WorkspaceAreaView: UIView {
    //MARK: UI COMPONENT OUTLETS
    @IBOutlet var spliceRightButton: UIButton!
    @IBOutlet var spliceButtomButton: UIButton!
    @IBOutlet var spliceTopButton: UIButton!
    @IBOutlet var spliceLeftButton: UIButton!
    @IBOutlet weak var spliceButtomAnimation: ShowLottieSplice!
    @IBOutlet var spliceRightAnimation: UIView!
    @IBOutlet var spliceTopAnimation: UIView!
    @IBOutlet var spliceLeftAnimation: UIView!
    @IBOutlet var spliceLeftButtonWidthConstant: NSLayoutConstraint!
    @IBOutlet var spliceRightButtonWidthConstant: NSLayoutConstraint!
    @IBOutlet var spliceTopButtonHeightConstant: NSLayoutConstraint!
    @IBOutlet var spliceBottomHeightConstant: NSLayoutConstraint!
    @IBOutlet weak var mirrorVipad: UIButton!
    @IBOutlet weak var mirrorHipad: UIButton!
    @IBOutlet weak var mirrorH: UIButton!
    @IBOutlet weak var mirrorV: UIButton!
    @IBOutlet var workAreaView: UIView!
    @IBOutlet var workAreaOptionsViewHeightConstraintForiPad: NSLayoutConstraint! = NSLayoutConstraint()
    @IBOutlet var workAreaOptionViewWidthConstraintForiPhone: NSLayoutConstraint! = NSLayoutConstraint()
    @IBOutlet var splicedScreenLabel: UILabel!
    @IBOutlet weak var selectAllipad: UIButton!
    @IBOutlet weak var selectAllButton: UIButton!
    @IBOutlet var workAreaOptionViewforiPhone: UIView!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var clearButtoniPad: UIButton!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var connectRecalibrateButton: UIButton!
    @IBOutlet weak var buttonIpadConnectRecalibrate: UIButton!
    @IBOutlet weak var viewSelectAll: UIView!
    @IBOutlet weak var viewClear: UIView!
    @IBOutlet weak var viewConnect: UIView!
    @IBOutlet var buttonIpadSewingInstruction: UIButton!
    @IBOutlet var buttonIpadTutorial: UIButton!
    @IBOutlet var buttonIphoneSewingInstruction: UIButton!
    @IBOutlet var buttonIphoneTutorial: UIButton!
    @IBOutlet var constraintHeightIphoneTutorial: NSLayoutConstraint!
    @IBOutlet var constraintHeightIpadTutorial: NSLayoutConstraint!
    @IBOutlet var constraintHeightIpadTutorialButton: NSLayoutConstraint!
    @IBOutlet var constraintHeightIphoneTutorialButton: NSLayoutConstraint! // 26
    @IBOutlet weak var constraintTopIpad: NSLayoutConstraint!
    @IBOutlet weak var constraintBottomIpad: NSLayoutConstraint!
    @IBOutlet weak var constraintBotttomTopIpad: NSLayoutConstraint!
    @IBOutlet weak var constraintBotttomBottomIpad: NSLayoutConstraint!
    @IBOutlet weak var constraintTopIphone: NSLayoutConstraint!  // 10
    @IBOutlet weak var constraintBottomIphone: NSLayoutConstraint! // 10
    @IBOutlet weak var viewIpadTutorialSewing: UIView!
    @IBOutlet weak var viewIphoneTutorialSewing: UIView!
    @IBOutlet weak var doubleTapToZoomLabel: UILabel!
    @IBOutlet weak var borderImageTop: UIImageView!
    @IBOutlet weak var borderImageBottom: UIImageView!
    @IBOutlet weak var borderImageLeft: UIImageView!
    @IBOutlet weak var borderImageRight: UIImageView!
    @IBOutlet weak var rotateDropDowniPhoneView: UIView!
    @IBOutlet weak var rotateDropDowniPhoneButton: UIButton!
    @IBOutlet weak var rotateDropDowniPhoneArrow: UIButton!
    @IBOutlet weak var rotateDropDowniPadView: UIView!
    @IBOutlet weak var rotateDropDowniPadArrow: UIButton!
    @IBOutlet weak var rotateDropDowniPadButton: UIButton!
    //MARK: VARIABLE DECLARATION
    var afterMirror: CGAffineTransform = CGAffineTransform(scaleX: 1, y: 1)
    var contentView: UIView! = UIView()
    var checkAlertShown: Bool = false
    var tappedImgVw = UIImageView()
    var mirroringDelegate: mirrorDelegate?
    var spliceDelegate: spliceDelegate?
    var rotateDelegate: rotateDelegate?
    var currentImageRowValue = 0
    var currentImageColumnValue = 0
    var isMirrorAlertHiddenCheck: Bool = true
    var tapped: Bool = false
    @objc open dynamic var checkFlippedV: Bool = false {
        didSet {
            self.afterMirror = self.tappedImgVw.transform
        }
    }
    @objc open dynamic var checkFlippedH: Bool = false {
        didSet {
            self.afterMirror = self.tappedImgVw.transform
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.nibSetup()
        self.mirrorH.isEnabled = false
        self.mirrorV.isEnabled = false
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.nibSetup()
    }
    private func nibSetup() {
        self.setNeedsLayout()
        self.layoutIfNeeded()
        self.contentView = self.loadViewFromNib()
        self.contentView.frame = self.bounds
        self.workAreaView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.contentView.translatesAutoresizingMaskIntoConstraints = true
        addSubview(self.contentView)
        self.splicedScreenLabel.isHidden = true
        self.viewIpadTutorialSewing.isHidden = UIDevice.isPhone ? true : false
        self.buttonIpadSewingInstruction.isHidden = UIDevice.isPhone ? true : false
        self.buttonIpadTutorial.isHidden = UIDevice.isPhone ? true : false
        self.buttonIpadConnectRecalibrate.isHidden = UIDevice.isPhone ? true : false
        self.viewIphoneTutorialSewing.isHidden = UIDevice.isPad ? true : false
        self.workAreaOptionViewforiPhone.isHidden = UIDevice.isPad ? true : false
        self.rotateDropDowniPhoneView.isHidden = UIDevice.isPad ? true : false
        self.rotateDropDowniPadView.isHidden = UIDevice.isPhone ? true : false
        if UIDevice.isPhone {
            self.constraintHeightIpadTutorial.constant = 0
            self.constraintTopIpad.constant = 0
            self.constraintBottomIpad.constant = 0
            self.constraintHeightIpadTutorialButton.constant = 0
            self.constraintBotttomTopIpad.constant = 0
            self.constraintBotttomBottomIpad.constant = 0
            self.self.workAreaOptionsViewHeightConstraintForiPad?.constant = 0
        } else {
            self.constraintHeightIphoneTutorial.constant = 0
            self.workAreaOptionViewWidthConstraintForiPhone?.constant = 5
        }
        self.contentView.layoutIfNeeded()
        self.contentView.setNeedsLayout()
    }
    private func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: ReusableCellIdentifiers.workspaceAreaViewIdentifier, bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as? UIView
        return nibView!
    }
    func showAlertForMirror(direction: String ) {   // Alert to enquire if need to mirror or not.
        DispatchQueue.main.async {
            let viewc = Constants.AlertWithTwoButtonsAndTitle.instantiateViewController(identifier: Constants.AlertWithTwoButonsTitleVCIdentifier) as AlertWithTwoButtonsAndTitleViewController
            viewc.alertArray = [AlertTitle.mirror, AlertMessage.mirrorAlertText, AlertTitle.cancel, AlertTitle.OKButton]
            viewc.screenType = ScreenTypeString.mirrorScreen
            viewc.modalPresentationStyle = .overFullScreen
            viewc.onOkInMirrorPressed = {
                Proxy.shared.keyWindow?.rootViewController?.dismiss(animated: false, completion: {
                    self.checkAlertShown = true
                    if direction == FormatsString.mirrorDirectionV {
                        self.mirrorImageV()
                    } else {
                        self.mirrorImageH()
                    }
                })
            }
            viewc.onCancelInMirrorPressed = {
                Proxy.shared.keyWindow?.rootViewController?.dismiss(animated: false, completion: {
                    self.checkAlertShown = true
                    self.mirroringDelegate?.mirrorAlertCancelTap(imgV: self.tappedImgVw)
                })
            }
            if Proxy.shared.keyWindow?.rootViewController?.presentedViewController == nil {
                Proxy.shared.keyWindow?.rootViewController?.present(viewc, animated: false, completion: nil)
            }
        }
    }
    func mirrorImageV() {   // MirrorV logic
        let rotated = tappedImgVw.transform.b
        if !self.checkFlippedV {   // Check if already mirrorv is done
            self.tappedImgVw.transform = self.checkFlippedH ? CGAffineTransform(scaleX: -1, y: -1) : CGAffineTransform(scaleX: 1, y: -1)
        } else {
            self.tappedImgVw.transform = self.checkFlippedH ? CGAffineTransform(scaleX: -1, y: 1) : CGAffineTransform(scaleX: 1, y: 1)
        }
        self.checkFlippedV = !self.checkFlippedV ? true : false
        self.afterMirror = self.tappedImgVw.transform
        self.contentView.layoutIfNeeded()
        self.contentView.setNeedsLayout()
        if rotated != 0 {
            self.movePatternPieceToVisibleArea(tappedImgVw: self.tappedImgVw)
        }
        self.mirroringDelegate?.mirrorDone(done: true, imgV: self.tappedImgVw, isMirrorV: true)
    }
    func mirrorImageH() {   // MirrorH logic
        let rotated = self.tappedImgVw.transform.b
        if !self.checkFlippedH {   // Check if already mirrorh is done
            self.tappedImgVw.transform = self.checkFlippedV ? CGAffineTransform(scaleX: -1, y: -1) : CGAffineTransform(scaleX: -1, y: 1)
        } else {
            self.tappedImgVw.transform = self.checkFlippedV ? CGAffineTransform(scaleX: 1, y: -1) : CGAffineTransform(scaleX: 1, y: 1)
        }
        self.checkFlippedH = !self.checkFlippedH ? true : false
        self.afterMirror = self.tappedImgVw.transform
        self.contentView.layoutIfNeeded()
        self.contentView.setNeedsLayout()
        if rotated != 0 {
            self.movePatternPieceToVisibleArea(tappedImgVw: self.tappedImgVw)
        }
        self.mirroringDelegate?.mirrorDone(done: true, imgV: self.tappedImgVw, isMirrorV: false)
    }
    func movePatternPieceToVisibleArea(tappedImgVw: UIImageView) {   // Code to keep a piece with mirroring after doing a vertical rotation on a piece at corner of WS inside the WS area itself
        if tappedImgVw.frame.origin.x < 0 {
            tappedImgVw.frame.origin.x = 0
        }
        if tappedImgVw.frame.origin.y < 0 {
            tappedImgVw.frame.origin.y = 0
        }
        if  tappedImgVw.frame.minX < self.workAreaView.frame.minX {
            tappedImgVw.frame.origin.x = 0
        }
        if  tappedImgVw.frame.minY < self.workAreaView.frame.minY {
            tappedImgVw.frame.origin.y = 0
        }
        if tappedImgVw.frame.origin.x + tappedImgVw.frame.width >= self.workAreaView.frame.width {
            tappedImgVw.frame.origin.x = (tappedImgVw.frame.origin.x < 0) ? 0 : (self.workAreaView.frame.width - tappedImgVw.frame.width)
        }
        if tappedImgVw.frame.origin.y + tappedImgVw.frame.height >= self.workAreaView.frame.height {
            tappedImgVw.frame.origin.y = self.workAreaView.frame.height - tappedImgVw.frame.height
        }
    }
    //MARK: UI COMPONENT ACTIONS
    @IBAction func mirrorHClicked(_ sender: UIButton) {   // MirrorH button action
        if !self.isMirrorAlertHiddenCheck {   // Check for WS Setting screen switch status for mirror alert
            if !self.checkAlertShown {   // Check for if mirror alert shown once or not
                self.showAlertForMirror(direction: FormatsString.mirrorDirectionH)
            } else {
                self.mirrorImageH()
            }
        } else {
            self.mirrorImageH()
        }
    }
    @IBAction func mirrorVClicked(_ sender: UIButton) {   // MirrorH button action
        if !self.isMirrorAlertHiddenCheck {   // Check for WS Setting screen switch status for mirror alert
            if !self.checkAlertShown {   // Check for if mirror alert shown once or not
                self.showAlertForMirror(direction: FormatsString.mirrorDirectionV)
            } else {
                self.mirrorImageV()
            }
        } else {
            self.mirrorImageV()
        }
    }
    @IBAction func spliceAction(_ sender: UIButton) {   // Splice button action
        self.tapped = true
        self.spliceDelegate?.spliceImage(withTag: SpliceConstant(rawValue: sender.tag)!)
    }
    @IBAction func rotateDropDownClicked(_ sender: Any) {   // Rotate drop down tap action
        self.rotateDelegate?.rotateDropDownTapped()
    }
}
