//
//  WorkspaceBaseViewController.swift
//  JoannTraceApp
//
//  Created by Prabha Rajalakshmi N on 12/08/20.
//  Copyright © 2020 Infosys. All rights reserved.
//

import UIKit
import FastSocket
import FabricTraceTransformFrx
import AVKit
import CoreGraphics
import Alamofire
import Lottie
import Foundation
import SDWebImage

class WorkspaceBaseViewController: UIViewController {
    //MARK: UI COMPONENT OUTLETS
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var sendToProjectorButtonOutlet: UIButton!
    @IBOutlet weak var workspaceSpliceReferenceView: ReferenceSpliceLayout!
    @IBOutlet var patternsView: PatternScrollableView!
    @IBOutlet var workspaceAreaView: WorkspaceAreaView!
    @IBOutlet var patternPieceLabel: UILabel!
    @IBOutlet var patternsSegmentedContol: UISegmentedControl!
    @IBOutlet weak var referenceLayoutButton: UIButton!
    @IBOutlet weak var patternPiecesButton: UIButton!
    @IBOutlet weak var viewSelected: UIView!
    @IBOutlet var buttonPatternPieceReferenceLayout: [UIButton]!
    @IBOutlet weak var thumbnailView: UIView!
    @IBOutlet weak var thumbnailImg: UIImageView!
    @IBOutlet weak var playVideoBtn: UIButton!
    @IBOutlet weak var closeThumbnailViewBtn: UIButton!
    @IBOutlet var instructionimgView: UIImageView!
    @IBOutlet weak var constraintVWSelectedLeading: NSLayoutConstraint!
    //MARK: VARIABLE DECLARATION
    var animView = AnimationView()   // connection animation based on client feedback_July9
    var delegate: ButtonVisibilityDelegate?
    static var workspaceViewModel = WorkspaceBaseViewModel()
    let objNewWorkSpaceBaseViewModel = NewWorkSpaceBaseViewModel()
    let splashObj = SplashViewController()
    // MARK: - View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViewDidLoad()
        self.setThumbnailView()
        self.patternsSegmentedContol.removeBorders()
        if let font = CustomFont.avenirLtProDemi(size: UIDevice.isPhone ? 12 : 15) {
            self.patternsSegmentedContol.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        }
    }
    @objc func appMovedToForeground() {
        if self.objNewWorkSpaceBaseViewModel.calibScreenType == FromScreen.tutorial {
            self.showConnectionLottie()
        } else {
            self.listenUnlock()
        }
    }
    override func viewDidLayoutSubviews() {
        if UIDevice.isPhone {
            switch UIScreen.main.nativeBounds.height {
            case 1136, 1334, 1920, 2208, 2436:
                self.sendToProjectorButtonOutlet.titleLabel?.font = self.sendToProjectorButtonOutlet.titleLabel?.font.withSize(10)
            default:
                break
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.workspaceAreaView.workAreaView.removeAllSubviews()
        self.setupViewWillAppear()
        self.loadWorkspaceArea()
        self.setupCutCountForSelectedTabCategory()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.patternPieceLabel.text = self.objNewWorkSpaceBaseViewModel.tailornovaDesignName
        self.objNewWorkSpaceBaseViewModel.hideTabNavController(uiViewController: self, hideTabBar: true, hideNav: true)
        self.patternsView.patternCollectionView?.reloadData()
        if !CommonConst.guestUserCheck {
            if let manager = NetworkReachabilityManager(), !manager.isReachable {
                self.showPreviousPatterUserWorked()
            }
        }
        self.dismissLottie()
        if self.objNewWorkSpaceBaseViewModel.calibScreenType == FromScreen.tutorial {
            self.showConnectionLottie()
        }
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            view.endEditing(true)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        self.dismissLottie()
        self.objNewWorkSpaceBaseViewModel.selectedTabCategory = self.objNewWorkSpaceBaseViewModel.previousSelectedTabCategory
        WorkspaceBaseViewController.workspaceViewModel.isFromInstructionView = false
        self.navigationItem.backButtonTitle = FormatsString.emptyString
        self.objNewWorkSpaceBaseViewModel.hideTabNavController(uiViewController: self, hideTabBar: false, hideNav: false)
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    @objc func listenUnlock() {   // Device unlock handling
        if !CommonConst.serviceConnectedCheck {
            self.showConnectionLottie()
        }
        if !ProjectorDetails.isCalibrated {
            self.dismissLottie()
            self.showConnectionLottie()
        }
    }
    func goToConectivityScreen() {  // navigation to connectivity screen
        DispatchQueue.main.async {
            if let connectivity = Constants.connectivity.instantiateViewController(withIdentifier: Constants.connectivityIdentifier) as? UINavigationController, !connectivity.viewControllers.isEmpty {
                if let connectvityVc = connectivity.viewControllers[0] as? ConnectivityViewController {
                    connectvityVc.dissmissConnectivityDelegate = self
                }
                connectivity.modalPresentationStyle = UIDevice.isPhone ? .popover : .overFullScreen
                if Proxy.shared.keyWindow?.rootViewController?.presentedViewController == nil {
                    Proxy.shared.keyWindow?.rootViewController?.present(connectivity, animated: false, completion: nil)
                }
            }
        }
    }
    func checkPatternPiecForMirroringAndSplicing(image: UIImageView) {   // Check mirroring, rotation and splicing status of tapped image
        self.objNewWorkSpaceBaseViewModel.tappedImgVw = image
        self.workspaceAreaView.tappedImgVw = self.objNewWorkSpaceBaseViewModel.tappedImgVw
        self.objNewWorkSpaceBaseViewModel.selctd = self.objNewWorkSpaceBaseViewModel.tappedImgVw.image!
        self.objNewWorkSpaceBaseViewModel.tappedImgVw.tintColor = CustomColor.red
        self.objNewWorkSpaceBaseViewModel.longPressGesture.numberOfTapsRequired = 2
        for piece in self.objNewWorkSpaceBaseViewModel.piecesDroppedArray.filter({ $0.imageView?.tag ==  self.objNewWorkSpaceBaseViewModel.tappedImgVw.tag}) {
            self.workspaceAreaView.checkAlertShown = piece.showMirrorDialog
        }
        self.objNewWorkSpaceBaseViewModel.tappedImgVw.addGestureRecognizer( self.objNewWorkSpaceBaseViewModel.longPressGesture)
        var spliceState = FormatsString.offStatusLabel
        var mirrorState = FormatsString.offStatusLabel
        self.objNewWorkSpaceBaseViewModel.enableClearing(view: self.workspaceAreaView)
        let patternObj = self.objNewWorkSpaceBaseViewModel.piecesDroppedArray.filter {($0.tagValue == self.objNewWorkSpaceBaseViewModel.tappedImgVw.tag)}
        guard let patternFirst = patternObj.first, let _ = patternObj.first?.imageId else {
            return
        }
        let arr = self.objNewWorkSpaceBaseViewModel.getDetailsOfCurrentSelectedPatternPiece(category: self.objNewWorkSpaceBaseViewModel.selectedTabCategory)
        let im2 = arr.filter {($0.tailornovaIndex == patternFirst.tailrnovaIndexId)}
        if !im2.isEmpty {
            mirrorState = !im2[0].mirrorOption ? FormatsString.offStatusLabel : FormatsString.onStatusLabel
            spliceState = !im2[0].isSpliced ? FormatsString.offStatusLabel : FormatsString.onStatusLabel
        }
        if spliceState == FormatsString.offStatusLabel {
            self.workspaceAreaView.workAreaView.addGestureRecognizer(self.objNewWorkSpaceBaseViewModel.rotate)
            self.workspaceAreaView.rotateDropDowniPhoneButton.setTitle(FormatsString.rotateLabel, for: .normal)
            self.workspaceAreaView.rotateDropDowniPadButton.setTitle(FormatsString.rotateLabel, for: .normal)
        }
        self.objNewWorkSpaceBaseViewModel.rotate.isEnabled = spliceState == FormatsString.offStatusLabel
        self.workspaceAreaView.rotateDropDowniPhoneButton.isEnabled = spliceState == FormatsString.offStatusLabel
        self.workspaceAreaView.rotateDropDowniPadButton.isEnabled = spliceState == FormatsString.offStatusLabel
        self.workspaceAreaView.rotateDropDowniPhoneArrow.isEnabled = spliceState == FormatsString.offStatusLabel
        self.workspaceAreaView.rotateDropDowniPadArrow.isEnabled = spliceState == FormatsString.offStatusLabel
        self.workspaceAreaView.mirrorH.isEnabled = mirrorState == FormatsString.onStatusLabel
        self.workspaceAreaView.mirrorV.isEnabled = mirrorState == FormatsString.onStatusLabel
        self.workspaceAreaView.mirrorHipad.isEnabled = mirrorState == FormatsString.onStatusLabel
        self.workspaceAreaView.mirrorVipad.isEnabled = mirrorState == FormatsString.onStatusLabel
        self.workspaceAreaView.mirrorH.isEnabled = mirrorState == FormatsString.onStatusLabel
        self.workspaceAreaView.mirrorV.isEnabled = mirrorState == FormatsString.onStatusLabel
        if mirrorState == FormatsString.onStatusLabel {
            self.workspaceAreaView.checkFlippedH =  self.objNewWorkSpaceBaseViewModel.tappedImgVw.transform.a < 0 ? true : false
            self.workspaceAreaView.checkFlippedV = self.objNewWorkSpaceBaseViewModel.tappedImgVw.transform.d < 0 ? true : false
        }
    }
    func setSingleTap(imgVw: UIImageView) {  // adding tap and pan gesture on pattern piece images
        imgVw.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.sinleTapped(gestureRecognizer:)))
        tapRecognizer.numberOfTapsRequired = 1
        imgVw.addGestureRecognizer(tapRecognizer)
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(self.handlePan(gestureRecognizer:)))
        imgVw.addGestureRecognizer(panGesture)
    }
    func addSplicedImageToWorkspaceView(draggedImage: UIImage, imgFrame: CGRect) {  // add splice piece to WS area
        self.workspaceAreaView.workAreaView.removeAllSubviews()
        self.objNewWorkSpaceBaseViewModel.piecesDroppedArray.removeAll()
        self.workspaceAreaView.selectAllButton.isEnabled = true
        self.workspaceAreaView.selectAllipad.isEnabled = true
        let imagVw = UIImageView(image: draggedImage.withRenderingMode(.automatic))
        imagVw.tintColor = UIColor.black
        imagVw.isUserInteractionEnabled = true
        imagVw.contentMode = .scaleAspectFit
        imagVw.frame = imgFrame
        self.setSingleTap(imgVw: imagVw)
        self.workspaceAreaView.splicedScreenLabel.text = FormatsString.emptyString
        let patternObj = PatternPieces()
        imagVw.tag = self.objNewWorkSpaceBaseViewModel.tagValue
        patternObj.height = Double(imagVw.frame.size.height)
        patternObj.image = imagVw.image
        patternObj.width = Double(imagVw.frame.size.width)
        patternObj.xcor = imagVw.frame.origin.x
        patternObj.ycor = imagVw.frame.origin.y
        patternObj.image = imagVw.image
        patternObj.isDisabled = false
        patternObj.imageView = imagVw
        patternObj.tagValue = self.objNewWorkSpaceBaseViewModel.tagValue
        let array = self.objNewWorkSpaceBaseViewModel.getPatternPiecesBasedOnTab(tabType: self.objNewWorkSpaceBaseViewModel.selectedTabCategory)
        patternObj.imageId = (array.count > self.objNewWorkSpaceBaseViewModel.currentIndexPath) ? Int(array[objNewWorkSpaceBaseViewModel.currentIndexPath].id) : 0
        patternObj.tailrnovaIndexId = (array.count > self.objNewWorkSpaceBaseViewModel.currentIndexPath) ? Int(array[self.objNewWorkSpaceBaseViewModel.currentIndexPath].tailornovaIndex) : 0
        patternObj.imagePath = (array.count > self.objNewWorkSpaceBaseViewModel.currentIndexPath) ? "\(getImageName(from: array[self.objNewWorkSpaceBaseViewModel.currentIndexPath].imageURL) ?? FormatsString.emptyString)" : FormatsString.emptyString
        self.objNewWorkSpaceBaseViewModel.imgg = imagVw
        self.objNewWorkSpaceBaseViewModel.tappedImgVw = imagVw
        self.objNewWorkSpaceBaseViewModel.tappedImgVw.image = imagVw.image?.withRenderingMode(.automatic)
        imagVw.layer.setValue("\(patternObj.imagePath)", forKey: "id")
        patternObj.image = patternObj.image?.withRenderingMode(.automatic)
        self.objNewWorkSpaceBaseViewModel.piecesDroppedArray.append(patternObj)
        self.objNewWorkSpaceBaseViewModel.patternPiecesArray.removeAll()
        self.objNewWorkSpaceBaseViewModel.patternPiecesArray.append(patternObj)
        let interaction = UIDragInteraction(delegate: self)
        interaction.isEnabled = true
        imagVw.addInteraction(interaction)
        imagVw.isUserInteractionEnabled = true
        imagVw.tag = self.objNewWorkSpaceBaseViewModel.tagValue
        self.workspaceAreaView.workAreaView.addSubview(imagVw)
        self.workspaceAreaView.workAreaView.clipsToBounds = true
        self.addRemoveSpliceButton(isShow: true)
        self.objNewWorkSpaceBaseViewModel.isSelectAll = false
        if self.workspaceAreaView.tapped {
            self.setSelectionForDroppedPatternPiece(gesture: imagVw)
            imagVw.addGestureRecognizer( self.objNewWorkSpaceBaseViewModel.longPressGesture)
        }
        self.objNewWorkSpaceBaseViewModel.totalImagesDropped = self.objNewWorkSpaceBaseViewModel.piecesDroppedArray.count
    }
    func setInitialFrameForSplicing(spliceDirection: String, workspaceFrame: CGRect, image: UIImage) -> CGPoint {  // setting initial frame for splice piece based on direction
        var point = CGPoint(x: 0, y: 0)
        if spliceDirection == SpliceDirectionType.horizontalSplicing.rawValue {
            self.objNewWorkSpaceBaseViewModel.yVal = (workspaceFrame.height/2) - (image.size.height/2)
            point = CGPoint(x: workspaceFrame.width - self.objNewWorkSpaceBaseViewModel.wdth, y: self.objNewWorkSpaceBaseViewModel.yVal)
        } else if spliceDirection == SpliceDirectionType.topToBottomSplicing.rawValue || spliceDirection == SpliceDirectionType.verticalSplicing.rawValue {
            self.objNewWorkSpaceBaseViewModel.xVal = (workspaceFrame.width/2) - (image.size.width/2)
            point = CGPoint(x: self.objNewWorkSpaceBaseViewModel.xVal, y: 0)
        }
        return point
    }
    @objc func sinleTapped(gestureRecognizer: UITapGestureRecognizer) {   // Single tap gesture on image view logic
        self.objNewWorkSpaceBaseViewModel.tappedImgVw.layer.borderWidth = 0
        self.objNewWorkSpaceBaseViewModel.tappedImgVw = gestureRecognizer.view! as! UIImageView
        self.objNewWorkSpaceBaseViewModel.tappedImgVw.image?.withRenderingMode(.alwaysTemplate)
        if gestureRecognizer.state == .recognized {
            self.checkPatternPiecForMirroringAndSplicing(image: self.objNewWorkSpaceBaseViewModel.tappedImgVw)
            self.setSelectionForDroppedPatternPiece(gesture: gestureRecognizer.view! as! UIImageView)
            self.workspaceAreaView.tapped = true
            for img in self.workspaceAreaView.workAreaView.subviews {
                if let imageView = img as? UIImageView {
                    for gesture in imageView.gestureRecognizers! {
                        if let recognizer = gesture as? UIPanGestureRecognizer {
                            recognizer.isEnabled = true
                        }
                    }
                }
            }
        }
    }
    func setSelectionForDroppedPatternPiece(gesture: UIImageView) {   // Set red color to selected pattern piece
        self.objNewWorkSpaceBaseViewModel.isSelectAll = false
        self.enableSelectAll()
        for view in self.workspaceAreaView.workAreaView.subviews {
            if let imageView1 = view as? UIImageView {
                imageView1.image?.withRenderingMode(.alwaysTemplate)
                if imageView1 == gesture {   // selected piece red color
                    CommonConst.userDefault.setValue("\(gesture.tag)", forKey: "piece\(self.objNewWorkSpaceBaseViewModel.selectedTabCategory)")
                    imageView1.image = imageView1.image?.withRenderingMode(.alwaysTemplate)
                    imageView1.tintColor = CustomColor.red
                    imageView1.isUserInteractionEnabled = true
                } else {   // normal piece black color
                    imageView1.image = imageView1.image?.withRenderingMode(.automatic)
                    imageView1.image?.withRenderingMode(.automatic)
                    imageView1.tintColor = UIColor.black
                    imageView1.layer.borderWidth = 0
                    imageView1.isUserInteractionEnabled = true
                }
            }
        }
    }
    func savePDF(path: URL) {   // Display pdf
        DispatchQueue.main.async {
            guard let pdfViewController = Constants.patternInstructions.instantiateViewController(withIdentifier: StoryBoardType.patternInstructions.rawValue) as? PatternInstructionsViewController else { return }
            pdfViewController.patternInstViewModel.fromSewingInstruction = false
            pdfViewController.patternInstViewModel.fromPatternDescription = true
            pdfViewController.patternInstViewModel.isPresentedFromWorkSpace = true
            pdfViewController.patternInstViewModel.fileURL = path
            pdfViewController.patternInstViewModel.mainURL = self.objNewWorkSpaceBaseViewModel.tailornoavInstructionURL
            pdfViewController.patternInstViewModel.titleLable = self.objNewWorkSpaceBaseViewModel.parentTitle!
            let navController = UINavigationController(rootViewController: pdfViewController)
            navController.modalPresentationStyle = .overFullScreen
            if self.presentedViewController == nil {
                self.navigationController?.present(navController, animated: false, completion: nil)
            }
        }
    }
    func handleAlertActionforPDF(action: UIAlertAction) {   // handling alert actions in failed PDF download
        let alerttitle = action.title
        if alerttitle == AlertTitle.retry {
            let fileName = "\(self.objNewWorkSpaceBaseViewModel.pattern!.patternTitle!).pdf"
            let documentsURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
            let finalPath = documentsURL.appendingPathComponent(fileName)
            self.savePDF(path: finalPath)
        } else {
        }
    }
    @objc func getBLEWIFIstatus() {   // Get BLE and WI-FI status and go to connectvity screen if on, else alert shown
        if self.presentedViewController == nil {
            DispatchQueue.main.async {
                self.showLottie()
            }
            DispatchQueue.global(qos: .background).async {
                if !self.objNewWorkSpaceBaseViewModel.socketConnected() {
                    if CommonConst.bleCheckValue {
                        if KAppDelegate.isWifiOn {
                            DispatchQueue.main.async {
                                self.dismissLottie()
                                self.dismiss(animated: false) {
                                    self.goToConectivityScreen()
                                }
                            }
                        } else {
                            DispatchQueue.main.async {
                                self.dismissLottie()
                                self.dismiss(animated: false) {
                                    self.showNeedWiFiAlert()
                                }
                            }
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.dismissLottie()
                            self.dismiss(animated: false) {
                                self.showNeedWiFiAlert()
                            }
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        self.dismissLottie()
                    }
                }
            }
        }
    }
    @objc func touchDetect(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    @objc func getBLEStatus() -> Bool {   // get BLE status
        return CommonConst.bleCheckValue
    }
    func updateSegmentSelectionForPatternPieceAndReference(sender: UIButton) {   // Switching pattern piece and refernce layout logic
        defer {
            for item in 0..<self.buttonPatternPieceReferenceLayout.count {
                if sender == self.buttonPatternPieceReferenceLayout[item] {
                    sender.isSelected = true
                } else {
                    self.buttonPatternPieceReferenceLayout[item].isSelected = false
                }
            }
            self.patternPiecesButton.titleLabel?.font = (sender.tag == 1) ? CustomFont.avenirLtProDemi(size: UIDevice.isPhone ? 12 : 18) :  CustomFont.avenirLtProRegular(size: UIDevice.isPhone ? 12 : 18)
            self.referenceLayoutButton.titleLabel?.font = (sender.tag == 1) ?  CustomFont.avenirLtProRegular(size: UIDevice.isPhone ? 12 : 18) : CustomFont.avenirLtProDemi(size: UIDevice.isPhone ? 12 : 18)
            self.patternsView.isHidden = (sender.tag == 1) ? false : true
            self.workspaceSpliceReferenceView.isHidden = (sender.tag == 1) ? true : false
            self.patternPiecesButton.isSelected = (sender.tag == 1) ? true : false
            self.referenceLayoutButton.isSelected = (sender.tag == 1) ? false : true
            self.constraintVWSelectedLeading.constant = (sender.tag == 1) ? 0 : self.buttonPatternPieceReferenceLayout[0].frame.width
        }
        DispatchQueue.main.async {
            self.referenceLayoutButton.isHidden = false
            self.referenceLayoutButton.setTitle(FormatsString.referenceLayoutLabel, for: .normal)
            if self.objNewWorkSpaceBaseViewModel.isSplicePiecePresent {
                self.workspaceSpliceReferenceView.enableSplice()
                self.workspaceSpliceReferenceView.referenceImageView.image =  self.workspaceSpliceReferenceView.spliceImage
            }
            self.updateRefLayoutViewForFabric(fabricSelected: self.objNewWorkSpaceBaseViewModel.selected, isSplice: self.objNewWorkSpaceBaseViewModel.isSplicePiecePresent)
            self.viewSelected.animateToSenderPostion(sender: sender)
            if sender == self.buttonPatternPieceReferenceLayout[0] {
                let selvageArr = self.objNewWorkSpaceBaseViewModel.getSelvagesBasedOnTab(tabType: self.objNewWorkSpaceBaseViewModel.selectedTabCategory)
                if selvageArr.isEmpty && !self.objNewWorkSpaceBaseViewModel.isSplicePiecePresent {
                    self.referenceLayoutButton.isHidden = true
                }
            }
        }
    }
    func removeSinglePieceFromWorkspace() {   // Removing single piece from WS on clear tap
        if let imageView = self.objNewWorkSpaceBaseViewModel.tappedImgVw as UIImageView? {
            let patternObj = self.objNewWorkSpaceBaseViewModel.piecesDroppedArray.filter {($0.tagValue == imageView.tag)}
            if !patternObj.isEmpty {
                if let intex1 = self.objNewWorkSpaceBaseViewModel.piecesDroppedArray.firstIndex(of: patternObj.first!) {
                    if !self.objNewWorkSpaceBaseViewModel.piecesDroppedArray.isEmpty, self.objNewWorkSpaceBaseViewModel.piecesDroppedArray.indices.contains(intex1) {
                        self.objNewWorkSpaceBaseViewModel.piecesDroppedArray.remove(at: intex1)
                    }
                    if !self.objNewWorkSpaceBaseViewModel.patternPiecesArray.isEmpty, self.objNewWorkSpaceBaseViewModel.patternPiecesArray.indices.contains(intex1) {
                        self.objNewWorkSpaceBaseViewModel.patternPiecesArray.remove(at: intex1)
                    }
                    imageView.removeFromSuperview()
                }
            }
            if self.objNewWorkSpaceBaseViewModel.isSpliceImageAddedToWorkspace {   // If piece is spliced piece
                if !self.objNewWorkSpaceBaseViewModel.piecesDroppedArray.isEmpty, self.objNewWorkSpaceBaseViewModel.piecesDroppedArray.indices.contains(0) {
                    self.objNewWorkSpaceBaseViewModel.piecesDroppedArray.remove(at: 0)
                }
                if !self.objNewWorkSpaceBaseViewModel.patternPiecesArray.isEmpty, self.objNewWorkSpaceBaseViewModel.patternPiecesArray.indices.contains(0) {
                    self.objNewWorkSpaceBaseViewModel.patternPiecesArray.remove(at: 0)
                }
                if !self.objNewWorkSpaceBaseViewModel.patternPiecesArray.isEmpty {
                    self.objNewWorkSpaceBaseViewModel.patternPiecesArray.removeAll()
                }
                if !self.objNewWorkSpaceBaseViewModel.piecesDroppedArray.isEmpty {
                    self.objNewWorkSpaceBaseViewModel.piecesDroppedArray.removeAll()
                }
                imageView.removeFromSuperview()
            }
        }
    }
    func removeAllPiecesFromWorkspace() {   // Removing all piece from WS on clear tap
        if let subvs = self.workspaceAreaView.workAreaView.subviews as? [UIImageView] {
            for sbvw in subvs {
                let patternObj =  self.objNewWorkSpaceBaseViewModel.piecesDroppedArray.filter {($0.tagValue == sbvw.tag)}
                if !patternObj.isEmpty {
                    if let intex1 = self.objNewWorkSpaceBaseViewModel.piecesDroppedArray.firstIndex(of: patternObj.first!) {
                        if !self.objNewWorkSpaceBaseViewModel.piecesDroppedArray.isEmpty, self.objNewWorkSpaceBaseViewModel.piecesDroppedArray.indices.contains(intex1) {
                            self.objNewWorkSpaceBaseViewModel.piecesDroppedArray.remove(at: intex1)
                        }
                        if !self.objNewWorkSpaceBaseViewModel.patternPiecesArray.isEmpty, self.objNewWorkSpaceBaseViewModel.patternPiecesArray.indices.contains(intex1) {
                            self.objNewWorkSpaceBaseViewModel.patternPiecesArray.remove(at: intex1)
                        }
                        sbvw.removeFromSuperview()
                    }
                }
            }
        }
        if !self.objNewWorkSpaceBaseViewModel.patternPiecesArray.isEmpty {
            self.objNewWorkSpaceBaseViewModel.patternPiecesArray.removeAll()
        }
        if !self.objNewWorkSpaceBaseViewModel.piecesDroppedArray.isEmpty {
            self.objNewWorkSpaceBaseViewModel.piecesDroppedArray.removeAll()
        }
        self.objNewWorkSpaceBaseViewModel.tagValue = 1
    }
    //MARK: UI COMPONENT ACTIONS
    @IBAction func patternSegmentControlAction(_ sender: UISegmentedControl) {   // Pattern segment tap action
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0 ) {
            self.delegate?.segmentDidPress()
        }
    }
    @IBAction func closeThumbnailBtnClicked(_ sender: Any) {   // Closing animation action
        self.moveThumbnail(view: self.thumbnailView)
    }
    @IBAction func playVideoBtnClicked(_ sender: Any) {   // Play animation video action
        self.movetoVideoVC()
    }
    @IBAction func actionChangeState(_ sender: UIButton) {   // Switching pattern piece and refernce layout action
        self.updateSegmentSelectionForPatternPieceAndReference(sender: sender)
    }
    @IBAction func exitButtonClicked(_ sender: UIButton) {
        DispatchQueue.main.async {
            self.objNewWorkSpaceBaseViewModel.sendImage(imageString: ImageNames.wsLaunchImage, hostData: ProjectorDetails.Host, portData: ProjectorDetails.port)
        }
        self.objNewWorkSpaceBaseViewModel.hideTabNavController(uiViewController: self, hideTabBar: false, hideNav: false)
        self.navigationController?.popToRootViewController(animated: true)
    }
    @IBAction func sendPatternToProjector(_ sender: Any) {   // Send to Projector button tap action
        self.sendToProjector()
    }
    @IBAction func exitButtonTapped(_ sender: Any) {   // WS exit button tap action
        if let manager = NetworkReachabilityManager(), !manager.isReachable {
            Proxy.shared.showLottie()
            self.saveWSandExit()
        } else {
            self.splashObj.splashViewModel.getBMToken(showloader: true) { status, _ in
                Proxy.shared.showLottie()
                if status {
                    self.saveWSandExit()
                } else {
                    self.exitFromWorkspaceWithoutSavingAlert(responseError: AlertMessage.unableToSaveText)
                }
            }
        }
    }
    func saveWSandExit() {   // WS exit button tap action
        CommonConst.userDefault.setValue(nil, forKey: "piece\(WorkAreaTabCategory.garment.categoryName)")
        CommonConst.userDefault.setValue(nil, forKey: "piece\(WorkAreaTabCategory.lining.categoryName)")
        CommonConst.userDefault.setValue(nil, forKey: "piece\(WorkAreaTabCategory.interfacing.categoryName)")
        CommonConst.userDefault.setValue(nil, forKey: "piece\(WorkAreaTabCategory.other.categoryName)")
        CommonConst.userDefault.setValue(nil, forKey: "reference\(WorkAreaTabCategory.garment.categoryName)")
        CommonConst.userDefault.setValue(nil, forKey: "reference\(WorkAreaTabCategory.lining.categoryName)")
        CommonConst.userDefault.setValue(nil, forKey: "reference\(WorkAreaTabCategory.interfacing.categoryName)")
        CommonConst.userDefault.setValue(nil, forKey: "reference\(WorkAreaTabCategory.other.categoryName)")
        KAppDelegate.isFromUniversalLinking = false
        DispatchQueue.main.async {
            self.objNewWorkSpaceBaseViewModel.sendImage(imageString: ImageNames.wsLaunchImage, hostData: ProjectorDetails.Host, portData: ProjectorDetails.port)
        }
        if CommonConst.guestUserCheck {   // WS exit for guest user
            self.exitFromWorkspaceWithoutSavingAlert(responseError: AlertMessage.guestSaveDisableText)
        } else {
            if let manager = NetworkReachabilityManager(), !manager.isReachable {   // WS exit for regular user without network
                self.exitFromWorkspaceWithoutSavingAlert(responseError: AlertMessage.noConnectionDescription)
            } else {
                self.saveLocalWS()
                var purchaseId = FormatsString.emptyString
                purchaseId = self.objNewWorkSpaceBaseViewModel.tailornovamannequinIDArray.isEmpty ? self.objNewWorkSpaceBaseViewModel.purchasedSizeId : self.objNewWorkSpaceBaseViewModel.tailornovamannequinIDArray[0].mannequinID
                if self.objNewWorkSpaceBaseViewModel.objGetWSMainPostModel.tailornaovaDesignId == FormatsString.emptyString {   // tailornovaDesignId is empty, i.e.,Create API call
                    self.setupPostUpdateParam {
                        let ppp = self.objNewWorkSpaceBaseViewModel.objWSMainPostModel
                        let json = JSONSerializer.toJson(ppp)
                        let paramNew = [FormatsString.wsSavejsonValueLabel: json  ] as [String: AnyObject]
                        print("The WS API Params -> \(paramNew)")
                        self.objNewWorkSpaceBaseViewModel.createCoWorkSpace(tailrnovaDesignId: self.objNewWorkSpaceBaseViewModel.tailornovaPatternDesignId, purchaseDesignId: purchaseId, postParam: paramNew) { errorParsingObject, errorMessage in
                            if errorParsingObject {
                                defer {
                                    DispatchQueue.main.async {
                                        self.objNewWorkSpaceBaseViewModel.sendImage(imageString: ImageNames.wsLaunchImage, hostData: ProjectorDetails.Host, portData: ProjectorDetails.port)
                                    }
                                    KAppDelegate.reloadMyLirary = true
                                    self.navigationController?.popToRootViewController(animated: true)
                                }
                                self.saveLocalWS()
                                self.savePatternsMetaDataToDB { }
                            } else {
                                self.exitFromWorkspaceWithoutSavingAlert(responseError: errorMessage)
                            }
                        }
                    }
                } else {
                    self.setupPostUpdateParam {
                        let ppp = self.objNewWorkSpaceBaseViewModel.objWSMainPostModel
                        let json = JSONSerializer.toJson(ppp)
                        let param = [FormatsString.wsSavejsonValueLabel: json  ] as [String: AnyObject]
                        print("The WS API Params -> \(param)")
                        if self.objNewWorkSpaceBaseViewModel.hitCreateOrPatchApi == WSSaveApi.create {   // First time save, Create API call
                            self.objNewWorkSpaceBaseViewModel.createCoWorkSpace(tailrnovaDesignId: self.objNewWorkSpaceBaseViewModel.tailornovaPatternDesignId, purchaseDesignId: purchaseId, postParam: param) { errorParsingObject, errorMessage in
                                if errorParsingObject {
                                    self.saveLocalWS()
                                    self.savePatternsMetaDataToDB { }
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        KAppDelegate.reloadMyLirary = true
                                        self.navigationController?.popToRootViewController(animated: true)
                                    }
                                } else {
                                    self.exitFromWorkspaceWithoutSavingAlert(responseError: errorMessage)
                                }
                            }
                        } else {   // Update API call
                            self.objNewWorkSpaceBaseViewModel.updateCoWorkSpace(tailrnovaDesignId: self.objNewWorkSpaceBaseViewModel.tailornovaPatternDesignId, purchaseDesignId: purchaseId, postParam: param) { errorParsingObject, errorMessage in
                                if errorParsingObject {
                                    self.saveLocalWS()
                                    self.savePatternsMetaDataToDB { }
                                    KAppDelegate.reloadMyLirary = true
                                    self.navigationController?.popToRootViewController(animated: true)
                                } else {
                                    self.exitFromWorkspaceWithoutSavingAlert(responseError: errorMessage)
                                }
                            }
                        }
                    }
                }
            }
        }
        Proxy.shared.dismissLottie()
    }
    @objc func patternViewReset(_ sender: UIButton) {   // Resetting the check box tick values. Reset icon tap action
        if self.objNewWorkSpaceBaseViewModel.selectedTabCategory == WorkAreaTabCategory.garment.categoryName {
            self.objNewWorkSpaceBaseViewModel.arrSelectedIndexGarment = []
        } else if self.objNewWorkSpaceBaseViewModel.selectedTabCategory == WorkAreaTabCategory.lining.categoryName {
            self.objNewWorkSpaceBaseViewModel.arrSelectedIndexLinings = []
        } else if self.objNewWorkSpaceBaseViewModel.selectedTabCategory == WorkAreaTabCategory.interfacing.categoryName {
            self.objNewWorkSpaceBaseViewModel.arrSelectedIndexInterfacing = []
        } else if self.objNewWorkSpaceBaseViewModel.selectedTabCategory == WorkAreaTabCategory.other.categoryName {
            self.objNewWorkSpaceBaseViewModel.arrSelectedIndexOthers = []
        }
        self.patternsView.labelSelectedCutCount.text = FormatsString.zeroLabel
        self.patternsView.patternCollectionView?.reloadData()
    }
    @objc func selectAllFirst(_ sender: UIButton) {   // Select all button tap action
        self.objNewWorkSpaceBaseViewModel.rotate.isEnabled = false
        self.objNewWorkSpaceBaseViewModel.disableRotateDropDown(view: self.workspaceAreaView)
        self.objNewWorkSpaceBaseViewModel.selectAllDragItemIncrementalCOunt = 0
        self.objNewWorkSpaceBaseViewModel.selectAllTotalCutPieces = 0
        self.objNewWorkSpaceBaseViewModel.disableClearing(view: self.workspaceAreaView)
        if !self.objNewWorkSpaceBaseViewModel.piecesDroppedArray.isEmpty {
            if !self.objNewWorkSpaceBaseViewModel.isSelectAll {   // Select All logic
                self.objNewWorkSpaceBaseViewModel.isSelectAll = true
                self.objNewWorkSpaceBaseViewModel.enableClearing(view: self.workspaceAreaView)
                self.updateSelectAllButtonImages()
                CommonConst.userDefault.setValue(FormatsString.selectAllLabel, forKey: "piece\(self.objNewWorkSpaceBaseViewModel.selectedTabCategory)")
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
            } else {   // Deselect all logic
                self.objNewWorkSpaceBaseViewModel.isSelectAll = false
                self.updateSelectAllButtonImages()
                CommonConst.userDefault.setValue(nil, forKey: "piece\(self.objNewWorkSpaceBaseViewModel.selectedTabCategory)")
                for imgVw in self.workspaceAreaView.workAreaView.subviews {
                    if let imageView = imgVw as? UIImageView {
                        if self.objNewWorkSpaceBaseViewModel.isSpliceImageAddedToWorkspace {
                            imageView.image = imageView.image!.withRenderingMode(.automatic)
                        } else {
                            imageView.tintColor = UIColor.black
                        }
                        self.setSingleTap(imgVw: imageView)
                    }
                }
            }
        }
        self.objNewWorkSpaceBaseViewModel.disableMirroring(view: self.workspaceAreaView)
        self.enableSelectAll()
    }
    @objc func clearFunction(_ sender: UIButton) {  // Clear button tap action
        self.objNewWorkSpaceBaseViewModel.rotate.isEnabled = false
        self.objNewWorkSpaceBaseViewModel.disableRotateDropDown(view: self.workspaceAreaView)
        if self.objNewWorkSpaceBaseViewModel.isSelectAll {   // Clear all tapped after select all is tapped
            self.removeAllPiecesFromWorkspace()
            self.objNewWorkSpaceBaseViewModel.isSelectAll = false
        } else {
            self.removeSinglePieceFromWorkspace()
        }
        if self.objNewWorkSpaceBaseViewModel.isSpliceImageAddedToWorkspace {   // Clear for splice piece
            self.workspaceAreaView.splicedScreenLabel.isHidden = true
            self.addRemoveSpliceButton(isShow: false)
        }
        self.objNewWorkSpaceBaseViewModel.isSpliceImageAddedToWorkspace = false
        self.objNewWorkSpaceBaseViewModel.disableMirroring(view: self.workspaceAreaView)
        self.enableSelectAll()
        self.objNewWorkSpaceBaseViewModel.disableClearing(view: self.workspaceAreaView)
        if !NewWorkSpaceBaseViewModel.zoomLabelShown && !self.workspaceAreaView.workAreaView.subviews.isEmpty {  // Display zoompop up for one time
            self.workspaceAreaView.doubleTapToZoomLabel.isHidden = false
            self.workspaceAreaView.doubleTapToZoomLabel.text = FormatsString.zoomLabel
            self.workspaceAreaView.doubleTapToZoomLabel.textColor = .black
        } else {
            self.workspaceAreaView.doubleTapToZoomLabel.isHidden = true
        }
        self.workspaceAreaView.borderImageTop.tintColor = UIColor.black
        self.workspaceAreaView.borderImageBottom.tintColor = UIColor.black
        self.workspaceAreaView.borderImageLeft.tintColor = UIColor.black
        self.workspaceAreaView.borderImageRight.tintColor = UIColor.black
        self.workspaceAreaView.spliceRightAnimation.isHidden = true
        self.workspaceAreaView.spliceTopAnimation.isHidden = true
        self.workspaceAreaView.spliceButtomAnimation.isHidden = true
        self.workspaceAreaView.spliceLeftAnimation.isHidden = true
        self.workspaceAreaView.spliceButtomButton.isHidden = true
        self.workspaceAreaView.spliceTopButton.isHidden = true
        self.workspaceAreaView.spliceRightButton.isHidden = true
        self.workspaceAreaView.spliceLeftButton.isHidden = true
        self.workspaceAreaView.currentImageRowValue = 0
        self.workspaceAreaView.currentImageColumnValue = 0
        self.workspaceSpliceReferenceView.isSpliceEnabled = false
        self.workspaceSpliceReferenceView.disableSpliceButton()
        self.objNewWorkSpaceBaseViewModel.isSplicePiecePresent = false
        self.updateRefLayoutViewForFabric(fabricSelected: self.objNewWorkSpaceBaseViewModel.selected, isSplice: false)
        if !buttonPatternPieceReferenceLayout.isEmpty {
            self.updateSegmentSelectionForPatternPieceAndReference(sender: self.buttonPatternPieceReferenceLayout[0] )
        }
        CommonConst.userDefault.setValue(nil, forKey: "piece\(self.objNewWorkSpaceBaseViewModel.selectedTabCategory)")
    }
    @objc func recalibrateConnectButtonAction() {  // Connect button tap action
        self.saveLocalWS()
        if self.objNewWorkSpaceBaseViewModel.calibrateConnect == FormatsString.calibrateWSLabel {  // Connect button
            KAppDelegate.bluetoothStatus()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                NotificationCenter.default.addObserver(self, selector: #selector(self.getBLEStatus), name: NSNotification.Name(rawValue: FormatsString.bluetoothLabel), object: nil)
                NotificationCenter.default.addObserver(self, selector: #selector(self.getBLEWIFIstatus), name: NSNotification.Name(rawValue: FormatsString.bluetoothLabel), object: nil)
                if CommonConst.bleCheckValue {
                    self.dismiss(animated: false, completion: nil)
                    if KAppDelegate.isWifiOn {
                        self.goToConectivityScreen()
                    } else {
                        self.showNeedWiFiAlert()
                    }
                } else {
                    self.showNeedBLEAlert()
                }
            }
        } else if self.objNewWorkSpaceBaseViewModel.calibrateConnect == FormatsString.recalibrateWSLabel {   // Calibrate button
            self.objNewWorkSpaceBaseViewModel.isRecalibrateButtonClicked = true
            self.workspaceAreaView.buttonIpadConnectRecalibrate.isUserInteractionEnabled = false
            self.workspaceAreaView.connectButton.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                let image = UIImage(named: ImageNames.connectedRotatedImage)
                self.objNewWorkSpaceBaseViewModel.sendImage(img: image!)
                let viewc = Constants.callibrationStoryBoard.instantiateViewController(identifier: Constants.LaunchCameraAlertViewControllerIdentifier) as LaunchCameraAlertViewController
                viewc.modalPresentationStyle = .overFullScreen
                viewc.cameraLaunchPopupDelegate = self
                self.present(viewc, animated: true)
                self.workspaceAreaView.buttonIpadConnectRecalibrate.isUserInteractionEnabled = true
                self.workspaceAreaView.connectButton.isUserInteractionEnabled = true
            }
        }
    }
    @objc func tutorialClicked(_ sender: UIButton) {   // tutorial button tap action
        CommonConst.navCheckValue = 1
        DispatchQueue.main.async {
            guard let myVC = Constants.storyBoardCategory.instantiateViewController(withIdentifier: StoryBoardIdentifiers.getStartedd.rawValue) as? GetStartedViewController else { return }
            myVC.objGetStartedViewModel.isFromWorkspace = true
            myVC.objGetStartedViewModel.isPresentedFromWorkSpace = true
            let navController = UINavigationController(rootViewController: myVC)
            navController.modalPresentationStyle = .overFullScreen
            if self.presentedViewController == nil {
                self.navigationController?.present(navController, animated: true, completion: nil)
            }
        }
    }
    @objc func sewingInstructionClicked(_ sender: UIButton) {  // Sewing Instruction tap action
        let url = self.objNewWorkSpaceBaseViewModel.tailornoavInstructionURL
        let fileName = "\(self.objNewWorkSpaceBaseViewModel.parentTitle!).pdf"
        let documentsURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
        let finalPath = documentsURL.appendingPathComponent(fileName)
        if !FileManager.default.fileExists(atPath: finalPath.path) {
            if let manager = NetworkReachabilityManager(), manager.isReachable {
                if url != FormatsString.emptyString && !url.isEmpty {
                    self.savePdf(urlString: url, fileName: fileName) { (status) in
                        if status {
                            self.savePDF(path: finalPath)
                        } else {
                            self.displayErrorPopUp()
                        }
                    }
                } else {
                    ServiceManagerProxy.shared.displayerrorPopup(url: url, responseError: AlertMessage.pdfUnavailableText)
                }
            } else {
                ServiceManagerProxy.shared.displayerrorPopup(url: url, responseError: AlertMessage.noConnectionDescription)
            }
        } else {
            DispatchQueue.main.async {
                guard let pdfViewController = Constants.patternInstructions.instantiateViewController(withIdentifier: StoryBoardType.patternInstructions.rawValue) as? PatternInstructionsViewController else { return }
                pdfViewController.patternInstViewModel.fromSewingInstruction = false
                pdfViewController.patternInstViewModel.fromPatternDescription = true
                pdfViewController.patternInstViewModel.isPresentedFromWorkSpace = true
                pdfViewController.patternInstViewModel.fileURL = finalPath
                pdfViewController.patternInstViewModel.mainURL = self.objNewWorkSpaceBaseViewModel.tailornoavInstructionURL
                pdfViewController.patternInstViewModel.titleLable = self.objNewWorkSpaceBaseViewModel.parentTitle!
                let navController = UINavigationController(rootViewController: pdfViewController)
                navController.modalPresentationStyle = .overFullScreen
                if self.presentedViewController == nil {
                    self.navigationController?.present(navController, animated: true, completion: nil)
                }
            }
        }
    }
    func goToCallibrateCameraView(screenType: String ) {  // goto to camera view on launch camera popup continue tap
        DispatchQueue.main.async {
            self.objNewWorkSpaceBaseViewModel.sendCalibPattern()
            if let categoryViewController = Constants.callibrationStoryBoard.instantiateViewController(withIdentifier: Constants.cameraNavIdentifier) as? UINavigationController, !categoryViewController.viewControllers.isEmpty {
                if let cameraController = categoryViewController.viewControllers[0] as? CallibrationCameraViewController {
                    cameraController.calScreenType = ScreenTypeString.workSpaceScreen
                    cameraController.host = self.objNewWorkSpaceBaseViewModel.host
                    cameraController.port = self.objNewWorkSpaceBaseViewModel.port
                    cameraController.goToWorkspaceFromCalibrationDelegate = self
                }
                if self.presentedViewController == nil {
                    self.navigationController?.present(categoryViewController, animated: true, completion: nil)
                }
            }
        }
    }
}
