//
//  AlertWithImageAndButtonsViewController.swift
//  Ditto
//
//  Created by Abiya Joy on 03/06/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit

class AlertWithImageAndButtonsViewController: UIViewController {
    // MARK: UI COMPONENT OUTLETS 
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var alertImageView: UIImageView!
    @IBOutlet weak var alertDescriptionLabel: UILabel!
    @IBOutlet weak var alertLeftButton: UIButton!
    @IBOutlet weak var alertRightButton: UIButton!
    @IBOutlet weak var thirdButton: UIButton!
    // MARK: VARIABLE DECLARATION
    var onTutorialPressed: (() -> Void)?
    var onOKPressed: (() -> Void )?
    var onRetryPressed: (() -> Void)?
    var onCancelPressed: (() -> Void)?
    var onUpdateNowPressed: (() -> Void)?
    var onDismissPressed: (() -> Void)?
    var onTailornovaAlertOKPressed: (() -> Void)?
    var alertArray = [String]()
    var screenType = FormatsString.emptyString
    // MARK: View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.alertImageView.image = UIImage(named: self.alertArray[0])
        self.alertDescriptionLabel.text = self.alertArray[1]
        self.alertLeftButton.setTitle(self.alertArray[2], for: .normal)
        self.alertRightButton.setTitle(self.alertArray[3], for: .normal)
        self.thirdButton.setTitle(self.alertArray[4], for: .normal)
    }
    // MARK: UI COMPONENT ACTIONS
    @IBAction func alertWithThirdButton(_ sender: Any) {   // Left button action
        if thirdButton.titleLabel?.text == AlertTitle.TUTORIAL {
            self.onTutorialPressed?()
        }
    }
    @IBAction func alertLeftButtonAction(_ sender: UIButton) {   // Middle button action
        if screenType == ScreenTypeString.softwareUpdatePresent {
            self.onDismissPressed?()
        } else {
            if screenType == ScreenTypeString.PatternDesc && self.alertLeftButton.titleLabel?.text == AlertTitle.RETRY {
                self.onRetryPressed?()
            } else {
                self.dismiss(animated: false) {
                    self.onCancelPressed?()
                }
            }
        }
    }
    @IBAction func alertRightButtonAction(_ sender: UIButton) {   // Right button action
        if screenType == ScreenTypeString.softwareUpdatePresent {
            self.onUpdateNowPressed?()
        } else if screenType == ScreenTypeString.tailornovaAlert {
            self.dismissController()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.onTailornovaAlertOKPressed?()
            }
        } else if screenType == ScreenTypeString.PatternDesc && self.alertRightButton.titleLabel?.text == AlertTitle.CANCEL {
            self.dismiss(animated: false) {
                self.onCancelPressed?()
            }
        } else if self.alertRightButton.titleLabel?.text == AlertTitle.RETRY {
            self.onRetryPressed?()
        } else {
            self.onOKPressed?()
        }
    }
}
