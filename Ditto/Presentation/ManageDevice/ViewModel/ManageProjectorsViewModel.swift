//
//  ManageProjectorsViewModel.swift
//  Ditto
//
//  Created by abiya.joy on 06/10/22.
//  Copyright © 2022 Infosys. All rights reserved.
//

import Foundation
import FastSocket

class ManageProjectorsViewModel: NSObject {
    //MARK: VARIABLE DECLARATION
    var host = String()
    var port = Int32()
    var isShowAlertForNetService = ObservableS<Bool>(value: false)
    var tableReloading = ObservableS<Bool>(value: false)
    var showLoader = ObservableS<Bool>(value: false)
    var initServiceConnection = ObservableS<Bool>(value: false)
    var foundService = ObservableS<Bool>(value: false)
    var showConnectivityScreen = ObservableS<Bool>(value: false)
    var decideAlert = ObservableS<String>(value: FormatsString.emptyString)
    var indexPath = IndexPath()
    var availableProjectors: NSMutableArray = []
    var projectorConnected: Bool!
    var availableServices = [NetService]()
    var whichProjectorSelected: Int!
    var isBLESearch: Bool = false
    var isThroughBLEWIFI: Bool = false
    var title = FormatsString.manageProjectorLabel
    var title1 = FormatsString.updateProjectorLabel

    //MARK: To Get ipv4 string from service address 192.168.1.101
    func getIPV4StringfromAddress(_ address: [Data] ) -> String {
        if  address.isEmpty {
            return "0.0.0.0"
        }
        let data = address.first! as NSData
        var ip1 = UInt8(0)
        data.getBytes(&ip1, range: NSRange(location: 4, length: 1))
        var ip2 = UInt8(0)
        data.getBytes(&ip2, range: NSRange(location: 5, length: 1))
        var ip3 = UInt8(0)
        data.getBytes(&ip3, range: NSRange(location: 6, length: 1))
        var ip4 = UInt8(0)
        data.getBytes(&ip4, range: NSRange(location: 7, length: 1))
        let ipStr = String(format: "%d.%d.%d.%d", ip1, ip2, ip3, ip4)
        return ipStr
    }
    func connectAfterSwitchingProjector(index: IndexPath) {   // connect to a projector after switching from other
        if index.row < self.availableServices.count && index.row >= 0 {
            self.showLoader.value = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                self.disconnectService()
                _ = self.connect(with: self.availableServices[index.row])
                self.whichProjectorSelected = index.row
                self.projectorConnected = true
                self.initServiceConnection.value = true
                self.tableReloading.value = true
                self.showLoader.value = false
            }
        } else {
            // PROJECTOR_CONNECTION_FAILED_POPUP
        }
    }
    func socketConnected() -> Bool {   // Check socket connection status
        var isConnected = Bool()
        guard let socket = FastSocket(host: ProjectorDetails.Host, andPort: String(ProjectorDetails.port)) else { return isConnected }
        isConnected = (ProjectorDetails.isProjectorConnected && socket.connect()) ? true : false
        return isConnected
    }
    @objc func getBLEWIFIstatus() {   // Check BLE status
        if self.isProjectorConnected() {
            self.showConnectivityScreen.value = true
        } else {
            if CommonConst.bleCheckValue {
                if KAppDelegate.isWifiOn {
                    self.showConnectivityScreen.value = true
                } else {
                    self.decideAlert.value = AlertTypes.WiFi
                }
            } else {
                self.decideAlert.value = AlertTypes.BLE
            }
        }
    }
    func connect(with service: NetService?) -> Bool {   // Connect projector
        var isConnected = false
        let connectd = false
        let addresses = service?.addresses
        self.host = self.getIPV4StringfromAddress(addresses!)
        self.port = Int32(service!.port)
        guard let client = FastSocket(host: self.host, andPort: String(self.port)) else { return isConnected }
        if !client.isConnected() {
            while !isConnected && addresses?.count != nil {
                let error: Error? = nil
                if client.connect(3) {
                    isConnected = true
                    self.isShowAlertForNetService.value = true // TRAC564
                    CommonConst.serviceConnectedCheck = true
                    CommonConst.removeObjectFromKey(key: CommonConst.lastConnectedProjector)
                    CommonConst.removeObjectFromKey(key: CommonConst.connectedHost)
                    CommonConst.removeObjectFromKey(key: CommonConst.connectedPort)
                    CommonConst.lastConnectedProjectorName = service?.name ?? FormatsString.emptyString
                    CommonConst.connectHost = self.host
                    CommonConst.connectPort = self.port
                    ProjectorDetails.Host = self.host
                    ProjectorDetails.port = self.port
                    ProjectorDetails.projectorName = service?.name ?? FormatsString.emptyString
                    ProjectorDetails.isProjectorConnected = true
                } else if error != nil {
                    if error != nil { }
                } else {
                    isConnected = false
                    self.isShowAlertForNetService.value = false
                    break
                }
            }
        } else {
            isConnected = connectd
        }
        return isConnected
    }
    func sendImage(img: UIImage) {   // Sending image to projector
        do {
            if let client = FastSocket(host: ProjectorDetails.Host, andPort: String(ProjectorDetails.port)) {
                if client.connect() {
                    if let data = img.pngData() {
                        data.withUnsafeBytes { databytes in
                            let buffer: UnsafePointer<CChar> = databytes.baseAddress!.assumingMemoryBound(to: CChar.self)
                            _ = client.sendBytes(buffer, count: data.count)
                        }
                    }
                }
            }
        }
    }
    func disconnectService() {    // To Disconect a service which is already connected
        self.sendImage(img: UIImage(named: ImageNames.disconnectionImage)!)
        DispatchQueue.global(qos: .default).async {
            guard let connectedHost = ProjectorDetails.Host as String? else {
                return
            }
            guard let connectedPort = ProjectorDetails.port as Int32? else {
                return
            }
            guard let socketToDisconnect = FastSocket(host: connectedHost, andPort: String(connectedPort)) else { return }
            socketToDisconnect.close()
            ProjectorDetails.isProjectorConnected = false
            ProjectorDetails.isCalibrated = false
        }
    }
    func isProjectorConnected() -> Bool {   // Checking for socket connection
        if let socket = FastSocket(host: ProjectorDetails.Host, andPort: String(ProjectorDetails.port)), socket.connect(3) {
            return true
        }
        return false
    }
}
