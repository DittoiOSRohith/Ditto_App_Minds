//
//  getStartedViewController.swift
//  JoannTraceApp
//
//  Created by Infosys on 03/08/20.
//  Copyright © 2020 Infosys. All rights reserved.

import UIKit
import Foundation
import CoreBluetooth
import Alamofire

class GetStartedViewController: UIViewController {
    //MARK: UI COMPONENT OUTLETS
    @IBOutlet weak var selectUnslectBtn: UIButton!
    @IBOutlet weak var skipContinueBtn: UIButton!
    @IBOutlet weak var onboardCollectionView: UICollectionView!
    @IBOutlet weak var screenAgainLabel: UILabel!
    @IBOutlet weak var letsGetStartedLabel: UILabel!
    @IBOutlet weak var hiThereNameLabel: UILabel!
    @IBOutlet weak var constraintHeigthNavBar: NSLayoutConstraint!
    @IBOutlet weak var labelNavTitle: UILabel!
    @IBOutlet weak var buttonBack: UIButton!
    //MARK: VARIABLE DECLARATION
    let objGetStartedViewModel = GetStartedViewModel()
    static var sharedInstace: GetStartedViewController?
    var isdontShowAlert: Bool = false
    //MARK: View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = " "
        self.showLottie()
        self.objGetStartedViewModel.fetchAllTutorialInstructionsFromDataBase {
            self.onboardCollectionView.reloadData()
            self.dismissLottie()
        }
        self.hiThereNameLabel.text = FormatsString.emptyString
        GetStartedViewController.sharedInstace = self
    }
    override func viewWillAppear(_ animated: Bool) {
        self.constraintHeigthNavBar.constant = 0
        self.labelNavTitle.isHidden = true
        self.buttonBack.isHidden = true
        GetStartedViewController.sharedInstace = self
        self.navigationController?.navigationBar.tintColor = UIColor.black
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        if CommonConst.navCheckValue == 0 {
            self.navigationController?.setNavigationBarHidden(true, animated: true)
            KAppDelegate.bluetoothStatus()
            if !self.isdontShowAlert {
                NotificationCenter.default.addObserver(self, selector: #selector(self.getBLEWIFIstatus), name: NSNotification.Name(rawValue: FormatsString.bluetoothLabel), object: nil)
            }
        } else if CommonConst.navCheckValue == 1 {
            self.skipContinueBtn.isHidden = true
            self.selectUnslectBtn.isHidden = true
            self.screenAgainLabel.isHidden = true
            self.hiThereNameLabel.text = FormatsString.emptyString
            self.letsGetStartedLabel.text = FormatsString.emptyString
            self.title = FormatsString.Tutorials
            self.navigationItem.backButtonTitle = FormatsString.emptyString
            if self.objGetStartedViewModel.isPresentedFromWorkSpace {
                self.constraintHeigthNavBar.constant = 50
                self.labelNavTitle.isHidden = false
                self.buttonBack.isHidden = false
            } else {
                self.navigationController?.setNavigationBarHidden(false, animated: true)
                self.configureNavTitle()
            }
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: FormatsString.bluetoothLabel), object: nil)
        WorkspaceBaseViewController.workspaceViewModel.isFromInstructionView = self.objGetStartedViewModel.isFromWorkspace ? true : false
    }
    func goToBeamSetUpViewController(fetchType: String) {  // Logic to navigate to beamsetup screen
        DispatchQueue.main.async {
            if let categoryViewController = Constants.storyBoardCategory.instantiateViewController(withIdentifier: Constants.BeamSetUpViewControllerIdentifier) as? BeamSetUpViewController {
                categoryViewController.beamSetUpViewModel.fetchType = fetchType
                categoryViewController.beamSetUpViewModel.fromScreenType = FromScreenType.getStartedd.rawValue
                self.navigationController?.pushViewController(categoryViewController, animated: true)
            }
        }
    }
    func goToFaqGlossary() {  // Logic to navigate to faqGlossary screen
        DispatchQueue.main.async {
            guard let manager = NetworkReachabilityManager(), manager.isReachable else { return self.openSettingApp() }
            if let faqViewController = Constants.faqView.instantiateViewController(withIdentifier: Constants.FaqViewControllerIdentifier) as? FaqViewController {
                faqViewController.objFaqViewModel.isFromWorkspace = self.objGetStartedViewModel.isFromWorkspace ? true : false
                faqViewController.objFaqViewModel.isFromCalibFailure = self.objGetStartedViewModel.isFromCalibFailure
                self.navigationController?.pushViewController(faqViewController, animated: true)
            }
        }
    }
    func openSettingApp() {  // Popup to display no internet connection in home screen
        DispatchQueue.main.async {
            let viewc = Constants.AlertWithTwoButtonsAndTitle.instantiateViewController(identifier: Constants.AlertWithTwoButonsTitleVCIdentifier) as AlertWithTwoButtonsAndTitleViewController
            viewc.alertArray = [AlertMessage.noConnectionTitle, AlertMessage.noConnectionDescription, AlertTitle.LATER, AlertTitle.SETTINGS]
            viewc.modalPresentationStyle = .overFullScreen
            if self.presentedViewController == nil {
                self.present(viewc, animated: true, completion: nil)
            }
        }
    }
    func showBLEAlertForGetStarted() {  // Popup to show the BLE connection required in home screen
        DispatchQueue.main.async {
            let viewc = Constants.AlertWithTwoButtonsAndTitle.instantiateViewController(identifier: Constants.AlertWithTwoButonsTitleVCIdentifier) as AlertWithTwoButtonsAndTitleViewController
            viewc.alertArray = [ConnectivityMessages.titleConnectivity, ConnectivityMessages.needBLEDescription, AlertTitle.LATER, AlertTitle.SETTINGS]
            viewc.screenType = ConnectivityMessages.needBLEDescription
            viewc.modalPresentationStyle = .overFullScreen
            viewc.onGetStartedBLELaterPressed = {
                self.dismiss(animated: false, completion: {
                    self.isdontShowAlert = true
                    NotificationCenter.default.removeObserver(self)
                    NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: FormatsString.bluetoothLabel), object: nil)
                })
            }
            if self.presentedViewController == nil {
                self.present(viewc, animated: true, completion: nil)
            }
        }
    }
    func showWiFiAlertForGetStarted() {  // Popup to show the Wi-Fi connection required in home screen
        DispatchQueue.main.async {
            let viewc = Constants.AlertWithTwoButtonsAndTitle.instantiateViewController(identifier: Constants.AlertWithTwoButonsTitleVCIdentifier) as AlertWithTwoButtonsAndTitleViewController
            viewc.alertArray = [ConnectivityMessages.titleConnectivity, ConnectivityMessages.needWiFiDescription, AlertTitle.LATER, AlertTitle.SETTINGS]
            viewc.screenType = ConnectivityMessages.needWiFiDescription
            viewc.modalPresentationStyle = .overFullScreen
            viewc.onGetStartedWiFiLaterPressed = {
                self.dismiss(animated: false, completion: {
                    self.isdontShowAlert = true
                    NotificationCenter.default.removeObserver(self)
                })
            }
            if self.presentedViewController == nil {
                self.present(viewc, animated: true, completion: nil)
            }
        }
    }
    @objc func getBLEWIFIstatus() {  // Logic to check the Wi-Fi status and show alert if not present
        if CommonConst.bleCheckValue {
            if !KAppDelegate.isWifiOn {
                self.showWiFiAlertForGetStarted()
            }
        } else {
            self.checkBLEWifi()
        }
    }
    func checkBLEWifi() {   // Logic to check the BLE status and show alert if not present
        if !CommonConst.bleCheckValue {
            self.showBLEAlertForGetStarted()
        }
    }
    //MARK: UI COMPONENT ACTIONS
    @IBAction func actionBack(_ sender: UIButton) {  // Back button logic when tutorial screen is visited from workspace
        self.dismiss(animated: true, completion: nil)
    }
}
