//
//  Ext+WorkspaceLoadingLogic.swift
//  Ditto
//
//  Created by abiya.joy on 06/10/22.
//  Copyright © 2022 Infosys. All rights reserved.
//

import UIKit
import Alamofire

extension WorkspaceBaseViewController {
    func loadRefLayout() {   // Loading Refernce layout
        self.workspaceSpliceReferenceView.delegate = self
    }
    func loadWorkspaceArea() {   // load workspace area
        self.objNewWorkSpaceBaseViewModel.disableMirroring(view: self.workspaceAreaView)
        self.objNewWorkSpaceBaseViewModel.disableRotateDropDown(view: self.workspaceAreaView)
        self.workspaceAreaView.spliceDelegate = self
        let newHeight = self.workspaceAreaView.workAreaView.bounds.size.width / 1.5555 // 1.5555 is 14:9 ratio, Setting WS ratio
        self.workspaceAreaView.workAreaView.frame = CGRect(x: 0, y: 0, width: self.workspaceAreaView.workAreaView.bounds.size.width, height: newHeight)
        self.registerSetUpNib()
    }
    func registerSetUpNib() {
        self.objNewWorkSpaceBaseViewModel.tableView.delegate = self
        self.objNewWorkSpaceBaseViewModel.tableView.dataSource = self
        self.objNewWorkSpaceBaseViewModel.tableView.separatorStyle = .none
        self.objNewWorkSpaceBaseViewModel.tableView.borderWidth = 1.0
        self.objNewWorkSpaceBaseViewModel.tableView.borderColor = CustomColor.textFieldBorder
        self.objNewWorkSpaceBaseViewModel.tableView.isScrollEnabled = true
        Proxy.shared.registerNib(self.objNewWorkSpaceBaseViewModel.tableView, nibName: ReusableCellIdentifiers.customisedListCellIdentifier, identifierCell: ReusableCellIdentifiers.customListIdentifier)
    }
    func addDragInteraction() {   // add drag interaction to collection view pattern pieces
        self.patternsView.patternCollectionView?.dragInteractionEnabled = true
    }
    func addDropInteraction() {   // add drop interaction to workspace view
        let interaction = UIDragInteraction(delegate: self)
        interaction.isEnabled = true
        self.workspaceAreaView.workAreaView.addInteraction(interaction)
        self.workspaceAreaView.workAreaView.addInteraction(UIDropInteraction(delegate: self))
        self.workspaceAreaView.workAreaView.isUserInteractionEnabled = true
        self.patternsView.patternCollectionView!.isUserInteractionEnabled = true
        self.patternsView.isUserInteractionEnabled = true
    }
    func loadPatternsView() {   // Load Pattern collection view
        self.patternsView.patternCollectionView?.dragDelegate = self as UICollectionViewDragDelegate?
        self.patternsView.patternCollectionView?.register(UINib(nibName: ReusableCellIdentifiers.patternCollectionViewCellIdentifier, bundle: Bundle.main), forCellWithReuseIdentifier: ReusableCellIdentifiers.patternCollectionViewCellIdentifier)
        self.patternsView.patternCollectionView?.delegate = self
        self.patternsView.patternCollectionView?.dataSource = self
        self.addDragInteraction()
        self.addDropInteraction()
        self.patternsView.patternCollectionView?.canCancelContentTouches = true
        self.patternsView.buttonReset.addTarget(self, action: #selector(patternViewReset(_ :)), for: .touchUpInside)
        self.patternsView.didClickAddNotes = {
            if let addNotesVC = Constants.workspaceStoryBoard.instantiateViewController(withIdentifier: Constants.AddNotesVCIdentifier) as? AddNotesViewController {
                addNotesVC.modalPresentationStyle = .overCurrentContext
                addNotesVC.SavedNotes = { savednotes in
                    self.objNewWorkSpaceBaseViewModel.notes = savednotes
                }
                addNotesVC.receivedSavedNotes = self.objNewWorkSpaceBaseViewModel.notes
                self.present(addNotesVC, animated: true)
            }
        }
        self.patternsView.labelTotalCutCount.text = "\(  self.objNewWorkSpaceBaseViewModel.getTotalNoOfCutBinPiecesForSelectedPatternFromTailornova(pieces: self.objNewWorkSpaceBaseViewModel.getPatternPiecesBasedOnTab(tabType: self.objNewWorkSpaceBaseViewModel.selectedTabCategory)))"
        self.setupCutCountForSelectedTabCategory()
    }
    func setupViewDidLoad () {   // View did load logics
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: FormatsString.forgroundLabel), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: FormatsString.unlockLabel), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.appMovedToForeground), name: NSNotification.Name(rawValue: FormatsString.forgroundLabel), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.listenUnlock), name: NSNotification.Name(rawValue: FormatsString.unlockLabel), object: nil)
        self.workspaceAreaView.doubleTapToZoomLabel.isHidden = true
        self.sendToProjectorButtonOutlet.titleLabel?.numberOfLines = 1
        self.sendToProjectorButtonOutlet.titleLabel?.adjustsFontSizeToFitWidth = true
        if let manager = NetworkReachabilityManager(), !manager.isReachable {
            self.setupPostParamsForNoInterent()
        }
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(bringZoomUpPopUp))
        tapRecognizer.numberOfTapsRequired = 2
        self.workspaceSpliceReferenceView.referenceImageView.isUserInteractionEnabled = true
        self.workspaceSpliceReferenceView.referenceImageView.addGestureRecognizer(tapRecognizer)
        self.workspaceSpliceReferenceView.isHidden = true
        self.delegate = self
        self.loadPatternsView()
        self.loadRefLayout()
        self.loadWorkspaceArea()
        self.objNewWorkSpaceBaseViewModel.workSpaceSettingsForAlert()
        self.objNewWorkSpaceBaseViewModel.currentSelectedPatternIndex = MyLibrarryViewController().myLibraryViewModel.currentSelectedPatternIndex
        self.enableSelectAll()
        self.objNewWorkSpaceBaseViewModel.disableClearing(view: self.workspaceAreaView)
        self.workspaceAreaView.clearButton.addTarget(self, action: #selector(self.clearFunction(_:)), for: .touchUpInside)
        self.workspaceAreaView.clearButtoniPad.addTarget(self, action: #selector(self.clearFunction(_:)), for: .touchUpInside)
        self.workspaceAreaView.selectAllButton.addTarget(self, action: #selector(self.selectAllFirst(_:)), for: .touchUpInside)
        self.workspaceAreaView.selectAllipad.addTarget(self, action: #selector(self.selectAllFirst(_:)), for: .touchUpInside)
        self.workspaceAreaView.buttonIpadSewingInstruction.addTarget(self, action: #selector(self.sewingInstructionClicked(_:)), for: .touchUpInside)
        self.workspaceAreaView.buttonIpadTutorial.addTarget(self, action: #selector(self.tutorialClicked(_:)), for: .touchUpInside)
        self.workspaceAreaView.buttonIphoneSewingInstruction.addTarget(self, action: #selector(self.sewingInstructionClicked(_:)), for: .touchUpInside)
        self.workspaceAreaView.buttonIphoneTutorial.addTarget(self, action: #selector(self.tutorialClicked(_:)), for: .touchUpInside)
        self.addGestureRecognizerToView()
        self.workspaceAreaView.mirroringDelegate = self
        self.workspaceAreaView.rotateDelegate = self
        if !self.objNewWorkSpaceBaseViewModel.isProjecting {
            self.objNewWorkSpaceBaseViewModel.sendImage(imageString: ImageNames.wsLaunchImage, hostData: self.objNewWorkSpaceBaseViewModel.host, portData: self.objNewWorkSpaceBaseViewModel.port)
        }
        if UIDevice.isPad {
            self.workspaceAreaView.buttonIpadConnectRecalibrate.addTarget(self, action: #selector(self.recalibrateConnectButtonAction), for: .touchUpInside)
        } else {
            self.workspaceAreaView.connectButton.addTarget(self, action: #selector(self.recalibrateConnectButtonAction), for: .touchUpInside)
        }
        if CommonConst.serviceConnectedCheck {
            self.objNewWorkSpaceBaseViewModel.sendImage(imageString: ImageNames.wsLaunchImage, hostData: ProjectorDetails.Host, portData: ProjectorDetails.port)
        } else {
            if let manager = NetworkReachabilityManager(), manager.isReachable {
                self.dismissLottie()
                self.showConnectionLottie()
            }
        }
        if !ProjectorDetails.isCalibrated {
            self.dismissLottie()
            self.showConnectionLottie()
        }
        if UIDevice.isPad {
            self.workspaceAreaView.buttonIpadConnectRecalibrate.setTitle(CommonConst.serviceConnectedCheck ? CalibrationMessages.calibrationConfTitle : FormatsString.connectLabel, for: .normal)
        } else {
            self.workspaceAreaView.connectRecalibrateButton.setTitle(CommonConst.serviceConnectedCheck ? CalibrationMessages.calibrationConfTitle : FormatsString.connectLabel, for: .normal)
        }
        self.objNewWorkSpaceBaseViewModel.isProjecting = false
        self.sendToProjectorButtonOutlet.isEnabled = CommonConst.serviceConnectedCheck && ProjectorDetails.isCalibrated ? true : false
        self.sendToProjectorButtonOutlet.backgroundColor = CommonConst.serviceConnectedCheck && ProjectorDetails.isCalibrated ? CustomColor.activeProjectorButtonBG : CustomColor.disabledProjectorButtonBG
        self.objNewWorkSpaceBaseViewModel.calibrateConnect = CommonConst.serviceConnectedCheck ? FormatsString.recalibrateWSLabel : FormatsString.calibrateWSLabel
        self.view.isUserInteractionEnabled = true
        self.workspaceAreaView.isMirrorAlertHiddenCheck = !self.objNewWorkSpaceBaseViewModel.isMirrorAlertShown // TRAC_603_WS_Pro_Settings_Logic
        self.objNewWorkSpaceBaseViewModel.hideTabNavController(uiViewController: self, hideTabBar: true, hideNav: true)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        CommonConst.selectedTabGarmentValue = true
        CommonConst.selectedTabLiningValue = true
        CommonConst.selectedTabInterfacingValue = true
        CommonConst.selectedTabOtherValue = true
    }
    func workspaceScreenLoading() {
        self.objNewWorkSpaceBaseViewModel.selectedTabCategory = self.objNewWorkSpaceBaseViewModel.getPatternPiecesBasedOnTab(tabType: self.objNewWorkSpaceBaseViewModel.selectedTabCategory).isEmpty ? self.objNewWorkSpaceBaseViewModel.selectedTabForNewPattern() : self.objNewWorkSpaceBaseViewModel.selectedTabCategory
        self.objNewWorkSpaceBaseViewModel.loadPatternPiecesFor(tabCategory: self.objNewWorkSpaceBaseViewModel.selectedTabCategory) { (patternArray) in
            self.objNewWorkSpaceBaseViewModel.disableMirroring(view: self.workspaceAreaView)
            self.objNewWorkSpaceBaseViewModel.disableRotateDropDown(view: self.workspaceAreaView)
            self.objNewWorkSpaceBaseViewModel.disableClearing(view: self.workspaceAreaView)
            self.workspaceAreaView.checkAlertShown = false
            for paten in patternArray {
                let imagePath = paten.imageURL
                self.objNewWorkSpaceBaseViewModel.imagePathArray.append(getImageName(from: imagePath)!)
                self.objNewWorkSpaceBaseViewModel.imagesArray.append(self.getImageForPatternPiece(id: paten.tailornovaIndex))
            }
            self.patternsView.patternCollectionView?.dragInteractionEnabled = true
            self.patternsView.patternCollectionView?.reloadData()
        }
        self.objNewWorkSpaceBaseViewModel.totalCutPieces =  self.objNewWorkSpaceBaseViewModel.getTotalNoOfCutBinPiecesForSelectedPatternFromTailornova(pieces: self.objNewWorkSpaceBaseViewModel.getPatternPiecesBasedOnTab(tabType: self.objNewWorkSpaceBaseViewModel.selectedTabCategory))
        self.updateRefLayoutViewForFabric(fabricSelected: self.objNewWorkSpaceBaseViewModel.selectedTabCategory, isSplice: false)
        self.patternsView.labelTotalCutCount.text = "\(  self.objNewWorkSpaceBaseViewModel.getTotalNoOfCutBinPiecesForSelectedPatternFromTailornova(pieces: self.objNewWorkSpaceBaseViewModel.getPatternPiecesBasedOnTab(tabType: self.objNewWorkSpaceBaseViewModel.selectedTabCategory)))"
        self.setupCutCountForSelectedTabCategory()
        self.objNewWorkSpaceBaseViewModel.previousSelectedTabCategory = self.objNewWorkSpaceBaseViewModel.selectedTabCategory
        if self.objNewWorkSpaceBaseViewModel.selectedTabCategory == WorkAreaTabCategory.garment.categoryName {
            self.patternsSegmentedContol.selectedSegmentIndex = 0
        } else if self.objNewWorkSpaceBaseViewModel.selectedTabCategory == WorkAreaTabCategory.lining.categoryName {
            self.patternsSegmentedContol.selectedSegmentIndex = 1
        } else if self.objNewWorkSpaceBaseViewModel.selectedTabCategory == WorkAreaTabCategory.interfacing.categoryName {
            self.patternsSegmentedContol.selectedSegmentIndex = 2
        } else if self.objNewWorkSpaceBaseViewModel.selectedTabCategory == WorkAreaTabCategory.other.categoryName {
            self.patternsSegmentedContol.selectedSegmentIndex = 3
        }
        self.updateSegmentedTabsForSelectedPattern()
        self.layoutButtonValueSetting()
    }
    func updateSegmentedTabsForSelectedPattern() {  // Enabling and Disabling Segment tab based on selvage array count
        let garmentArr = self.objNewWorkSpaceBaseViewModel.getPatternPiecesBasedOnTab(tabType: WorkAreaTabCategory.garment.categoryName)
        let liningArr = self.objNewWorkSpaceBaseViewModel.getPatternPiecesBasedOnTab(tabType: WorkAreaTabCategory.lining.categoryName)
        let interFacingArr = self.objNewWorkSpaceBaseViewModel.getPatternPiecesBasedOnTab(tabType: WorkAreaTabCategory.interfacing.categoryName)
        let otherArr = self.objNewWorkSpaceBaseViewModel.getPatternPiecesBasedOnTab(tabType: WorkAreaTabCategory.other.categoryName)
        if garmentArr.isEmpty {
            self.patternsSegmentedContol.setEnabled(false, forSegmentAt: 0)
        }
        if liningArr.isEmpty {
            self.patternsSegmentedContol.setEnabled(false, forSegmentAt: 1)
        }
        if interFacingArr.isEmpty {
            self.patternsSegmentedContol.setEnabled(false, forSegmentAt: 2)
        }
        if otherArr.isEmpty {
            self.patternsSegmentedContol.setEnabled(false, forSegmentAt: 3)
        }
    }
    func setupViewWillAppear() {  // view will appear logic
        let myLayer = CALayer()
        let myImage = UIImage(named: ImageNames.workspaceViewBorderImage)?.cgImage
        myLayer.contents = myImage
        self.workspaceAreaView.workAreaView.layer.addSublayer(myLayer)
        self.view.isUserInteractionEnabled = true
        self.navigationController?.navigationBar.isHidden = true
        if !WorkspaceBaseViewController.workspaceViewModel.isFromInstructionView {
            CommonConst.userDefault.setValue(nil, forKey: "piece\(WorkAreaTabCategory.garment.categoryName)")
            CommonConst.userDefault.setValue(nil, forKey: "piece\(WorkAreaTabCategory.lining.categoryName)")
            CommonConst.userDefault.setValue(nil, forKey: "piece\(WorkAreaTabCategory.interfacing.categoryName)")
            CommonConst.userDefault.setValue(nil, forKey: "piece\(WorkAreaTabCategory.other.categoryName)")
            CommonConst.userDefault.setValue(nil, forKey: "reference\(WorkAreaTabCategory.garment.categoryName)")
            CommonConst.userDefault.setValue(nil, forKey: "reference\(WorkAreaTabCategory.lining.categoryName)")
            CommonConst.userDefault.setValue(nil, forKey: "reference\(WorkAreaTabCategory.interfacing.categoryName)")
            CommonConst.userDefault.setValue(nil, forKey: "reference\(WorkAreaTabCategory.other.categoryName)")
            let myLayer = CALayer()
            let myImage = UIImage(named: ImageNames.workspaceViewBorderImage)?.cgImage
            myLayer.contents = myImage
            self.workspaceAreaView.workAreaView.layer.addSublayer(myLayer)
            self.view.isUserInteractionEnabled = true
            self.objNewWorkSpaceBaseViewModel.hideTabNavController(uiViewController: self, hideTabBar: true, hideNav: true)
            self.addRemoveSpliceButton(isShow: false)
            // MARK: - Tailrnova User Worked ID Internet is available
            let purchaseId = self.objNewWorkSpaceBaseViewModel.tailornovamannequinIDArray.isEmpty ? self.objNewWorkSpaceBaseViewModel.purchasedSizeId : self.objNewWorkSpaceBaseViewModel.tailornovamannequinIDArray[0].mannequinID
            if !CommonConst.guestUserCheck {
                if  let manager = NetworkReachabilityManager(), manager.isReachable {
                    self.objNewWorkSpaceBaseViewModel.getCoWorkspace(tailrnovaDesignId: self.objNewWorkSpaceBaseViewModel.tailornovaPatternDesignId, purchaseDesignId: purchaseId ) {
                        self.workspaceScreenLoading()
                        self.selectedPiecesUpdateFunction()
                    }
                } else {
                    self.objNewWorkSpaceBaseViewModel.dragLabelShown = true
                    self.objNewWorkSpaceBaseViewModel.objGetWSMainPostModel.patternPieces.removeAll()
                    for dict in self.objNewWorkSpaceBaseViewModel.tailornovaPatternArray {
                        let obj = WSPatternPiecesModel()
                        obj.id = dict.tailornovaIndex
                        obj.isCompleted = dict.isSelected
                        self.objNewWorkSpaceBaseViewModel.objGetWSMainPostModel.patternPieces.append(obj)
                    }
                    self.workspaceScreenLoading()
                    self.selectedPiecesUpdateFunction()
                }
            } else {
                self.objNewWorkSpaceBaseViewModel.selectedTabCategory = self.objNewWorkSpaceBaseViewModel.selectedTabForNewPattern()
                self.workspaceScreenLoading()
                self.selectedPiecesUpdateFunction()
            }
        } else {
            self.settingSelectionOfSelectedTab()
            if let manager = NetworkReachabilityManager(), manager.isReachable {
                self.showPreviousPatterUserWorked()
            }
        }
        self.workspaceAreaView.viewSelectAll.roundCorners(corners: [.topRight], radius: 4)
        self.workspaceAreaView.viewClear.roundCorners(corners: [.bottomRight], radius: 4)
        if !CommonConst.serviceConnectedCheck {
            self.showConnectionLottie()
        }
        if !ProjectorDetails.isCalibrated {
            self.dismissLottie()
            self.showConnectionLottie()
        }
    }
    func setSelectedSegmentIndex(tabCategory: String) {   // set segment index based on the tab category selected
        if tabCategory == WorkAreaTabCategory.garment.categoryName { // "Garment"{
            self.patternsSegmentedContol.selectedSegmentIndex = WorkAreaTabCategory.garment.rawValue // 0
        } else if tabCategory == WorkAreaTabCategory.lining.categoryName { // "Lining"{
            self.patternsSegmentedContol.selectedSegmentIndex = WorkAreaTabCategory.lining.rawValue // 1
        } else if tabCategory == WorkAreaTabCategory.interfacing.categoryName { // "Interfacing" {
            self.patternsSegmentedContol.selectedSegmentIndex = WorkAreaTabCategory.interfacing.rawValue // 2
        } else if tabCategory == WorkAreaTabCategory.other.categoryName { // "Other" {
            self.patternsSegmentedContol.selectedSegmentIndex = WorkAreaTabCategory.other.rawValue // 3
        }
    }
}
