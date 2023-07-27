//
//  Ext+VirtualWorkspaceLogic.swift
//  Ditto
//
//  Created by abiya.joy on 06/10/22.
//  Copyright © 2022 Infosys. All rights reserved.
//

import UIKit
import FabricTraceTransformFrx
import FastSocket
import SDWebImage
import SDWebImageMapKit

extension WorkspaceBaseViewController {
    // MARK: - rescale methods
    func sendToProjector() {   // sendToProjector Button tap action
        DispatchQueue.main.async {
            self.sendToProjectorButtonOutlet.isUserInteractionEnabled = false
        }
        if CommonConst.serviceConnectedCheck {
            self.saveWorkspace()
            self.fetch()
        } else {
            KAppDelegate.bluetoothStatus()
            DispatchQueue.main.async {
                self.sendToProjectorButtonOutlet.isUserInteractionEnabled = true
            }
            NotificationCenter.default.addObserver(self, selector: #selector(self.getBLEWIFIstatus), name: NSNotification.Name(rawValue: FormatsString.bluetoothLabel), object: nil)
        }
    }
    // VIRTUAL WORKSPACE PROJECTION
    func fetch() {
        self.objNewWorkSpaceBaseViewModel.isProjecting = true
        let frame = CGRect(x: 0, y: 0, width: self.workspaceAreaView.workAreaView.frame.size.width * self.objNewWorkSpaceBaseViewModel.scaleFacctor, height: self.workspaceAreaView.workAreaView.frame.size.height * self.objNewWorkSpaceBaseViewModel.scaleFacctor)
        DispatchQueue.global(qos: .background).async {
            let vLayer = VirtualLayer()
            vLayer.pattern = self.objNewWorkSpaceBaseViewModel.patternPiecesArray
            vLayer.scaleF = self.objNewWorkSpaceBaseViewModel.scaleFacctor
            vLayer.bounds = frame
            vLayer.setNeedsDisplay()
            vLayer.layoutIfNeeded()
            DispatchQueue.main.async {
                self.view.makeToast("Projection area is in process...Please wait!!")
            }
            if !self.objNewWorkSpaceBaseViewModel.patternPiecesArray.isEmpty {
                if let img = self.objNewWorkSpaceBaseViewModel.imageFromLayer(layer: vLayer) as UIImage? {
                    if let virtualImage = img.pngData() {
                        let imageForTransform = UIImage(data: virtualImage)
                        let (ret, transformedImage) = FabricTraceTransform.performTransform(patternImage: imageForTransform!, overrideTransParams: nil, invertColor: true)
                        let start = Date()
                        switch ret {
                        case .success:
                            _ = Date().timeIntervalSince(start)
                            DispatchQueue.global(qos: .background).async {
                                do {
                                    if let client = FastSocket(host: ProjectorDetails.Host, andPort: String(ProjectorDetails.port)), client.connect() {
                                        let img = transformedImage.withBackground(color: .black)
                                        if let data = img.pngData() {
                                            _ = client.sendBytes(data.bytes, count: (data.count))
                                            client.close()
                                            self.objNewWorkSpaceBaseViewModel.isProjecting = false
                                            DispatchQueue.main.async {
                                                self.sendToProjectorButtonOutlet.isUserInteractionEnabled = true
                                            }
                                        }
                                    } else {
                                        self.objNewWorkSpaceBaseViewModel.isProjecting = false
                                        DispatchQueue.main.async {
                                            self.sendToProjectorButtonOutlet.isUserInteractionEnabled = true
                                        }
                                        DispatchQueue.main.async {
                                            let alert = Constants.AlertWithImageAndButtons.instantiateViewController(identifier: Constants.AlertWithImageAndButonsVCIdentifier) as AlertWithImageAndButtonsViewController
                                            alert.alertArray = [ConnectivityUtils.failedImage, ConnectivityMessages.projectorConnectionFailed, AlertTitle.CANCEL, AlertTitle.RETRY, FormatsString.emptyString]
                                            alert.modalPresentationStyle = .overFullScreen
                                            alert.onRetryPressed = {
                                                self.dismiss(animated: false, completion: {
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                                        self.goToConectivityScreen()
                                                    }
                                                })
                                            }
                                            alert.onCancelPressed = {
                                                self.dismmissConnectionView(presentScreenType: ScreenTypeString.skipType)
                                                self.passButtonTitle(title: FormatsString.connectLabel)
                                                self.dismiss(animated: false, completion: nil)
                                            }
                                            if self.presentedViewController == nil {
                                                self.present(alert, animated: false, completion: nil)
                                            }
                                        }
                                    }
                                }
                            }
                        case .additionalImageNeeded:
                            self.objNewWorkSpaceBaseViewModel.isProjecting = false
                        case .invalidImageFormat:
                            self.objNewWorkSpaceBaseViewModel.isProjecting = false
                        case .failToReadTransformParams:
                            self.objNewWorkSpaceBaseViewModel.isProjecting = false
                        case .failToScaleDownInputImage:
                            self.objNewWorkSpaceBaseViewModel.isProjecting = false
                        case .retakeImage:
                            self.objNewWorkSpaceBaseViewModel.isProjecting = false
                        default:
                            self.objNewWorkSpaceBaseViewModel.isProjecting = false
                        }
                        DispatchQueue.main.async {
                            self.sendToProjectorButtonOutlet.isUserInteractionEnabled = true
                        }
                    } else {
                        self.objNewWorkSpaceBaseViewModel.sendImage(imageString: ImageNames.wsLaunchImage, hostData: ProjectorDetails.Host, portData: ProjectorDetails.port)
                        self.imageNotFoundToProject()
                    }
                } else {
                    self.objNewWorkSpaceBaseViewModel.sendImage(imageString: ImageNames.wsLaunchImage, hostData: ProjectorDetails.Host, portData: ProjectorDetails.port)
                    self.imageNotFoundToProject()
                }
            } else {
                self.objNewWorkSpaceBaseViewModel.sendImage(imageString: ImageNames.wsLaunchImage, hostData: ProjectorDetails.Host, portData: ProjectorDetails.port)
                DispatchQueue.main.async {
                    self.sendToProjectorButtonOutlet.isUserInteractionEnabled = true
                }
            }
        }
    }
    func saveWorkspace() {   // Clearing pattern array and saving
        if self.objNewWorkSpaceBaseViewModel.totalImagesDropped > 0 {
            self.objNewWorkSpaceBaseViewModel.patternPiecesArray.removeAll()
            for img in self.workspaceAreaView.workAreaView.subviews {
                if let iVw = img as? UIImageView {
                    let pieceArray = self.objNewWorkSpaceBaseViewModel.piecesDroppedArray.filter({$0.tagValue == iVw.tag})
                    if !pieceArray.isEmpty {
                        let patternObj = PatternPieces()
                        let piece = pieceArray[0]
                        patternObj.height = Double(iVw.frame.size.height)
                        patternObj.image = iVw.image?.withRenderingMode(.alwaysOriginal)
                        patternObj.width = Double(iVw.frame.size.width)
                        patternObj.xcor = iVw.frame.origin.x
                        patternObj.ycor = iVw.frame.origin.y
                        patternObj.degree = piece.degree
                        patternObj.imageView = iVw
                        patternObj.isDisabled = false
                        patternObj.mirrorOption = piece.mirrorOption
                        patternObj.isRotated = piece.isRotated
                        patternObj.transfromA = piece.transfromA
                        patternObj.transfromD = piece.transfromD
                        patternObj.isMirrorV = piece.isMirrorV ?? false
                        patternObj.isMirrordH = piece.isMirrordH ?? false
                        patternObj.tailrnovaIndexId = piece.patternPieceId
                        patternObj.showMirrorDialog = piece.showMirrorDialog
                        if self.objNewWorkSpaceBaseViewModel.currentIndexPath < self.objNewWorkSpaceBaseViewModel.imagePathArray.count {
                            patternObj.imagePath = piece.imagePath
                            patternObj.imageId = piece.imageId
                        }
                        self.objNewWorkSpaceBaseViewModel.patternPiecesArray.append(patternObj)
                    }
                }
            }
        }
    }
    func imageNotFoundToProject() {   // Alert for no image found when trying to project
        DispatchQueue.main.async {
            let alert = Constants.AlertWithImageAndButtons.instantiateViewController(identifier: Constants.AlertWithImageAndButonsVCIdentifier) as AlertWithImageAndButtonsViewController
            alert.alertArray = [ConnectivityUtils.failedImage, AlertMessage.imageFetchIssueText, FormatsString.emptyString, AlertTitle.OKButton, FormatsString.emptyString]
            alert.modalPresentationStyle = .overFullScreen
            alert.onOKPressed = {
                self.dismiss(animated: false, completion: {
                    DispatchQueue.main.async {
                        self.sendToProjectorButtonOutlet.isUserInteractionEnabled = true
                    }
                })
            }
            if self.presentedViewController == nil {
                self.present(alert, animated: false, completion: nil)
            }
        }
    }
}
