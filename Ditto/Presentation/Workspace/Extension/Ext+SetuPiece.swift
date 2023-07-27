//
//  Ext+SetuPiece.swift
//  Ditto
//
//  Created by Gaurav.rajan on 11/11/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit
import SDWebImage
import Alamofire

extension WorkspaceBaseViewController {
    func getImageForPatternPiece(id: Int) -> UIImage {   // Getting image from the local directory using imageURL
        let pattern1Array = self.objNewWorkSpaceBaseViewModel.getPatternPiecesBasedOnTab(tabType: self.objNewWorkSpaceBaseViewModel.selectedTabCategory).filter {$0.tailornovaIndex == id}
        if !pattern1Array.isEmpty {
            dump(pattern1Array)
            return getImageFromDirectory(imageUrl: fetchImageName(from: pattern1Array[0].imageURL)!, patternDesignId: self.objNewWorkSpaceBaseViewModel.patternNameDirectory, isTrail: self.objNewWorkSpaceBaseViewModel.checkForTrailPattern)!
        }
        return UIImage()
    }
    func isSplicedPattern(id: Int) -> Bool {   // Check if a pattern is Spliced or not
        let pattern1Array = self.objNewWorkSpaceBaseViewModel.getPatternPiecesBasedOnTab(tabType: self.objNewWorkSpaceBaseViewModel.selectedTabCategory).filter {$0.tailornovaIndex == id}
        return !pattern1Array.isEmpty ? pattern1Array[0].isSpliced : false
    }
    func setuPiece(arrPieces: [WSWorkSpaceIteamModel]) {   // Setting pieces and values in a reopened WS
        let workSpaceSize = self.workspaceAreaView.workAreaView.bounds.size
        self.objNewWorkSpaceBaseViewModel.scaleFacctor = 35*72 / workSpaceSize.width
        if !arrPieces.isEmpty {
            self.workspaceAreaView.workAreaView.removeAllSubviews()
            self.objNewWorkSpaceBaseViewModel.piecesDroppedArray.removeAll()
            self.objNewWorkSpaceBaseViewModel.patternPiecesArray.removeAll()
        }
        for dict in arrPieces {
            let patterPiece =  PatternPieces()
            self.objNewWorkSpaceBaseViewModel.tagValue = dict.id
            patterPiece.tailrnovaIndexId = dict.patternPiecesId
            patterPiece.xcor = CGFloat(dict.xcoordinate) / self.objNewWorkSpaceBaseViewModel.scaleFacctor
            patterPiece.ycor = CGFloat(dict.ycoordinate) / self.objNewWorkSpaceBaseViewModel.scaleFacctor
            patterPiece.image = getImageForPatternPiece(id: dict.patternPiecesId)
            patterPiece.tagValue  = self.objNewWorkSpaceBaseViewModel.tagValue
            patterPiece.isMirrordH = dict.isMirrorH
            patterPiece.isMirrorV = dict.isMirrorV
            patterPiece.degree = CGFloat(Double(dict.rotationAngle))
            patterPiece.imageId = dict.id
            patterPiece.isRotated = patterPiece.degree > 0
            patterPiece.centerX = Float(dict.xcoordinate + dict.pivotX) / Float(self.objNewWorkSpaceBaseViewModel.scaleFacctor)
            patterPiece.centerY = Float(dict.ycoordinate + dict.pivotY) / Float(self.objNewWorkSpaceBaseViewModel.scaleFacctor)
            patterPiece.transfromA = dict.transformA
            patterPiece.transfromD = dict.transformD
            patterPiece.imagePath = FormatsString.emptyString
            patterPiece.isSpliced = self.isSplicedPattern(id: dict.patternPiecesId)
            patterPiece.isDisabled = false
            patterPiece.currentSplicedPieceRow = dict.currentSplicedPieceRow
            patterPiece.currentSplicedPieceColumn = dict.currentSplicedPieceColumn
            patterPiece.currentSplicedPieceNo = dict.currentSplicedPieceNo
            patterPiece.mirrorOption = dict.mirrorOption
            patterPiece.showMirrorDialog = dict.showMirrorDialog
            if self.isSplicedPattern(id: dict.patternPiecesId) {   // Handling spliced piece
                var currentIndexPath = 0
                let pattern1Array = self.objNewWorkSpaceBaseViewModel.getPatternPiecesBasedOnTab(tabType: self.objNewWorkSpaceBaseViewModel.selectedTabCategory).filter {$0.tailornovaIndex == dict.patternPiecesId}
                if !pattern1Array.isEmpty {
                    for (item, dicts) in self.objNewWorkSpaceBaseViewModel.getPatternPiecesBasedOnTab(tabType: self.objNewWorkSpaceBaseViewModel.selectedTabCategory).enumerated() where pattern1Array[0].id == dicts.id {
                        currentIndexPath = item
                    }
                }
                self.objNewWorkSpaceBaseViewModel.currentIndexPath = currentIndexPath
                CommonConst.currentIndexPathCheck = self.objNewWorkSpaceBaseViewModel.currentIndexPath
                if !self.objNewWorkSpaceBaseViewModel.getPatternPiecesBasedOnTab(tabType: self.objNewWorkSpaceBaseViewModel.selectedTabCategory).filter({$0.tailornovaIndex == dict.patternPiecesId}).isEmpty {
                    let splicedImages = self.objNewWorkSpaceBaseViewModel.getPatternPiecesBasedOnTab(tabType: self.objNewWorkSpaceBaseViewModel.selectedTabCategory).filter { $0.tailornovaIndex == dict.patternPiecesId}[0]
                    for objSplicedImages in splicedImages.splicedImages {
                        if objSplicedImages.row == 0 && objSplicedImages.column == 0 {
                            var spImage = getImageFromDirectory(imageUrl: fetchImageName(from: objSplicedImages.imageURL)!, patternDesignId: self.objNewWorkSpaceBaseViewModel.patternNameDirectory, isTrail: self.objNewWorkSpaceBaseViewModel.checkForTrailPattern) ?? UIImage()
                            self.objNewWorkSpaceBaseViewModel.hite = ceil(spImage.size.height / self.objNewWorkSpaceBaseViewModel.scaleFacctor)
                            self.objNewWorkSpaceBaseViewModel.wdth = ceil(spImage.size.width / self.objNewWorkSpaceBaseViewModel.scaleFacctor)
                            self.objNewWorkSpaceBaseViewModel.size = CGSize(width: self.objNewWorkSpaceBaseViewModel.wdth, height: self.objNewWorkSpaceBaseViewModel.hite)
                            self.workspaceAreaView.tapped = false
                            patterPiece.width = self.objNewWorkSpaceBaseViewModel.wdth
                            patterPiece.height = self.objNewWorkSpaceBaseViewModel.hite
                            if let resizedImage = spImage.resizeImage(targetSize: self.objNewWorkSpaceBaseViewModel.size) {
                                spImage = resizedImage
                            }
                            self.workspaceSpliceReferenceView.isSpliceEnabled = true
                            self.workspaceSpliceReferenceView.enableSplice()
                            if objSplicedImages.row == dict.currentSplicedPieceRow && objSplicedImages.column == dict.currentSplicedPieceColumn {
                                if let imageURL = URL(string: objSplicedImages.mapImageURL) {
                                    SDWebImageManager.shared.loadImage(with: imageURL, options: .allowInvalidSSLCertificates) {(_, _, _) in
                                    } completed: {(image, _, err, _, _, _) in
                                        if err == nil {
                                            self.workspaceSpliceReferenceView.referenceImageView.sd_imageProgress = .some(.init(totalUnitCount: 10))
                                            self.workspaceSpliceReferenceView.referenceImageView.image = image
                                            self.workspaceSpliceReferenceView.spliceImage = image!
                                            self.updateRefLayoutViewForFabric(fabricSelected: self.objNewWorkSpaceBaseViewModel.selected, isSplice: true )
                                        } else {
                                            self.workspaceSpliceReferenceView.referenceImageView.image = UIImage(named: ImageNames.placeholderImage)
                                        }
                                    }
                                }
                            }
                            self.updateSegmentSelectionForPatternPieceAndReference(sender: self.buttonPatternPieceReferenceLayout[1])
                            self.updateRefLayoutViewForFabric(fabricSelected: objNewWorkSpaceBaseViewModel.selected, isSplice: true )
                            self.objNewWorkSpaceBaseViewModel.isSplicePiecePresent = true
                            self.updateRefLayoutViewForFabric(fabricSelected: self.objNewWorkSpaceBaseViewModel.selected, isSplice: true)
                            self.objNewWorkSpaceBaseViewModel.isSpliceImageAddedToWorkspace = true
                            let point = self.setInitialFrameForSplicing(spliceDirection: splicedImages.spliceDirection, workspaceFrame: self.workspaceAreaView.workAreaView.bounds, image: spImage)
                            self.objNewWorkSpaceBaseViewModel.currentSpliceIndex = 1
                            self.objNewWorkSpaceBaseViewModel.originalSplicePosition = CGRect(x: point.x, y: point.y, width: self.objNewWorkSpaceBaseViewModel.wdth, height: self.objNewWorkSpaceBaseViewModel.hite)
                            self.objNewWorkSpaceBaseViewModel.currentSpliceDirection = splicedImages.spliceDirection
                            self.addSplicedImageToWorkspaceView(draggedImage: spImage, imgFrame: CGRect(x: point.x, y: point.y, width: self.objNewWorkSpaceBaseViewModel.wdth, height: self.objNewWorkSpaceBaseViewModel.hite))
                        }
                        if objSplicedImages.row > 0 && self.workspaceAreaView.spliceTopButton.isHidden {
                            self.workspaceAreaView.borderImageTop.tintColor = CustomColor.redCustom
                            self.workspaceAreaView.spliceTopButton.isHidden = false
                            self.workspaceAreaView.spliceTopAnimation.isHidden = false
                        }
                        if self.workspaceAreaView.spliceRightButton.isHidden {
                            self.workspaceAreaView.spliceRightButton.isHidden = objSplicedImages.column > 0 ? false : true
                            self.workspaceAreaView.spliceRightAnimation.isHidden = objSplicedImages.column > 0 ? false : true
                            if objSplicedImages.column > 0 {
                                self.workspaceAreaView.borderImageRight.tintColor = CustomColor.redCustom
                            }
                        }
                    }
                }
                for _ in 0..<dict.currentSplicedPieceRow {
                    self.workspaceAreaView.spliceDelegate?.spliceImage(withTag: SpliceConstant.spliceTop)
                }
                for _ in 0..<dict.currentSplicedPieceColumn {
                    self.workspaceAreaView.spliceDelegate?.spliceImage(withTag: SpliceConstant.spliceLeft)
                }
                if !self.workspaceAreaView.tapped {
                    self.objNewWorkSpaceBaseViewModel.disableClearing(view: self.workspaceAreaView)
                }
            } else {   // Handling normal piece
                let img = self.getImageForPatternPiece(id: dict.patternPiecesId)
                self.objNewWorkSpaceBaseViewModel.hite = ceil(img.size.height / self.objNewWorkSpaceBaseViewModel.scaleFacctor)
                self.objNewWorkSpaceBaseViewModel.wdth = ceil(img.size.width / self.objNewWorkSpaceBaseViewModel.scaleFacctor)
                self.objNewWorkSpaceBaseViewModel.size = CGSize(width: self.objNewWorkSpaceBaseViewModel.wdth, height: self.objNewWorkSpaceBaseViewModel.hite)
                patterPiece.width = self.objNewWorkSpaceBaseViewModel.wdth
                patterPiece.height = self.objNewWorkSpaceBaseViewModel.hite
                let imageView = UIImageView(image: img.resizeImage(targetSize: self.objNewWorkSpaceBaseViewModel.size)!.withRenderingMode(.alwaysTemplate))
                imageView.frame = CGRect(x: patterPiece.xcor,
                                         y: patterPiece.ycor,
                                         width: self.objNewWorkSpaceBaseViewModel.wdth,
                                         height: self.objNewWorkSpaceBaseViewModel.hite)
                imageView.tintColor = UIColor.black
                imageView.tag = self.objNewWorkSpaceBaseViewModel.tagValue
                imageView.contentMode = .scaleAspectFit
                imageView.layer.setValue("\(dict.id)", forKey: "id")
                self.setSingleTap(imgVw: imageView)
                imageView.isUserInteractionEnabled = true
                let interaction = UIDragInteraction(delegate: self)
                interaction.isEnabled = true
                imageView.addInteraction(interaction)
                self.workspaceAreaView.workAreaView.addSubview(imageView)
                patterPiece.tagValue = self.objNewWorkSpaceBaseViewModel.tagValue
                patterPiece.image = imageView.image?.withRenderingMode(.alwaysTemplate)
                imageView.transform = CGAffineTransform(scaleX: CGFloat(Float(dict.transformA) ?? 0), y: CGFloat(Float(dict.transformD) ?? 0) )
                var trans = CGAffineTransform.identity
                if dict.rotationAngle != 0  && dict.rotationAngle != 0.0 {
                    patterPiece.isRotated = true
                    if (CGFloat(round(Double(dict.transformD)!)) == 1 && CGFloat(round(Double(dict.transformA)!)) == -1) || (CGFloat(round(Double(dict.transformD)!)) == -1 && CGFloat(round(Double(dict.transformA)!)) == 1) {
                        trans = trans.scaledBy(x: CGFloat(round(Double(dict.transformA)!)), y: CGFloat(round(Double(dict.transformD)!))).rotated(by: -patterPiece.degree.degreesToRadians)
                    } else {
                        trans = trans.scaledBy(x: CGFloat(round(Double(dict.transformA)!)), y: CGFloat(round(Double(dict.transformD)!))).rotated(by: patterPiece.degree.degreesToRadians)
                    }
                } else {
                    patterPiece.isRotated = false
                    trans = trans.scaledBy(x: CGFloat(round(Double(dict.transformA)!)), y: CGFloat(round(Double(dict.transformD)!)))
                }
                imageView.transform = trans
                patterPiece.imageView = imageView
                patterPiece.imageId = Int(String(format: "%d", dict.id))!
                self.objNewWorkSpaceBaseViewModel.piecesDroppedArray.append(patterPiece)
                self.objNewWorkSpaceBaseViewModel.patternPiecesArray.append(patterPiece)
            }
            self.enableSelectAll()
        }
        if !NewWorkSpaceBaseViewModel.zoomLabelShown && !self.workspaceAreaView.workAreaView.subviews.isEmpty {
            self.workspaceAreaView.doubleTapToZoomLabel.isHidden = false
            self.workspaceAreaView.doubleTapToZoomLabel.text = FormatsString.zoomLabel
            self.workspaceAreaView.doubleTapToZoomLabel.textColor = .black
        }
        if !self.objNewWorkSpaceBaseViewModel.dragLabelShown {
            self.workspaceAreaView.doubleTapToZoomLabel.isHidden = false
            self.workspaceAreaView.doubleTapToZoomLabel.text = FormatsString.dragAndDropLabel
            self.workspaceAreaView.doubleTapToZoomLabel.textColor = CustomColor.redCustom
        }
        self.objNewWorkSpaceBaseViewModel.totalImagesDropped = self.objNewWorkSpaceBaseViewModel.piecesDroppedArray.count
        self.settingSelectionOfSelectedTab()
        self.objNewWorkSpaceBaseViewModel.tagValue = self.objNewWorkSpaceBaseViewModel.piecesDroppedArray.map { $0.tagValue }.max()! + 1
    }
    func settingSelectionOfSelectedTab() {
        if let selection = CommonConst.userDefault.value(forKey: "piece\(self.objNewWorkSpaceBaseViewModel.selectedTabCategory)") as? String {
            if selection == FormatsString.selectAllLabel {
                self.objNewWorkSpaceBaseViewModel.isSelectAll = true
                self.updateSelectAllButtonImages()
                self.objNewWorkSpaceBaseViewModel.enableClearing(view: self.workspaceAreaView)
                for imgVw in self.workspaceAreaView.workAreaView.subviews {
                    if let imageView = imgVw as? UIImageView {
                        imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
                        imageView.tintColor = CustomColor.red
                        for gesture in imageView.gestureRecognizers! {
                            if let recognizer = gesture as? UIPanGestureRecognizer {
                                recognizer.isEnabled = false
                            }
                        }
                    }
                }
            } else {
                for imgVw in self.workspaceAreaView.workAreaView.subviews {
                    if let imageView = imgVw as? UIImageView {
                        if imageView.tag == Int(selection) {   // selected piece red color
                            self.checkPatternPiecForMirroringAndSplicing(image: imageView)
                            imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
                            imageView.tintColor = CustomColor.red
                            imageView.isUserInteractionEnabled = true
                        } else {   // normal piece black color
                            imageView.image = imageView.image?.withRenderingMode(.automatic)
                            imageView.image?.withRenderingMode(.automatic)
                            imageView.tintColor = UIColor.black
                            imageView.layer.borderWidth = 0
                            imageView.isUserInteractionEnabled = true
                        }
                    }
                }
            }
        }
        if !self.objNewWorkSpaceBaseViewModel.isSplicePiecePresent {
            if let reference = CommonConst.userDefault.value(forKey: "reference\(self.objNewWorkSpaceBaseViewModel.selectedTabCategory)") as? String {
                self.objNewWorkSpaceBaseViewModel.selected = reference
                let selArr = self.objNewWorkSpaceBaseViewModel.getSelvagesBasedOnTab(tabType: self.objNewWorkSpaceBaseViewModel.selectedTabCategory)
                var button = self.objNewWorkSpaceBaseViewModel.selected
                if self.objNewWorkSpaceBaseViewModel.selectedTabCategory == WorkAreaTabCategory.interfacing.categoryName {
                    button = (reference == ReferenceLayoutType.fourtyfive) ? ReferenceLayoutType.twenty : ReferenceLayoutType.fourtyfive
                }
                self.buttonAndImageHandlingReferenceLayout(button: self.objNewWorkSpaceBaseViewModel.selected, arrayCount: selArr.count, imgpth: selArr.filter({ $0.fabricLength == button})[0].imageURL, isSplice: false)
            }
        }
    }
    func selectedPiecesUpdateFunction() {  // fetching cut completed array on get api call when loading WS
        var tempGIndex = [Int]()
        var tempLIndex = [Int]()
        var tempIIndex = [Int]()
        var tempOIndex = [Int]()
        self.objNewWorkSpaceBaseViewModel.objGetWSMainPostModel.patternPieces = self.objNewWorkSpaceBaseViewModel.objGetWSMainPostModel.patternPieces.sorted(by: {$0.id < $1.id})
        for obj in self.objNewWorkSpaceBaseViewModel.objGetWSMainPostModel.patternPieces {
            let arrGarment = self.objNewWorkSpaceBaseViewModel.getPatternPiecesBasedOnTab(tabType: WorkAreaTabCategory.garment.categoryName)
            if !arrGarment.isEmpty {
                if (obj.id >= arrGarment.min(by: {$0.tailornovaIndex < $1.tailornovaIndex})!.tailornovaIndex && obj.id <= arrGarment.min(by: {$0.tailornovaIndex > $1.tailornovaIndex })!.tailornovaIndex && obj.isCompleted) {
                    tempGIndex.append(obj.id)
                }
            }
            let arrLining = self.objNewWorkSpaceBaseViewModel.getPatternPiecesBasedOnTab(tabType: WorkAreaTabCategory.lining.categoryName)
            if !arrLining.isEmpty {
                if (obj.id >= arrLining.min(by: {$0.tailornovaIndex < $1.tailornovaIndex})!.tailornovaIndex && obj.id <= arrLining.min(by: {$0.tailornovaIndex > $1.tailornovaIndex})!.tailornovaIndex && obj.isCompleted) {
                    tempLIndex.append(obj.id)
                }
            }
            let arrInterfacing = self.objNewWorkSpaceBaseViewModel.getPatternPiecesBasedOnTab(tabType: WorkAreaTabCategory.interfacing.categoryName)
            if !arrInterfacing.isEmpty {
                if (obj.id >= arrInterfacing.min(by: {$0.tailornovaIndex < $1.tailornovaIndex})!.tailornovaIndex && obj.id <= arrInterfacing.min(by: {$0.tailornovaIndex > $1.tailornovaIndex})!.tailornovaIndex && obj.isCompleted) {
                    tempIIndex.append(obj.id)
                }
            }
            let arrOther = self.objNewWorkSpaceBaseViewModel.getPatternPiecesBasedOnTab(tabType: WorkAreaTabCategory.other.categoryName)
            if !arrOther.isEmpty {
                if (obj.id >= arrOther.min(by: {$0.tailornovaIndex < $1.tailornovaIndex})!.tailornovaIndex && obj.id <= arrOther.min(by: {$0.tailornovaIndex > $1.tailornovaIndex })!.tailornovaIndex && obj.isCompleted) {
                    tempOIndex.append(obj.id)
                }
            }
        }
        self.objNewWorkSpaceBaseViewModel.arrSelectedIndexGarment = tempGIndex
        self.objNewWorkSpaceBaseViewModel.arrSelectedIndexLinings = tempLIndex
        self.objNewWorkSpaceBaseViewModel.arrSelectedIndexInterfacing = tempIIndex
        self.objNewWorkSpaceBaseViewModel.arrSelectedIndexOthers = tempOIndex
        self.setupCutCountForSelectedTabCategory()
        if !CommonConst.guestUserCheck {
            if let manager = NetworkReachabilityManager(), manager.isReachable {
                self.showPreviousPatterUserWorked()
            }
        }
        if !NewWorkSpaceBaseViewModel.zoomLabelShown && !self.workspaceAreaView.workAreaView.subviews.isEmpty {
            self.workspaceAreaView.doubleTapToZoomLabel.isHidden = false
            self.workspaceAreaView.doubleTapToZoomLabel.text = FormatsString.zoomLabel
            self.workspaceAreaView.doubleTapToZoomLabel.textColor = .black
        }
        if !self.objNewWorkSpaceBaseViewModel.dragLabelShown {
            self.workspaceAreaView.doubleTapToZoomLabel.isHidden = false
            self.workspaceAreaView.doubleTapToZoomLabel.text = FormatsString.dragAndDropLabel
            self.workspaceAreaView.doubleTapToZoomLabel.textColor = CustomColor.redCustom
        }
        self.patternsView.patternCollectionView?.reloadData()
    }
}
