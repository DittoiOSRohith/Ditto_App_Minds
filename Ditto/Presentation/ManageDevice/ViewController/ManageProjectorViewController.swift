//
//  ManageProjectorViewController.swift
//  Ditto
//  Created by niranjan on 03/06/21.
//  Copyright © 2021 Infosys. All rights reserved.
//
import UIKit
import Foundation
import FastSocket

class ManageProjectorViewController: UIViewController {
    //MARK: UI COMPONENT OUTLETS
    @IBOutlet weak var projectorListTableView: UITableView!
    @IBOutlet weak var noOfProjectorsLbl: UILabel!
    @IBOutlet weak var noProjectorsFoundLabel: UILabel!
    //MARK: VARIABLE DECLARATION
    var dataViewModel = ManageProjectorsViewModel()
    //MARK: View Life Cycle Methods
    
    
    //Rohith
    //managing update projector screen titles here
    override func viewDidLoad() { // TRAC_601
        
        let projector = UserDefaults.standard.bool(forKey: "projector")
        print(projector)
        if projector == true{
            self.title = self.dataViewModel.title

        }else{
            self.title = self.dataViewModel.title1

        }

        let size: CGFloat = UIDevice.isPhone ?  21 : 28
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: CustomFont.avenirLtProMedium(size: size) ?? UIFont.systemFont(ofSize: size)]
        KAppDelegate.bluetoothStatus()
        self.dataViewModel.showLoader.value = true
        self.dataViewModel.projectorConnected = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.dataViewModel.showLoader.value = false
            self.dataViewModel.getBLEWIFIstatus()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        self.initViewModel()
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: FormatsString.bluetoothLabel), object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.getBLEWIFIstatus), name: NSNotification.Name(rawValue: FormatsString.bluetoothLabel), object: nil)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(rawValue: FormatsString.bluetoothLabel), object: nil)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    @objc func getBLEWIFIstatus() {   // Check BLE status
        DispatchQueue.main.async {
            if let presentVC = self.presentedViewController {
                presentVC.showLottie()
            } else {
                self.showLottie()
            }
        }
        DispatchQueue.global(qos: .background).async {
            if self.dataViewModel.socketConnected() {
                DispatchQueue.main.async {
                    self.dismissLottie()
                    self.dismiss(animated: false) {
                        self.goToConectivityScreen()
                    }
                }
            } else {
                if CommonConst.bleCheckValue {
                    if KAppDelegate.isWifiOn {
                        DispatchQueue.main.async {
                            self.dismissLottie()
                            self.dismiss(animated: false) {
                                self.goToConectivityScreen()
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.dismissLottie()
                            self.dismiss(animated: false) {
                                self.showNeedWiFiAlert()
                            }
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.dismissLottie()
                        self.dismiss(animated: false) {
                            self.showNeedBLEAlert()
                        }
                    }
                }
            }
        }
    }
    func initViewModel() {
        self.dataViewModel.tableReloading.addObserver { _ in
            DispatchQueue.main.async {
                self.projectorListTableView.reloadData()
            }
        }
        self.dataViewModel.showLoader.addObserver { (showLoader) in
            self.noOfProjectorsLbl.isHidden = showLoader ? true : false
            if showLoader {
                self.dataViewModel.foundService.value = true
                self.noProjectorsFoundLabel.isHidden = true
                self.showLottie()
            } else {
                self.dismissLottie()
            }
        }
        self.dataViewModel.initServiceConnection.addObserver { (tryserviceConnection) in
            if tryserviceConnection {
                self.initServiceConnection()
            }
        }
        self.dataViewModel.foundService.addObserver { (gotService) in
            self.noProjectorsFoundLabel.isHidden = !gotService ? false : true
            self.noOfProjectorsLbl.isHidden = !gotService ? false : true
            self.projectorListTableView.isHidden = !gotService ? true : false
        }
        self.dataViewModel.showConnectivityScreen.addObserver { (isShown) in
            if isShown {
                self.goToConectivityScreen()
            }
        }
        self.dataViewModel.decideAlert.addObserver { (alert) in
            switch alert {
            case AlertTypes.WiFi:
                self.showNeedWiFiAlert()
            case AlertTypes.BLE:
                self.showNeedBLEAlert()
            case AlertTypes.SWITCHPROJECTOR:
                self.showProjectorSwitchAlert(ind: self.dataViewModel.indexPath)
            default:
                break
            }
        }
    }
    func initServiceConnection() {   // checking for service connection
        self.dataViewModel.isShowAlertForNetService.addObserver { (isConnected) in
            if !isConnected {
                ProjectorDetails.isProjectorConnected = false
                self.showConnectionFailedAlert()
            } else {
                self.dataViewModel.sendImage(img: UIImage(named: ImageNames.connectedRotatedImage)!)
            }
        }
    }
    func goToConectivityScreen() {   // Navigation to connectivity screen
        DispatchQueue.main.async {
            if let connectivity = Constants.connectivity.instantiateViewController(withIdentifier: Constants.connectivityIdentifier)  as? UINavigationController, !connectivity.viewControllers.isEmpty {
                if let connectvityVc = connectivity.viewControllers[0]  as? ConnectivityViewController {
                    self.dataViewModel.foundService.value = true
                    connectvityVc.dissmissConnectivityDelegate = self
                    connectvityVc.isFromManageDevices = true
                    connectvityVc.isBLESearchFromManageDevices = self.dataViewModel.isBLESearch
                }
                connectivity.modalPresentationStyle = UIDevice.isPhone ? .popover : .overFullScreen
                if self.presentedViewController == nil {
                    self.present(connectivity, animated: false, completion: nil)
                }
            }
        }
    }
    func showProjectorSwitchAlert(ind: IndexPath) {   // Projector switch alert
        DispatchQueue.main.async {
            if let viewc = Constants.AlertWithTwoButtonsAndTitle.instantiateViewController(identifier: Constants.AlertWithTwoButonsTitleVCIdentifier) as? AlertWithTwoButtonsAndTitleViewController {
                viewc.alertArray = [FormatsString.emptyString, ConnectivityMessages.needProjectorSwitch, AlertTitle.NOButton, AlertTitle.YES]
                viewc.screenType = CalibrationMessages.calibrationScreenConfirmation
                viewc.modalPresentationStyle = .overFullScreen
                viewc.onYesPressed = {
                    self.dismiss(animated: false, completion: {
                        self.dataViewModel.connectAfterSwitchingProjector(index: ind)
                    })
                }
                viewc.onNoPressed = {
                    self.dismiss(animated: false, completion: nil)
                }
                if self.presentedViewController == nil {
                    self.present(viewc, animated: false, completion: nil)
                }
                self.projectorListTableView.reloadData()
            }
        }
    }
    func showConnectionFailedAlert() {   // Connection failed alert
        DispatchQueue.main.async {
            if let viewc = Constants.AlertWithImageAndButtons.instantiateViewController(identifier: Constants.AlertWithImageAndButonsVCIdentifier) as? AlertWithImageAndButtonsViewController {
                viewc.alertArray = [ConnectivityUtils.failedImage, ConnectivityMessages.projectorConnectionFailed, FormatsString.emptyString, AlertTitle.OKButton, FormatsString.emptyString]
                viewc.modalPresentationStyle = .overFullScreen
                viewc.onOKPressed = {
                    self.dismiss(animated: false, completion: nil)
                }
                if self.presentedViewController == nil {
                    self.present(viewc, animated: false, completion: nil)
                }
            }
        }
    }
    //MARK: UI COMPONENT ACTIONS
    @IBAction func scanForDevicesAction(_ sender: Any) {   // Search for Projector button tap
        self.dataViewModel.isBLESearch = true
        self.goToConectivityScreen()
    }
}
