//
//  Ext+NetServiceDelegate.swift
//  Ditto
//
//  Created by Abiya Joy on 22/02/22.
//  Copyright © 2022 Infosys. All rights reserved.
//

import Foundation

extension ConnectivityViewModel: NetServiceDelegate {
    // MARK: NetServiceDelegate: The interface a net service uses to inform its delegate about the state of the service it offers.
    func netServiceWillResolve(_ sender: NetService) {
    }
    func netServiceDidResolveAddress(_ sender: NetService) {  // address for a given service was resolved
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.updateInterface()
        }
    }
    func netService(_ sender: NetService, didNotResolve errorDict: [String: NSNumber]) {  // an error occurred during resolution of a given service.
        self.services.removeAll()
    }
    func netServiceDidStop(_ sender: NetService) {
    }
}
