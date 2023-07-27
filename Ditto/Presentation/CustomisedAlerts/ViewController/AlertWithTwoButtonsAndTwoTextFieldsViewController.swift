//
//  AlertWithTwoButtonsAndTwoTextFieldsViewController.swift
//  Ditto
//
//  Created by Abiya Joy on 02/06/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit

class AlertWithTwoButtonsAndTwoTextFieldsViewController: UIViewController {
    // MARK: UI COMPONENT OUTLETS
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var networkTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var eyeIcon: UIButton!
    // MARK: VARIABLE DECLARATION
    var netWorkName = String()
    var iconClick = true
    var connectToWifi: (() -> Void)? // TRAC_564
    var onCancelPressed: (() -> Void)? // TRAC_564
    // MARK: View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.networkTextField.text = netWorkName
    }
    // MARK: UI COMPONENT ACTIONS
    @IBAction func connectToWiFiClicked(_ sender: UIButton) {   // Right button action
        self.connectToWifi?()
    }
    @IBAction func cancelClicked(_ sender: UIButton) {   // Left button action
        self.onCancelPressed?()
    }
    @IBAction func refreshButtonClicked(_ sender: UIButton) {   // Top Refresh button action
    }
    @IBAction func iconAction(sender: AnyObject) {   // Password icon action
        self.passwordTextField.isSecureTextEntry = self.iconClick ? false : true
        let iconImage = self.iconClick ? ImageNames.eyeFillImage : ImageNames.eyeSlashFillImage
        self.eyeIcon.setImage(UIImage(systemName: iconImage), for: .normal)
        self.iconClick = !self.iconClick
    }
}
