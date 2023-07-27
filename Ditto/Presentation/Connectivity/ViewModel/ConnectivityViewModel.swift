//
//  ConnectivityViewModel.swift
//  JoannTraceApp
//
//  Created by Shefrin Hakeem on 18/03/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit
import CoreBluetooth
import FastSocket
import FabricTraceTransformFrx
import CoreLocation
import CryptoSwift
import SystemConfiguration.CaptiveNetwork

class ConnectivityViewModel: NSObject, CLLocationManagerDelegate {
    var peripheralAddNameArray = [String]()
    var peripheralAddversimentDataArray: [(name: String, peripheral: CBPeripheral)] = []
    var peripherals: [CBPeripheral] = [CBPeripheral]()
    let isShowAlertForNetService = ObservableS<Bool>(value: false)
    let showBLEPopUp = ObservableS<Bool>(value: false)
    var blePeripherals = ObservableS<[CBPeripheral]>(value: [])
    var netServices = ObservableS<[NetService]>(value: [])
    let isBleConnectionSuccessfull = ObservableS<Bool>(value: false)
    let dissmissConnectionView = ObservableS<Bool>(value: false)
    let showConnectivityStatus = ObservableS<String>(value: FormatsString.emptyString)
    let showServicesList = ObservableS<Bool>(value: false) // TRAC564
    let skipDefbuttonTitle = ObservableS<String>(value: FormatsString.SKIPLabel) // TRAC564
    let tabletitle = ObservableS<String>(value: FormatsString.selectbluetoothLabel) // TRAC564
    let isFromBLEWIFIConnection = ObservableS<Bool>(value: false) // TRAC564
    let connectionFailedtitle = ObservableS<String>(value: ConnectivityMessages.wiFiConnectionFailed)
    let isBLEConnectionFailed  = ObservableS<Bool>(value: false) // TRAC564
    let isLastConnectedProjector = ObservableS<Bool>(value: false) // TRAC564
    let netServiceSearchingStopped = ObservableS<Bool>(value: false)
    var isConnectionFromBeamSetup = false
    var isFromManageDevices = false
    var isBLESearchFromManageDevices = false
    var isThroughBLEWIFI = false
    var data = Data()
    var dataToSend = String()
    var mainDescriptor: CBDescriptor?
    var secondWrite = false
    var gotResponse: Bool = false
    var value = 10.0
    var responseTimer = Timer()
    var locationManager = CLLocationManager()
    var manager: CBCentralManager?
    var mainPeripheral: CBPeripheral?
    var characteristics: [CBCharacteristic]?
    var mainCharacteristic: CBCharacteristic?
    var peripheralManagaer: CBPeripheralManager?
    var transferCharacteristic: CBMutableCharacteristic!
    let BLEService = Constants.TRANSFERSERVICEUUID
    let BLECharacteristic = Constants.TRANSFERCHARACTERISTICUUID
    var host = String()
    var pattern = PatternObject()
    var isBLEConnected: Bool = false
    var netServiceBrowser: NetServiceBrowser!
    var services = [NetService]()
    var serviceName = String()
    var port = Int32()
    let netService: NetService = NetService.init(domain: Constants.domainKey, type: Constants.typeKey, name: Constants.dittoOnlyCheck, port: 0000)  // restrict marconi projector
    var dissmissConnectivityDelegate: DissmissConnectivityDelegate?
    var currentNetworkInfos: [NetworkInfo]? {
        get {
            return SSID.fetchNetworkInfo()
        }
    }
    // CUSTOM FUNCTIONS
    func checkConnectionAndSetUI() {   // checking the connection,location permission and other UI
        if #available(iOS 13.0, *) {
            let status = CLLocationManager.authorizationStatus()
            if status != .authorizedWhenInUse {
                self.locationManager.delegate = self
                self.locationManager.requestWhenInUseAuthorization()
            }
        }
        if self.isFromManageDevices && !self.isBLESearchFromManageDevices {
            self.showServicesList.value = false
            self.showBLEPopUp.value = false
        } else {
            if self.services.isEmpty {
                self.showServicesList.value = false
                self.showBLEPopUp.value = true
                self.scanBLEDevices()
            } else {
                if let lastConnectedProjector = CommonConst.lastConnectedProjectorName as? String, self.serviceName == lastConnectedProjector {
                    self.isLastConnectedProjector.value = true
                    self.showBLEPopUp.value = false
                    self.showServicesList.value = false
                    self.scanForServices()
                } else {
                    self.isLastConnectedProjector.value = false
                    self.showBLEPopUp.value = true
                    self.showServicesList.value = true
                }
            }
        }
    }
    //MARK: DITTO BLE Connection
    func startTimer() {
        self.responseTimer = Timer.scheduledTimer(timeInterval: value, target: self, selector: #selector(self.respond), userInfo: nil, repeats: true)
    }
    func stopTimer() {
        self.responseTimer.invalidate()
    }
    @objc  func respond() {
        self.value -= 1
        if self.value == 0.0 || self.mainPeripheral == nil {
            self.responseTimer.invalidate()
            self.connectionFailedtitle.value = self.secondWrite ? ConnectivityMessages.wiFiConnectionFailed : ConnectivityMessages.bleConnectionFailed
            self.showConnectivityStatus.value = WifiConnectionStatus.connectionUnsuccessfull.rawValue
        }
    }
    func connectBLEManager(peripheral: CBPeripheral) {
        self.manager?.connect(peripheral, options: nil)
        self.value = 10.0
        self.startTimer()
    }
    func initiateBLEManagers() {   // initiate BLE manager
        self.manager = CBCentralManager(delegate: self, queue: nil)
        self.peripheralManagaer = CBPeripheralManager(delegate: self, queue: nil)
    }
    func scanBLEDevices() {   // scan for BLE devices
        self.manager?.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            self.stopScanForBLEDevices()
        }
    }
    func stopScanForBLEDevices() {   // stop scanning for devices
        self.manager?.stopScan()
    }
    func sendValue(valuetoSend: String) {   // sending the credential data entered
        self.mainPeripheral?.delegate = self
        self.data = valuetoSend.data(using: .utf8)!
        if self.mainPeripheral?.state == CBPeripheralState.connected {
            let services = self.mainPeripheral?.services
            services?.forEach({ (service) in
                self.mainPeripheral?.discoverCharacteristics(nil, for: service)
                service.characteristics?.forEach({ (characteristic) in
                    if characteristic.uuid.uuidString == self.BLECharacteristic {
                        self.mainPeripheral?.delegate = self
                        self.mainPeripheral?.writeValue(self.data, for: characteristic, type: .withResponse)
                        self.mainPeripheral?.setNotifyValue(true, for: characteristic)
                    }
                })
            })
        }
        self.mainPeripheral?.discoverDescriptors(for: mainCharacteristic!)
    }
    func scanForServices() {   // Ditto Projector Service Connection
        self.services.removeAll()
        self.netServiceBrowser = NetServiceBrowser()
        self.netServiceBrowser.delegate = self
        self.netServiceBrowser.searchForServices(ofType: Constants.typeKey, inDomain: Constants.domainKey)
        self.netServiceBrowser.schedule(in: .current, forMode: .default)
    }
    func updateInterface() {   // Updating interface based on service connection
        if !self.services.isEmpty {
            self.services.forEach({ (service) in
                if service.port == -1 {
                    service.delegate = self
                    service.resolve(withTimeout: 5)
                } else { // UI update required
                    if self.isFromManageDevices && !self.isBLESearchFromManageDevices {
                        self.dissmissConnectivityDelegate?.dismmissConnectionView(presentScreenType: ScreenTypeString.skipType)
                    } else {
                        if let lastConnectedProjector = CommonConst.lastConnectedProjectorName as? String, service.name == lastConnectedProjector {
                            self.serviceName = service.name
                            self.showBLEPopUp.value = false
                            self.isLastConnectedProjector.value = true
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                self.isLastConnectedProjector.value = true
                                _ = self.connect(with: service)
                            }
                        } else {
                            if self.isFromBLEWIFIConnection.value {
                                _ = self.connect(with: service)
                            } else {
                                self.showBLEPopUp.value = true
                                self.host = self.getIPV4StringfromAddress(service.addresses!)
                                self.isLastConnectedProjector.value = false
                                self.showServicesList.value = true
                                self.serviceName = service.name
                                self.port = Int32(service.port)
                            }
                        }
                    }
                }
            })
        } else {
            self.showBLEPopUp.value = false
            self.showConnectivityStatus.value = WifiConnectionStatus.connectionUnsuccessfull.rawValue
        }
    }
    func getIPV4StringfromAddress(_ address: [Data]) -> String {   // To Get ipv4 string from service address 192.168.1.101
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
    func connect(with service: NetService?) -> Bool {   // Connect to Services
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
                    self.isShowAlertForNetService.value = true
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
                    self.connectionFailedtitle.value = ConnectivityMessages.projectorConnectionFailed
                    self.showBLEPopUp.value = false
                    self.showConnectivityStatus.value = WifiConnectionStatus.connectionUnsuccessfull.rawValue
                    break
                }
            }
        } else {
            isConnected = connectd
        }
        return isConnected
    }
}
