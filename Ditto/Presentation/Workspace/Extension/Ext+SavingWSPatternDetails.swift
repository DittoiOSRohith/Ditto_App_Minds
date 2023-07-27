//
//  Ext+SavingWSPatternDetails.swift
//  Ditto
//
//  Created by Abiya Joy on 28/03/22.
//  Copyright © 2022 Infosys. All rights reserved.
//

import UIKit

extension WorkspaceBaseViewController {
    func getDroppedPiecesBasedOnCategory(arrPieces: [PatternPieces], selectedTabCategory: WorkAreaTabCategory) -> [WSWorkSpaceIteamModel] {  // Getting the detaild of the dropped pieces based on category
        var tempArr = [WSWorkSpaceIteamModel]()
        for cutPieces in arrPieces {
            if let cutPiec = cutPieces as PatternPieces? {
                let objWSWorkSpaceIteamModel = WSWorkSpaceIteamModel()
                objWSWorkSpaceIteamModel.id = cutPiec.tagValue
                objWSWorkSpaceIteamModel.patternPiecesId = cutPiec.tailrnovaIndexId
                objWSWorkSpaceIteamModel.isCompleted = false
                objWSWorkSpaceIteamModel.xcoordinate = Double(self.getImageView(id: cutPiec.tagValue).frame.origin.x * self.objNewWorkSpaceBaseViewModel.scaleFacctor)
                objWSWorkSpaceIteamModel.ycoordinate = Double(self.getImageView(id: cutPiec.tagValue).frame.origin.y * self.objNewWorkSpaceBaseViewModel.scaleFacctor)
                objWSWorkSpaceIteamModel.isMirrorH = cutPiec.isMirrordH ? cutPiec.isMirrordH : false
                objWSWorkSpaceIteamModel.isMirrorV = cutPiec.isMirrorV ? cutPiec.isMirrorV : false
                objWSWorkSpaceIteamModel.transformA = cutPiec.transfromA != FormatsString.emptyString ? cutPiec.transfromA : Constants.defaultTransformValue
                objWSWorkSpaceIteamModel.transformD = cutPiec.transfromD != FormatsString.emptyString ? cutPiec.transfromD : Constants.defaultTransformValue
                objWSWorkSpaceIteamModel.showMirrorDialog = cutPiec.showMirrorDialog
                objWSWorkSpaceIteamModel.currentSplicedPieceNo = FormatsString.emptyString
                objWSWorkSpaceIteamModel.currentSplicedPieceRow = workspaceAreaView.currentImageRowValue
                objWSWorkSpaceIteamModel.currentSplicedPieceColumn = workspaceAreaView.currentImageColumnValue
                let pivotxxxxx = cutPiec.width / Double(Constants.halfConstantValue)  // half width of original piece
                let pivotyyyy = cutPiec.height / Double(Constants.halfConstantValue)  // half height of original piece
                // getting x and y coordinate of the original piece even if it is a rotated one ... Done for cross platform compatability
                let xdifference = Double(self.getImageView(id: cutPiec.tagValue).frame.origin.x) - (pivotxxxxx - Double(self.getImageView(id: cutPiec.tagValue).frame.size.width / Double(Constants.halfConstantValue)))
                let ydifference = Double(self.getImageView(id: cutPiec.tagValue).frame.origin.y) - (pivotyyyy - Double(self.getImageView(id: cutPiec.tagValue).frame.size.height / Double(Constants.halfConstantValue)))
                //  getting half width and height of original piece... Done for cross platform compatability
                objWSWorkSpaceIteamModel.pivotX = Double(pivotxxxxx * Double(self.objNewWorkSpaceBaseViewModel.scaleFacctor))
                objWSWorkSpaceIteamModel.pivotY = Double(pivotyyyy * Double(self.objNewWorkSpaceBaseViewModel.scaleFacctor))
                objWSWorkSpaceIteamModel.xcoordinate = (xdifference * Double(self.objNewWorkSpaceBaseViewModel.scaleFacctor))
                objWSWorkSpaceIteamModel.ycoordinate = (ydifference * Double(self.objNewWorkSpaceBaseViewModel.scaleFacctor))
                objWSWorkSpaceIteamModel.rotationAngle = self.getImageView(id: cutPiec.tagValue).transform.b != 0 ? cutPiec.degree : 0.0
                objWSWorkSpaceIteamModel.mirrorOption = cutPiec.mirrorOption
                tempArr.append(objWSWorkSpaceIteamModel)
            }
        }
        return tempArr
    }
    func getImageView(id: Int) -> UIImageView {  // Get imageview from workspace subviews based on tagvalue
        if self.objNewWorkSpaceBaseViewModel.totalImagesDropped > 0 {
            let imageArray = self.workspaceAreaView.workAreaView.subviews.filter {$0.tag == id}
            if !imageArray.isEmpty {
                return imageArray[0] as! UIImageView
            }
        }
        return  UIImageView()
    }
    func saveLocalWS() {   // Local saving of WS details for showing on tab switch
        if self.objNewWorkSpaceBaseViewModel.previousSelectedTabCategory == WorkAreaTabCategory.garment.categoryName {
            self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.garmetWorkspaceItems.removeAll()
            self.objNewWorkSpaceBaseViewModel.objGetWSMainPostModel.garmetWorkspaceItems.removeAll()
            self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.garmetWorkspaceItems = self.getDroppedPiecesBasedOnCategory(arrPieces: self.objNewWorkSpaceBaseViewModel.piecesDroppedArray, selectedTabCategory: .garment)
            self.objNewWorkSpaceBaseViewModel.objGetWSMainPostModel.garmetWorkspaceItems = self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.garmetWorkspaceItems
        } else if self.objNewWorkSpaceBaseViewModel.previousSelectedTabCategory == WorkAreaTabCategory.lining.categoryName {
            self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.liningWorkspaceItems.removeAll()
            self.objNewWorkSpaceBaseViewModel.objGetWSMainPostModel.liningWorkspaceItems.removeAll()
            self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.liningWorkspaceItems = self.getDroppedPiecesBasedOnCategory(arrPieces: self.objNewWorkSpaceBaseViewModel.piecesDroppedArray, selectedTabCategory: .lining)
            self.objNewWorkSpaceBaseViewModel.objGetWSMainPostModel.liningWorkspaceItems = self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.liningWorkspaceItems
        } else if self.objNewWorkSpaceBaseViewModel.previousSelectedTabCategory == WorkAreaTabCategory.interfacing.categoryName {
            self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.interfaceWorkspaceItems.removeAll()
            self.objNewWorkSpaceBaseViewModel.objGetWSMainPostModel.interfaceWorkspaceItems.removeAll()
            self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.interfaceWorkspaceItems = self.getDroppedPiecesBasedOnCategory(arrPieces: self.objNewWorkSpaceBaseViewModel.piecesDroppedArray, selectedTabCategory: .interfacing)
            self.objNewWorkSpaceBaseViewModel.objGetWSMainPostModel.interfaceWorkspaceItems = self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.interfaceWorkspaceItems
        } else if self.objNewWorkSpaceBaseViewModel.previousSelectedTabCategory == WorkAreaTabCategory.other.categoryName {
            self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.otherWorkspaceItems.removeAll()
            self.objNewWorkSpaceBaseViewModel.objGetWSMainPostModel.otherWorkspaceItems.removeAll()
            self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.otherWorkspaceItems = self.getDroppedPiecesBasedOnCategory(arrPieces: self.objNewWorkSpaceBaseViewModel.piecesDroppedArray, selectedTabCategory: .other)
            self.objNewWorkSpaceBaseViewModel.objGetWSMainPostModel.otherWorkspaceItems = self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.otherWorkspaceItems
        }
        self.objNewWorkSpaceBaseViewModel.totalImagesDropped = self.objNewWorkSpaceBaseViewModel.piecesDroppedArray.count
        CommonConst.userDefault.set(self.workspaceAreaView.currentImageRowValue, forKey: "\(self.objNewWorkSpaceBaseViewModel.previousSelectedTabCategory)row")
        CommonConst.userDefault.set(self.workspaceAreaView.currentImageColumnValue, forKey: "\(self.objNewWorkSpaceBaseViewModel.previousSelectedTabCategory)column")
        CommonConst.currentIndexPathCheck = self.objNewWorkSpaceBaseViewModel.currentIndexPath
    }
    func setupPostUpdateParam(_ completion: @escaping() -> Void) {   // Setting up params for Save/Update API on exit tap
        var tempArrPatternPieces = [WSPatternPiecesModel]()
        for item in 0..<self.objNewWorkSpaceBaseViewModel.getPatternPiecesBasedOnTab(tabType: WorkAreaTabCategory.garment.categoryName).count {
            let objWSPatternPiecesModel = WSPatternPiecesModel()
            objWSPatternPiecesModel.id = Int(self.objNewWorkSpaceBaseViewModel.getPatternPiecesBasedOnTab(tabType: WorkAreaTabCategory.garment.categoryName)[item].tailornovaIndex)
            objWSPatternPiecesModel.isCompleted = self.objNewWorkSpaceBaseViewModel.arrSelectedIndexGarment.contains(Int(self.objNewWorkSpaceBaseViewModel.getPatternPiecesBasedOnTab(tabType: WorkAreaTabCategory.garment.categoryName)[item].tailornovaIndex))
            tempArrPatternPieces.append(objWSPatternPiecesModel)
        }
        for item in 0..<self.objNewWorkSpaceBaseViewModel.getPatternPiecesBasedOnTab(tabType: WorkAreaTabCategory.lining.categoryName).count {
            let objWSPatternPiecesModel = WSPatternPiecesModel()
            objWSPatternPiecesModel.id = Int(self.objNewWorkSpaceBaseViewModel.getPatternPiecesBasedOnTab(tabType: WorkAreaTabCategory.lining.categoryName)[item].tailornovaIndex)
            objWSPatternPiecesModel.isCompleted = self.objNewWorkSpaceBaseViewModel.arrSelectedIndexLinings.contains(Int(self.objNewWorkSpaceBaseViewModel.getPatternPiecesBasedOnTab(tabType: WorkAreaTabCategory.lining.categoryName)[item].tailornovaIndex))
            tempArrPatternPieces.append(objWSPatternPiecesModel)
        }
        for item in 0..<self.objNewWorkSpaceBaseViewModel.getPatternPiecesBasedOnTab(tabType: WorkAreaTabCategory.interfacing.categoryName).count {
            let objWSPatternPiecesModel = WSPatternPiecesModel()
            objWSPatternPiecesModel.id = Int(self.objNewWorkSpaceBaseViewModel.getPatternPiecesBasedOnTab(tabType: WorkAreaTabCategory.interfacing.categoryName)[item].tailornovaIndex)
            objWSPatternPiecesModel.isCompleted = self.objNewWorkSpaceBaseViewModel.arrSelectedIndexInterfacing.contains(Int(self.objNewWorkSpaceBaseViewModel.getPatternPiecesBasedOnTab(tabType: WorkAreaTabCategory.interfacing.categoryName)[item].tailornovaIndex))
            tempArrPatternPieces.append(objWSPatternPiecesModel)
        }
        for item in 0..<self.objNewWorkSpaceBaseViewModel.getPatternPiecesBasedOnTab(tabType: WorkAreaTabCategory.other.categoryName).count {
            let objWSPatternPiecesModel = WSPatternPiecesModel()
            objWSPatternPiecesModel.id = Int(self.objNewWorkSpaceBaseViewModel.getPatternPiecesBasedOnTab(tabType: WorkAreaTabCategory.other.categoryName)[item].tailornovaIndex)
            objWSPatternPiecesModel.isCompleted = self.objNewWorkSpaceBaseViewModel.arrSelectedIndexOthers.contains(Int(self.objNewWorkSpaceBaseViewModel.getPatternPiecesBasedOnTab(tabType: WorkAreaTabCategory.other.categoryName)[item].tailornovaIndex))
            tempArrPatternPieces.append(objWSPatternPiecesModel)
        }
        self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.patternPieces = tempArrPatternPieces
        if !self.objNewWorkSpaceBaseViewModel.objGetWSMainPostModel.garmetWorkspaceItems.isEmpty {
            self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.garmetWorkspaceItems.removeAll()
            self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.garmetWorkspaceItems = self.objNewWorkSpaceBaseViewModel.objGetWSMainPostModel.garmetWorkspaceItems
        }
        if !self.objNewWorkSpaceBaseViewModel.objGetWSMainPostModel.liningWorkspaceItems.isEmpty {
            self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.liningWorkspaceItems.removeAll()
            self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.liningWorkspaceItems = self.objNewWorkSpaceBaseViewModel.objGetWSMainPostModel.liningWorkspaceItems
        }
        if !self.objNewWorkSpaceBaseViewModel.objGetWSMainPostModel.interfaceWorkspaceItems.isEmpty {
            self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.interfaceWorkspaceItems.removeAll()
            self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.interfaceWorkspaceItems = self.objNewWorkSpaceBaseViewModel.objGetWSMainPostModel.interfaceWorkspaceItems
        }
        if !self.objNewWorkSpaceBaseViewModel.objGetWSMainPostModel.otherWorkspaceItems.isEmpty {
            self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.otherWorkspaceItems.removeAll()
            self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.otherWorkspaceItems = self.objNewWorkSpaceBaseViewModel.objGetWSMainPostModel.otherWorkspaceItems
        }
        if self.objNewWorkSpaceBaseViewModel.selectedTabCategory == WorkAreaTabCategory.garment.categoryName {
            self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.garmetWorkspaceItems.removeAll()
            self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.garmetWorkspaceItems = self.getDroppedPiecesBasedOnCategory(arrPieces: self.objNewWorkSpaceBaseViewModel.piecesDroppedArray, selectedTabCategory: .garment)
        } else if self.objNewWorkSpaceBaseViewModel.selectedTabCategory == WorkAreaTabCategory.lining.categoryName {
            self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.liningWorkspaceItems.removeAll()
            self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.liningWorkspaceItems = self.getDroppedPiecesBasedOnCategory(arrPieces: self.objNewWorkSpaceBaseViewModel.piecesDroppedArray, selectedTabCategory: .lining)
        } else if self.objNewWorkSpaceBaseViewModel.selectedTabCategory == WorkAreaTabCategory.interfacing.categoryName {
            self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.interfaceWorkspaceItems.removeAll()
            self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.interfaceWorkspaceItems = self.getDroppedPiecesBasedOnCategory(arrPieces: self.objNewWorkSpaceBaseViewModel.piecesDroppedArray, selectedTabCategory: .interfacing)
        } else if self.objNewWorkSpaceBaseViewModel.selectedTabCategory == WorkAreaTabCategory.other.categoryName {
            self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.otherWorkspaceItems.removeAll()
            self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.otherWorkspaceItems = self.getDroppedPiecesBasedOnCategory(arrPieces: self.objNewWorkSpaceBaseViewModel.piecesDroppedArray, selectedTabCategory: .other)
        }
        self.completedPieceForTab()
        self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.tailornaovaDesignId = self.objNewWorkSpaceBaseViewModel.tailornovaPatternDesignId
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = FormatsString.dateFormatTwo
        self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.time = "\(Date().millisecondsSince1970)" // "Wed Sep 01 07:59:20 GMT 2021"
        self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.notes = Proxy.shared.returnFormattedNotes(isForDBSave: false, notesStr: self.objNewWorkSpaceBaseViewModel.notes)
        self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.selectedTab = self.objNewWorkSpaceBaseViewModel.selectedTabCategory
        self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.status = (self.objNewWorkSpaceBaseViewModel.patternstatus == FormatsString.new) ? FormatsString.OWNED: self.objNewWorkSpaceBaseViewModel.patternstatus
        completion()
    }
    func completedPieceForTab() {  // getting completed cut count for each category
        var garmentQuant = 0
        var liningQuant = 0
        var interfaceQuant = 0
        var otherQuant = 0
        let garmentselectedArr = self.objNewWorkSpaceBaseViewModel.getSelectedPatternPiecesBasedOnTab(
            selectedId: self.objNewWorkSpaceBaseViewModel.arrSelectedIndexGarment, tabType: WorkAreaTabCategory.garment.categoryName)
        let liningselectedArr = self.objNewWorkSpaceBaseViewModel.getSelectedPatternPiecesBasedOnTab(
            selectedId: self.objNewWorkSpaceBaseViewModel.arrSelectedIndexLinings, tabType: WorkAreaTabCategory.lining.categoryName)
        let interfaceselectedArr = self.objNewWorkSpaceBaseViewModel.getSelectedPatternPiecesBasedOnTab(
            selectedId: self.objNewWorkSpaceBaseViewModel.arrSelectedIndexInterfacing, tabType: WorkAreaTabCategory.interfacing.categoryName)
        let otherselectedArr = self.objNewWorkSpaceBaseViewModel.getSelectedPatternPiecesBasedOnTab(
            selectedId: self.objNewWorkSpaceBaseViewModel.arrSelectedIndexOthers, tabType: WorkAreaTabCategory.other.categoryName)
        for garment in garmentselectedArr {
            garmentQuant += Proxy.shared.getIntegerValuefromString(str: !garmentselectedArr.isEmpty ? garment.cutQuantity : FormatsString.zeroLabel)
        }
        for lining in liningselectedArr {
            liningQuant += Proxy.shared.getIntegerValuefromString(str: !liningselectedArr.isEmpty ? lining.cutQuantity : FormatsString.zeroLabel)
        }
        for interface in interfaceselectedArr {
            interfaceQuant += Proxy.shared.getIntegerValuefromString(str: !interfaceselectedArr.isEmpty ? interface.cutQuantity : FormatsString.zeroLabel)
        }
        for other in otherselectedArr {
            otherQuant += Proxy.shared.getIntegerValuefromString(str: !otherselectedArr.isEmpty ? other.cutQuantity : FormatsString.zeroLabel)
        }
        self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.numberOfCompletedPiece.garment = garmentQuant
        self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.numberOfCompletedPiece.lining = liningQuant
        self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.numberOfCompletedPiece.interface = interfaceQuant
        self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.numberOfCompletedPiece.other = otherQuant
    }
    func exitFromWorkspaceWithoutSavingAlert(responseError: String) {   // Popup when exiting WS without saving
        DispatchQueue.main.async {
            let viewc = Constants.AlertWithImageAndButtons.instantiateViewController(identifier: Constants.AlertWithImageAndButonsVCIdentifier) as AlertWithImageAndButtonsViewController
            viewc.alertArray = [ConnectivityUtils.failedImage, "\(responseError)", FormatsString.emptyString, AlertTitle.OKButton, FormatsString.emptyString]
            viewc.modalPresentationStyle = .overFullScreen
            viewc.onOKPressed = {
                DispatchQueue.main.async {
                    self.objNewWorkSpaceBaseViewModel.sendImage(imageString: ImageNames.wsLaunchImage, hostData: ProjectorDetails.Host, portData: ProjectorDetails.port)
                }
                Proxy.shared.keyWindow?.rootViewController?.dismiss(animated: false, completion: nil)
                self.navigationController?.popToRootViewController(animated: true)
            }
            if Proxy.shared.keyWindow?.rootViewController?.presentedViewController == nil {
                Proxy.shared.keyWindow?.rootViewController?.present(viewc, animated: false, completion: nil)
            }
        }
    }
}
