//
//  Ext+FetchableImageLogics.swift
//  Ditto
//
//  Created by abiya.joy on 06/10/22.
//  Copyright © 2022 Infosys. All rights reserved.
//

import UIKit
import CoreData
import Alamofire

extension WorkspaceBaseViewController: FetchableImage {
    func mapDropPiecesFromDbtowokrspaceArrya(dropArray: [WSWorkSpaceIteamModel], tabCategory: String) -> [UserDefaultWSSaveModel] {   // Map WS drop pieces saved in db to array to display in offline case
        var dropObject = [UserDefaultWSSaveModel]()
        if !dropArray.isEmpty {
            for piece in dropArray {
                let pieceObject = UserDefaultWSSaveModel()
                pieceObject.tabCategory = tabCategory
                pieceObject.idVal = piece.id
                pieceObject.patternTitle = self.objNewWorkSpaceBaseViewModel.parentTitle
                pieceObject.addNotes = self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.notes
                pieceObject.patternType = self.objNewWorkSpaceBaseViewModel.patternType
                piece.transformA = (piece.transformA != Constants.defaultTransformValue && piece.transformA != Constants.changingTransformValue && piece.transformA != Constants.zeroTransformValue) ? Constants.defaultTransformValue : piece.transformA
                piece.transformD = (piece.transformD != Constants.defaultTransformValue && piece.transformD != Constants.changingTransformValue && piece.transformD != Constants.zeroTransformValue) ? Constants.defaultTransformValue : piece.transformD
                if  let transformA = piece.transformA as String? {
                    pieceObject.transformA = Float(transformA)!
                }
                if  let transformD = piece.transformD as String? {
                    pieceObject.transformD = Float(transformD)!
                }
                if  let centerY = piece.pivotY as Double? {
                    pieceObject.centerY = Float(centerY)
                }
                if  let centerX = piece.pivotX as Double? {
                    pieceObject.centerX = Float(centerX)
                }
                if  let xcord = piece.xcoordinate as Double? {
                    pieceObject.xcor = Float(xcord)
                }
                if  let ycord = piece.ycoordinate as Double? {
                    pieceObject.ycor = Float(ycord)
                }
                if  let rotatedAngle = piece.rotationAngle as Double? {
                    pieceObject.rotatedAngle = Float(rotatedAngle)
                }
                if let isRotated = ((Float(piece.rotationAngle)) != 0) as Bool? {
                    pieceObject.isRotated = isRotated
                }
                if let showMirrorDialog = piece.showMirrorDialog as Bool? {
                    pieceObject.showMirrorDialog = showMirrorDialog
                }
                if  let tailornovaIndex = piece.patternPiecesId as Int? {
                    pieceObject.tailornovaIndex = tailornovaIndex
                }
                if let currentSplicedPieceRow = piece.currentSplicedPieceRow as Int? {
                    pieceObject.currentSplicedPieceRow = Int16(currentSplicedPieceRow)
                }
                if let currentSplicedPieceColumn = piece.currentSplicedPieceColumn as Int? {
                    pieceObject.currentSplicedPieceColumn = Int16(currentSplicedPieceColumn)
                }
                dropObject.append(pieceObject)
            }
        }
        return dropObject
    }
    func savePatternsMetaDataToDB(_ completion: @escaping() -> Void) {   // save last worked pattern details to db
        self.showLottie()
        let context = DatabaseHelper().managedObjectContext
        if self.objNewWorkSpaceBaseViewModel.patternType != FormatsString.Trial {
            CommonConst.offlineDesignIdText = self.objNewWorkSpaceBaseViewModel.tailornovaPatternDesignId
        } else {
            CommonConst.offlineDesignIdText = FormatsString.emptyString
        }
        let fetchRequest: NSFetchRequest<Pattern> = Pattern.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "tailornovadesignID == %@", self.objNewWorkSpaceBaseViewModel.tailornovaPatternDesignId)
        do {
            let objects = try context.fetch(fetchRequest)
            if !objects.isEmpty {
                for object in objects {
                    context.delete(object)
                }
                try context.save()
            }
        } catch _ {
            // error handling
        }
        if let patternEntity = Pattern(context: context) as Pattern? {
            patternEntity.addNotes = Proxy.shared.returnFormattedNotes(isForDBSave: true, notesStr: self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.notes)
            patternEntity.patternTitle = self.objNewWorkSpaceBaseViewModel.parentTitle
            patternEntity.patternImage = self.objNewWorkSpaceBaseViewModel.descriptionImageURL
            patternEntity.patternInstruction = self.objNewWorkSpaceBaseViewModel.tailornoavInstructionURL
            patternEntity.patternInstruction = self.objNewWorkSpaceBaseViewModel.patternDescription
            patternEntity.yardagedetails = self.objNewWorkSpaceBaseViewModel.yardageDetails
            patternEntity.notiondetails = self.objNewWorkSpaceBaseViewModel.notionDetails
            patternEntity.yardagePdfUrl = self.objNewWorkSpaceBaseViewModel.yardagePdfUrl
            patternEntity.tailornovadesignID = self.objNewWorkSpaceBaseViewModel.tailornovaPatternDesignId
            patternEntity.orderNo = self.objNewWorkSpaceBaseViewModel.tailornovaOrderNo
            patternEntity.purchasedSizeID = self.objNewWorkSpaceBaseViewModel.purchasedSizeId
            patternEntity.patternType = self.objNewWorkSpaceBaseViewModel.patternType
            patternEntity.subscriptionExpiryDate = self.objNewWorkSpaceBaseViewModel.subscriptionExpiryDate
            patternEntity.status = self.objNewWorkSpaceBaseViewModel.patternstatus
            patternEntity.patternSize = self.objNewWorkSpaceBaseViewModel.patternsize
            patternEntity.tailornovaDesignName = self.objNewWorkSpaceBaseViewModel.tailornovaDesignName
            patternEntity.patternBrand = self.objNewWorkSpaceBaseViewModel.patternBrand
            patternEntity.selectedTabCategory = self.objNewWorkSpaceBaseViewModel.selectedTabCategory
            patternEntity.lastModifiedSizeDate = self.objNewWorkSpaceBaseViewModel.lastModifiedSizeDate
            patternEntity.customSizeFitName = self.objNewWorkSpaceBaseViewModel.customSizeFitName
            patternEntity.selectedSizeName = self.objNewWorkSpaceBaseViewModel.selectedSizeName
            patternEntity.selectedViewCupSizeName = self.objNewWorkSpaceBaseViewModel.selectedViewCupSizeName
            patternEntity.productId = self.objNewWorkSpaceBaseViewModel.productId
            if !self.objNewWorkSpaceBaseViewModel.tailornovamannequinIDArray.isEmpty {
                if let maniEntity = Mannequin(context: context) as Mannequin? {
                    maniEntity.id = self.objNewWorkSpaceBaseViewModel.tailornovamannequinIDArray[0].mannequinID
                    maniEntity.name = self.objNewWorkSpaceBaseViewModel.tailornovamannequinIDArray[0].mannequinName
                    maniEntity.pattern = patternEntity
                    patternEntity.addToMannequins(maniEntity)
                }
            }
            var dropArray = [UserDefaultWSSaveModel]()
            dropArray.removeAll()
            if !self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.garmetWorkspaceItems.isEmpty {
                dropArray.append(contentsOf: self.mapDropPiecesFromDbtowokrspaceArrya(dropArray: self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.garmetWorkspaceItems, tabCategory: WorkAreaTabCategory.garment.categoryName))
            }
            if !self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.liningWorkspaceItems.isEmpty {
                dropArray.append(contentsOf: self.mapDropPiecesFromDbtowokrspaceArrya(dropArray: self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.liningWorkspaceItems, tabCategory: WorkAreaTabCategory.lining.categoryName))
            }
            if !self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.interfaceWorkspaceItems.isEmpty {
                dropArray.append(contentsOf: self.mapDropPiecesFromDbtowokrspaceArrya(dropArray: self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.interfaceWorkspaceItems, tabCategory: WorkAreaTabCategory.interfacing.categoryName))
            }
            if !self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.otherWorkspaceItems.isEmpty {
                dropArray.append(contentsOf: self.mapDropPiecesFromDbtowokrspaceArrya(dropArray: self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.otherWorkspaceItems, tabCategory: WorkAreaTabCategory.other.categoryName))
            }
            for drop in dropArray {
                if let dropEntity = DropPiecesDetails(context: context) as DropPiecesDetails? {
                    dropEntity.idVal = Int32(drop.idVal)
                    dropEntity.tailornovaIndex = Int32(drop.tailornovaIndex)
                    dropEntity.tabCategory = drop.tabCategory
                    dropEntity.xVal = drop.xcor
                    dropEntity.yVal = drop.ycor
                    dropEntity.centerX = drop.centerX
                    dropEntity.centerY = drop.centerY
                    dropEntity.isRotated = drop.isRotated
                    dropEntity.rotatedAngle = drop.rotatedAngle
                    dropEntity.transformA = drop.transformA
                    dropEntity.transformD = drop.transformD
                    dropEntity.patternName = drop.patternTitle
                    dropEntity.patternType = drop.patternType
                    dropEntity.currentSplicedPieceRow = drop.currentSplicedPieceRow
                    dropEntity.currentSplicedPieceColumn = drop.currentSplicedPieceColumn
                    dropEntity.showMirrorDialog = drop.showMirrorDialog
                    dropEntity.pattern = patternEntity
                    patternEntity.addToDropPiecesDetails(dropEntity)
                }
            }
            for dict in self.objNewWorkSpaceBaseViewModel.tailornovaPatternArray {
                if let pieceEntity = PatternPieceDetails(context: context) as PatternPieceDetails? {
                    pieceEntity.id = Int16(dict.id)
                    pieceEntity.tailornovaIndex = Int32(dict.tailornovaIndex)
                    pieceEntity.imagePath = dict.imageURL
                    pieceEntity.pieceDescription = dict.pieceDescription
                    pieceEntity.thumbnailImagePath = dict.thumbnailImageURL
                    pieceEntity.cutQuantity = dict.cutQuantity
                    pieceEntity.tabCategory = dict.tabCategory
                    pieceEntity.positionInTabLineUp = dict.positionInTab
                    pieceEntity.pattern = patternEntity
                    pieceEntity.pieceNumber = dict.pieceNumber
                    pieceEntity.isMirrored = String(dict.mirrorOption)
                    pieceEntity.parentPatten = self.objNewWorkSpaceBaseViewModel.parentTitle
                    pieceEntity.splice = dict.isSpliced
                    pieceEntity.spliceScreenQuantity = dict.spliceScreenQuantity
                    pieceEntity.spliceDirection = dict.spliceDirection
                    pieceEntity.mirrorOption = dict.mirrorOption
                    pieceEntity.contrast = dict.contrast
                    pieceEntity.isSelected = !self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.patternPieces.filter({$0.id == Int16(dict.tailornovaIndex)}).isEmpty ? self.objNewWorkSpaceBaseViewModel.objWSMainPostModel.patternPieces.filter({$0.id == Int16(dict.tailornovaIndex)})[0].isCompleted : false
                    let arrDropped = self.objNewWorkSpaceBaseViewModel.piecesDroppedArray.filter { $0.tailrnovaIndexId == dict.tailornovaIndex }
                    if !arrDropped.isEmpty {
                        pieceEntity.mirrorTransformA = Float(arrDropped[0].transfromA) ?? 0
                        pieceEntity.mirrorTranformD = Float(arrDropped[0].transfromD) ?? 0
                        pieceEntity.isRotated =  "\(arrDropped[0].isRotated )"
                        pieceEntity.centerX = arrDropped[0].centerX
                        pieceEntity.centerY = arrDropped[0].centerY
                        if arrDropped[0].imageView != nil {
                            pieceEntity.rotatedAngle = atan2(Float(arrDropped[0].imageView!.transform.b), Float(arrDropped[0].imageView!.transform.a))
                        }
                    }
                    patternEntity.addToPatternPiece(pieceEntity)
                    if dict.isSpliced {
                        if !dict.splicedImages.isEmpty {
                            for spliceObject in dict.splicedImages {
                                if let spliceEntity = SplicedImages(context: context) as SplicedImages? {
                                    spliceEntity.id =  Int16(spliceObject.id)
                                    spliceEntity.imagePath = spliceObject.imageURL
                                    spliceEntity.coloumn = Int16(spliceObject.column)
                                    spliceEntity.row = Int16(spliceObject.row)
                                    spliceEntity.referenceSplice = spliceObject.mapImageURL
                                    spliceEntity.patternPiece = pieceEntity
                                    pieceEntity.addToSplicedImages(spliceEntity)
                                }
                            }
                        }
                    }
                }
                if !self.objNewWorkSpaceBaseViewModel.tailornovaSelvagesArray.isEmpty {
                    for selvage in self.objNewWorkSpaceBaseViewModel.tailornovaSelvagesArray {
                        if let selvagesEntity = Selvages(context: context) as Selvages? {
                            selvagesEntity.imagePath = selvage.imageURL
                            selvagesEntity.fabricLength = selvage.fabricLength
                            selvagesEntity.tabCategory = selvage.tabCategory
                            selvagesEntity.pattern = patternEntity
                            patternEntity.addToPatternSelvages(selvagesEntity)
                        }
                    }
                }
            }
            DatabaseHelper().saveContext(context)
        }
        var allworkedPatternarray = Proxy.shared.getAllWorkedPatternsIDArray()
        _ = allworkedPatternarray.map({ (patternID) in
            if patternID != self.objNewWorkSpaceBaseViewModel.patternNameDirectory {
                self.objNewWorkSpaceBaseViewModel.remvoveFromDirectory(patternDesignId: patternID)
                if let index = allworkedPatternarray.firstIndex(of: patternID) {
                    allworkedPatternarray.remove(at: index)
                }
            }
        })
        CommonConst.userDefault.set(nil, forKey: CommonConst.allWorkerPatterns)
        CommonConst.userDefault.set(allworkedPatternarray, forKey: CommonConst.allWorkerPatterns)
    }
}
