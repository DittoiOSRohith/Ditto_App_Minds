//
//  Ext+WSBVC+SpiceDelegate.swift
//  Ditto
//
//  Created by Gaurav Rajan on 21/04/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit
import  SDWebImage

extension WorkspaceBaseViewController: spliceDelegate {
    func addRemoveSpliceButton(isShow: Bool) {   // Adding and Removing Splice buttons in WS
        self.workspaceAreaView.spliceLeftButtonWidthConstant.constant = !isShow ? 0 : CGFloat(40.0)
        self.workspaceAreaView.spliceRightButtonWidthConstant.constant = !isShow ? 0 : CGFloat(40.0)
        self.workspaceAreaView.spliceTopButtonHeightConstant.constant = !isShow ? 0 : CGFloat(40.0)
        self.workspaceAreaView.spliceBottomHeightConstant.constant = !isShow ? 0 : CGFloat(40.0)
    }
    func spliceImage(withTag: SpliceConstant) {   // Splice Image adding to WS view logic
        self.objNewWorkSpaceBaseViewModel.spliceConstant = "\(withTag.rawValue)"
        if self.objNewWorkSpaceBaseViewModel.currentIndexPath < self.objNewWorkSpaceBaseViewModel.getPatternPiecesBasedOnTab(tabType: self.objNewWorkSpaceBaseViewModel.selectedTabCategory).count {
            let patternPi = self.objNewWorkSpaceBaseViewModel.getPatternPiecesBasedOnTab(tabType: self.objNewWorkSpaceBaseViewModel.selectedTabCategory)[self.objNewWorkSpaceBaseViewModel.currentIndexPath]
            let splicedImages = patternPi.splicedImages
            self.objNewWorkSpaceBaseViewModel.imgg.addGestureRecognizer(self.objNewWorkSpaceBaseViewModel.longPressGesture)
            self.objNewWorkSpaceBaseViewModel.scaleFacctor = 35*72 / self.workspaceAreaView.workAreaView.bounds.width
            if patternPi.isSpliced {
                self.objNewWorkSpaceBaseViewModel.enableClearing(view: self.workspaceAreaView)
                let objSplicedImagesMax = splicedImages.max(by: { (first, second) -> Bool in
                    return first.row < second.row || first.column < second.column
                })
                /*Splice Button Action */
                switch withTag {
                case .spliceTop:
                    if self.workspaceAreaView.currentImageRowValue <= objSplicedImagesMax!.row {
                        if self.workspaceAreaView.currentImageRowValue != objSplicedImagesMax!.row {
                            self.workspaceAreaView.currentImageRowValue += 1
                        }
                        self.workspaceAreaView.spliceButtomButton.isHidden = false
                        self.workspaceAreaView.spliceButtomAnimation.isHidden = false
                        self.workspaceAreaView.borderImageTop.tintColor = CustomColor.redCustom
                        self.workspaceAreaView.borderImageBottom.tintColor = CustomColor.redCustom
                        if self.workspaceAreaView.currentImageRowValue == objSplicedImagesMax!.row {
                            self.workspaceAreaView.spliceTopButton.isHidden = true
                            self.workspaceAreaView.spliceTopAnimation.isHidden = true
                            self.workspaceAreaView.borderImageTop.tintColor = UIColor.black
                        }
                    }
                case .spliceLeft:
                    if self.workspaceAreaView.currentImageColumnValue <= objSplicedImagesMax!.column {
                        if self.workspaceAreaView.currentImageColumnValue != objSplicedImagesMax!.column {
                            self.workspaceAreaView.currentImageColumnValue += 1
                        }
                        self.workspaceAreaView.spliceLeftButton.isHidden = false
                        self.workspaceAreaView.spliceLeftAnimation.isHidden = false
                        self.workspaceAreaView.borderImageLeft.tintColor = CustomColor.redCustom
                        self.workspaceAreaView.borderImageRight.tintColor = CustomColor.redCustom
                        if self.workspaceAreaView.currentImageColumnValue == objSplicedImagesMax!.column {
                            self.workspaceAreaView.spliceRightButton.isHidden = true
                            self.workspaceAreaView.spliceRightAnimation.isHidden = true
                            self.workspaceAreaView.borderImageRight.tintColor = UIColor.black
                        }
                    }
                case .spliceBottom:
                    if self.workspaceAreaView.currentImageRowValue >= 0 {
                        if self.workspaceAreaView.currentImageRowValue != 0 {
                            self.workspaceAreaView.currentImageRowValue -= 1
                        }
                        self.workspaceAreaView.spliceTopButton.isHidden = false
                        self.workspaceAreaView.spliceTopAnimation.isHidden = false
                        self.workspaceAreaView.borderImageTop.tintColor = CustomColor.redCustom
                        self.workspaceAreaView.borderImageBottom.tintColor = CustomColor.redCustom
                        if self.workspaceAreaView.currentImageRowValue == 0 {
                            self.workspaceAreaView.spliceButtomButton.isHidden = true
                            self.workspaceAreaView.spliceButtomAnimation.isHidden = true
                            self.workspaceAreaView.borderImageBottom.tintColor = UIColor.black
                        }
                    }
                case .spliceRight:
                    if self.workspaceAreaView.currentImageColumnValue >= 0 {
                        if self.workspaceAreaView.currentImageColumnValue != 0 {
                            self.workspaceAreaView.currentImageColumnValue -= 1
                        }
                        self.workspaceAreaView.spliceRightButton.isHidden = false
                        self.workspaceAreaView.spliceRightAnimation.isHidden = false
                        self.workspaceAreaView.borderImageLeft.tintColor = CustomColor.redCustom
                        self.workspaceAreaView.borderImageRight.tintColor = CustomColor.redCustom
                        if self.workspaceAreaView.currentImageColumnValue == 0 {
                            self.workspaceAreaView.spliceLeftButton.isHidden = true
                            self.workspaceAreaView.spliceLeftAnimation.isHidden = true
                            self.workspaceAreaView.borderImageLeft.tintColor = UIColor.black
                        }
                    }
                }
                /* Loading Splice Images to workarea view */
                if let objSplicedImages = splicedImages.filter({$0.row == self.workspaceAreaView.currentImageRowValue && $0.column == self.workspaceAreaView.currentImageColumnValue }).first {
                    var draggedImage = getImageFromDirectory(imageUrl: fetchImageName(from: objSplicedImages.imageURL)!, patternDesignId: self.objNewWorkSpaceBaseViewModel.patternNameDirectory, isTrail: self.objNewWorkSpaceBaseViewModel.checkForTrailPattern) ?? UIImage()
                    self.objNewWorkSpaceBaseViewModel.hite = ceil(draggedImage.size.height / self.objNewWorkSpaceBaseViewModel.scaleFacctor)
                    self.objNewWorkSpaceBaseViewModel.wdth = ceil(draggedImage.size.width / self.objNewWorkSpaceBaseViewModel.scaleFacctor)
                    self.objNewWorkSpaceBaseViewModel.size = CGSize(width: self.objNewWorkSpaceBaseViewModel.wdth, height: self.objNewWorkSpaceBaseViewModel.hite)
                    if let resizedImage = draggedImage.resizeImage(targetSize: self.objNewWorkSpaceBaseViewModel.size) {
                        draggedImage = resizedImage
                    }
                    self.workspaceSpliceReferenceView.isSpliceEnabled = true
                    if let url = URL(string: objSplicedImages.mapImageURL) {
                        SDWebImageManager.shared.loadImage(with: url, options: .allowInvalidSSLCertificates) { (_, _, _) in
                        } completed: { (image, _, err, _, _, _) in
                            if err == nil {
                                self.workspaceSpliceReferenceView.spliceImage = image!
                                self.workspaceSpliceReferenceView.referenceImageView.image = image!
                            } else {
                                self.workspaceSpliceReferenceView.referenceImageView.image = UIImage(named: ImageNames.placeholderImage)
                            }
                        }
                    }
                    self.workspaceSpliceReferenceView.isSpliceEnabled = true
                    // UPDATE rEFERENCE
                    self.updateRefLayoutViewForFabric(fabricSelected: self.objNewWorkSpaceBaseViewModel.selected, isSplice: true)
                    self.objNewWorkSpaceBaseViewModel.originalSplicePosition = self.workspaceAreaView.workAreaView.bounds
                    self.addSplicedImageToWorkspaceView(draggedImage: draggedImage, imgFrame: self.workspaceAreaView.workAreaView.bounds)
                }
                if let selection = CommonConst.userDefault.value(forKey: "piece\(self.objNewWorkSpaceBaseViewModel.selectedTabCategory)") as? String {
                    if selection == FormatsString.selectAllLabel {
                        self.objNewWorkSpaceBaseViewModel.isSelectAll = true
                        self.updateSelectAllButtonImages()
                    }
                    for imgVw in self.workspaceAreaView.workAreaView.subviews {
                        if let imageView = imgVw as? UIImageView {
                            imageView.image = imageView.image?.withRenderingMode(.alwaysTemplate)
                            imageView.tintColor = CustomColor.red
                        }
                    }
                }
            }
        }
    }
}
