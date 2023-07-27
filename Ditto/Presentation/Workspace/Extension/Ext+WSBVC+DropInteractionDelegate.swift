//
//  Ext+WSBVC+DropInteractionDelegate.swift
//  Ditto
//
//  Created by Gaurav Rajan on 21/04/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit
import SDWebImage

extension WorkspaceBaseViewController: UIDropInteractionDelegate {
    // drop interaction functions
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        let workspaceDropViewlocation = session.location(in: self.workspaceAreaView.workAreaView)
        var dropOperation: UIDropOperation?
        if session.canLoadObjects(ofClass: UIImage.self) {
            dropOperation = self.workspaceAreaView.workAreaView.bounds.contains(workspaceDropViewlocation) ? .move : .copy
        }
        dropOperation = session.localDragSession == nil ? .copy : .move
        return UIDropProposal(operation: dropOperation!)
    }
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return session.canLoadObjects(ofClass: UIImage.self)
    }
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        if self.objNewWorkSpaceBaseViewModel.currentIndexPath < self.objNewWorkSpaceBaseViewModel.getPatternPiecesBasedOnTab(tabType: self.objNewWorkSpaceBaseViewModel.selectedTabCategory).count {
            CommonConst.userDefault.setValue(nil, forKey: "piece\(self.objNewWorkSpaceBaseViewModel.selectedTabCategory)")
            let objPatternsArray = self.objNewWorkSpaceBaseViewModel.getPatternPiecesBasedOnTab(tabType: self.objNewWorkSpaceBaseViewModel.selectedTabCategory)[self.objNewWorkSpaceBaseViewModel.currentIndexPath]
            let workSpaceSize = self.workspaceAreaView.workAreaView.bounds.size
            DispatchQueue.main.async {
                if !self.objNewWorkSpaceBaseViewModel.dragLabelShown {
                    self.objNewWorkSpaceBaseViewModel.dragLabelShown = true
                    self.workspaceAreaView.doubleTapToZoomLabel.isHidden = true
                }
                if !NewWorkSpaceBaseViewModel.zoomLabelShown {
                    self.workspaceAreaView.doubleTapToZoomLabel.isHidden = false
                    self.workspaceAreaView.doubleTapToZoomLabel.text = FormatsString.zoomLabel
                    self.workspaceAreaView.doubleTapToZoomLabel.textColor = .black
                }
            }
            for dragItem in session.items {
                dragItem.itemProvider.loadObject(ofClass: UIImage.self) { (obj, err) in
                    if err != nil {
                        return
                    }
                    guard var draggedImage = obj as? UIImage else {
                        return
                    }
                    self.objNewWorkSpaceBaseViewModel.scaleFacctor = 35*72 / workSpaceSize.width
                    self.objNewWorkSpaceBaseViewModel.hite = ceil(draggedImage.size.height / self.objNewWorkSpaceBaseViewModel.scaleFacctor)
                    self.objNewWorkSpaceBaseViewModel.wdth = ceil(draggedImage.size.width / self.objNewWorkSpaceBaseViewModel.scaleFacctor)
                    self.objNewWorkSpaceBaseViewModel.size = CGSize(width: self.objNewWorkSpaceBaseViewModel.wdth, height: self.objNewWorkSpaceBaseViewModel.hite)
                    let tempImage = draggedImage
                    if let resizedImage = tempImage.resizeImage(targetSize: self.objNewWorkSpaceBaseViewModel.size) {
                        draggedImage = resizedImage
                    }
                    DispatchQueue.main.async {
                        if objPatternsArray.isSpliced {  // Splice piece dropped
                            self.updateSegmentSelectionForPatternPieceAndReference(sender: self.buttonPatternPieceReferenceLayout[1] )
                            // Splice Pattern Images
                            if !self.workspaceAreaView.workAreaView.subviews.isEmpty { // When there is already a splice piece in the WS AREA
                                self.workspaceAreaView.selectAllButton.isEnabled = true
                                self.workspaceAreaView.selectAllipad.isEnabled = true
                                if self.objNewWorkSpaceBaseViewModel.isMultiplePieceSpliceAlertShown { // if WS settings screen allows to show popup
                                    self.showAlertForAddingSlicedImageOnOtherPatterns(viewController: self)
                                }
                                self.objNewWorkSpaceBaseViewModel.currentIndexPath = self.objNewWorkSpaceBaseViewModel.lastSelectedIndexPath
                            } else { // First Time
                                self.workspaceAreaView.tapped = false
                                self.objNewWorkSpaceBaseViewModel.spliceDone = false
                                if self.objNewWorkSpaceBaseViewModel.isSpliceAlertShown {
                                    if Int(objPatternsArray.spliceScreenQuantity)! > 2 {  // MultiAlert Popup
                                        self.showAlertForAddingMultiSlicedImageToWorkspace(viewController: self)
                                    } else {  // Splice Piece Popup
                                        self.showAlertForAddingSlicedImageToWorkspace(viewController: self)
                                    }
                                }
                                self.workspaceAreaView.selectAllButton.isEnabled = false
                                self.workspaceAreaView.selectAllipad.isEnabled = false
                                let loc = session.location(in: self.workspaceAreaView.workAreaView)
                                let splicedImages = objPatternsArray.splicedImages
                                for objSplicedImages in splicedImages {
                                    if objSplicedImages.row == 0 && objSplicedImages.column == 0 {
                                        var spImage = getImageFromDirectory(imageUrl: fetchImageName(from: objSplicedImages.imageURL)!, patternDesignId: self.objNewWorkSpaceBaseViewModel.patternNameDirectory, isTrail: self.objNewWorkSpaceBaseViewModel.checkForTrailPattern) ?? UIImage()
                                        self.objNewWorkSpaceBaseViewModel.scaleFacctor = 35*72 / workSpaceSize.width
                                        self.objNewWorkSpaceBaseViewModel.xVal = loc.x
                                        self.objNewWorkSpaceBaseViewModel.yVal = loc.y
                                        self.objNewWorkSpaceBaseViewModel.hite = ceil(spImage.size.height / self.objNewWorkSpaceBaseViewModel.scaleFacctor)
                                        self.objNewWorkSpaceBaseViewModel.wdth = ceil(spImage.size.width / self.objNewWorkSpaceBaseViewModel.scaleFacctor)
                                        self.objNewWorkSpaceBaseViewModel.size = CGSize(width: self.objNewWorkSpaceBaseViewModel.wdth, height: self.objNewWorkSpaceBaseViewModel.hite)
                                        if let resizedImage = spImage.resizeImage(targetSize: self.objNewWorkSpaceBaseViewModel.size) {
                                            spImage = resizedImage
                                        }
                                        self.workspaceSpliceReferenceView.isSpliceEnabled = true
                                        self.workspaceSpliceReferenceView.enableSplice()
                                        self.objNewWorkSpaceBaseViewModel.isSplicePiecePresent = true
                                        self.updateRefLayoutViewForFabric(fabricSelected: self.objNewWorkSpaceBaseViewModel.selected, isSplice: true) // UPDATE REFERENCE COUNT- CHNAGE
                                        self.workspaceSpliceReferenceView.spliceImage = UIImage(named: ImageNames.placeholderImage)!
                                        if let url = URL(string: objSplicedImages.mapImageURL) {
                                            SDWebImageManager.shared.loadImage(with: url, options: .allowInvalidSSLCertificates) { (_, _, _) in
                                            } completed: { (image, _, err, _, _, _) in
                                                self.workspaceSpliceReferenceView.spliceImage = (err == nil) ? image! : UIImage(named: ImageNames.placeholderImage)!
                                                self.workspaceSpliceReferenceView.referenceImageView.image = (err == nil) ? image! : UIImage(named: ImageNames.placeholderImage)!
                                            }
                                        }
                                        self.objNewWorkSpaceBaseViewModel.isSpliceImageAddedToWorkspace = true
                                        let point = self.setInitialFrameForSplicing(spliceDirection: objPatternsArray.spliceDirection, workspaceFrame: self.workspaceAreaView.workAreaView.bounds, image: spImage)
                                        self.objNewWorkSpaceBaseViewModel.currentSpliceIndex = 1
                                        self.objNewWorkSpaceBaseViewModel.originalSplicePosition = CGRect(x: point.x, y: point.y,
                                                                                                          width: self.objNewWorkSpaceBaseViewModel.wdth,
                                                                                                          height: self.objNewWorkSpaceBaseViewModel.hite)
                                        self.objNewWorkSpaceBaseViewModel.currentSpliceDirection = objPatternsArray.spliceDirection
                                        self.addSplicedImageToWorkspaceView(draggedImage: spImage, imgFrame: CGRect(x: point.x, y: point.y, width: self.objNewWorkSpaceBaseViewModel.wdth, height: self.objNewWorkSpaceBaseViewModel.hite))
                                    }
                                    if objSplicedImages.row > 0 && self.workspaceAreaView.spliceTopButton.isHidden {
                                        self.workspaceAreaView.borderImageTop.tintColor = CustomColor.redCustom
                                        self.workspaceAreaView.spliceTopButton.isHidden = false
                                        self.workspaceAreaView.spliceTopAnimation.isHidden = false
                                    }
                                    if self.workspaceAreaView.spliceRightButton.isHidden {
                                        if objSplicedImages.column > 0 {
                                            self.workspaceAreaView.borderImageRight.tintColor = CustomColor.redCustom
                                        }
                                        self.workspaceAreaView.spliceRightButton.isHidden = !(objSplicedImages.column > 0)
                                        self.workspaceAreaView.spliceRightAnimation.isHidden = !(objSplicedImages.column > 0)
                                    }
                                }
                            }
                        } else {  //  Normal Pattern Images
                            let centerPoint =  session.location(in: self.workspaceAreaView.workAreaView)
                            self.objNewWorkSpaceBaseViewModel.rotate.isEnabled = false
                            self.objNewWorkSpaceBaseViewModel.disableRotateDropDown(view: self.workspaceAreaView)
                            let imagVw = UIImageView(image: draggedImage.withRenderingMode(.alwaysTemplate))
                            imagVw.tintColor = UIColor.black
                            imagVw.isUserInteractionEnabled = true
                            imagVw.contentMode = .scaleAspectFit
                            imagVw.frame = CGRect(x: 0, y: 0, width: self.objNewWorkSpaceBaseViewModel.wdth, height: self.objNewWorkSpaceBaseViewModel.hite)
                            self.setSingleTap(imgVw: imagVw)
                            imagVw.tag = self.objNewWorkSpaceBaseViewModel.tagValue
                            let pobjImage = self.objNewWorkSpaceBaseViewModel.currentIndexPath < self.objNewWorkSpaceBaseViewModel.imagePathArray.count ? self.objNewWorkSpaceBaseViewModel.imagePathArray[self.objNewWorkSpaceBaseViewModel.currentIndexPath] : FormatsString.emptyString
                            let pobj = WorkspaceBaseViewController.workspaceViewModel.getDroppedPatternPieceObject(tailornovaIndex: objPatternsArray.tailornovaIndex, droppedImageVw: imagVw, imagePath: "\(pobjImage)", imageId: Int(objPatternsArray.id), location: .zero, tag: self.objNewWorkSpaceBaseViewModel.tagValue)
                            pobj.mirrorOption = objPatternsArray.mirrorOption
                            self.objNewWorkSpaceBaseViewModel.isSpliceImageAddedToWorkspace = false
                            let interaction = UIDragInteraction(delegate: self)
                            interaction.isEnabled = true
                            imagVw.addInteraction(interaction)
                            imagVw.layer.setValue("\( objPatternsArray.id)", forKey: "id")
                            self.workspaceAreaView.workAreaView.addSubview(imagVw)
                            self.objNewWorkSpaceBaseViewModel.piecesDroppedArray.append(pobj)
                            self.objNewWorkSpaceBaseViewModel.isSelectAll = false
                            self.objNewWorkSpaceBaseViewModel.disableMirroring(view: self.workspaceAreaView)
                            self.objNewWorkSpaceBaseViewModel.disableRotateDropDown(view: self.workspaceAreaView)
                            self.objNewWorkSpaceBaseViewModel.disableClearing(view: self.workspaceAreaView)
                            self.enableSelectAll()
                            imagVw.center = centerPoint
                            self.objNewWorkSpaceBaseViewModel.totalImagesDropped += 1
                            self.objNewWorkSpaceBaseViewModel.movePatternPieceToVisibleArea(workAreaView: self.workspaceAreaView.workAreaView, tag: self.objNewWorkSpaceBaseViewModel.tagValue)
                            self.saveWorkspace()
                            let idTag = imagVw.tag
                            let patternArray = self.objNewWorkSpaceBaseViewModel.patternPiecesArray.filter({$0.imageView?.tag == idTag})
                            for pattern in patternArray {
                                pattern.xcor = imagVw.frame.origin.x
                                pattern.ycor = imagVw.frame.origin.y
                                pattern.width = Double(imagVw.frame.size.width)
                                pattern.height = Double(imagVw.frame.size.height)
                                pattern.tagValue = imagVw.tag
                            }
                        }
                        self.objNewWorkSpaceBaseViewModel.tagValue = self.objNewWorkSpaceBaseViewModel.piecesDroppedArray.map { $0.tagValue }.max()! + 1
                    }
                }
            }
        }
    }
}
