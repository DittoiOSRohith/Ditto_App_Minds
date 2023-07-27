//
//  Ext+NetServiceBrowserDelegate.swift
//  Ditto
//
//  Created by Abiya Joy on 22/02/22.
//  Copyright © 2022 Infosys. All rights reserved.
//

import Foundation

extension ConnectivityViewModel: NetServiceBrowserDelegate {
    // MARK: NetServiceBrowserDelegate: The interface a net service browser uses to inform a delegate about the state of service discovery.
    func netServiceBrowserWillSearch(_ browser: NetServiceBrowser) {  // a search is stoping.
        DispatchQueue.main.asyncAfter(deadline: .now() + 10.0) {
            browser.stop()
        }
    }
    func netServiceBrowserDidStopSearch(_ browser: NetServiceBrowser) {  // search was stopped.
        self.netServices.value = self.services
        self.netServiceSearchingStopped.value = true
    }
    func netServiceBrowser(_ browser: NetServiceBrowser, didNotSearch errorDict: [String: NSNumber]) {
    }
    func netServiceBrowser(_ browser: NetServiceBrowser, didFind service: NetService, moreComing: Bool) {  // sender found a service
        if service.name.contains(Constants.dittoOnlyCheck) && !self.services.contains(service) {  // restrict marconi projector and solve duplicates
            self.services.append(service)
        }
        service.delegate = self
        service.resolve(withTimeout: 2)
    }
    func netServiceBrowser(_ browser: NetServiceBrowser, didRemove service: NetService, moreComing: Bool) {   // a service has disappeared or has become unavailable.
        if let index = self.services.firstIndex(of: service) {
            self.services.remove(at: index)
        }
    }
}
