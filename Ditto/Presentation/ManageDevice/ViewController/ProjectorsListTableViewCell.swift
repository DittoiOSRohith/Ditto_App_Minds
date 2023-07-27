//
//  ProjectorsListTableViewCell.swift
//  Ditto
//
//  Created by Sanchu Bose on 17/06/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit
import Network

class ProjectorsListTableViewCell: UITableViewCell {
    //MARK: UI COMPONENT OUTLETS
    @IBOutlet weak var projImg: UIImageView!
    @IBOutlet weak var projNameLbl: UILabel!
    @IBOutlet weak var connectedLbl: UILabel!
    @IBOutlet weak var connectBtn: UIButton!
    
    @IBOutlet var InfoBtn: UIButton!
    @IBOutlet var updateBtn: UIButton!
    //Rohith
    // Closure for the Button action inside the tableviewcell
    @IBAction func infoSelected(_ sender: Any) {
        if let btnAction = self.selectionItem {
            DispatchQueue.main.async {
                let address = self.getAddress()
                let MACaddress  = self.GetMACAddressFromIPv6(ip: address ?? "")
                if let viewc = Constants.AlertWithTwoButtonsAndTitle.instantiateViewController(identifier: Constants.AlertWithTwoButonsTitleVCIdentifier) as? AlertWithTwoButtonsAndTitleViewController {
                    viewc.alertArray = [FormatsString.emptyString,"Firmware version : \(UIDevice.current.systemVersion) \nSerial number :\(ProjectorDetails.port) \nMAC address :\(MACaddress)" , AlertTitle.EmptyButton, AlertTitle.OKButton]
                    //UIDevice.current.identifierForVendor!.uuidString
                    viewc.screenType = CalibrationMessages.calibrationScreenConfirmation
                    viewc.modalPresentationStyle = .overFullScreen
                    viewc.onYesPressed = {
                        

                        Proxy.shared.keyWindow?.rootViewController?.dismiss(animated: false, completion: {
                            //  self.accountSettingsApihit()
                        })

                       
                    }
                    
                    //                    UIApplication.shared.keyWindow?.rootViewController?.present(viewc, animated: false, completion: nil)
                    
                    if Proxy.shared.keyWindow?.rootViewController?.presentedViewController == nil {
                        Proxy.shared.keyWindow?.rootViewController?.present(viewc, animated: false, completion: nil)
                    }

                }
            }
            
        }
        
    }

   //Rohith
    // To GetMACAddressFromIPv6
    func GetMACAddressFromIPv6(ip: String) -> String{
            let IPStruct = IPv6Address(ip)
            if(IPStruct == nil){
                return ""
            }
            let extractedMAC = [
                (IPStruct?.rawValue[8])! ^ 0b00000010,
                IPStruct?.rawValue[9],
                IPStruct?.rawValue[10],
                IPStruct?.rawValue[13],
                IPStruct?.rawValue[14],
                IPStruct?.rawValue[15]
            ]
            return String(format: "%02x:%02x:%02x:%02x:%02x:%02x",
                extractedMAC[0] ?? 00,
                extractedMAC[1] ?? 00,
                extractedMAC[2] ?? 00,
                extractedMAC[3] ?? 00,
                extractedMAC[4] ?? 00,
                extractedMAC[5] ?? 00)
        }
    // to get Address
    func getAddress() -> String? {
        var address: String?

        // Get list of all interfaces on the local machine:
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return nil }
        guard let firstAddr = ifaddr else { return nil }

        // For each interface ...
        for ifptr in sequence(first: firstAddr, next: { $0.pointee.ifa_next }) {
            let interface = ifptr.pointee

            // Check IPv6 interface:
            let addrFamily = interface.ifa_addr.pointee.sa_family
            if addrFamily == UInt8(AF_INET6) {
                // Check interface name:
                let name = String(cString: interface.ifa_name)
                if name.contains("ipsec") {

                    // Convert interface address to a human readable string:
                    var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                    getnameinfo(interface.ifa_addr, socklen_t(interface.ifa_addr.pointee.sa_len),
                                &hostname, socklen_t(hostname.count),
                                nil, socklen_t(0), NI_NUMERICHOST)
                    address = String(cString: hostname)
                    let ipv6addr = IPv6Address(address ?? "::")
                    if(ipv6addr?.isLinkLocal ?? false){
                        return address
                    }
                }
            }
        }
        freeifaddrs(ifaddr)

        return address
    }

