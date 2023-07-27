//
//  AlertWithTwoButtonsAndTitleViewController.swift
//  Ditto
//
//  Created by Abiya Joy on 02/06/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit

class AlertWithTwoButtonsAndTitleViewController: UIViewController {
    //MARK: UI COMPONENT OUTLETS
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var alertTitleLabel: UILabel!
    @IBOutlet weak var alertDescriptionLabel: UILabel!
    @IBOutlet weak var alertLeftButton: UIButton!
    @IBOutlet weak var alertRightButton: UIButton!
    //MARK: VARIABLE DECLARATION
    var onYesPressed: (() -> Void)?
    var onNoPressed: (() -> Void)?
    var onOkInMirrorPressed: (() -> Void)?
    var onCancelInMirrorPressed: (() -> Void)?
    var onGetStartedWiFiLaterPressed: (() -> Void)?
    var onGetStartedBLELaterPressed: (() -> Void)?
    var onCancelInDeleteFolderPressed: (() -> Void)?
    var onOkInDeleteFolderPressed: (() -> Void)?
    var screenType = FormatsString.emptyString
    var alertArray = [String]()
    //MARK: View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.alertTitleLabel.text = self.alertArray[0]
        if self.screenType == ScreenTypeString.fromSpliceAlert && self.alertArray[1].contains(FormatsString.attributedStringLabel) {
            let finalStr = self.alertArray[1].replacingOccurrences(of: FormatsString.attributedStringLabel, with: FormatsString.emptyString, options: NSString.CompareOptions.literal, range: nil)
            let mailSize =  UIDevice.isPad ? CGFloat(18) : CGFloat(14)
            let strNumber: NSString = finalStr as NSString
            let range = (strNumber).range(of: FormatsString.tracingLabel)
            let attribute = NSMutableAttributedString.init(string: finalStr as String)
            attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black, range: range)
            attribute.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
            attribute.addAttribute(.font, value: CustomFont.avenirLtProDemi(size: mailSize) ?? UIFont.systemFont(ofSize: mailSize), range: range)
            self.alertDescriptionLabel.attributedText = attribute
        } else {
            self.alertDescriptionLabel.text = self.alertArray[1]
        }
        self.alertLeftButton.setTitle(self.alertArray[2], for: .normal)
        self.alertRightButton.setTitle(self.alertArray[3], for: .normal)
    }
    //MARK: UI COMPONENT ACTIONS
    @IBAction func alertLeftButtonAction(_ sender: UIButton) {
        if self.alertLeftButton.titleLabel?.text == AlertTitle.LATER {
            if self.screenType == ConnectivityMessages.needWiFiDescription {
                self.onGetStartedWiFiLaterPressed?()
            } else if self.screenType == ConnectivityMessages.needBLEDescription {
                self.onGetStartedBLELaterPressed?()
            } else {
                self.dismiss(animated: false, completion: nil)
            }
        } else if self.screenType ==  CalibrationMessages.calibrationScreenConfirmation {
            self.onNoPressed?()
        } else if self.screenType ==  ScreenTypeString.PatternDesc {
            self.dismiss(animated: false, completion: nil)
        } else if self.screenType == ScreenTypeString.mirrorScreen {
            self.onCancelInMirrorPressed?()
        } else if self.screenType == ScreenTypeString.deleteFolder {
            self.onCancelInDeleteFolderPressed?()
        }
    }
    @IBAction func alertRightButtonAction(_ sender: UIButton) {
        if self.alertRightButton.titleLabel?.text == AlertTitle.SETTINGS {
            self.dismiss(animated: false, completion: {
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                    return
                }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(URL(string: FormatsString.appSettings)!)
                }
            })
        } else if self.screenType == CalibrationMessages.calibrationScreenConfirmation {
            self.onYesPressed?()
        } else if self.screenType == ScreenTypeString.mirrorScreen {
            self.onOkInMirrorPressed?()
        } else if self.screenType == ScreenTypeString.fromSpliceAlert {
            self.dismiss(animated: false, completion: nil)
        } else if self.screenType == ScreenTypeString.PatternDesc {
            self.onYesPressed?()
        } else if self.screenType == ScreenTypeString.deleteFolder {
            self.onOkInDeleteFolderPressed?()
        }
    }
}
