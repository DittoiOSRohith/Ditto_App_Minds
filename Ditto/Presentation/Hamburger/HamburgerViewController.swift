//
//  HamburgerViewController.swift
//  Ditto
//
//  Created by Abiya Joy on 24/04/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController {
    //MARK: UI COMPONENT OUTLETS
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailIdLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var hamTableView: UITableView!
    @IBOutlet weak var qualityImageOutlet: UIImageView!
    @IBOutlet weak var subsriptionLabel: UILabel!
    @IBOutlet weak var dayleftLabel: UILabel!
    //MARK: VARIABLE DECLARATION
    var objHamburgerViewModel = HamburgerViewModel()
    var tapGesture = UITapGestureRecognizer()
    //MARK: View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.qualityImageOutlet.isHidden = true
        self.subsriptionLabel.isHidden = true
        self.dayleftLabel.isHidden = true
        if CommonConst.guestUserCheck {   // Setting hamburger data for Guest user
            self.nameLabel.text = FormatsString.hamburgerNameLabel
            let signInText = FormatsString.hamburgerSignInLabel
            let textRange = NSRange(location: 0, length: 7)
            let attributedText = NSMutableAttributedString(string: signInText)
            attributedText.addAttribute(.underlineStyle,
                                                value: NSUnderlineStyle.single.rawValue,
                                                range: textRange)
            self.tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tapResponse))
            self.emailIdLabel.isUserInteractionEnabled =  true
            self.emailIdLabel.addGestureRecognizer(self.tapGesture)
            self.emailIdLabel.attributedText = attributedText
            self.phoneLabel.isHidden = true
            self.objHamburgerViewModel.arrHamBurgerMenu = self.objHamburgerViewModel.removeWorkspaceSettingsCell()
        } else {   // Setting hamburger data for Regular user
            self.nameLabel.text = CommonConst.firstNameValue
            self.emailIdLabel.text = CommonConst.loginEmailText
            self.phoneLabel.text = CommonConst.loginPhoneText
            self.qualityImageOutlet.isHidden = false
            self.subsriptionLabel.isHidden = false
            self.dayleftLabel.isHidden = false
            var relativeDays = 0
            if CommonConst.subscribeValid && CommonConst.subscribeEndDate != FormatsString.emptyString {   // Calculation of Subscription days left logic
                let endDateGiven = CommonConst.subscribeEndDate
                let currentDate = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = FormatsString.dateFormat
                if let convertedEndDate = dateFormatter.date(from: endDateGiven) {
                    relativeDays = Calendar.current.dateComponents([.day], from: currentDate, to: convertedEndDate).day ?? 0
                }
            }
            relativeDays = (relativeDays >= 0) ? relativeDays : 0
            self.dayleftLabel.text = "\(relativeDays)" + FormatsString.daysLeftLabel
        }
    }
    override func viewDidLayoutSubviews() {
        self.hamTableView.reloadData()
    }
    @objc func tapResponse(recognizer: UITapGestureRecognizer) {   // Sign In text tap on menu
        if let mailLbl = self.emailIdLabel {
            if self.tapGesture.didTapAttributedTextInLabel(label: mailLbl, inRange: NSRange(location: 0, length: 6)) {
                CommonConst.navCheckValue = 0
                self.root(selectedStoryboard: .login, identifier: Constants.LoginViewControllerIdentifier)
            }
        }
    }
}
