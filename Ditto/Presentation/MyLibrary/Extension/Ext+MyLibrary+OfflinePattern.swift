//
//  Ext+MyLibrary+OfflinePattern.swift
//  Ditto
//
//  Created by Gokul Ramesh on 24/03/22.
//  Copyright © 2022 Infosys. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

extension MyLibrarryViewController {
    func addObservers() {   // Add notification observer to check network availablity and update the offline/online patterns
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: FormatsString.NetworkStatus), object: nil)
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: FormatsString.NetworkStatus), object: nil, queue: OperationQueue.main) { _ in
            if let isinMylibrary = CommonConst.userDefault.value(forKey: IsInPage.myLibrary.rawValue) as? Bool, isinMylibrary {
                if let manager = NetworkReachabilityManager() {
                    if CommonConst.savedNetworkStatusCheck != manager.isReachable {
                        if manager.isReachable {
                            self.setpatterns(network: true)
                        } else {
                            self.setpatterns(network: false)
                            self.isInFolder = false
                        }
                    }
                }
            }
        }
    }
    func setpatterns(network: Bool) { // Set MyLibrary pattens according to the network status and load Online/Offline patterns
        DispatchQueue.main.async {
            if network {
                if !CommonConst.guestUserCheck {   // Logged In User
                    self.homeViewModel.getMyLibraryData { mylibraryData  in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.collectionView.reloadData()
                            KAppDelegate.window?.rootViewController?.view.viewWithTag(TagValue.lottieTag)?.removeFromSuperview()
                            self.view.viewWithTag(TagValue.lottieTag)?.removeFromSuperview()
                        }
                        self.myLibraryViewModel.objMylibData = mylibraryData
                        self.collectionView.reloadData()
                        self.pageID = 1
                        self.setOnlineUI()
                    }
                } else {   // Guest User
                    self.collectionView.reloadData()
                    self.setOnlineUI()
                }
            } else {
                guard let manager = NetworkReachabilityManager(), !manager.isReachable else { return }
                self.setOfflineUI()
                if !CommonConst.guestUserCheck {   // Logged In User
                    self.setOfflineFlow()
                    self.collectionView.reloadData()
                } else {   // Guest User
                    self.collectionView.reloadData()
                }
            }
        }
    }
    func setOfflineFlow() {
        guard let manager = NetworkReachabilityManager(), !manager.isReachable else { return }
        if !CommonConst.guestUserCheck {   // Logged In User
            if CommonConst.offlineDesignIdText != FormatsString.emptyString {
                self.myLibraryViewModel.DBFetch()
            }
            self.myLibraryViewModel.setofflineData(trailArray: self.homeViewModel.trailPatternArray)
            self.homeViewModel.offlineDataArray.removeAll()
            self.homeViewModel.offlineDataArray = self.myLibraryViewModel.offlinePattern
            if self.folderSwitch {
                self.folderSwitch = false
                self.collectionView.reloadData()
            }
        } else {   // Guest User
            self.homeViewModel.offlineDataArray.removeAll()
            Proxy.shared.openSettingApp()
        }
    }
}
