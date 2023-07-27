//
//  ConnectivityViewController.swift
//  Ditto
//
//  Created by abiya.joy on 09/11/22.
//  Copyright © 2022 Infosys. All rights reserved.
//

import UIKit
import CoreBluetooth
import FabricTraceTransformFrx
import FastSocket
import CryptoSwift
import Lottie
import SystemConfiguration.CaptiveNetwork

class ConnectivityViewController: UIViewController {
    //MARK: UI COMPONENT OUTLETS
    @IBOutlet weak var projectorsNotFound: UILabel!
    @IBOutlet weak var calibrationAlertView: CalibartionAlertView!
    @IBOutlet weak var tableTitleLabel: UILabel!
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var mainCenterConnectingShownView: UIView!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var showBLEDevicesView: UIView!
    @IBOutlet weak var showBLEDeviceTableView: UITableView!
    @IBOutlet weak var skipDefaultBtn: UIButton!
    @IBOutlet weak var skipServicesButton: UIButton!
    //MARK: VARIABLE DECLARATION
    var dissmissConnectivityDelegate: DissmissConnectivityDelegate?
    var isConnectionFromBeamSetup: Bool = false
    var isFromManageDevices: Bool = false
    var isBLESearchFromManageDevices: Bool = false
    var selectedCell: IndexPath?
    var dataViewModel = ConnectivityViewModel()
    var animView = AnimationView()
    //MARK: View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dismissLottie()
        self.showConnectionLottie()
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.dataViewModel.isConnectionFromBeamSetup = self.isConnectionFromBeamSetup
        self.dataViewModel.isFromManageDevices = self.isFromManageDevices
        self.dataViewModel.isBLESearchFromManageDevices = self.isBLESearchFromManageDevices
        self.mainView.backgroundColor = self.isFromManageDevices ? .clear : .black
        self.showBLEDeviceTableView.flashScrollIndicators()
        self.view.frame = UIScreen.main.bounds
        self.showBLEDeviceTableView.backgroundColor = .clear
        self.showBLEDeviceTableView.delegate = self
        self.showBLEDeviceTableView.dataSource = self
        self.showBLEDevicesView.layer.cornerRadius = 4
        self.initConnectivityViewModel()
        self.registerNIBTableView()
        self.calibrationAlertView.isHidden = true
    }
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.dataViewModel.checkConnectionAndSetUI()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.calibrationAlertView.isHidden = true
        DispatchQueue.main.async {
            self.dismissLottie()
        }
    }
    func initConnectivityViewModel() {
        self.dataViewModel.dissmissConnectionView.addObserver { (isDissmiss) in
            if isDissmiss {
                self.dismiss(animated: true, completion: nil)
            }
        }
        self.dataViewModel.isShowAlertForNetService.addObserver(fireNow: false) { (isAlert) in
            if self.isConnectionFromBeamSetup {
                self.sendCalibImage()
                self.dissmissConnectivityDelegate?.passServiceAddress(host: self.dataViewModel.host, port: self.dataViewModel.port)
                self.dissmissConnectivityDelegate?.dismmissConnectionView(presentScreenType: ScreenTypeString.skipType)
                self.dismiss(animated: false, completion: nil)
            } else {
                DispatchQueue.main.async {
                    self.showBLEDevicesView.isHidden = true
                    self.mainCenterConnectingShownView.isHidden = false
                    self.showConnectionLottie()
                }
                if isAlert {
                    self.dataViewModel.showConnectivityStatus.value = WifiConnectionStatus.projectorConnectionSuccess.rawValue
                }
            }
        }
        if self.isFromManageDevices && self.isBLESearchFromManageDevices {
        } else {
            self.dataViewModel.scanForServices()
        }
        self.dataViewModel.initiateBLEManagers()
        self.dataViewModel.showBLEPopUp.addObserver(fireNow: false) { (isShowAlert) in
            if isShowAlert {
                self.showConnectionLottie()
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.mainCenterConnectingShownView.isHidden = true
                    self.showBLEDevicesView.isHidden = false
                    self.dataViewModel.scanBLEDevices()
                }
            } else {
                self.showBLEDevicesView.isHidden = true
                self.mainCenterConnectingShownView.isHidden = false
                self.showConnectionLottie()
            }
            self.skipDefaultBtn.setTitle(self.dataViewModel.skipDefbuttonTitle.value, for: .normal)
        }
        self.dataViewModel.tabletitle.addObserver { (title) in
            self.tableTitleLabel.text = title
        }
        self.dataViewModel.showServicesList.addObserver { (isShowing) in
            self.tableTitleLabel.text = isShowing ? FormatsString.selectProjectorLabel : FormatsString.selectbluetoothLabel
            self.skipServicesButton.isHidden = !isShowing
            self.skipDefaultBtn.setTitle(isShowing ? FormatsString.scanBluetoothLabel : FormatsString.SKIPLabel, for: .normal)
        }
        self.dataViewModel.blePeripherals.addObserver(fireNow: false) { (peripherals) in
            self.showBLEDeviceTableView.isHidden = peripherals.isEmpty
            self.projectorsNotFound.isHidden = !peripherals.isEmpty
            if !peripherals.isEmpty {
                DispatchQueue.main.async {
                    self.showBLEDeviceTableView.reloadData()
                }
            }
        }
        self.dataViewModel.netServices.addObserver { (services) in
            if services.isEmpty {
                if self.isFromManageDevices && !self.isBLESearchFromManageDevices {
                } else {
                    if self.dataViewModel.showServicesList.value {
                        self.showBLEDeviceTableView.isHidden = true
                        self.projectorsNotFound.isHidden = false
                    }
                }
            } else {
                if self.isFromManageDevices && !self.isBLESearchFromManageDevices {
                } else {
                    self.projectorsNotFound.isHidden = true
                    self.showBLEDeviceTableView.isHidden = false
                }
            }
            DispatchQueue.main.async {
                self.showBLEDeviceTableView.reloadData()
            }
        }
        self.dataViewModel.netServiceSearchingStopped.addObserver { (searchingStopped) in
            if searchingStopped {
                if self.isFromManageDevices && !self.isBLESearchFromManageDevices {
                    self.dissmissConnectivityDelegate?.passServices?(services: self.dataViewModel.netServices.value, isThroughBLEWIFI: self.dataViewModel.isThroughBLEWIFI)
                    self.dissmissConnectivityDelegate?.dismmissConnectionView(presentScreenType: ScreenTypeString.skipType)
                }
            }
        }
        self.dataViewModel.isBleConnectionSuccessfull.addObserver(fireNow: false) { (isSuccess) in
            if isSuccess {
                self.mainCenterConnectingShownView.isHidden = true
            } else {
                self.dataViewModel.connectionFailedtitle.value = ConnectivityMessages.bleConnectionFailed
                self.dataViewModel.showConnectivityStatus.value = WifiConnectionStatus.connectionUnsuccessfull.rawValue
            }
        }
        dataViewModel.showConnectivityStatus.addObserver(fireNow: false) { (statusString) in
            switch statusString {
            case WifiConnectionStatus.serviceSuccess.rawValue:
                self.showBLEDevicesView.isHidden = true
                self.mainCenterConnectingShownView.isHidden = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                    self.dataViewModel.scanForServices()
                    self.dataViewModel.isFromBLEWIFIConnection.value = true
                    self.isBLESearchFromManageDevices = false
                }
            case WifiConnectionStatus.traceBLEConnected.rawValue:
                self.showAlertWithTF()
            case  WifiConnectionStatus.traceFailed.rawValue:
                self.showProjectorRespose()
            case WifiConnectionStatus.traceFailedWiFi.rawValue:
                self.showProjectorRespose()
            case WifiConnectionStatus.connectionUnsuccessfull.rawValue:
                self.showProjectorRespose()
            case WifiConnectionStatus.projectorConnectionSuccess.rawValue:
                self.showProjectorConnectionSuccessResponse()
            case WifiConnectionStatus.showCalibPopAfterConnectionSuccess.rawValue:
                self.showCalibPopUp()
            default:
                break
            }
        }
    }
    func showConnectionLottie() {  // Connection lottie animation
        let jsonName = ConnectivityUtils.jsonLoader
        let animation = Animation.named(jsonName)
        self.animView = AnimationView(animation: animation)
        self.animView.frame.size = self.mainCenterConnectingShownView.frame.size
        self.mainCenterConnectingShownView.addSubview(self.animView)
        self.animView.contentMode = .center
        self.animView.loopMode = .loop
        self.animView.play()
    }
    func sendDittoCalib(img: UIImage) {  // SENDING IMAGE TO PROJECTOR
        do {
            if let client = FastSocket(host: self.dataViewModel.host, andPort: String(self.dataViewModel.port)), client.connect() {
                if let data = img.pngData() {
                    _ = client.sendBytes(data.bytes, count: (data.count))
                }
            } else {
                self.dataViewModel.connectionFailedtitle.value = ConnectivityMessages.projectorConnectionFailed
                self.dataViewModel.showConnectivityStatus.value = WifiConnectionStatus.connectionUnsuccessfull.rawValue
            }
        }
    }
    func registerNIBTableView() {
        Proxy.shared.registerNib(self.showBLEDeviceTableView, nibName: ReusableCellIdentifiers.bLEDevicesTableViewCellIdentifier, identifierCell: ReusableCellIdentifiers.bleDevicesIdentifier)
    }
    func goToWorkspace() {   // navigation to workspace
        if let workspaceViewController = Constants.workspaceStoryBoard.instantiateViewController(withIdentifier: Constants.WorkspaceBaseViewControllerIdentifier) as? WorkspaceBaseViewController {
            self.navigationController?.pushViewController(workspaceViewController, animated: true)
        }
    }
    func selectCell(indexPath: IndexPath) {   // BLE list cell selection code
        self.selectedCell = indexPath
        DispatchQueue.main.async {
            self.showBLEDeviceTableView.reloadData()
        }
    }
    func sendImage(img: UIImage) {  // SENDING IMAGE TO PROJECTOR
        do {
            if let client = FastSocket(host: self.dataViewModel.host, andPort: String(self.dataViewModel.port)), client.connect() {
                if let data =  img.pngData() {
                    data.withUnsafeBytes { dataBytes in
                        let buffer: UnsafePointer<CChar> = dataBytes.baseAddress!.assumingMemoryBound(to: CChar.self)
                        _ = client.sendBytes(buffer, count: data.count)
                    }
                }
            } else {
                self.dataViewModel.showConnectivityStatus.value = WifiConnectionStatus.connectionUnsuccessfull.rawValue
            }
        }
    }
    //  Alerts
    func showCalibrationConfirmationAlert() {   // Calibration conformation alert action handling
        DispatchQueue.main.async {
            let viewc = Constants.AlertWithTwoButtonsAndTitle.instantiateViewController(identifier: Constants.AlertWithTwoButonsTitleVCIdentifier) as AlertWithTwoButtonsAndTitleViewController
            viewc.alertArray = [CalibrationMessages.calibrationConfTitle, CalibrationMessages.calibrationConfirmation, AlertTitle.NOButton, AlertTitle.YES]
            viewc.screenType = CalibrationMessages.calibrationScreenConfirmation
            viewc.modalPresentationStyle = .overFullScreen
            viewc.onYesPressed = {
                self.dismiss(animated: false, completion: {
                    ProjectorDetails.isCalibrated = false
                    ProjectorDetails.isUserCalibrated = true
                    self.dissmissConnectivityDelegate?.passButtonTitle?(title: CalibrationMessages.calibrationConfTitle)
                    self.dissmissConnectivityDelegate?.dismmissConnectionView(presentScreenType: ScreenTypeString.skipType)
                })
            }
            viewc.onNoPressed = {
                ProjectorDetails.isCalibrated = true
                ProjectorDetails.isUserCalibrated = false
                self.dissmissConnectivityDelegate?.passButtonTitle?(title: CalibrationMessages.calibrationConfTitle)
                self.dissmissConnectivityDelegate?.dismmissConnectionView(presentScreenType: ScreenTypeString.calibConnectivitySuccessScreen)
            }
            if self.presentedViewController == nil {
                self.present(viewc, animated: false, completion: nil)
            }
        }
    }
    @objc  func showCalibPopUp() {   // Alert asking if needed to calibrate or not
        self.showCalibrationConfirmationAlert()
    }
    func showProjectorConnectionSuccessResponse() {   // Projector/Wi-Fi successful connection alert
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let viewc = Constants.AlertWithImageAndButtons.instantiateViewController(identifier: Constants.AlertWithImageAndButonsVCIdentifier) as AlertWithImageAndButtonsViewController
            viewc.alertArray = [ConnectivityUtils.successImage, ConnectivityMessages.wiFiConnectionSuccess, FormatsString.emptyString, AlertTitle.OKButton, FormatsString.emptyString]
            viewc.modalPresentationStyle = .overFullScreen
            viewc.onOKPressed = {
                let image = UIImage(named: ImageNames.wsLaunchImage)
                self.sendDittoCalib(img: image!)
                self.dismiss(animated: false, completion: {
                    self.dissmissConnectivityDelegate?.passButtonTitle?(title: CalibrationMessages.calibrationConfTitle)
                    self.dataViewModel.showConnectivityStatus.value = WifiConnectionStatus.showCalibPopAfterConnectionSuccess.rawValue
                })
            }
            if self.presentedViewController == nil {
                self.present(viewc, animated: false) {
                    let image = UIImage(named: ImageNames.connectedRotatedImage)
                    self.sendDittoCalib(img: image!)
                }
            }
        }
    }
    func showProjectorRespose() {   // Projector/WiFi failed popup
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let alert = Constants.AlertWithImageAndButtons.instantiateViewController(identifier: Constants.AlertWithImageAndButonsVCIdentifier) as AlertWithImageAndButtonsViewController
            alert.alertArray = [ConnectivityUtils.failedImage, self.dataViewModel.connectionFailedtitle.value, AlertTitle.CANCEL, AlertTitle.RETRY, FormatsString.emptyString]
            alert.modalPresentationStyle = .overFullScreen
            alert.onRetryPressed = {
                self.dismiss(animated: false, completion: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                        if self.dataViewModel.showConnectivityStatus.value == WifiConnectionStatus.traceFailedWiFi.rawValue {
                            self.showAlertWithTF()
                        } else if self.dataViewModel.isBLEConnectionFailed.value {
                            self.dataViewModel.showBLEPopUp.value = true
                            self.dataViewModel.scanBLEDevices()
                            self.dataViewModel.showServicesList.value = false
                            self.mainCenterConnectingShownView.isHidden = true
                            self.showBLEDevicesView.isHidden = false
                            self.showBLEDeviceTableView.reloadData()
                        } else {
                            self.dataViewModel.initiateBLEManagers()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                self.dataViewModel.checkConnectionAndSetUI()
                            }
                        }
                    }
                })
            }
            alert.onCancelPressed = {
                self.dissmissConnectivityDelegate?.dismmissConnectionView(presentScreenType: ScreenTypeString.skipType)
                self.dissmissConnectivityDelegate?.passButtonTitle?(title: FormatsString.connectLabel)
                self.mainCenterConnectingShownView.isHidden = true
            }
            if self.presentedViewController == nil {
                self.present(alert, animated: false, completion: nil)
            }
        }
    }
    func showAlertWithTF() {     // BLE popup with network name and password handling
        DispatchQueue.main.async {
            let viewc = Constants.AlertWithTwoButtonsAndTwoTextFields.instantiateViewController(identifier: Constants.AlertWithTwoButonsTextFieldsVCIdentifier) as AlertWithTwoButtonsAndTwoTextFieldsViewController
            viewc.netWorkName = self.dataViewModel.currentNetworkInfos?.first?.ssid ?? FormatsString.emptyString
            viewc.modalPresentationStyle = .overFullScreen
            viewc.connectToWifi = {
                guard let emailId = viewc.networkTextField.text else {
                    return
                }
                guard let password = viewc.passwordTextField.text else {
                    return
                }
                guard !emailId.isEmpty else {
                    self.showAlertWithTF()
                    return
                }
                // #### SEND_DATA ####
                self.dismiss(animated: false) {
                    if let mainperipheral = self.dataViewModel.mainPeripheral {
                        self.dataViewModel.dataToSend = "\(emailId.aesEncrypt()),\(password.aesEncrypt()),\("IOS".aesEncrypt())"
                        self.dataViewModel.manager?.connect(mainperipheral, options: nil)
                        self.dataViewModel.connectionFailedtitle.value = ConnectivityMessages.wiFiConnectionFailed
                        self.mainCenterConnectingShownView.isHidden = false
                        self.showConnectionLottie()
                    }
                }
            }
            viewc.onCancelPressed = {
                DispatchQueue.main.async {
                    CommonConst.serviceConnectedCheck = false
                    self.dissmissConnectivityDelegate?.dismmissConnectionView(presentScreenType: ScreenTypeString.skipType)
                    self.dismiss(animated: true, completion: nil)
                }
            }
            if self.presentedViewController == nil {
                self.present(viewc, animated: false, completion: nil)
            }
        }
    }
    //MARK: UI COMPONENT ACTIONS
    @IBAction func refreshButtonClicked(_ sender: UIButton) {   // Refresh icon tap action on select projector popup
        self.showLottie()
        if self.dataViewModel.showServicesList.value {
            self.dataViewModel.scanForServices()
        } else {
            self.dataViewModel.peripherals.removeAll()
            self.dataViewModel.peripheralAddversimentDataArray.removeAll()
            self.dataViewModel.scanBLEDevices()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            if self.dataViewModel.showServicesList.value {
                self.projectorsNotFound.isHidden = !self.dataViewModel.services.isEmpty ? true : false
                self.showBLEDeviceTableView.isHidden = !self.dataViewModel.services.isEmpty ? false : true
            } else {
                self.projectorsNotFound.isHidden = !self.dataViewModel.peripheralAddversimentDataArray.isEmpty ? true : false
                self.showBLEDeviceTableView.isHidden = !self.dataViewModel.peripheralAddversimentDataArray.isEmpty ? false : true
            }
            self.showBLEDeviceTableView.reloadData()
            self.dismissLottie() // TDP-454
        }
    }
    @IBAction func cancelButtonClicked(_ sender: UIButton) {   // Skip button tap action on BLE list popup and Scan via bluetooth button tap on select projector popup
        if self.dataViewModel.showServicesList.value {    //  Scan via bluetooth button tap on select projector popup
            self.dataViewModel.showServicesList.value = false
            self.dataViewModel.scanBLEDevices()
            DispatchQueue.main.async {
                self.showBLEDeviceTableView.reloadData()
            }
        } else {   // Skip button tap action on BLE list popup
            CommonConst.serviceConnectedCheck = false
            if !self.isConnectionFromBeamSetup && !CommonConst.serviceConnectedCheck {
                self.dissmissConnectivityDelegate?.passButtonTitle?(title: FormatsString.connectLabel)
            }
            self.dissmissConnectivityDelegate?.dismmissConnectionView(presentScreenType: ScreenTypeString.skipType)
            self.dismiss(animated: false, completion: nil)
        }
    }
    @IBAction func skipButtonClicked(_ sender: UIButton) {  // skip button tap action on select projector popup
        self.dismiss(animated: false, completion: nil)
    }
}