//Rohith
    // updating projector here
    @IBAction func updateBtnTapped(_ sender: Any) {
        if let btnAction = self.selectionItem {
            DispatchQueue.main.async {
                
                
                DispatchQueue.main.async {
                    let viewc = Constants.AlertWithImageAndButtons.instantiateViewController(identifier: Constants.AlertWithImageAndButonsVCIdentifier) as AlertWithImageAndButtonsViewController
                    viewc.alertArray = [ImageNames.projectorBlueImage, AlertMessage.UpdateProjectortxt, AlertTitle.EmptyButton, AlertTitle.OKButton, FormatsString.emptyString]
                    viewc.modalPresentationStyle = .overFullScreen
                    viewc.onOKPressed = {
                        Proxy.shared.keyWindow?.rootViewController?.dismiss(animated: false, completion: {
                        })
                    }
                    viewc.onCancelPressed = {
                        Proxy.shared.keyWindow?.rootViewController?.dismiss(animated: false, completion: {
                        })
                    }
                    
                    if Proxy.shared.keyWindow?.rootViewController?.presentedViewController == nil {
                        Proxy.shared.keyWindow?.rootViewController?.present(viewc, animated: false, completion: nil)
                    }
                }
            }
        }
    }
    
    @IBAction func selectedConnection(_ sender: Any) {
        if let btnAction = self.selectionItem {
            btnAction()
        }
    }
    //MARK: VARIABLE DECLARATION
    var selectionItem: (() -> Void)?
    //MARK:  FUNCTION LOGICS
    //Rohith
    // content view cretaed here for projector Information
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 5, bottom: 20, right: 5))
        self.connectBtn.layer.borderColor = UIColor.black.cgColor
        self.connectBtn.layer.borderWidth = 1
        self.InfoBtn.setTitle("Info", for: .normal)


    }
    func configureCell(index: IndexPath, viewModel: ManageProjectorsViewModel) {   // Table view cell values handling
        if index.row < viewModel.availableProjectors.count && index.row >= 0 {
            DispatchQueue.main.async {
                self.addShadow()
                self.projNameLbl.text = viewModel.availableProjectors[index.row] as? String
                self.projImg.image = (ProjectorDetails.isProjectorConnected && ProjectorDetails.projectorName == self.projNameLbl.text && viewModel.isProjectorConnected()) ? UIImage(named: ImageNames.projectorBlueImage) : UIImage(named: ImageNames.projectorWhiteImage)
                self.connectedLbl.isHidden = (ProjectorDetails.isProjectorConnected && ProjectorDetails.projectorName == self.projNameLbl.text && viewModel.isProjectorConnected()) ? false : true
                print(ProjectorDetails.Host)
                self.connectedLbl.text = FormatsString.connectedLabel
                self.connectBtn.backgroundColor = (ProjectorDetails.isProjectorConnected && ProjectorDetails.projectorName == self.projNameLbl.text && viewModel.isProjectorConnected()) ? UIColor.black : UIColor.white
                if  ProjectorDetails.isProjectorConnected && ProjectorDetails.projectorName == self.projNameLbl.text && viewModel.isProjectorConnected() {
                    viewModel.whichProjectorSelected = index.row
                    self.connectBtn.setTitleColor(UIColor.white, for: .normal)
                    self.connectBtn.setTitle(FormatsString.disconnectLabel, for: .normal)
                } else {
                    self.connectBtn.setTitleColor(UIColor.black, for: .normal)
                    self.connectBtn.setTitle(FormatsString.connectLabel, for: .normal)
                    self.connectedLbl.textColor = CustomColor.signIn
                }
                if viewModel.isThroughBLEWIFI {
                    if ProjectorDetails.projectorName == self.projNameLbl.text {
                        if index.row < viewModel.availableServices.count {
                            viewModel.showLoader.value = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                viewModel.disconnectService()
                                _ = viewModel.availableProjectors.index(of: self.projNameLbl.text ?? FormatsString.emptyString)
                                _ = viewModel.connect(with: viewModel.availableServices[index.row])
                                viewModel.whichProjectorSelected = index.row
                                viewModel.projectorConnected = true
                                viewModel.initServiceConnection.value = true
                                viewModel.tableReloading.value = true
                                viewModel.showLoader.value = false
                                viewModel.isBLESearch = false
                                viewModel.isThroughBLEWIFI = false
                            }
                        } else {
                            // PROJECTOR_CONNECTION_FAILED_POPUP
                        }
                    }
                }
                self.selectionItem = {
                    if viewModel.whichProjectorSelected == index.row && self.projImg.image == UIImage(named: ImageNames.projectorBlueImage) {
                        viewModel.showLoader.value = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            viewModel.disconnectService()
                            viewModel.whichProjectorSelected = nil
                            viewModel.projectorConnected = false
                            viewModel.tableReloading.value = true
                            viewModel.showLoader.value = false
                        }
                    } else {
                        if ProjectorDetails.isProjectorConnected && viewModel.isProjectorConnected() {
                            viewModel.indexPath = index
                            viewModel.decideAlert.value = AlertTypes.SWITCHPROJECTOR
                        } else {
                            if index.row < viewModel.availableServices.count {
                                viewModel.showLoader.value = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    viewModel.initServiceConnection.value = true
                                    _ = viewModel.connect(with: viewModel.availableServices[index.row])
                                    viewModel.whichProjectorSelected = index.row
                                    viewModel.projectorConnected = true
                                    viewModel.tableReloading.value = true
                                    viewModel.showLoader.value = false
                                }
                            } else {
                                // PROJECTOR_CONNECTION_FAILED_POPUP
                            }
                        }
                    }
                    viewModel.tableReloading.value = true
                }
                let projecot = UserDefaults.standard.bool(forKey: "projector")
                
                if projecot == true{
                    self.InfoBtn.isHidden = true
                    self.updateBtn.isHidden = true

                    if self.connectedLbl.text == FormatsString.connectedLabel && ProjectorDetails.isProjectorConnected {
                        viewModel.sendImage(img: UIImage(named: ImageNames.connectedRotatedImage)!)
                        //left Space for button
                    }
                }else{
                    if self.connectedLbl.text == FormatsString.connectedLabel && ProjectorDetails.isProjectorConnected {
                        viewModel.sendImage(img: UIImage(named: ImageNames.connectedRotatedImage)!)
                        self.InfoBtn.isHidden = false
                        self.updateBtn.isHidden = false

                        //left Space for button
                    }else{
                        self.InfoBtn.isHidden = true
                        self.updateBtn.isHidden = true

                    }
                }
                
            }
        }
    }
}

