//
//  Ext+ShowPreviousPattern.swift
//  Ditto
//
//  Created by Gaurav.rajan on 27/10/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire

extension WorkspaceBaseViewController {
    func showPreviousPatterUserWorked() {   // Logic for showing saved pattern
        if let manager = NetworkReachabilityManager(), !manager.isReachable {
            self.objNewWorkSpaceBaseViewModel.objGetWSMainPostModel.garmetWorkspaceItems.removeAll()
            self.objNewWorkSpaceBaseViewModel.objGetWSMainPostModel.liningWorkspaceItems.removeAll()
            self.objNewWorkSpaceBaseViewModel.objGetWSMainPostModel.interfaceWorkspaceItems.removeAll()
            self.objNewWorkSpaceBaseViewModel.objGetWSMainPostModel.otherWorkspaceItems.removeAll()
            self.objNewWorkSpaceBaseViewModel.objGetWSMainPostModel.garmetWorkspaceItems = self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.garmetWorkspaceItems
            self.objNewWorkSpaceBaseViewModel.objGetWSMainPostModel.liningWorkspaceItems = self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.liningWorkspaceItems
            self.objNewWorkSpaceBaseViewModel.objGetWSMainPostModel.interfaceWorkspaceItems = self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.interfaceWorkspaceItems
            self.objNewWorkSpaceBaseViewModel.objGetWSMainPostModel.otherWorkspaceItems = self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.otherWorkspaceItems
        }
        if self.objNewWorkSpaceBaseViewModel.selectedTabCategory == WorkAreaTabCategory.garment.categoryName {
            if !self.objNewWorkSpaceBaseViewModel.objGetWSMainPostModel.garmetWorkspaceItems.isEmpty {
                self.setuPiece(arrPieces: self.objNewWorkSpaceBaseViewModel.objGetWSMainPostModel.garmetWorkspaceItems )
            }
        } else if self.objNewWorkSpaceBaseViewModel.selectedTabCategory == WorkAreaTabCategory.lining.categoryName {
            if !self.objNewWorkSpaceBaseViewModel.objGetWSMainPostModel.liningWorkspaceItems.isEmpty {
                self.setuPiece(arrPieces: self.objNewWorkSpaceBaseViewModel.objGetWSMainPostModel.liningWorkspaceItems )
            }
        } else if self.objNewWorkSpaceBaseViewModel.selectedTabCategory == WorkAreaTabCategory.interfacing.categoryName {
            if !self.objNewWorkSpaceBaseViewModel.objGetWSMainPostModel.interfaceWorkspaceItems.isEmpty {
                self.setuPiece(arrPieces: self.objNewWorkSpaceBaseViewModel.objGetWSMainPostModel.interfaceWorkspaceItems )
            }
        } else if self.objNewWorkSpaceBaseViewModel.selectedTabCategory == WorkAreaTabCategory.other.categoryName {
            if !self.objNewWorkSpaceBaseViewModel.objGetWSMainPostModel.otherWorkspaceItems.isEmpty {
                self.setuPiece(arrPieces: self.objNewWorkSpaceBaseViewModel.objGetWSMainPostModel.otherWorkspaceItems )
            }
        }
    }
    func setupPostParamsForNoInterent() {   // Setting up tabArrays for offline case
        self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.garmetWorkspaceItems.removeAll()
        self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.liningWorkspaceItems.removeAll()
        self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.interfaceWorkspaceItems.removeAll()
        self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.otherWorkspaceItems.removeAll()
        if !self.objNewWorkSpaceBaseViewModel.arrUserDefaultWSSaveModel.isEmpty {
            self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.garmetWorkspaceItems = self.setupA(tabCategory: .garment)
            self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.liningWorkspaceItems = self.setupA(tabCategory: .lining)
            self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.interfaceWorkspaceItems = self.setupA(tabCategory: .interfacing)
            self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.otherWorkspaceItems = self.setupA(tabCategory: .other)
        }
    }
    func setupA(tabCategory: WorkAreaTabCategory) -> [WSWorkSpaceIteamModel] {  // Setting up tabArrays details from DB
        var tempWSWorkSpaceIteamModel = [WSWorkSpaceIteamModel]()
        let patternArray = self.objNewWorkSpaceBaseViewModel.getPatternPiecesBasedOnTab(tabType: tabCategory.categoryName).filter({$0.tabCategory == tabCategory.categoryName})
        let arrDefault = self.objNewWorkSpaceBaseViewModel.arrUserDefaultWSSaveModel.filter({$0.tabCategory == tabCategory.categoryName})
        for pattern in arrDefault {
            let pieceArray = patternArray.filter({$0.tailornovaIndex == pattern.tailornovaIndex})
            if !pieceArray.isEmpty {
                let objWSWorkSpaceIteamModel = WSWorkSpaceIteamModel()
                objWSWorkSpaceIteamModel.id = pattern.idVal
                objWSWorkSpaceIteamModel.patternPiecesId = pieceArray[0].tailornovaIndex
                objWSWorkSpaceIteamModel.isCompleted = false
                objWSWorkSpaceIteamModel.mirrorOption = pieceArray[0].mirrorOption
                objWSWorkSpaceIteamModel.xcoordinate = Double(pattern.xcor)
                objWSWorkSpaceIteamModel.ycoordinate = Double(pattern.ycor)
                objWSWorkSpaceIteamModel.transformA = "\(pattern.transformA)"
                objWSWorkSpaceIteamModel.transformD = "\(pattern.transformD)"
                // For Splice Images
                if pieceArray[0].isSpliced {
                    let pattern1Array = self.objNewWorkSpaceBaseViewModel.getPatternPiecesBasedOnTab(tabType: self.objNewWorkSpaceBaseViewModel.selectedTabCategory).filter {$0.tailornovaIndex == pieceArray[0].tailornovaIndex}
                    if !pattern1Array.isEmpty {
                        for (item, dicts) in self.objNewWorkSpaceBaseViewModel.getPatternPiecesBasedOnTab(tabType: self.objNewWorkSpaceBaseViewModel.selectedTabCategory).enumerated() where pattern1Array[0].id == dicts.id {
                            self.objNewWorkSpaceBaseViewModel.currentIndexPath = item
                        }
                    }
                }
                objWSWorkSpaceIteamModel.rotationAngle = Double(pattern.rotatedAngle)
                objWSWorkSpaceIteamModel.pivotX =  Double(pattern.centerX)
                objWSWorkSpaceIteamModel.pivotY = Double(pattern.centerY)
                objWSWorkSpaceIteamModel.currentSplicedPieceNo = FormatsString.emptyString
                objWSWorkSpaceIteamModel.currentSplicedPieceRow = Int(pattern.currentSplicedPieceRow)
                objWSWorkSpaceIteamModel.currentSplicedPieceColumn = Int(pattern.currentSplicedPieceColumn)
                objWSWorkSpaceIteamModel.showMirrorDialog = pattern.showMirrorDialog
                tempWSWorkSpaceIteamModel.append(objWSWorkSpaceIteamModel)
            }
        }
        return tempWSWorkSpaceIteamModel
    }
    func setupCutCountForSelectedTabCategory() {   // Calculating total cut count of selected tabcategory
        var totalCutQuantity = 0
        var finalQuant = 0
        if self.patternsSegmentedContol.selectedSegmentIndex == 0 {  // Garment tab total cut count
            let selectedArr = self.objNewWorkSpaceBaseViewModel.getSelectedPatternPiecesBasedOnTab(
                selectedId: self.objNewWorkSpaceBaseViewModel.arrSelectedIndexGarment, tabType: self.objNewWorkSpaceBaseViewModel.selectedTabCategory)
            for item in 0..<self.objNewWorkSpaceBaseViewModel.arrSelectedIndexGarment.count where item < selectedArr.count {
                let val = Proxy.shared.getIntegerValuefromString(str: !selectedArr.isEmpty ? selectedArr[item].cutQuantity : FormatsString.zeroLabel)
                totalCutQuantity += val
            }
            finalQuant = totalCutQuantity
        } else if self.patternsSegmentedContol.selectedSegmentIndex == 1 {  // Lining tab total cut count
            let selectedArr = self.objNewWorkSpaceBaseViewModel.getSelectedPatternPiecesBasedOnTab(
                selectedId: self.objNewWorkSpaceBaseViewModel.arrSelectedIndexLinings, tabType: self.objNewWorkSpaceBaseViewModel.selectedTabCategory)
            for item in 0..<self.objNewWorkSpaceBaseViewModel.arrSelectedIndexLinings.count where item < selectedArr.count {
                let val = Proxy.shared.getIntegerValuefromString(str: !selectedArr.isEmpty ? selectedArr[item].cutQuantity : FormatsString.zeroLabel)
                totalCutQuantity += val
            }
            finalQuant = totalCutQuantity
        } else if self.patternsSegmentedContol.selectedSegmentIndex == 2 {  // Interfacing tab total cut count
            let selectedArr = self.objNewWorkSpaceBaseViewModel.getSelectedPatternPiecesBasedOnTab(
                selectedId: self.objNewWorkSpaceBaseViewModel.arrSelectedIndexInterfacing, tabType: self.objNewWorkSpaceBaseViewModel.selectedTabCategory)
            for item in 0..<self.objNewWorkSpaceBaseViewModel.arrSelectedIndexInterfacing.count where item < selectedArr.count {
                let val = Proxy.shared.getIntegerValuefromString(str: !selectedArr.isEmpty ? selectedArr[item].cutQuantity : FormatsString.zeroLabel)
                totalCutQuantity += val
            }
            finalQuant = totalCutQuantity
        } else if self.patternsSegmentedContol.selectedSegmentIndex == 3 {  // Others tab total cut count
            let selectedArr = self.objNewWorkSpaceBaseViewModel.getSelectedPatternPiecesBasedOnTab(
                selectedId: self.objNewWorkSpaceBaseViewModel.arrSelectedIndexOthers, tabType: self.objNewWorkSpaceBaseViewModel.selectedTabCategory)
            for item in 0..<self.objNewWorkSpaceBaseViewModel.arrSelectedIndexOthers.count where item < selectedArr.count {
                let val = Proxy.shared.getIntegerValuefromString(str: !selectedArr.isEmpty ? selectedArr[item].cutQuantity : FormatsString.zeroLabel)
                totalCutQuantity += val
            }
            finalQuant = totalCutQuantity
        }
        self.patternsView.labelSelectedCutCount.text = "\(finalQuant)"
    }
}
