//
//  Ext+UITableViewDataSource.swift
//  Ditto
//
//  Created by Abiya Joy on 22/02/22.
//  Copyright © 2022 Infosys. All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
extension ConnectivityViewController: UITableViewDelegate, UITableViewDataSource {
    // table view functions
    func tableViewDuplicateAvoiding() {   // Removing duplicate items from table view
        if !self.dataViewModel.services.isEmpty {
            let serviceArray = self.dataViewModel.services.sorted(by: { $0.name < $1.name })
            self.dataViewModel.services.removeAll()
            for service in serviceArray where !self.dataViewModel.services.contains(service) {
                self.dataViewModel.services.append(service)
            }
        }
        if !self.dataViewModel.peripheralAddversimentDataArray.isEmpty {
            let peripheralArray = self.dataViewModel.peripheralAddversimentDataArray.sorted(by: { $0.name < $1.name })
            self.dataViewModel.peripheralAddversimentDataArray.removeAll()
            for peripheral in peripheralArray where !self.dataViewModel.peripheralAddversimentDataArray.contains(where: {$0.name == peripheral.name}) {
                self.dataViewModel.peripheralAddversimentDataArray.append(peripheral)
            }
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.tableViewDuplicateAvoiding()
        let rows = self.dataViewModel.showServicesList.value ? self.dataViewModel.services.count : self.dataViewModel.peripheralAddversimentDataArray.count
        return rows > 0 ? rows : 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        self.tableViewDuplicateAvoiding()
        var tableViewCell = UITableViewCell()
        if let cell = self.showBLEDeviceTableView.dequeueReusableCell(withIdentifier: ReusableCellIdentifiers.bleDevicesIdentifier, for: indexPath) as? BLEDevicesTableViewCell {
            if self.dataViewModel.showServicesList.value {  // PROJECTOR LIST
                if indexPath.row < self.dataViewModel.services.count && indexPath.row >= 0 {
                    cell.deviceNameLabel?.text = self.dataViewModel.services[indexPath.row].name
                    tableViewCell = cell
                }
            } else {   // BLE list
                if indexPath.row < self.dataViewModel.peripheralAddversimentDataArray.count && indexPath.row >= 0 {
                    let periAddName = self.dataViewModel.peripheralAddversimentDataArray[indexPath.row]
                    cell.tag  = indexPath.row
                    cell.deviceNameLabel?.text = periAddName.name
                    cell.selectionStyle = UITableViewCell.SelectionStyle.default
                    self.showBLEDeviceTableView.rowHeight = cell.deviceNameLabel.frame.size.height + 12
                    tableViewCell = cell
                }
            }
        }
        return tableViewCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.dataViewModel.showServicesList.value {
            if indexPath.row < self.dataViewModel.services.count && indexPath.row >= 0 {
                let serv = self.dataViewModel.services[indexPath.row] as NetService
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    _ = self.dataViewModel.connect(with: serv)
                }
                self.showBLEDevicesView.isHidden = true
                self.mainCenterConnectingShownView.isHidden = false
                self.showConnectionLottie()
            }
        } else {
            // PERIPHERAL SELECTION
            if indexPath.row < self.dataViewModel.peripheralAddversimentDataArray.count && indexPath.row >= 0 {
                self.selectCell(indexPath: indexPath)
                let name = self.dataViewModel.peripheralAddversimentDataArray[indexPath.row].peripheral
                let periAddName = self.dataViewModel.peripheralAddversimentDataArray[indexPath.row].name
                if periAddName == FormatsString.unknowmDeviceLabel || name.name == nil {
                    self.showBLEDevicesView.isHidden = true
                    self.dataViewModel.connectionFailedtitle.value = ConnectivityMessages.bleConnectionFailed
                    self.dataViewModel.showConnectivityStatus.value = WifiConnectionStatus.connectionUnsuccessfull.rawValue
                } else {
                    if indexPath.row < self.dataViewModel.peripherals.count && indexPath.row >= 0 {
                        let peripheral = self.dataViewModel.peripherals[indexPath.row]
                        self.showBLEDevicesView.isHidden = true
                        self.mainCenterConnectingShownView.isHidden = false
                        Thread.sleep(forTimeInterval: 1)
                        self.dataViewModel.manager?.cancelPeripheralConnection(peripheral)
                        self.dataViewModel.connectBLEManager(peripheral: peripheral)
                    }
                }
            }
        }
    }
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = self.showBLEDeviceTableView.dequeueReusableCell(withIdentifier: ReusableCellIdentifiers.bleDevicesIdentifier, for: indexPath) as? BLEDevicesTableViewCell {
            cell.backgroundColor = .clear
        }
    }
}
