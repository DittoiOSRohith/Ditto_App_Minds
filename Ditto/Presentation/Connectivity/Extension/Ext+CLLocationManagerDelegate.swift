//
//  Ext+CLLocationManagerDelegate.swift
//  Ditto
//
//  Created by Abiya Joy on 22/02/22.
//  Copyright © 2022 Infosys. All rights reserved.
//

import UIKit
import CoreLocation

@objc protocol DissmissConnectivityDelegate {
    func dismmissConnectionView(presentScreenType: String)
    func passServiceAddress(host: String, port: Int32)
    @objc optional func passButtonTitle(title: String)
    @objc optional func passServices(services: [NetService], isThroughBLEWIFI: Bool)
}

@available(iOS 13.0, *)
extension ConnectivityViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    }
    func sendCalibImage() {  // SENDING SUCCESSFULLY CONNECTED CASE IMAGE TO PROJECTOR
        let img = UIImage(named: ImageNames.connectedRotatedImage)
        self.sendImage(img: img!)
    }
}
