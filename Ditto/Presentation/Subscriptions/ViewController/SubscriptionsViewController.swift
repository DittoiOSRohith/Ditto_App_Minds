//
//  SubscriptionsViewController.swift
//  Ditto
//
//  Created by Gokul Ramesh on 22/06/22.
//  Copyright © 2022 Infosys. All rights reserved.
//

import UIKit

class SubscriptionsViewController: UIViewController {
    // MARK: UI COMPONENT OUTLETS
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var firstNameLbl: UILabel!
    @IBOutlet weak var lastNameLbl: UILabel!
    @IBOutlet weak var emailLbl: UILabel!
    @IBOutlet weak var phoneNumberLbl: UILabel!
    @IBOutlet weak var subscriptionExpiryLbl: UILabel!
    @IBOutlet weak var descriptionTxTFielf: UITextView!
    // MARK: VARIABLE DECLARATION
    var subscriptionViewModel = SubscriptionsViewModel()
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
    //Rohith
    func setUI() {   // UI Value populating code
        _ = self.descriptionTxTFielf.layoutManager   // iOS 16 crash fix
        self.firstNameLbl.text = CommonConst.firstNameValue
        self.lastNameLbl.text = CommonConst.lastNameValue
        self.emailLbl.text = CommonConst.loginEmailText
        self.phoneNumberLbl.text = CommonConst.loginPhoneText
        self.subscriptionExpiryLbl.text = self.subscriptionViewModel.subscriptionDaysLeft() + FormatsString.daysLeftLabel
        self.descriptionTxTFielf.text = AlertMessage.subscriptionRenewDescFirst + self.subscriptionViewModel.subscriptionDaysLeft() + FormatsString.daysLabel + AlertMessage.subscriptionRenewDescSecond
        if CommonConst.subscriptionStatusText.uppercased() == FormatsString.PAUSED {
            self.descriptionTxTFielf.text = AlertMessage.subscriptionPausedText
        } else if CommonConst.subscriptionStatusText.uppercased() == FormatsString.EXPIRED {
            self.descriptionTxTFielf.text = AlertMessage.subscriptionExpiredText
        }else  if CommonConst.subscriptionStatusText.uppercased() == FormatsString.CANCELLED {// when user subscription cancelled 
            self.descriptionTxTFielf.text = AlertMessage.subscriptionCancelledText
            self.descriptionTxTFielf.textColor = .red

        }
        self.descriptionTxTFielf.isUserInteractionEnabled = false
    }
    // MARK: UI COMPONENT ACTIONS
    @IBAction func backBtnTapped(_ sender: Any) {   // Back button Action
        self.pop()
    }
    @IBAction func renewSubscriptionButtonTapped(_ sender: UIButton) {   // Renew Subscription button Action
        self.subscriptionViewModel.gotoSubscriptionView()
    }
}
