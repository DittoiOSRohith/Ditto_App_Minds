//
//  Ext+SaveAndExitDelegate.swift
//  Ditto
//
//  Created by Abiya Joy on 28/03/22.
//  Copyright © 2022 Infosys. All rights reserved.
//

import UIKit
import SDWebImage

extension WorkspaceBaseViewController: SaveAndExitDelegate {
    @objc func bringZoomUpPopUp() {   // bring referenceimage to zoom popup
        self.objNewWorkSpaceBaseViewModel.selctd = self.workspaceSpliceReferenceView.referenceImageView.image!
        self.showZoomPopUp(isForReference: true)
    }
    func questionMarkPopUp() {  // Alert popup for question mark tap
        DispatchQueue.main.async {
            let viewc = StoryBoardType.alertWithTwoButtonsAndTitle.storyboard.instantiateViewController(identifier: Constants.AlertWithTwoButonsTitleVCIdentifier) as AlertWithTwoButtonsAndTitleViewController
            viewc.alertArray = [FormatsString.emptyString, AlertMessage.questionMarkMessage, FormatsString.emptyString, AlertTitle.OKButton]
            viewc.screenType = ScreenTypeString.fromSpliceAlert
            viewc.modalPresentationStyle = .overFullScreen
            if self.presentedViewController == nil {
                self.present(viewc, animated: false, completion: nil)
            }
        }
    }
    func updateRefLayoutViewForFabric(fabricSelected: String, isSplice: Bool) {  // Update Reference Layout View based on selvage count
        let selvagesArr = self.objNewWorkSpaceBaseViewModel.getSelvagesBasedOnTab(tabType: self.objNewWorkSpaceBaseViewModel.selectedTabCategory)
        self.referenceLayoutButton.isHidden = selvagesArr.isEmpty ? (isSplice ? false : true) : false
        if selvagesArr.isEmpty {
            self.workspaceSpliceReferenceView.fourtyButton.isEnabled = false
            self.workspaceSpliceReferenceView.sixtyButton.isEnabled = false
            self.workspaceSpliceReferenceView.fourtyFiveLabel.textColor = .lightGray
            self.workspaceSpliceReferenceView.fourtyFiveNapLabel.textColor = .lightGray
            self.workspaceSpliceReferenceView.sixtyLable.textColor = .lightGray
            self.workspaceSpliceReferenceView.sixtyNapLabel.textColor = .lightGray
            self.workspaceSpliceReferenceView.fourtyFiveView.backgroundColor = CustomColor.wsReferenceGrayColor
            self.workspaceSpliceReferenceView.sixtyView.backgroundColor = CustomColor.wsReferenceGrayColor
        }
        for sel in selvagesArr {
            let buttonOne = (self.objNewWorkSpaceBaseViewModel.selectedTabCategory != WorkAreaTabCategory.interfacing.categoryName) ? ReferenceLayoutType.fourtyfive : ReferenceLayoutType.twenty
            let buttonTwo = (self.objNewWorkSpaceBaseViewModel.selectedTabCategory != WorkAreaTabCategory.interfacing.categoryName) ? ReferenceLayoutType.sixty : ReferenceLayoutType.fourtyfive
            if selvagesArr.count == 1 {
                if fabricSelected == ReferenceLayoutType.fourtyfive {
                    if sel.fabricLength == buttonOne {
                        self.buttonAndImageHandlingReferenceLayout(button: ReferenceLayoutType.fourtyfive, arrayCount: 1, imgpth: sel.imageURL, isSplice: isSplice)
                    }
                } else if fabricSelected == ReferenceLayoutType.sixty {
                    if sel.fabricLength == buttonTwo {
                        self.buttonAndImageHandlingReferenceLayout(button: ReferenceLayoutType.sixty, arrayCount: 1, imgpth: sel.imageURL, isSplice: isSplice)
                    }
                }
            } else if selvagesArr.count == 2 {
                self.workspaceSpliceReferenceView.sixtyButton.isEnabled = true
                self.workspaceSpliceReferenceView.fourtyButton.isEnabled = true
                if fabricSelected == ReferenceLayoutType.fourtyfive {
                    if sel.fabricLength == buttonOne {
                        self.buttonAndImageHandlingReferenceLayout(button: ReferenceLayoutType.fourtyfive, arrayCount: 2, imgpth: sel.imageURL, isSplice: isSplice)
                    }
                } else if fabricSelected == ReferenceLayoutType.sixty {
                    if sel.fabricLength == buttonTwo {
                        self.buttonAndImageHandlingReferenceLayout(button: ReferenceLayoutType.sixty, arrayCount: 2, imgpth: sel.imageURL, isSplice: isSplice)
                    }
                }
            }
        }
    }
    func buttonAndImageHandlingReferenceLayout(button: String, arrayCount: Int, imgpth: String, isSplice: Bool) {  // Handling images and buttons in reference layout
        self.objNewWorkSpaceBaseViewModel.selected = button
        if !isSplice {
            SDWebImageManager.shared.loadImage(with: URL(string: imgpth), options: .allowInvalidSSLCertificates) { (_, _, _) in
            } completed: { (image, _, err, _, _, _) in
                self.workspaceSpliceReferenceView.referenceImageView.image = (err == nil) ? image : UIImage(named: ImageNames.placeholderImage)
            }
        }
        self.workspaceSpliceReferenceView.fourtyButton.isEnabled = (button == ReferenceLayoutType.fourtyfive) ? true : ((arrayCount == 1) ? false : true)
        self.workspaceSpliceReferenceView.sixtyButton.isEnabled = (button == ReferenceLayoutType.fourtyfive) ? ((arrayCount == 1) ? false : true) : true
        self.workspaceSpliceReferenceView.fourtyFiveLabel.textColor = (button == ReferenceLayoutType.fourtyfive) ? ((isSplice) ? .black : .white) : ((arrayCount == 1) ? .lightGray : .black)
        self.workspaceSpliceReferenceView.fourtyFiveNapLabel.textColor = (button == ReferenceLayoutType.fourtyfive) ? ((isSplice) ? .black : .white) : ((arrayCount == 1) ? .lightGray : .black)
        self.workspaceSpliceReferenceView.sixtyLable.textColor = (button == ReferenceLayoutType.fourtyfive) ? ((arrayCount == 1) ? .lightGray : .black) : ((isSplice) ? .black : .white)
        self.workspaceSpliceReferenceView.sixtyNapLabel.textColor = (button == ReferenceLayoutType.fourtyfive) ? ((arrayCount == 1) ? .lightGray : .black) : ((isSplice) ? .black : .white)
        self.workspaceSpliceReferenceView.fourtyFiveView.backgroundColor = (button == ReferenceLayoutType.fourtyfive) ? ((isSplice) ? CustomColor.wsReferenceGrayColor : .black) : CustomColor.wsReferenceGrayColor
        self.workspaceSpliceReferenceView.sixtyView.backgroundColor = (button == ReferenceLayoutType.fourtyfive) ? CustomColor.wsReferenceGrayColor : ((isSplice) ? CustomColor.wsReferenceGrayColor : .black)
        if !isSplice {
            if self.objNewWorkSpaceBaseViewModel.isSplicePiecePresent {
                self.workspaceSpliceReferenceView.spliceButtonView.backgroundColor = CustomColor.spliceEnableColor
                self.workspaceSpliceReferenceView.spliceButton.setTitleColor(.black, for: .normal)
                self.workspaceSpliceReferenceView.isSpliceEnabled = true
            }
        } else {
            self.workspaceSpliceReferenceView.referenceImageView.image =  self.workspaceSpliceReferenceView.spliceImage
            if (arrayCount == 1 && button == ReferenceLayoutType.fourtyfive) || (arrayCount == 2 && button == ReferenceLayoutType.sixty) {
                self.workspaceSpliceReferenceView.enableSplice()
            } else {
                if self.objNewWorkSpaceBaseViewModel.isSplicePiecePresent {
                    self.workspaceSpliceReferenceView.enableSplice()
                }
            }
        }
    }
}
