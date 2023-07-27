//
//  Ext+BeamSetupVC+CollectionVIew.swift
//  Ditto
//
//  Created by Gokul Ramesh on 24/03/23.
//  Copyright © 2023 Infosys. All rights reserved.
//

import UIKit

extension BeamSetUpViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
    // Collection view functions
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.beamSetUpViewModel.typeofScreen = self.beamSetUpViewModel.fetchType
        if self.beamSetUpViewModel.fetchType == TutorialDataFetchType.calibration || self.beamSetUpViewModel.fetchType == TutorialDataFetchType.connectivity {
            self.beamSetUpViewModel.selectedIndex = FormatsString.emptyString
        }
        let inst = self.beamSetUpViewModel.getArrayForSelectedIndex(selectedTabIndex: self.beamSetUpViewModel.selectedIndex, type: self.beamSetUpViewModel.typeofScreen)
        return inst.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var collectionViewCell = UICollectionViewCell()
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReusableCellIdentifiers.beamsetupCellIdentifier, for: indexPath as IndexPath) as? BeamSetUpCollectionViewCell {
        cell.backgroundColor = .clear
        cell.beamSetUpView.backgroundColor = .clear
        cell.contentView.backgroundColor = .clear
        collectionView.showsHorizontalScrollIndicator = false
        let inst = self.beamSetUpViewModel.getArrayForSelectedIndex(selectedTabIndex: self.beamSetUpViewModel.selectedIndex, type: self.beamSetUpViewModel.typeofScreen)
        if indexPath.row < inst.count && indexPath.row >= 0 {
            cell.frame.origin.y = 0
            self.segmentHeightConstraint.constant = UIDevice.isPad ? 40 : 30
            self.topspaceConstraint.constant = UIDevice.isPad ? 20 : 10
            cell.beamSetUpView.imageHeightConstraint.constant = UIDevice.isPad ? -35 : 0
            self.beamSetUpViewModel.typeofScreen = self.beamSetUpViewModel.fetchType
            if self.beamSetUpViewModel.fetchType == TutorialDataFetchType.calibration || self.beamSetUpViewModel.fetchType == TutorialDataFetchType.connectivity {
                self.beamSetUpViewModel.selectedIndex = FormatsString.emptyString
            }
            if self.beamSetUpViewModel.fetchType == TutorialDataFetchType.beamSetup {
                self.segmentHeightConstraint.constant = UIDevice.isPad ? 40 : 30
                self.topspaceConstraint.constant = UIDevice.isPad ? 20 : 10
                if self.beamSetUpViewModel.isFromCalibration && self.beamSetUpViewModel.initial == 1 {
                    cell.beamSetUpView.beamLabelTopConstraint.constant = (CommonConst.navCheckValue == 1) ? (UIDevice.isPhone ? 45 : 50) : (UIDevice.isPhone ? 25 : 30)
                    self.beamSetUpViewModel.initial = 0
                } else {
                    cell.beamSetUpView.beamLabelTopConstraint.constant = 0
                }
            } else {
                self.segmentHeightConstraint.constant = 0
                self.topspaceConstraint.constant = 0
                cell.beamSetUpView.beamLabelTopConstraint.constant = 5
                if CommonConst.navCheckValue == 1 {
                    if self.beamSetUpViewModel.initial == 0 {
                        cell.beamSetUpView.beamLabelTopConstraint.constant = UIDevice.isPhone ? 25 : 20
                        self.beamSetUpViewModel.initial = 1
                    }
                }
            }
            self.beamSetUpViewModel.resourceName = inst[indexPath.row].instructionVdoPath
            cell.beamSetUpView.layoutSubviews()
            cell.beamSetUpView.layoutIfNeeded()
            cell.beamSetUpView.titleLabel.text = inst[indexPath.row].instructionTitle
            let imageURL = URL(string: inst[indexPath.row].instructionImage)
            cell.beamSetUpView.instructionImage.sd_setImage(with: imageURL, placeholderImage: UIImage(named: ImageNames.placeholderImage)) { (image, err, _, _) in
                cell.beamSetUpView.instructionImage.image = (err == nil) ? image : UIImage(named: ImageNames.placeholderImage)
            }
            cell.beamSetUpView.watchVideoButton.tag = indexPath.row
            cell.beamSetUpView.watchVideo.tag = indexPath.row
            cell.beamSetUpView.watchVideo.addTarget(self, action: #selector(self.watchVideoButtonClicked), for: .touchUpInside)
            cell.beamSetUpView.pdfImageButton.addTarget(self, action: #selector(self.pdfButtonClicked), for: .touchUpInside)
            cell.beamSetUpView.instructionLabel.text = inst[indexPath.row].instructionDescription
            if CommonConst.navCheckValue == 1 {
                if self.beamSetUpViewModel.fetchType == TutorialDataFetchType.beamSetup && UIDevice.isPhone {
                    cell.beamSetUpView.imageHeightConstraint.constant = -10
                }
            }
            cell.beamSetUpView.scrollBottomDividerView.isHidden = true
            cell.beamSetUpView.scrollView.showsVerticalScrollIndicator = true
            cell.beamSetUpView.scrollView.showsHorizontalScrollIndicator = false
            DispatchQueue.main.asyncAfter(deadline: (.now() + .milliseconds(250))) {
                cell.beamSetUpView.scrollView.flashScrollIndicators()
            }
            cell.hideAndShowbeamSetUpDivider()
            self.beamSetUpViewModel.typeofScreen = self.beamSetUpViewModel.fetchType
            if self.beamSetUpViewModel.fetchType == TutorialDataFetchType.calibration || self.beamSetUpViewModel.fetchType == TutorialDataFetchType.connectivity {
                self.beamSetUpViewModel.selectedIndex = FormatsString.emptyString
            }
            let instruct = self.beamSetUpViewModel.getArrayForSelectedIndex(selectedTabIndex: self.beamSetUpViewModel.selectedIndex, type: self.beamSetUpViewModel.typeofScreen)
            collectionViewCell = cell
        }
    }
        return collectionViewCell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let space = UIDevice.isPad ? 80 : 50
        var safeAreHeight = self.view.frame.height - CGFloat(space)
        var safeAreWidth = self.view.frame.width
        if Proxy.shared.keyWindow != nil {
            let safeAreaInsets = Proxy.shared.keyWindow!.safeAreaInsets
            safeAreHeight -= safeAreaInsets.bottom - safeAreaInsets.top
            safeAreWidth -= safeAreaInsets.left - safeAreaInsets.right
        }
        return CGSize(width: safeAreWidth, height: safeAreHeight)
    }
    func addCollectionView() {   // Adding collection view to window
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.collectionView = UICollectionView(frame: self.baseView.frame, collectionViewLayout: layout)
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.isPagingEnabled = true
        self.baseView.addSubview(self.collectionView)
        self.baseView.backgroundColor = UIColor.clear
        self.collectionView.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView.leadingAnchor.constraint(equalTo: self.baseView.leadingAnchor, constant: (UIDevice.isPad ? 15.0 : 0.0)).isActive = true
        self.collectionView.trailingAnchor.constraint(equalTo: self.baseView.trailingAnchor, constant: 0.0).isActive = true
        self.collectionView.bottomAnchor.constraint(equalTo: self.baseView.bottomAnchor, constant: 0.0).isActive = true
        self.collectionView.topAnchor.constraint(equalTo: self.baseView.topAnchor, constant: 0.0).isActive = true
    }
    func reloadCollectionViewData() {  // Reload the data based on selection between beam setup and takedown
        self.beamSetUpViewModel.typeofScreen = self.beamSetUpViewModel.fetchType
        if self.beamSetUpViewModel.fetchType == TutorialDataFetchType.calibration || self.beamSetUpViewModel.fetchType == TutorialDataFetchType.connectivity {
            self.beamSetUpViewModel.selectedIndex = FormatsString.emptyString
        }
        let instructionArray = self.beamSetUpViewModel.getArrayForSelectedIndex(selectedTabIndex: self.beamSetUpViewModel.selectedIndex, type: self.beamSetUpViewModel.typeofScreen)
        self.currentIndex = 0
        self.collectionView.reloadData()
        self.pageControl.numberOfPages = instructionArray.count
        UIView.animate(withDuration: 0.5, delay: 0.0, animations: {
            self.collectionView.scrollToItem(at: IndexPath(item: self.currentIndex, section: 0), at: .centeredHorizontally, animated: false)
        }, completion: nil)
    }
    @objc func watchVideoButtonClicked(_ sender: UIButton) {   // Watch Video button tap action
        if let tag = sender.tag as Int? {
            self.beamSetUpViewModel.popupBackground.frame = DeviceInfo.screenBound
            self.beamSetUpViewModel.typeofScreen = self.beamSetUpViewModel.fetchType
            if self.beamSetUpViewModel.fetchType == TutorialDataFetchType.calibration || self.beamSetUpViewModel.fetchType == TutorialDataFetchType.connectivity {
                self.beamSetUpViewModel.selectedIndex = FormatsString.emptyString
            }
            let fetchArray = self.beamSetUpViewModel.getArrayForSelectedIndex(selectedTabIndex: self.beamSetUpViewModel.selectedIndex, type: self.beamSetUpViewModel.typeofScreen)
            if fetchArray.count > tag {
                let inst = fetchArray[tag]
                DispatchQueue.main.async {
                    if let watchVideoController = Constants.loginStoryBoard.instantiateViewController(withIdentifier: Constants.AdvertisementVideoControllerIdentifier) as? AdvertisementVideoController {
                        watchVideoController.modalPresentationStyle = .custom
                        if inst.instructionVdoPath != FormatsString.emptyString {
                            watchVideoController.videoUrl = inst.instructionVdoPath
                            watchVideoController.videoTitle = (self.beamSetUpViewModel.fetchType == TutorialDataFetchType.calibration || self.beamSetUpViewModel.fetchType == TutorialDataFetchType.connectivity) ? inst.instructionType : inst.tabName
                            watchVideoController.isFromSceen = ScreenTypeString.tutorial
                            if self.presentedViewController == nil {
                                self.present(watchVideoController, animated: true, completion: nil)
                            }
                        }
                    }
                }
            }
        } else {
            ServiceManagerProxy.shared.displayerrorPopup(url: FormatsString.emptyString, responseError: AlertMessage.invalidEntry)
        }
    }
    @objc func pdfButtonClicked(_ sender: UIButton) {   // PDF Image button tap action
        if let tag = sender.tag as Int? {
            self.beamSetUpViewModel.typeofScreen = self.beamSetUpViewModel.fetchType
            if self.beamSetUpViewModel.fetchType == TutorialDataFetchType.calibration || self.beamSetUpViewModel.fetchType == TutorialDataFetchType.connectivity {
                self.beamSetUpViewModel.selectedIndex = FormatsString.emptyString
            }
            let fetchArray = self.beamSetUpViewModel.getArrayForSelectedIndex(selectedTabIndex: self.beamSetUpViewModel.selectedIndex, type: self.beamSetUpViewModel.typeofScreen)
            if fetchArray.count > tag {
                let inst = fetchArray[tag]
                let tutorialPdfUrl = inst.tutorialPdfUrl
                if !tutorialPdfUrl.isEmpty {
                    let fileName = "\(((self.beamSetUpViewModel.fetchType == TutorialDataFetchType.calibration || self.beamSetUpViewModel.fetchType == TutorialDataFetchType.connectivity) ? inst.instructionType : inst.tabName) + FormatsString.tutorialPdfLabel).pdf"
                    let documentsURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
                    let finalPath = documentsURL.appendingPathComponent("\(((self.beamSetUpViewModel.fetchType == TutorialDataFetchType.calibration || self.beamSetUpViewModel.fetchType == TutorialDataFetchType.connectivity) ? inst.instructionType : inst.tabName) + FormatsString.tutorialPdfLabel).pdf")
                    if !FileManager.default.fileExists(atPath: finalPath.path) {
                        if Network.reachability.isReachable {
                            self.savePdf(urlString: tutorialPdfUrl, fileName: fileName) { (status) in
                                if status {
                                    DispatchQueue.main.async {
                                        if let pdfViewController = Constants.patternInstructions.instantiateViewController(withIdentifier: Constants.PatternInstructionsIdentifier) as? PatternInstructionsViewController {
                                            pdfViewController.patternInstViewModel.fromSewingInstruction = false
                                            pdfViewController.patternInstViewModel.fromPatternDescription = false
                                            pdfViewController.patternInstViewModel.fromTutorial = true
                                            pdfViewController.patternInstViewModel.fileURL = finalPath
                                            pdfViewController.patternInstViewModel.mainURL = tutorialPdfUrl
                                            pdfViewController.patternInstViewModel.titleLable = (self.beamSetUpViewModel.fetchType == TutorialDataFetchType.calibration || self.beamSetUpViewModel.fetchType == TutorialDataFetchType.connectivity) ? inst.instructionType : inst.tabName
                                            self.navigationController?.pushViewController(pdfViewController, animated: true)
                                        }
                                    }
                                } else {
                                    self.displayErrorPopUp()
                                }
                            }
                        } else {
                            ServiceManagerProxy.shared.displayerrorPopup(url: FormatsString.emptyString, responseError: AlertMessage.noConnectionDescription)
                        }
                    } else {
                        DispatchQueue.main.async {
                            if let pdfViewController = Constants.patternInstructions.instantiateViewController(withIdentifier: Constants.PatternInstructionsIdentifier) as? PatternInstructionsViewController {
                                pdfViewController.patternInstViewModel.fromSewingInstruction = false
                                pdfViewController.patternInstViewModel.fromPatternDescription = false
                                pdfViewController.patternInstViewModel.fromTutorial = true
                                pdfViewController.patternInstViewModel.fileURL = finalPath
                                pdfViewController.patternInstViewModel.mainURL = tutorialPdfUrl
                                pdfViewController.patternInstViewModel.titleLable = (self.beamSetUpViewModel.fetchType == TutorialDataFetchType.calibration || self.beamSetUpViewModel.fetchType == TutorialDataFetchType.connectivity) ? inst.instructionType : inst.tabName
                                self.navigationController?.pushViewController(pdfViewController, animated: true)
                            }
                        }
                    }
                } else {
                    ServiceManagerProxy.shared.displayerrorPopup(url: tutorialPdfUrl, responseError: MessageString.noPdftoDisplay)
                }
            }
        } else {
            ServiceManagerProxy.shared.displayerrorPopup(url: FormatsString.emptyString, responseError: AlertMessage.invalidEntry)
        }
    }
    func displayErrorPopUp() {   // Popup when Error inDownloading PDF
        DispatchQueue.main.async {
            let viewc = Constants.AlertWithImageAndButtons.instantiateViewController(identifier: Constants.AlertWithImageAndButonsVCIdentifier) as AlertWithImageAndButtonsViewController
            viewc.alertArray = [ConnectivityUtils.failedImage, AlertMessage.unabletoLoadFIle, AlertTitle.RETRY, AlertTitle.CANCEL, FormatsString.emptyString]
            viewc.screenType = ScreenTypeString.PatternDesc
            viewc.modalPresentationStyle = .overFullScreen
            viewc.onRetryPressed = {
                self.pdfButtonClicked(UIButton())
            }
            if self.presentedViewController == nil {
                self.present(viewc, animated: false, completion: nil)
            }
        }
    }
}

