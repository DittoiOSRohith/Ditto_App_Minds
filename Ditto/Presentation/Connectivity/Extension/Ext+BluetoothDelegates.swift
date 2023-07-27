//
//  Ext+BluetoothDelegates.swift
//  Ditto
//
//  Created by Abiya Joy on 22/02/22.
//  Copyright © 2022 Infosys. All rights reserved.
//

import Foundation
import CoreBluetooth

extension ConnectivityViewModel: CBCentralManagerDelegate, CBPeripheralDelegate, CBPeripheralManagerDelegate {
    // MARK: Bluetooth Delegates
    // MARK: CBCentralManagerDelegate : A protocol that provides updates for the discovery and management of peripheral devices.
    func centralManagerDidUpdateState(_ central: CBCentralManager) {  // central manager’s state updated.
    }
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {  // central manager discovered a peripheral while scanning for devices.
        let localKey = advertisementData[CBAdvertisementDataLocalNameKey] as? String ?? FormatsString.unknowmDeviceLabel
        if localKey.contains(Constants.dittoOnlyCheck) && !self.peripherals.contains(peripheral) {
            self.peripherals.append(peripheral)
            self.peripheralAddNameArray.append(advertisementData[CBAdvertisementDataLocalNameKey] as? String ?? FormatsString.unknowmDeviceLabel)
            self.peripheralAddversimentDataArray.append((advertisementData[CBAdvertisementDataLocalNameKey] as? String ?? FormatsString.unknowmDeviceLabel, peripheral))
        }
        self.blePeripherals.value = peripherals
    }
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {  // central manager connected to a peripheral.
        self.mainPeripheral = peripheral
        peripheral.delegate = self
        peripheral.discoverServices(nil)
        self.manager?.delegate = self
    }
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {  // central manager disconnected from a peripheral.
    }
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {  // central manager failed to create a connection with a peripheral.
    }
    // MARK: CBPeripheralManagerDelegate: A protocol that provides updates for local peripheral state and interactions with remote central devices.
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {  // peripheral manager’s state updated
        if #available(iOS 10.0, *) {
            if peripheral.state != CBManagerState.poweredOn {
                return
            } else if  peripheral.state == CBManagerState.poweredOn {
                self.manager?.scanForPeripherals(withServices: nil, options: [CBCentralManagerScanOptionAllowDuplicatesKey: false])
            }
        }
        self.transferCharacteristic = CBMutableCharacteristic(type: CBUUID(string: self.BLECharacteristic), properties: CBCharacteristicProperties.notify, value: nil, permissions: CBAttributePermissions.readable)
        let transferService = CBMutableService(type: CBUUID(string: self.BLEService), primary: true)
        transferService.characteristics = [self.transferCharacteristic]
        self.peripheralManagaer!.add(transferService)
    }
    // MARK: CBPeripheralDelegate: A protocol that provides updates on the use of a peripheral’s services.
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {   // peripheral service discovery succeeded
        for service in peripheral.services!.filter({ $0.uuid.uuidString == self.BLEService}) {
            peripheral.discoverCharacteristics(nil, for: service)
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {  // peripheral found characteristics for a service
        self.characteristics = service.characteristics
        if service.uuid.uuidString == self.BLEService {
            for characteristic in service.characteristics!.filter({ $0.uuid.uuidString == BLECharacteristic}) {
                self.mainCharacteristic = characteristic
                peripheral.setNotifyValue(true, for: characteristic)
            }
        }
        self.mainPeripheral?.discoverDescriptors(for: self.mainCharacteristic!)
    }
    func peripheral(_ peripheral: CBPeripheral, didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {  // peripheral found descriptors for a characteristic
        characteristic.descriptors?.forEach({ (descriptors) in
            if descriptors.uuid.uuidString == FormatsString.uuidLabel {
                self.mainDescriptor = descriptors
                if self.gotResponse && self.secondWrite {
                    self.secondWrite = false
                    self.sendValue(valuetoSend: self.dataToSend)
                } else {
                    self.sendValue(valuetoSend: Constants.TRACEREQUEST)
                }
            }
        })
    }
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {  // peripheral successfully set a value for the characteristic
        peripheral.readValue(for: self.mainCharacteristic!)
        if characteristic.uuid.uuidString == self.BLECharacteristic {
            peripheral.setNotifyValue(true, for: characteristic)
        }
    }
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {  // retrieving the specified characteristic’s value succeeded, or the characteristic’s value changed
        if characteristic.uuid.uuidString == self.BLECharacteristic {
            if characteristic.value != nil {
                guard let stringValue = String(data: characteristic.value!, encoding: String.Encoding.utf8) else {
                    self.gotResponse = true
                    self.showConnectivityStatus.value = WifiConnectionStatus.connectionUnsuccessfull.rawValue
                    self.connectionFailedtitle.value = ConnectivityMessages.bleConnectionFailed
                    self.isBLEConnectionFailed.value = true
                    self.responseTimer.invalidate()
                    self.manager?.cancelPeripheralConnection(self.mainPeripheral!)
                    return
                }
                if stringValue == WifiConnectionStatus.traceBLEConnected.rawValue {
                    self.gotResponse = true
                    self.isBLEConnected = true
                    self.secondWrite = true
                    self.responseTimer.invalidate()
                    self.showConnectivityStatus.value = WifiConnectionStatus.traceBLEConnected.rawValue
                    self.manager?.cancelPeripheralConnection(self.mainPeripheral!)
                } else if  stringValue.contains(WifiConnectionStatus.serviceSuccess.rawValue) {
                    let lastProjector = stringValue.split(separator: ",")
                    CommonConst.removeObjectFromKey(key: CommonConst.lastConnectedProjector)
                    CommonConst.lastConnectedProjectorName = (lastProjector.count > 1) ? lastProjector[1] : FormatsString.emptyString
                    ProjectorDetails.projectorName = (lastProjector.count > 1) ? String(lastProjector[1]) : FormatsString.emptyString
                    self.stopTimer()
                    self.isFromBLEWIFIConnection.value = true
                    self.scanForServices()
                    self.showConnectivityStatus.value = WifiConnectionStatus.serviceSuccess.rawValue
                    self.isBLESearchFromManageDevices = false
                    self.isThroughBLEWIFI = true
                    self.showServicesList.value = true
                } else if stringValue == WifiConnectionStatus.traceFailed.rawValue {
                    self.gotResponse = true
                    self.stopTimer()
                    self.showConnectivityStatus.value = WifiConnectionStatus.traceFailed.rawValue
                    self.isBLEConnectionFailed.value = false
                    self.connectionFailedtitle.value = ConnectivityMessages.wiFiConnectionFailed
                    self.manager?.cancelPeripheralConnection(self.mainPeripheral!)
                } else if stringValue == WifiConnectionStatus.traceFailedWiFi.rawValue {
                    self.gotResponse = true
                    self.secondWrite = true
                    self.stopTimer()
                    self.showConnectivityStatus.value = WifiConnectionStatus.traceFailedWiFi.rawValue
                    self.connectionFailedtitle.value = ConnectivityMessages.wiFiConnectionFailed
                    self.manager?.cancelPeripheralConnection(self.mainPeripheral!)
                } else {
                    self.showConnectivityStatus.value = WifiConnectionStatus.connectionUnsuccessfull.rawValue
                    self.connectionFailedtitle.value = ConnectivityMessages.bleConnectionFailed
                    self.stopTimer()
                    self.isBLEConnectionFailed.value = false
                    self.gotResponse = true
                    self.manager?.cancelPeripheralConnection(self.mainPeripheral!)
                }
            }
        }
    }
}
