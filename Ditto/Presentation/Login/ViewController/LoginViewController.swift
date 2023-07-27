//
//  LoginViewController.swift
//  iOS_TraceJoAnn
//
//  Created by Infosys on 03/08/20.
//  Copyright © 2020 Infosys. All rights reserved.
//

import UIKit
import CoreBluetooth
import Alamofire

class LoginViewController: UIViewController {
    //MARK: UI COMPONENT OUTLETS
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginImageView: UIImageView!
    @IBOutlet weak var forgotPasswordLabel: UILabel!
    @IBOutlet weak var seeMoreLabel: UILabel!
    @IBOutlet weak var signUpLabel: UILabel!
    @IBOutlet weak var weGotThisView: UIView!
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var eyeIcon: UIButton!
    //MARK: VARIABLE DECLARATION
    var objLoginViewModel = LoginViewModel()
    //MARK: View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.objLoginViewModel.getContentForLoginScreen { _ in
            self.imageDisplayFunction()
            self.dismissLottie()
        }
        DispatchQueue.main.async {
            UITextField.connectFields(fields: [self.emailTextField, self.passwordTextField ] )
            self.versionLabel.text = "\(FormatsString.versionText) \(AppInfo.versionNumber)"
            self.emailTextField.borderColor = CustomColor.textFieldBorder.withAlphaComponent(0.30)
            self.passwordTextField.borderColor = CustomColor.textFieldBorder.withAlphaComponent(0.30)
            self.gestureHandling()
            #if DEBUG
            self.emailTextField.autocorrectionType = .no
//            self.emailTextField.text = "abiya.joy25@gmail.com"
//            self.passwordTextField.text = "Admin@123"
//Rohith
                // defult login
            self.emailTextField.text = "rohithk@appmindsglobal.com"
            self.passwordTextField.text = "Abc@1234"

            #endif
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        self.view.bringSubviewToFront(weGotThisView)
    }
    func gestureHandling() {  // tap gestures handling
        self.objLoginViewModel.forgotPasswordGesture = UITapGestureRecognizer(target: self, action: #selector(forgotPasswordTapped(_ :)))
        self.objLoginViewModel.forgotPasswordGesture.numberOfTapsRequired = 1
        self.forgotPasswordLabel!.addGestureRecognizer(self.objLoginViewModel.forgotPasswordGesture)
        self.objLoginViewModel.signUpGesture = UITapGestureRecognizer(target: self, action: #selector(signUpTapped(_ :)))
        self.objLoginViewModel.signUpGesture.numberOfTapsRequired = 1
        self.signUpLabel!.addGestureRecognizer(self.objLoginViewModel.signUpGesture)
        self.objLoginViewModel.seeMoreGesture = UITapGestureRecognizer(target: self, action: #selector(seeMoreTapped(_ :)))
        self.objLoginViewModel.seeMoreGesture.numberOfTapsRequired = 1
        self.seeMoreLabel!.addGestureRecognizer(self.objLoginViewModel.seeMoreGesture)
    }
    func imageDisplayFunction() {  // image display in login screen
        DispatchQueue.main.async {
            let imageURL = URL(string: "\(self.objLoginViewModel.loginImageName)")
            self.loginImageView.sd_setImage(with: imageURL, placeholderImage: UIImage(named: ImageNames.placeholderImage)) { (image, err, _, _) in
                self.loginImageView.image = (err == nil) ? image : UIImage(named: ImageNames.placeholderImage)
            }
        }
    }
    //MARK: UI COMPONENT ACTIONS
    @IBAction func signInButtonClicked(_ sender: Any) {  // Login button action
        if let email = self.emailTextField.text, let password = self.passwordTextField.text {
            let loginParams = LoginParams(email: email, password: password)
            self.objLoginViewModel.hitLoginApi(postParam: loginParams) {
                if !CommonConst.isInstructionSavedCheck {
                    GetStartedViewController().objGetStartedViewModel.getContentForGetStartedAndTutorials { _ in
                        CommonConst.isInstructionSavedCheck = true
                        CommonConst.guestUserCheck = false
                        CommonConst.navCheckValue = 1
                       // UserDefaults.standard.set(true, forKey: "isChecked")
                        self.rootWithDrawer(mainVCStoryboard: .dashboard, mainVCIdentifier: Constants.HomeViewControllerIdentifier, sideVCStoryboard: .dashboard, sideVCIdentifier: Constants.HamburgerViewControllerIdentifier)
                    }
                } else {
                    CommonConst.guestUserCheck = false
                    CommonConst.navCheckValue = 1
                    self.rootWithDrawer(mainVCStoryboard: .dashboard, mainVCIdentifier: Constants.HomeViewControllerIdentifier, sideVCStoryboard: .dashboard, sideVCIdentifier: Constants.HamburgerViewControllerIdentifier)
                }
            }
        }
    }
    @IBAction func iconAction(sender: AnyObject) {   // Password icon action
        self.passwordTextField.isSecureTextEntry = self.objLoginViewModel.iconClick ? false : true
        let iconImage = self.objLoginViewModel.iconClick ? ImageNames.eyeFillImage : ImageNames.eyeSlashFillImage
        self.eyeIcon.setImage(UIImage(systemName: iconImage), for: .normal)
        self.objLoginViewModel.iconClick = !self.objLoginViewModel.iconClick
    }
    @objc func forgotPasswordTapped(_ gesture: UITapGestureRecognizer) {  // Forgot password action
        guard let url = URL(string: Apis.forgotPassword), !url.absoluteString.isEmpty else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    @objc func signUpTapped(_ gesture: UITapGestureRecognizer) {  // Signup button action
        guard let url = URL(string: Apis.signUp), !url.absoluteString.isEmpty else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
    @objc func seeMoreTapped(_ gesture: UITapGestureRecognizer) {   // Guestpreview action
        if !CommonConst.isInstructionSavedCheck {
            if let manager = NetworkReachabilityManager(), manager.isReachable {
                GetStartedViewController().objGetStartedViewModel.getContentForGetStartedAndTutorials { _ in
                    CommonConst.isInstructionSavedCheck = true
                    CommonConst.guestUserCheck = true
                    CommonConst.navCheckValue = 1
                    self.rootWithDrawer(mainVCStoryboard: .dashboard, mainVCIdentifier: Constants.HomeViewControllerIdentifier, sideVCStoryboard: .dashboard, sideVCIdentifier: Constants.HamburgerViewControllerIdentifier)
                }
            } else {
                self.noNetworkConnectionAlert()
            }
        } else {
            CommonConst.guestUserCheck = true
            CommonConst.navCheckValue = 1
            self.rootWithDrawer(mainVCStoryboard: .dashboard, mainVCIdentifier: Constants.HomeViewControllerIdentifier, sideVCStoryboard: .dashboard, sideVCIdentifier: Constants.HamburgerViewControllerIdentifier)
        }
    }
}
