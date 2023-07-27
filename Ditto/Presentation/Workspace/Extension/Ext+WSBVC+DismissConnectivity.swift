//
//  Ext+WSBVC+D.swift
//  Ditto
//
//  Created by Gaurav Rajan on 21/04/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit
import FastSocket
import FabricTraceTransformFrx

extension WorkspaceBaseViewController: LauchCameraPopUpDissmissDelegate {
    func lauchCameraPopUpScreenDissmiss() {  // Camera launch popup dismiss action and opening camera screen
        DispatchQueue.main.async {
            let img = UIImage(named: ImageNames.calibrationpatternImage)
            self.objNewWorkSpaceBaseViewModel.sendCalibImage(img: img!, hostData: ProjectorDetails.Host, portData: ProjectorDetails.port)
            self.goToCallibrateCameraView(screenType: ScreenTypeString.workSpaceScreen)
        }
    }
}
extension WorkspaceBaseViewController: DissmissConnectivityDelegate {
    func passServiceAddress(host: String, port: Int32) {
        self.objNewWorkSpaceBaseViewModel.host = host
        self.objNewWorkSpaceBaseViewModel.port = port
    }
    func dismmissConnectionView(presentScreenType: String) {  // handling dismiss lottie based on different screen type
        DispatchQueue.main.async {
            self.dismissLottie()
            self.objNewWorkSpaceBaseViewModel.isProjecting = false
            self.objNewWorkSpaceBaseViewModel.calibScreenType = FromScreen.tutorial
            if presentScreenType == ScreenTypeString.workSpaceScreen {
                self.goToCallibrateCameraView(screenType: ScreenTypeString.workSpaceScreen)
            } else if presentScreenType == ScreenTypeString.workspaceFromCalibration {
                self.dismiss(animated: false) {
                    self.animView.stop()
                    self.animView.removeFromSuperview()
                }
            } else if presentScreenType == ScreenTypeString.calibYes {
                self.sendToProjectorButtonOutlet.backgroundColor = CustomColor.disabledProjectorButtonBG
                self.sendToProjectorButtonOutlet.isEnabled = false
                self.showConnectionLottie()
            } else if presentScreenType == ScreenTypeString.calibConnectivitySuccessScreen {
                self.dismiss(animated: false) {
                    self.objNewWorkSpaceBaseViewModel.calibScreenType = FromScreen.workspace
                    self.animView.stop()
                    self.animView.removeFromSuperview()
                    self.sendToProjectorButtonOutlet.backgroundColor = CustomColor.activeProjectorButtonBG
                    self.sendToProjectorButtonOutlet.isEnabled = true
                }
            } else if presentScreenType == ScreenTypeString.onRetry {
                self.dismiss(animated: false) {
                    self.showConnectionLottie()
                    self.sendToProjectorButtonOutlet.backgroundColor = CustomColor.disabledProjectorButtonBG
                    self.sendToProjectorButtonOutlet.isEnabled = false
                }
                DispatchQueue.main.async {
                    let viewc = Constants.callibrationStoryBoard.instantiateViewController(identifier: Constants.LaunchCameraAlertViewControllerIdentifier) as LaunchCameraAlertViewController
                    viewc.modalPresentationStyle = .overFullScreen
                    viewc.cameraLaunchPopupDelegate = self
                    self.present(viewc, animated: false, completion: nil)
                }
            } else if presentScreenType == ScreenTypeString.tutorialClicked {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.dismiss(animated: false) {
                        self.showConnectionLottie()
                        self.objNewWorkSpaceBaseViewModel.calibScreenType = FromScreen.tutorial
                        DispatchQueue.main.async {
                            let viewc = Constants.storyBoardCategory.instantiateViewController(identifier: StoryBoardIdentifiers.getStartedd.rawValue) as GetStartedViewController
                            viewc.objGetStartedViewModel.isFromWorkspace = true
                            viewc.objGetStartedViewModel.isFromCalibFailure = true
                            self.sendToProjectorButtonOutlet.backgroundColor = CustomColor.disabledProjectorButtonBG
                            self.sendToProjectorButtonOutlet.isEnabled = false
                            self.navigationController?.pushViewController(viewc, animated: true)
                        }
                    }
                }
            } else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    func passButtonTitle(title: String) {   // handling the name and color of connect button and send to projector button in WS
        if UIDevice.isPad {
            self.workspaceAreaView.buttonIpadConnectRecalibrate.setTitle(title, for: .normal)
        } else {
            self.workspaceAreaView.connectRecalibrateButton.setTitle(title, for: .normal)
        }
        if title != CalibrationMessages.calibrationConfTitle {
            self.objNewWorkSpaceBaseViewModel.calibrateConnect = FormatsString.calibrateWSLabel
            self.sendToProjectorButtonOutlet.backgroundColor = CustomColor.disabledProjectorButtonBG
            self.sendToProjectorButtonOutlet.isEnabled = false
            self.showConnectionLottie()
        } else { // CalibrationChanges_July22
            self.objNewWorkSpaceBaseViewModel.calibrateConnect = FormatsString.recalibrateWSLabel
        }
    }
    func enableSelectAll() {  // select all button handling
        self.workspaceAreaView.selectAllButton.isEnabled = !self.workspaceAreaView.workAreaView.subviews.isEmpty
        self.workspaceAreaView.selectAllipad.isEnabled = !self.workspaceAreaView.workAreaView.subviews.isEmpty
        self.updateSelectAllButtonImages()
    }
    func updateSelectAllButtonImages() {   // changing select all button images based on selection/deselection
        if objNewWorkSpaceBaseViewModel.isSelectAll {
            if UIDevice.isPhone {
                self.workspaceAreaView.selectAllButton.isSelected = true
                self.workspaceAreaView.selectAllButton.titleLabel?.font = CustomFont.avenirLtProRegular(size: 8)
            } else {
                self.workspaceAreaView.selectAllipad.isSelected = true
            }
        } else {
            for view in self.workspaceAreaView.workAreaView.subviews {
                if let imageView = view as? UIImageView {
                    imageView.tintColor = UIColor.black
                    imageView.isUserInteractionEnabled = true
                    self.workspaceAreaView.tapped = false
                }
            }
            if UIDevice.isPhone {
                self.workspaceAreaView.selectAllButton.isSelected = false
                self.workspaceAreaView.selectAllButton.titleLabel?.font = CustomFont.avenirLtProRegular(size: 10)
            } else {
                self.workspaceAreaView.selectAllipad.isSelected = false
            }
        }
    }
}
