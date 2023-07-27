//
//  PatterndescNavigationAndAlertExtension.swift
//  Ditto
//
//  Created by abiya.joy on 03/10/22.
//  Copyright © 2022 Infosys. All rights reserved.
//

import Foundation
import UIKit
import FastSocket
import Alamofire
import CoreData

extension PatternDescriptionViewController {
    func goToWorkspace() {   //  Navigation to workspace
        // IF pushing directly to workspace without ble and wifi case (simulator case ) need to uncomment below code, other wise crash occurs due to connect recalibrate text change in button mechanism
        if let socket = FastSocket(host: ProjectorDetails.Host, andPort: String(ProjectorDetails.port)), (ProjectorDetails.isProjectorConnected && socket.connect(3)) {
            CommonConst.serviceConnectedCheck = true
        } else {
            CommonConst.serviceConnectedCheck = false
        }
        if let manager = NetworkReachabilityManager(), manager.isReachable {
            self.getpatternDetailsandGotoWorkspace()
        } else {
            if self.patternDesViewModel.patternType == FormatsString.Trial {
                let fetchRequest: NSFetchRequest<Pattern> = Pattern.fetchRequest()
                fetchRequest.predicate = NSPredicate(format: "tailornovadesignID == %@", self.patternDesViewModel.tailornovaDesignId)
                do {
                    let objects = try DatabaseHelper().managedObjectContext.fetch(fetchRequest)
                    if !objects.isEmpty {
                        self.getOfflinePatternandGoToWorkspace()
                    } else {
                        self.getpatternDetailsandGotoWorkspace()
                    }
                } catch _ {
                    // error handling
                }
            } else {
                self.getOfflinePatternandGoToWorkspace()
            }
        }
    }
    func getpatternDetailsandGotoWorkspace() {  // Got to WS,if already worked pattern and is online
        if let workspaceViewController = Constants.workspaceStoryBoard.instantiateViewController(withIdentifier: Constants.WorkspaceBaseViewControllerIdentifier) as? WorkspaceBaseViewController {
            workspaceViewController.objNewWorkSpaceBaseViewModel.checkForTrailPattern = self.patternDesViewModel.patternType.uppercased() == FormatsString.TRIAL ? true : false
            workspaceViewController.objNewWorkSpaceBaseViewModel.patternType = self.patternDesViewModel.patternType
            workspaceViewController.objNewWorkSpaceBaseViewModel.subscriptionExpiryDate = self.patternDesViewModel.subscriptionExpiryDate
            workspaceViewController.objNewWorkSpaceBaseViewModel.tailornovaDesignName = self.patternDesViewModel.tailornovaDesignName
            workspaceViewController.objNewWorkSpaceBaseViewModel.patternsize = self.patternDesViewModel.patternSize
            workspaceViewController.objNewWorkSpaceBaseViewModel.patternstatus = self.patternDesViewModel.patternStatus
            workspaceViewController.objNewWorkSpaceBaseViewModel.parentTitle = self.patternDesViewModel.patternTitle
            workspaceViewController.objNewWorkSpaceBaseViewModel.host = self.patternDesViewModel.host
            workspaceViewController.objNewWorkSpaceBaseViewModel.port = self.patternDesViewModel.port
            workspaceViewController.objNewWorkSpaceBaseViewModel.pattern = self.patternDesViewModel.currentSelectedPatterny
            workspaceViewController.objNewWorkSpaceBaseViewModel.screenType = self.patternDesViewModel.screenType
            workspaceViewController.objNewWorkSpaceBaseViewModel.workSpace = self.patternDesViewModel.currenSelectedWorkspace
            workspaceViewController.objNewWorkSpaceBaseViewModel.parentTitle =  self.patternDesViewModel.patternTitle
            workspaceViewController.objNewWorkSpaceBaseViewModel.notes = self.patternDesViewModel.savednotes
            workspaceViewController.objNewWorkSpaceBaseViewModel.tailornovaPatternDesignId = self.patternDesViewModel.tailornovaDesignId
            workspaceViewController.objNewWorkSpaceBaseViewModel.arrUserDefaultWSSaveModel = self.patternDesViewModel.dropPieceArray
            workspaceViewController.objNewWorkSpaceBaseViewModel.selectedTabCategory = self.patternDesViewModel.selectedTabCategory
            workspaceViewController.objNewWorkSpaceBaseViewModel.tailornoavInstructionURL = self.patternDesViewModel.tailornovaInsUrl
            workspaceViewController.objNewWorkSpaceBaseViewModel.patternDescription =  self.patternDesViewModel.patternDescription
            workspaceViewController.objNewWorkSpaceBaseViewModel.patternBrand = self.patternDesViewModel.patternBrand
            workspaceViewController.objNewWorkSpaceBaseViewModel.lastModifiedSizeDate = self.patternDesViewModel.lastModifiedSizeDate
            workspaceViewController.objNewWorkSpaceBaseViewModel.customSizeFitName = self.patternDesViewModel.customSizeFitName
            workspaceViewController.objNewWorkSpaceBaseViewModel.selectedSizeName = self.patternDesViewModel.selectedSizeName
            workspaceViewController.objNewWorkSpaceBaseViewModel.selectedViewCupSizeName = self.patternDesViewModel.selectedViewCupSizeName
            workspaceViewController.objNewWorkSpaceBaseViewModel.productId = self.patternDesViewModel.productId
            workspaceViewController.objNewWorkSpaceBaseViewModel.yardageDetails = self.patternDesViewModel.yardageDetails
            workspaceViewController.objNewWorkSpaceBaseViewModel.notionDetails = self.patternDesViewModel.notionDetails
            workspaceViewController.objNewWorkSpaceBaseViewModel.yardagePdfUrl = self.patternDesViewModel.yardagePdfUrl
            workspaceViewController.objNewWorkSpaceBaseViewModel.tailornovaOrderNo = self.patternDesViewModel.orderNo != FormatsString.emptyString ? self.patternDesViewModel.orderNo : KAppDelegate.tailorNovaOrderID
            workspaceViewController.objNewWorkSpaceBaseViewModel.patternNameDirectory = self.patternDesViewModel.tailornovaDesignId
            if self.patternDesViewModel.patternType != FormatsString.Trial {
                workspaceViewController.objNewWorkSpaceBaseViewModel.tailornovamannequinIDArray = self.patternDesViewModel.tailornovamannequinIDArray.filter({$0.mannequinID == self.patternDesViewModel.designIdToPass})
                workspaceViewController.objNewWorkSpaceBaseViewModel.purchasedSizeId = self.patternDesViewModel.purchasedSizeId
                if !workspaceViewController.objNewWorkSpaceBaseViewModel.tailornovamannequinIDArray.isEmpty {
                    workspaceViewController.objNewWorkSpaceBaseViewModel.patternNameDirectory += "_" + workspaceViewController.objNewWorkSpaceBaseViewModel.tailornovamannequinIDArray[0].mannequinID
                } else {
                    workspaceViewController.objNewWorkSpaceBaseViewModel.patternNameDirectory += "_" + self.patternDesViewModel.purchasedSizeId
                }
            }
            //  WORKSPACE TAILORNOVA CHNAGES
            var filterPatternArray = self.patternDesViewModel.tailornovaSelvagesModelObjectArray.filter({$0.tabCategory.capitalized == FormatsString.garment})
            filterPatternArray.removeAll()
            for item in self.patternDesViewModel.tailornovaSelvagesModelObjectArray.filter({$0.tabCategory.capitalized == FormatsString.garment}) {
                if !filterPatternArray.contains(where: {$0.fabricLength == item.fabricLength && $0.tabCategory.capitalized == FormatsString.garment}) {
                    if item.fabricLength == ReferenceLayoutType.fourtyfive || item.fabricLength == ReferenceLayoutType.sixty {
                        filterPatternArray.append(item)
                    }
                }
            }
            for item in self.patternDesViewModel.tailornovaSelvagesModelObjectArray.filter({$0.tabCategory.capitalized == FormatsString.lining}) {
                if !filterPatternArray.contains(where: {$0.fabricLength == item.fabricLength && $0.tabCategory.capitalized == FormatsString.lining}) {
                    if item.fabricLength == ReferenceLayoutType.fourtyfive || item.fabricLength == ReferenceLayoutType.sixty {
                        filterPatternArray.append(item)
                    }
                }
            }
            for item in self.patternDesViewModel.tailornovaSelvagesModelObjectArray.filter({$0.tabCategory.capitalized == FormatsString.interfacing}) {
                if !filterPatternArray.contains(where: {$0.fabricLength == item.fabricLength && $0.tabCategory == FormatsString.interfacing}) {
                    if item.fabricLength == ReferenceLayoutType.twenty || item.fabricLength == ReferenceLayoutType.fourtyfive {
                        filterPatternArray.append(item)
                    }
                }
            }
            for item in self.patternDesViewModel.tailornovaSelvagesModelObjectArray.filter({$0.tabCategory.capitalized == FormatsString.other}) {
                if !filterPatternArray.contains(where: {$0.fabricLength == item.fabricLength && $0.tabCategory.capitalized == FormatsString.other}) {
                    if item.fabricLength == ReferenceLayoutType.fourtyfive || item.fabricLength == ReferenceLayoutType.sixty {
                        filterPatternArray.append(item)
                    }
                }
            }
            workspaceViewController.objNewWorkSpaceBaseViewModel.tailornovaModelObject = self.patternDesViewModel.tailornovaModelObject
            workspaceViewController.objNewWorkSpaceBaseViewModel.tailornovaSelvagesArray = filterPatternArray
            workspaceViewController.objNewWorkSpaceBaseViewModel.tailornovaPatternArray = self.patternDesViewModel.tailornovaModelObjectArray
            workspaceViewController.objNewWorkSpaceBaseViewModel.descriptionImageURL = self.patternDesViewModel.descriptionImageURL
            self.navigationController?.pushViewController(workspaceViewController, animated: true)
        }
    }
    func getOfflinePatternandGoToWorkspace() {  // Got to WS, if it is offline
        self.patternDesViewModel.getPatternOffline(id: self.patternDesViewModel.tailornovaDesignId) { pattern in
            if let workspaceViewController = Constants.workspaceStoryBoard.instantiateViewController(withIdentifier: Constants.WorkspaceBaseViewControllerIdentifier) as? WorkspaceBaseViewController {
                workspaceViewController.objNewWorkSpaceBaseViewModel.checkForTrailPattern = self.patternDesViewModel.patternType.uppercased() == FormatsString.TRIAL ? true : false
                workspaceViewController.objNewWorkSpaceBaseViewModel.patternType = self.patternDesViewModel.patternType
                workspaceViewController.objNewWorkSpaceBaseViewModel.subscriptionExpiryDate = self.patternDesViewModel.subscriptionExpiryDate
                workspaceViewController.objNewWorkSpaceBaseViewModel.tailornovaDesignName = self.patternDesViewModel.tailornovaDesignName
                workspaceViewController.objNewWorkSpaceBaseViewModel.parentTitle = self.patternDesViewModel.patternTitle
                workspaceViewController.objNewWorkSpaceBaseViewModel.notes = self.patternDesViewModel.savednotes
                workspaceViewController.objNewWorkSpaceBaseViewModel.patternsize = self.patternDesViewModel.patternSize
                workspaceViewController.objNewWorkSpaceBaseViewModel.patternstatus = self.patternDesViewModel.patternStatus
                workspaceViewController.objNewWorkSpaceBaseViewModel.host = self.patternDesViewModel.host
                workspaceViewController.objNewWorkSpaceBaseViewModel.port = self.patternDesViewModel.port
                workspaceViewController.objNewWorkSpaceBaseViewModel.pattern = self.patternDesViewModel.currentSelectedPatterny
                workspaceViewController.objNewWorkSpaceBaseViewModel.screenType = self.patternDesViewModel.screenType
                workspaceViewController.objNewWorkSpaceBaseViewModel.workSpace = self.patternDesViewModel.currenSelectedWorkspace
                workspaceViewController.objNewWorkSpaceBaseViewModel.parentTitle = self.patternDesViewModel.patternTitle
                workspaceViewController.objNewWorkSpaceBaseViewModel.tailornovaPatternDesignId = self.patternDesViewModel.tailornovaDesignId
                workspaceViewController.objNewWorkSpaceBaseViewModel.arrUserDefaultWSSaveModel = self.patternDesViewModel.dropPieceArray
                workspaceViewController.objNewWorkSpaceBaseViewModel.selectedTabCategory = self.patternDesViewModel.selectedTabCategory
                workspaceViewController.objNewWorkSpaceBaseViewModel.tailornoavInstructionURL = self.patternDesViewModel.tailornovaInsUrl
                workspaceViewController.objNewWorkSpaceBaseViewModel.patternBrand = self.patternDesViewModel.patternBrand
                workspaceViewController.objNewWorkSpaceBaseViewModel.lastModifiedSizeDate = self.patternDesViewModel.lastModifiedSizeDate
                workspaceViewController.objNewWorkSpaceBaseViewModel.customSizeFitName = self.patternDesViewModel.customSizeFitName
                workspaceViewController.objNewWorkSpaceBaseViewModel.selectedSizeName = self.patternDesViewModel.selectedSizeName
                workspaceViewController.objNewWorkSpaceBaseViewModel.selectedViewCupSizeName = self.patternDesViewModel.selectedViewCupSizeName
                workspaceViewController.objNewWorkSpaceBaseViewModel.productId = self.patternDesViewModel.productId
                workspaceViewController.objNewWorkSpaceBaseViewModel.yardageDetails = self.patternDesViewModel.yardageDetails
                workspaceViewController.objNewWorkSpaceBaseViewModel.notionDetails = self.patternDesViewModel.notionDetails
                workspaceViewController.objNewWorkSpaceBaseViewModel.yardagePdfUrl = self.patternDesViewModel.yardagePdfUrl
                workspaceViewController.objNewWorkSpaceBaseViewModel.descriptionImageURL = self.patternDesViewModel.descriptionImageURL
                workspaceViewController.objNewWorkSpaceBaseViewModel.patternNameDirectory = self.patternDesViewModel.tailornovaDesignId
                if self.patternDesViewModel.patternType != FormatsString.Trial {
                    workspaceViewController.objNewWorkSpaceBaseViewModel.tailornovamannequinIDArray = self.patternDesViewModel.tailornovamannequinIDArray
                    workspaceViewController.objNewWorkSpaceBaseViewModel.purchasedSizeId = self.patternDesViewModel.purchasedSizeId
                    if !workspaceViewController.objNewWorkSpaceBaseViewModel.tailornovamannequinIDArray.isEmpty {
                        workspaceViewController.objNewWorkSpaceBaseViewModel.patternNameDirectory += "_" + self.patternDesViewModel.tailornovamannequinIDArray[0].mannequinID
                    } else {
                        workspaceViewController.objNewWorkSpaceBaseViewModel.patternNameDirectory += "_" + self.patternDesViewModel.purchasedSizeId
                    }
                }
                //  WORKSPACE TAILORNOVA CHNAGES
                var filterPatternArray = pattern.selvages.filter({$0.tabCategory.capitalized == FormatsString.garment})
                filterPatternArray.removeAll()
                for item in pattern.selvages.filter({$0.tabCategory.capitalized == FormatsString.garment}) {
                    if !filterPatternArray.contains(where: {$0.fabricLength == item.fabricLength && $0.tabCategory.capitalized == FormatsString.garment}) {
                        if item.fabricLength == ReferenceLayoutType.fourtyfive || item.fabricLength == ReferenceLayoutType.sixty {
                            filterPatternArray.append(item)
                        }
                    }
                }
                for item in pattern.selvages.filter({$0.tabCategory.capitalized == FormatsString.lining}) {
                    if !filterPatternArray.contains(where: {$0.fabricLength == item.fabricLength && $0.tabCategory.capitalized == FormatsString.lining}) {
                        if item.fabricLength == ReferenceLayoutType.fourtyfive || item.fabricLength == ReferenceLayoutType.sixty {
                            filterPatternArray.append(item)
                        }
                    }
                }
                for item in pattern.selvages.filter({$0.tabCategory.capitalized == FormatsString.interfacing}) {
                    if !filterPatternArray.contains(where: {$0.fabricLength == item.fabricLength && $0.tabCategory.capitalized == FormatsString.interfacing}) {
                        if item.fabricLength == ReferenceLayoutType.twenty || item.fabricLength == ReferenceLayoutType.fourtyfive {
                            filterPatternArray.append(item)
                        }
                    }
                }
                for item in pattern.selvages.filter({$0.tabCategory.capitalized == FormatsString.other}) {
                    if !filterPatternArray.contains(where: {$0.fabricLength == item.fabricLength && $0.tabCategory.capitalized == FormatsString.other}) {
                        if item.fabricLength == ReferenceLayoutType.fourtyfive || item.fabricLength == ReferenceLayoutType.sixty {
                            filterPatternArray.append(item)
                        }
                    }
                }
                workspaceViewController.objNewWorkSpaceBaseViewModel.tailornovaModelObject = pattern
                workspaceViewController.objNewWorkSpaceBaseViewModel.tailornovaSelvagesArray = filterPatternArray
                workspaceViewController.objNewWorkSpaceBaseViewModel.tailornovaPatternArray = pattern.patternPieces
                workspaceViewController.objNewWorkSpaceBaseViewModel.patternDescription = self.patternDesViewModel.patternDescription
                workspaceViewController.objNewWorkSpaceBaseViewModel.tailornovaOrderNo = self.patternDesViewModel.orderNo
                self.dismissLottie()
                self.navigationController?.pushViewController(workspaceViewController, animated: true)
            }
        }
    }
    func retrieveImage(forKey key: String, inStorageType storageType: StorageType) -> UIImage? {
        switch storageType {
        case .fileSystem: break
        case .userDefaults:
            if let imageData = CommonConst.userDefault.object(forKey: key) as? Data {
                let image = UIImage(data: imageData)
                return image
            }
        }
        return UIImage()
    }
    func displayErrorPopUp() {   // Popup when Error inDownloading PDF
        DispatchQueue.main.async {
            let viewc = Constants.AlertWithImageAndButtons.instantiateViewController(identifier: Constants.AlertWithImageAndButonsVCIdentifier) as AlertWithImageAndButtonsViewController
            viewc.alertArray = [ConnectivityUtils.failedImage, AlertMessage.unabletoLoadFIle, AlertTitle.RETRY, AlertTitle.CANCEL, FormatsString.emptyString]
            viewc.screenType = ScreenTypeString.PatternDesc
            viewc.modalPresentationStyle = .overFullScreen
            viewc.onRetryPressed = {
                Proxy.shared.keyWindow?.rootViewController?.dismiss(animated: false, completion: nil)
                self.instructionsAction(UIButton())
            }
            if Proxy.shared.keyWindow?.rootViewController?.presentedViewController == nil {
                Proxy.shared.keyWindow?.rootViewController?.present(viewc, animated: false, completion: nil)
            }
        }
    }
    func unabletoFetchDesignIDErrorPopUp() {   // Popup when unable to fetch Design ID
        DispatchQueue.main.async {
            let viewc = Constants.AlertWithImageAndButtons.instantiateViewController(identifier: Constants.AlertWithImageAndButonsVCIdentifier) as AlertWithImageAndButtonsViewController
            viewc.alertArray = [ConnectivityUtils.failedImage, MessageString.unabletoFetchDesignID, FormatsString.emptyString, AlertTitle.OKButton, FormatsString.emptyString]
            viewc.screenType = ScreenTypeString.PatternDesc
            viewc.modalPresentationStyle = .overFullScreen
            viewc.onOKPressed = {
                Proxy.shared.keyWindow?.rootViewController?.dismiss(animated: false, completion: nil)
                self.popToRoot()
            }
            if Proxy.shared.keyWindow?.rootViewController?.presentedViewController == nil {
                Proxy.shared.keyWindow?.rootViewController?.present(viewc, animated: false, completion: nil)
            }
        }
    }
}
