//
//  SplashViewController.swift
//  JoannTraceApp
//
//  Created by Gaurav Rajan on 15/04/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import Alamofire

class SplashViewController: UIViewController {
    var splashViewModel = SplashViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = true
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
    }
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.setRootViewController()
        }
    }
    //Rohith
    // handling user user first time login here
    func setRootViewController() {  // If already logged in navigate to home screen, else go to login screen
        CommonConst.navCheckValue = 0
        CommonConst.guestUserCheck = false
        let getUser = DatabaseHelper().fetchAllObjectsOfEntity(DBEntities.userDb)
        if getUser.first == nil {
            if CommonConst.appUpdatedStatusCheck {
                print(CommonConst.appUpdatedStatusCheck)
                UserDefaults.standard.set(false, forKey: "isChecked")// establishing user first time login

                self.root(selectedStoryboard: .login, identifier: Constants.LoginViewControllerIdentifier)
            } else {
                self.splashViewModel.logOutUser(viewController: self)  // Logout User from the App when there is DB Change
                UserDefaults.standard.set(false, forKey: "isChecked")

            }
        } else if (getUser.first as? User) != nil {
            CommonConst.navCheckValue = 1
            if CommonConst.appUpdatedStatusCheck {
                print(CommonConst.appUpdatedStatusCheck)
                UserDefaults.standard.set(true, forKey: "isChecked")

                self.rootWithDrawer(mainVCStoryboard: .dashboard, mainVCIdentifier: Constants.HomeViewControllerIdentifier, sideVCStoryboard: .dashboard, sideVCIdentifier: Constants.HamburgerViewControllerIdentifier)
            } else {
                self.splashViewModel.logOutUser(viewController: self)  // Logout User from the App when there is DB Change
            }
        }
        if CommonConst.versionAlertStatusOnLaunch {
            let tStamp = "\(Int(Date().timeIntervalSince1970))"
            ServiceManagerProxy.shared.getDittoVersion(timeStamp: tStamp, fromHamburgerUpdate: false)
        }
    }
}
