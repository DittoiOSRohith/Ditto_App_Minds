//
//  Ext+WorksaceAlertExtensions.swift
//  Ditto
//
//  Created by Abiya Joy on 28/03/22.
//  Copyright © 2022 Infosys. All rights reserved.
//

import UIKit
import Lottie

extension WorkspaceBaseViewController {
    func showAlertForSplicedImage(patternObj: PatternPieceModelObject) -> Bool {  // Alert when trying to drop splice piece onto an occupied WS
        var isShowAlert = false
        if patternObj.isSpliced && !self.workspaceAreaView.workAreaView.subviews.isEmpty {   // Trying to drop a splice piece onto normal piece
            if self.objNewWorkSpaceBaseViewModel.isMultiplePieceSpliceAlertShown {
                self.showAlertForAddingSlicedImageOnOtherPatterns(viewController: self)
            }
            isShowAlert = true
        } else if self.objNewWorkSpaceBaseViewModel.isSpliceImageAddedToWorkspace {   // Trying to drop a splice piece onto splice piece
            if self.objNewWorkSpaceBaseViewModel.isMultiplePieceSpliceAlertShown {
                self.spliceCustomAlert(title: AlertTitle.splicedPiecesText, message: AlertMessage.multipleSpliceDropMsg, buttonOne: FormatsString.emptyString, buttonTwo: AlertTitle.OKButton, viewController: self)
            }
            isShowAlert = true
        }
        return isShowAlert
    }
    func showAlertOnSwitchingTabs(tabCategory: String) {   // Switching tab logic
        if !self.objNewWorkSpaceBaseViewModel.isSplicePiecePresent {
            if self.workspaceSpliceReferenceView.fourtyFiveTapped {
                CommonConst.userDefault.setValue(ReferenceLayoutType.fourtyfive, forKey: "reference\(self.objNewWorkSpaceBaseViewModel.previousSelectedTabCategory)")
            } else if self.workspaceSpliceReferenceView.sixtyTapped {
                CommonConst.userDefault.setValue(ReferenceLayoutType.sixty, forKey: "reference\(self.objNewWorkSpaceBaseViewModel.previousSelectedTabCategory)")
            } else if self.workspaceSpliceReferenceView.spliceTapped {
                CommonConst.userDefault.setValue(nil, forKey: "reference\(self.objNewWorkSpaceBaseViewModel.previousSelectedTabCategory)")
            }
        } else {
            CommonConst.userDefault.setValue(nil, forKey: "reference\(self.objNewWorkSpaceBaseViewModel.previousSelectedTabCategory)")
        }
        self.workspaceSpliceReferenceView.fourtyFiveTapped = false
        self.workspaceSpliceReferenceView.sixtyTapped = false
        self.workspaceSpliceReferenceView.spliceTapped = false
        self.workspaceAreaView.spliceRightAnimation.isHidden = true
        self.workspaceAreaView.spliceTopAnimation.isHidden = true
        self.workspaceAreaView.spliceLeftAnimation.isHidden = true
        self.workspaceAreaView.spliceButtomAnimation.isHidden = true
        self.workspaceAreaView.spliceRightButton.isHidden = true
        self.workspaceAreaView.spliceLeftButton.isHidden = true
        self.workspaceAreaView.spliceTopButton.isHidden = true
        self.workspaceAreaView.spliceButtomButton.isHidden = true
        self.workspaceAreaView.currentImageRowValue = 0
        self.workspaceAreaView.currentImageColumnValue = 0
        self.workspaceAreaView.borderImageTop.tintColor = UIColor.black
        self.workspaceAreaView.borderImageBottom.tintColor = UIColor.black
        self.workspaceAreaView.borderImageLeft.tintColor = UIColor.black
        self.workspaceAreaView.borderImageRight.tintColor = UIColor.black
        self.objNewWorkSpaceBaseViewModel.sendImage(imageString: ImageNames.wsLaunchImage, hostData: ProjectorDetails.Host, portData: ProjectorDetails.port)
        self.workspaceAreaView.workAreaView.removeAllSubviews()
        self.workspaceAreaView.selectAllButton.isEnabled = false
        self.workspaceAreaView.selectAllipad.isEnabled = false
        self.workspaceAreaView.splicedScreenLabel.isHidden = true
        self.addRemoveSpliceButton(isShow: false)
        self.objNewWorkSpaceBaseViewModel.patternsArray.removeAll()
        self.objNewWorkSpaceBaseViewModel.piecesDroppedArray.removeAll()
        self.objNewWorkSpaceBaseViewModel.patternPiecesArray.removeAll()
        self.objNewWorkSpaceBaseViewModel.tagValue = 0
        self.objNewWorkSpaceBaseViewModel.tappedImgVw.image = nil
        self.objNewWorkSpaceBaseViewModel.isSpliceImageAddedToWorkspace = false
        self.workspaceAreaView.doubleTapToZoomLabel.isHidden = true
        self.objNewWorkSpaceBaseViewModel.previousSelectedTabCategory =  self.objNewWorkSpaceBaseViewModel.selectedTabCategory
        self.patternsView.patternCollectionView?.contentOffset = CGPoint(x: 0, y: 0)
        self.objNewWorkSpaceBaseViewModel.loadPatternPiecesFor(tabCategory: self.objNewWorkSpaceBaseViewModel.selectedTabCategory) { (patternArray) in
            self.patternsView.labelTotalCutCount.text = "\(self.objNewWorkSpaceBaseViewModel.getTotalNoOfCutBinPiecesForSelectedPatternFromTailornova(pieces: self.objNewWorkSpaceBaseViewModel.getPatternPiecesBasedOnTab(tabType: self.objNewWorkSpaceBaseViewModel.selectedTabCategory)))"
            self.setupCutCountForSelectedTabCategory()
            self.objNewWorkSpaceBaseViewModel.disableMirroring(view: self.workspaceAreaView)
            self.objNewWorkSpaceBaseViewModel.disableRotateDropDown(view: self.workspaceAreaView)
            self.objNewWorkSpaceBaseViewModel.disableClearing(view: self.workspaceAreaView)
            self.workspaceAreaView.checkAlertShown = false
            self.objNewWorkSpaceBaseViewModel.imagePathArray.removeAll()
            self.objNewWorkSpaceBaseViewModel.imagesArray.removeAll()
            for pattern in patternArray {
                let imagePath = pattern.imageURL
                self.objNewWorkSpaceBaseViewModel.imagePathArray.append(getImageName(from: imagePath)!)
                self.objNewWorkSpaceBaseViewModel.imagesArray.append(self.getImageForPatternPiece(id: pattern.tailornovaIndex))
            }
            self.patternsView.patternCollectionView?.dragInteractionEnabled = true
            self.patternsView.patternCollectionView?.reloadData()
        }
        self.workspaceSpliceReferenceView.isSpliceEnabled = false
        self.workspaceSpliceReferenceView.disableSpliceButton()
        self.objNewWorkSpaceBaseViewModel.isSplicePiecePresent = false
        self.layoutButtonValueSetting()
        self.updateRefLayoutViewForFabric(fabricSelected: self.objNewWorkSpaceBaseViewModel.selected, isSplice: false)
        self.patternsView.patternCollectionView?.reloadData()
        if (CommonConst.userDefault.value(forKey: "selectedTab\(tabCategory)") as? Bool)! {
            self.updateSegmentSelectionForPatternPieceAndReference(sender: self.patternPiecesButton)
        } else {
            self.updateSegmentSelectionForPatternPieceAndReference(sender: self.referenceLayoutButton)
        }
        self.showPreviousPatterUserWorked()
        if self.workspaceAreaView.workAreaView.subviews.isEmpty {
            self.enableSelectAll()
            self.settingSelectionOfSelectedTab()
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
    }
    func showAlert(indexVal: Int, completion: @escaping(_ isCompleted: Bool, _ index: Int) -> Void) {  // Cut alert if cut count is more than 1
        let dictData = self.objNewWorkSpaceBaseViewModel.tailornovaPatternArray.filter {$0.tailornovaIndex == indexVal}
        let dictCutQuantity = !dictData.isEmpty ? dictData[0].cutQuantity : FormatsString.zeroLabel
        let cutQuantity: Int = Proxy.shared.getIntegerValuefromString(str: dictCutQuantity)
        DispatchQueue.main.async {
            let objVC = Constants.workspaceStoryBoard.instantiateViewController(withIdentifier: Constants.AlertForCutConfirmVCIdentifier) as? AlertForCutConfirmationViewController
            objVC!.title = "\(cutQuantity)"
            objVC!.completion = { (isCompleted) in
                self.dismiss(animated: false, completion: {
                    DispatchQueue.main.async {
                        completion(isCompleted, indexVal)
                    }
                })
            }
            if self.presentedViewController == nil {
                self.navigationController?.present(objVC!, animated: false, completion: nil)
            }
        }
    }
    func spliceCustomAlert(title: String, message: String, buttonOne: String, buttonTwo: String, viewController: UIViewController) {  // Custom alert for splicing operations
        DispatchQueue.main.async {
            let viewc = StoryBoardType.alertWithTwoButtonsAndTitle.storyboard.instantiateViewController(identifier: Constants.AlertWithTwoButonsTitleVCIdentifier) as AlertWithTwoButtonsAndTitleViewController
            viewc.alertArray = [title, message, buttonOne, buttonTwo]
            viewc.screenType = ScreenTypeString.fromSpliceAlert
            viewc.modalPresentationStyle = .overFullScreen
            if self.presentedViewController == nil {
                viewController.present(viewc, animated: false, completion: nil)
            }
        }
    }
    func showAlertForAddingSlicedImageOnOtherPatterns(viewController: UIViewController) {  // Alert Dropping splice onto another splice piece in workspace
        self.spliceCustomAlert(title: AlertTitle.spliceDropText, message: AlertMessage.spliceonSpliceMsg, buttonOne: FormatsString.emptyString, buttonTwo: AlertTitle.OKButton, viewController: viewController)
        return
    }
    func showAlertForAddingSlicedImageToWorkspace(viewController: UIViewController) {  // Alert Dropping normal splice piece to workspace
        self.spliceCustomAlert(title: AlertTitle.spliceDropText,
                               message: AlertMessage.spliceDropMsg,
                               buttonOne: FormatsString.emptyString,
                               buttonTwo: AlertTitle.OKButton, viewController: viewController)
        return
    }
    func showAlertForAddingMultiSlicedImageToWorkspace(viewController: UIViewController) {  // Alert Dropping multidirectional splice piece to workspace
        self.spliceCustomAlert(title: AlertTitle.multiSpliceDropText,
                               message: AlertMessage.multiSpliceDropMsg,
                               buttonOne: FormatsString.emptyString,
                               buttonTwo: AlertTitle.OKButton, viewController: viewController)
        return
    }
    func showConnectionLottie() { // connection animation based on client feedback_July9
        DispatchQueue.main.async {
            let jsonName = ConnectivityUtils.connectBtnLoader
            let animation = Animation.named(jsonName)
            self.animView.stop()
            self.animView.removeFromSuperview()
            self.animView = AnimationView(animation: animation)
            self.animView.frame.size = UIDevice.isPad ? self.workspaceAreaView.buttonIpadConnectRecalibrate.frame.size : self.workspaceAreaView.viewConnect.frame.size
            let view = UIDevice.isPad ? self.workspaceAreaView.buttonIpadConnectRecalibrate : self.workspaceAreaView.viewConnect
            view?.addSubview(self.animView)
            self.animView.contentMode = .scaleAspectFill
            self.animView.loopMode = .loop
            let tpGesture = UITapGestureRecognizer(target: self, action: #selector(self.recalibrateConnectButtonAction))
            tpGesture.numberOfTapsRequired = 1
            view?.addGestureRecognizer(tpGesture)
            self.animView.play()
        }
    }
    func displayErrorPopUp() {   // Popup when Error inDownloading PDF
        DispatchQueue.main.async {
            let viewc = Constants.AlertWithImageAndButtons.instantiateViewController(identifier: Constants.AlertWithImageAndButonsVCIdentifier) as AlertWithImageAndButtonsViewController
            viewc.alertArray = [ConnectivityUtils.failedImage, AlertMessage.unabletoLoadFIle, AlertTitle.RETRY, AlertTitle.CANCEL, FormatsString.emptyString]
            viewc.screenType = ScreenTypeString.PatternDesc
            viewc.modalPresentationStyle = .overFullScreen
            viewc.onRetryPressed = {
                Proxy.shared.keyWindow?.rootViewController?.dismiss(animated: false, completion: nil)
                self.sewingInstructionClicked(UIButton())
            }
            if Proxy.shared.keyWindow?.rootViewController?.presentedViewController == nil {
                Proxy.shared.keyWindow?.rootViewController?.present(viewc, animated: false, completion: nil)
            }
        }
    }
}
