//
//  AccountSettingsViewController.swift
//  Ditto
//
//  Created by Gokul Ramesh on 02/02/22.
//  Copyright © 2022 Infosys. All rights reserved.
//

import UIKit

class AccountSettingsViewController: UIViewController {
    // MARK: UI COMPONENT OUTLETS
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var firstNameLbl: UILabel!
    @IBOutlet weak var secondNameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var phoneNumberLbl: UILabel!
    @IBOutlet weak var subscriptionExpiryLbl: UILabel!
    @IBOutlet weak var descriptionTxTFielf: UITextView!
    // MARK: VARIABLE DECLARATION
    var accountSettingViewModel = AccountSettingViewModel()
    // MARK: View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    func setUI() {   // UI Value populating code
        _ = self.descriptionTxTFielf.layoutManager   // iOS 16 crash fix
        self.firstNameLbl.text = CommonConst.firstNameValue
        self.secondNameLbl.text = CommonConst.lastNameValue
        self.emailLbl.text = CommonConst.loginEmailText
        self.phoneNumberLbl.text = CommonConst.loginPhoneText
        self.subscriptionExpiryLbl.text = self.accountSettingViewModel.subscriptionDaysLeft() + FormatsString.daysLeftLabel
        self.descriptionTxTFielf.text = AlertMessage.deleteScreenDescription
        self.descriptionTxTFielf.isUserInteractionEnabled = false
    }
    func accountSettingsApihit() {   // Delete account API call
        ServiceManagerProxy.shared.deleteAccount(urlStr: Apis.deleteAccount + "/\(CommonConst.customerNoText)") { (resp) in
            if let dataJson = resp, dataJson.success {
                self.accountSettingViewModel.accountDeletionLogic()
                self.root(selectedStoryboard: .login, identifier: Constants.LoginViewControllerIdentifier)
            } else {
                ServiceManagerProxy.shared.displayerrorPopup(url: Apis.deleteAccount + "/\(CommonConst.customerNoText)", responseError: AlertMessage.apiFailedText)
            }
        }
    }
    func displayAlert() {   // Popup for Delete action confirmation
        DispatchQueue.main.async {
            let viewc = Constants.AlertWithImageAndButtons.instantiateViewController(identifier: Constants.AlertWithImageAndButonsVCIdentifier) as AlertWithImageAndButtonsViewController
            viewc.alertArray = [ImageNames.updateAvailableImage, AlertMessage.deleteAlertText, AlertTitle.YES, AlertTitle.NOButton, FormatsString.emptyString]
            viewc.modalPresentationStyle = .overFullScreen
            viewc.onOKPressed = {
                Proxy.shared.keyWindow?.rootViewController?.dismiss(animated: false, completion: nil)
            }
            viewc.onCancelPressed = {
                Proxy.shared.keyWindow?.rootViewController?.dismiss(animated: false, completion: {
                    self.accountSettingsApihit()
                })
            }
            if Proxy.shared.keyWindow?.rootViewController?.presentedViewController == nil {
                Proxy.shared.keyWindow?.rootViewController?.present(viewc, animated: false, completion: nil)
            }
        }
    }
    // MARK: UI COMPONENT ACTIONS
    @IBAction func backBtnTapped(_ sender: Any) {   // Back button Action
        self.pop()
    }
    @IBAction func deleteAccount(_ sender: Any) {   // Delete account button Action
        self.displayAlert()
    }
}
