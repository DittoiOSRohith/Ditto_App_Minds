//
//  ManageProjectorDismissDelegateExtension.swift
//  Ditto
//
//  Created by abiya.joy on 29/09/22.
//  Copyright © 2022 Infosys. All rights reserved.
//

import UIKit

extension ManageProjectorViewController: DissmissConnectivityDelegate {
    func dismmissConnectionView(presentScreenType: String) {  // handling dismiss lottie based on different screen type
        if presentScreenType == ScreenTypeString.skipType {
            self.dataViewModel.foundService.value = !self.dataViewModel.availableServices.isEmpty ? true : false
            self.dataViewModel.showLoader.value = false
            self.dismiss(animated: false, completion: nil)
        }
    }
    func passServices(services: [NetService], isThroughBLEWIFI: Bool) {   // sorting required service from the list and deciding other details based on that service
        self.dataViewModel.availableProjectors = []
        self.dataViewModel.availableServices = []
        services.sorted(by: { $0.name < $1.name }).forEach { (service) in
            if service.name.contains(Constants.dittoOnlyCheck) && !self.dataViewModel.availableProjectors.contains(service.name) {
                self.dataViewModel.availableProjectors.add(service.name)
                self.dataViewModel.availableServices.append(service)
            }
        }
        self.dataViewModel.foundService.value = !services.isEmpty ? true : false
        self.noOfProjectorsLbl.text = "\(services.count)\(FormatsString.projectorFoundLabel)"
        self.dataViewModel.isThroughBLEWIFI = isThroughBLEWIFI
        self.dataViewModel.tableReloading.value = true
        self.dismiss(animated: false) {
            self.dataViewModel.showLoader.value = false
        }
    }
    func passServiceAddress(host: String, port: Int32) {
    }
}
