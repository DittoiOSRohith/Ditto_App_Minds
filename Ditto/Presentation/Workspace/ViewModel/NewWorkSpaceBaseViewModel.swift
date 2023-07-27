//
//  NewWorkSpaceBaseViewModel.swift
//  Ditto
//
//  Created by Gaurav.rajan on 08/07/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit
import FastSocket
import CoreData
import Alamofire
import Lottie

class NewWorkSpaceBaseViewModel {
    //MARK: VARIABLE DECLARATION
    static var zoomLabelShown = false
    var objWSMainPostModel = WSMainPostModel()
    var tailornovaModelObject = PatternModelObject()
    var checkForTrailPattern = false
    var arrSelectedIndexGarment = [Int]()
    var arrSelectedIndexLinings = [Int]()
    var arrSelectedIndexInterfacing = [Int]()
    var arrSelectedIndexOthers = [Int]()
    var tailornoavInstructionURL = FormatsString.emptyString
    var radians: Double = 0
    var spliceConstant = FormatsString.emptyString
    var panGesture = UIPanGestureRecognizer()
    var longPressGesture = UITapGestureRecognizer()
    var rotationGesture = UIRotationGestureRecognizer()
    var tapGr = UITapGestureRecognizer()
    var newView = UIImageView()
    var isOverlappingFeatureOn = false
    var isRecalibrateButtonClicked = false
    var isSplicePiecePresent = false
    var initialAngle = 0.0
    var currentDragPatternPieceObj: PatternPieceDetails = PatternPieceDetails()
    var piecesDroppedArray: [PatternPieces] = [PatternPieces]()
    var cutBinDroppedArray: [PatternPieces] = [PatternPieces]()
    var patternPiecesArray = [PatternPieces]()
    var patternsArray = [PatternPieceDetails]()
    var selvagesArray = [Selvages]()
    var parentTitle: String!
    var notes = String()
    var currentIndexPath: Int = 0
    var lastSelectedIndexPath: Int! = 0
    var currentSelectedPatternIndex: Int = 0
    var selectedTabCategory: String = FormatsString.emptyString
    var previousSelectedTabCategory: String = FormatsString.emptyString
    var imagesArray = [UIImage]()
    var selected = FormatsString.emptyString
    var tappedImgVw = UIImageView()
    var totalImagesDropped = 0
    var totalCutPieces = 0
    var selectAllTotalCutPieces = 0
    var first = 1
    var second = 2
    var xVal = CGFloat()
    var yVal = CGFloat()
    var width = CGFloat()
    var height = CGFloat()
    let popup = UIView()
    let popupBackground = UIView()
    var rotate = UIRotationGestureRecognizer()
    var selctd = UIImage()
    var isSpliceImageAddedToWorkspace: Bool = false
    var imagvPopUp = UIImageView()
    var isRotated: Bool = false
    var degree: CGFloat = 0
    var isMirrorH: Bool = false
    var scaleFacctor = CGFloat()
    var hite = CGFloat()
    var size = CGSize()
    var wdth = CGFloat()
    var prevdegree: CGFloat = 0
    var isSelectAll = false
    var selectAllDragItemIncrementalCOunt = 0
    var tagValue: NSInteger = 1
    var host = String()
    var port = Int32()
    var imgg = UIImageView()
    var imagePathArray = [String]()
    var pattern: Pattern?
    var workSpace: Workspace?
    var titleLabel = UILabel()
    var screenType = Constants.fromAllPatterns
    var isProjecting: Bool = false
    var screenHeight = UIScreen.main.bounds.height
    var calibrateConnect: String = FormatsString.calibrateWSLabel
    var originalSplicePosition: CGRect = .zero
    var currentSpliceIndex: Int = 0
    var currentSpliceDirection: String = FormatsString.emptyString
    var isYes: Bool = false
    var calibImg = UIImage()
    var spliceDone: Bool = false
    var isMirrorAlertShown: Bool = true
    var isCutNumberAlertShown: Bool = true
    var isMultiplePieceSpliceAlertShown: Bool = true
    var isSpliceAlertShown: Bool = true
    var selectedIndexPath = IndexPath()
    var isCellSelected = false
    var tailornovaPatternArray = [PatternPieceModelObject]()
    var tailornovaSelvagesArray = [SelvagesModelObject]()
    var patternType = FormatsString.Trial
    var tailornovamannequinIDArray = [MannequinIDObject]()
    var purchasedSizeId = FormatsString.emptyString
    var tailornovaOrderNo = FormatsString.emptyString
    var subscriptionExpiryDate = FormatsString.emptyString
    var tailornovaDesignName = FormatsString.emptyString
    var patternsize = FormatsString.emptyString
    var patternstatus = FormatsString.emptyString
    var tailornovaPatternDesignId = FormatsString.emptyString
    var patternDescription = FormatsString.emptyString
    var arrUserDefaultWSSaveModel = [UserDefaultWSSaveModel]()
    var objGetWSMainPostModel = WSMainPostModel()
    var hitCreateOrPatchApi = WSSaveApi.patch
    var dragLabelShown: Bool = false
    var lastangle = CGFloat(0)
    var haveAngle = CGFloat(0)
    var patternBrand = FormatsString.emptyString
    var calibScreenType = FromScreen.workspace
    var lastModifiedSizeDate = FormatsString.emptyString
    var customSizeFitName = FormatsString.emptyString
    var selectedSizeName = FormatsString.emptyString
    var selectedViewCupSizeName = FormatsString.emptyString
    var productId = FormatsString.emptyString
    var descriptionImageURL = FormatsString.emptyString
    var notionDetails = FormatsString.emptyString
    var yardageDetails = FormatsString.emptyString
    var yardagePdfUrl = FormatsString.emptyString
    var patternNameDirectory = FormatsString.emptyString
    var rotationList = [FormatsString.clockWiseLabel, FormatsString.antiCWLabel]
    let tableView = UITableView()
    var rotateSelected = false
    let transparentView = UIView()
    var rotationSelection = 0
    //  FUNCTION LOGICS
    func getTotalNoOfCutBinPiecesForSelectedPatternFromTailornova(pieces: [PatternPieceModelObject]) -> Int {  // tatoal number of cut pieces for selected pattern
        var cutBinCount = 0
        for pice in ((pieces as [AnyObject]?)!) {
            if let pattern = pice as? PatternPieceModelObject {
                let quantity = pattern.cutQuantity
                let newstring = quantity.filter { "0"..."9" ~= $0 }
                cutBinCount += Int(newstring)!
            }
        }
        return Int(cutBinCount)
    }
    func sendImage(imageString: String, hostData: String, portData: Int32) {   // send image to projector function
        self.isProjecting = true
        do {
            guard let client = FastSocket(host: hostData, andPort: String(portData)) else { return }
            if client.connect(3) {
                if let data = UIImage(named: "\(imageString)")?.pngData() {
                    _ = client.sendBytes(data.bytes, count: (data.count))
                    client.close()
                    self.isProjecting = false
                }
            }
        }
    }
    func sendCalibImage(img: UIImage, hostData: String, portData: Int32) {   // send calibration image
        self.isProjecting = true
        do {
            guard let client = FastSocket(host: hostData, andPort: String(portData)) else { return }
            if client.connect() {
                if let data =  img.pngData() {
                    _ = client.sendBytes(data.bytes, count: (data.count))
                    client.close()
                    self.isProjecting = false
                }
            }
        }
    }
    func hideTabNavController(uiViewController: UIViewController, hideTabBar: Bool, hideNav: Bool) {  // code to hide nav bar
        uiViewController.tabBarController?.tabBar.isHidden = hideTabBar
        uiViewController.navigationController?.navigationBar.isHidden = hideNav
    }
    func selectedTabForNewPattern() -> String {   // based on count of pattern piece in tab category, decide the selectedtabcategory
        let garmentArr = self.getPatternPiecesBasedOnTab(tabType: WorkAreaTabCategory.garment.categoryName)
        let liningArr = self.getPatternPiecesBasedOnTab(tabType: WorkAreaTabCategory.lining.categoryName)
        let interFacingArr = self.getPatternPiecesBasedOnTab(tabType: WorkAreaTabCategory.interfacing.categoryName)
        let otherArr = self.getPatternPiecesBasedOnTab(tabType: WorkAreaTabCategory.other.categoryName)
        if garmentArr.isEmpty {
            if liningArr.isEmpty {
                if interFacingArr.isEmpty {
                    if !otherArr.isEmpty {
                        return WorkAreaTabCategory.other.categoryName
                    }
                } else {
                    return WorkAreaTabCategory.interfacing.categoryName
                }
            } else {
                return WorkAreaTabCategory.lining.categoryName
            }
        } else {
            return WorkAreaTabCategory.garment.categoryName
        }
        return WorkAreaTabCategory.garment.categoryName
    }
    func getCoWorkspace(tailrnovaDesignId: String, purchaseDesignId: String, _ completion: @escaping() -> Void) {  // Get api call function, i.e., fetching saved pattern set
        let customerId = CommonConst.customerIDText
        self.tailornovaOrderNo = (self.patternType == FormatsString.Trial) ? (self.tailornovaOrderNo == FormatsString.emptyString ? FormatsString.trialOrderNoLabel : self.tailornovaOrderNo) : self.tailornovaOrderNo
        let finalString = "\(customerId)_\(self.tailornovaOrderNo)_\(tailrnovaDesignId)_\(purchaseDesignId)"
        ServiceManagerProxy.shared.getDataWS(urlStr: Apis.getCOWorkSpace + finalString + ApiUrlStrings.getWSUrl) { (response) in
            if let dictData = response?.data![FormatsString.wsSavejsonValueLabel] as? [String: AnyObject] {
                self.objGetWSMainPostModel.setData(dict: dictData)
                self.selectedTabCategory = (self.objGetWSMainPostModel.selectedTab != FormatsString.emptyString) ? self.objGetWSMainPostModel.selectedTab : self.selectedTabForNewPattern()
                self.hitCreateOrPatchApi = WSSaveApi.patch
                self.notes = self.objGetWSMainPostModel.notes
                self.dragLabelShown = true
            } else if (response?.data!["fault"] as? [String: AnyObject]) != nil {
                self.hitCreateOrPatchApi = WSSaveApi.create
                self.selectedTabCategory = self.selectedTabForNewPattern()
            }
            completion()
        }
    }
    func createCoWorkSpace(tailrnovaDesignId: String, purchaseDesignId: String, postParam: [String: AnyObject], _ completion: @escaping(_ error: Bool, _ message: String) -> Void) {   // Create api call function, i.e., creating a new patternn set
        let customerId = CommonConst.customerIDText
        self.tailornovaOrderNo = (self.patternType == FormatsString.Trial) ? (self.tailornovaOrderNo == FormatsString.emptyString ? FormatsString.trialOrderNoLabel : self.tailornovaOrderNo) : self.tailornovaOrderNo
        let finalString = "\(customerId)_\(self.tailornovaOrderNo)_\(tailrnovaDesignId)_\(purchaseDesignId)"
        ServiceManagerProxy.shared.putData(urlStr: Apis.createCOWorkSpace + finalString + ApiUrlStrings.createWSUrl, params: postParam) {(resp) in
            if resp!.success {
                completion(true, FormatsString.emptyString)
            } else {
                completion(false, resp?.message ?? FormatsString.emptyString)
            }
        }
    }
    func updateCoWorkSpace(tailrnovaDesignId: String, purchaseDesignId: String, postParam: [String: AnyObject], _ completion: @escaping(_ error: Bool, _ message: String) -> Void) {   // Update api call function, i.e., updating an existing pattern set
        let customerId = CommonConst.customerIDText
        self.tailornovaOrderNo = (self.patternType == FormatsString.Trial) ? (self.tailornovaOrderNo == FormatsString.emptyString ? FormatsString.trialOrderNoLabel : self.tailornovaOrderNo) : self.tailornovaOrderNo
        let finalString = "\(customerId)_\(self.tailornovaOrderNo)_\(tailrnovaDesignId)_\(purchaseDesignId)"
        ServiceManagerProxy.shared.patchData(urlStr: Apis.updateCOWorkSpace + finalString + ApiUrlStrings.updateWSUrl, params: postParam) {(resp) in
            if resp!.success {
                completion(true, FormatsString.emptyString)
            } else {
                completion(false, resp?.message ?? FormatsString.emptyString)
            }
        }
    }
    func loadPatternPiecesFor(tabCategory: String, completion: @escaping([PatternPieceModelObject]) -> Void) {   // loading pattern pieces in collection view
        self.patternsArray.removeAll()
        var pattern1Array = self.tailornovaPatternArray.filter { $0.tabCategory == "\(tabCategory)"}
        pattern1Array.sort {($0.positionInTab) < ($1.positionInTab)}
        self.imagesArray.removeAll()
        self.imagePathArray.removeAll()
        completion(pattern1Array)
    }
    func movePatternPieceToVisibleArea(workAreaView: UIView, tag: Int) {  // Move patternPiece to visible region in WS
        let each = workAreaView.subviews.filter({$0.tag == tag})
        if !each.isEmpty {
            if each[0].frame.origin.x < 0 {
                each[0].frame.origin.x = 0
            }
            if each[0].frame.origin.y < 0 {
                each[0].frame.origin.y = 0
            }
            if  each[0].frame.minX < workAreaView.frame.minX {
                each[0].frame.origin.x = 0
            }
            if  each[0].frame.minY < workAreaView.frame.minY {
                each[0].frame.origin.y = 0
            }
            if each[0].frame.origin.y + each[0].frame.height > workAreaView.frame.height {
                each[0].frame.origin.y = workAreaView.frame.height - each[0].frame.height
            }
            if each[0].frame.origin.x + each[0].frame.width > workAreaView.frame.width {
                each[0].frame.origin.x = workAreaView.frame.width - each[0].frame.width
            }
        }
    }
    func remvoveFromDirectory( patternDesignId: String) {   // remove the patterns other than last worked pattern folder from directory
        let documentsURL = try! FileManager.default.url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        let folderURL = documentsURL.appendingPathComponent("Patterns").appendingPathComponent("\(patternDesignId)")
        do {
            let fileManager = FileManager.default
            if fileManager.fileExists(atPath: folderURL.path) {
                try fileManager.removeItem(atPath: folderURL.path)
            }
        } catch _ as NSError {
        }
    }
    // MARK: - CREATE IMAGE FROM CALAYER
    func imageFromLayer(layer: CALayer) -> UIImage {   // get the image of virtual ws
        UIGraphicsBeginImageContextWithOptions(layer.bounds.size, layer.isOpaque, 1.0)
        if let rendr = UIGraphicsGetCurrentContext() {
            layer.render(in: rendr)
        } else {
        }
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outputImage ?? UIImage()
    }
    func senduniversalImage() {   // send calibration image when ok tap for calibration popup
        let img = UIImage(named: ImageNames.calibrationpatternImage)
        self.sendCalibImage(img: img!, hostData: host, portData: port)
    }
    func sendCalibPattern() {   // send calibration image when goto camera view
        let img = UIImage(named: ImageNames.calibrationpatternImage)
        self.sendCalibImage(img: img!, hostData: host, portData: port)
    }
    func socketConnected() -> Bool {   // check connection of socket
        guard let socket = FastSocket(host: ProjectorDetails.Host, andPort: String(ProjectorDetails.port)) else { return false }
        return ProjectorDetails.isProjectorConnected && socket.connect()
    }
    func sendImage(img: UIImage) {  // sending image on connect button tap
        do {
            guard let client =  FastSocket(host: ProjectorDetails.Host, andPort: String(ProjectorDetails.port)) else { return }
            if client.connect() {
                if let data =  img.pngData() {
                    data.withUnsafeBytes { databytes in
                        let buffer: UnsafePointer<CChar> = databytes.baseAddress!.assumingMemoryBound(to: CChar.self)
                        _ = client.sendBytes(buffer, count: data.count)
                    }
                }
            } else {
            }
        }
    }
    func workSpaceSettingsForAlert() {    // TRAC_603_WS_Pro_Settings_Logic
        if !CommonConst.guestUserCheck {
            self.isMirrorAlertShown = CommonConst.mirrorReminderCheck
            self.isCutNumberAlertShown = CommonConst.cuttingReminderCheck
            self.isMultiplePieceSpliceAlertShown = CommonConst.spliceMultiplePieceReminderCheck
            self.isSpliceAlertShown = CommonConst.spliceReminderCheck
        }
    }
    func disableMirroring(view: WorkspaceAreaView) {   // disable mirror buttons in WS
        view.mirrorHipad.isEnabled = false
        view.mirrorVipad.isEnabled = false
        view.mirrorH.isEnabled = false
        view.mirrorV.isEnabled = false
        view.checkFlippedV = false
        view.checkFlippedH = false
    }
    func disableRotateDropDown(view: WorkspaceAreaView) {   // disable rotate dropdown in WS
        view.rotateDropDowniPhoneButton.isEnabled = false
        view.rotateDropDowniPadButton.isEnabled = false
        view.rotateDropDowniPhoneArrow.isEnabled = false
        view.rotateDropDowniPadArrow.isEnabled = false
        view.rotateDropDowniPhoneButton.setTitle(FormatsString.rotateLabel, for: .normal)
        view.rotateDropDowniPadButton.setTitle(FormatsString.rotateLabel, for: .normal)
    }
    func disableClearing(view: WorkspaceAreaView) {   // Disable clear button function
        view.clearButton.isEnabled = false
        view.clearButtoniPad.isEnabled = false
    }
    func enableClearing(view: WorkspaceAreaView) {   // Enable clear button function
        view.clearButton.isEnabled = true
        view.clearButtoniPad.isEnabled = true
    }
    // MARK: - Filter tailornova array based on tabs
    func getPatternPiecesBasedOnTab(tabType: String) -> [PatternPieceModelObject] {   // Get pattern pieces array based on tab category and sort it
        let pattern1Array = self.tailornovaPatternArray.filter {$0.tabCategory == "\(tabType)"}
        let sortedPattern1Array = pattern1Array.sorted(by: {Int($0.positionInTab)! < Int($1.positionInTab)!})
        return sortedPattern1Array
    }
    func getSelectedPatternPiecesBasedOnTab(selectedId: [Int], tabType: String) -> [PatternPieceModelObject] {   // Get selected pattern piece from array based on tab category and tailornova index
        var pattern1Array = self.tailornovaPatternArray.filter {$0.tabCategory == "\(tabType)" && selectedId.contains($0.tailornovaIndex)}
        pattern1Array = pattern1Array.sorted(by: {($0.positionInTab) < ($1.positionInTab)})
        return pattern1Array
    }
    func getSelvagesBasedOnTab(tabType: String) -> [SelvagesModelObject] {   // Get selvage array based on tab category
        let pattern1Array = self.tailornovaSelvagesArray.filter {$0.tabCategory == "\(tabType)"}
        return pattern1Array.sorted(by: {$0.id < $1.id})
    }
    func getDetailsOfCurrentSelectedPatternPiece(category: String) -> [PatternPieceModelObject] {   // Get pattern piece array based on tab category
        let patternArrayObject = self.getPatternPiecesBasedOnTab(tabType: category)
        return patternArrayObject
    }
}
