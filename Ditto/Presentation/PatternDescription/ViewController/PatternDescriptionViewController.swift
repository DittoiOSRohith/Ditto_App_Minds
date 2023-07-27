//
//  PatternDescriptionViewController.swift
//  JoannTraceApp
//
//  Created by Abiya Joy on 15/04/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit
import FastSocket
import FabricTraceTransformFrx
import Alamofire
import Lottie
import SDWebImage

class PatternDescriptionViewController: UIViewController {
    //MARK: UI COMPONENT OUTLETS
    @IBOutlet weak var expiredAlertView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var patternDescriptionImageView: UIImageView!
    @IBOutlet weak var patternStatusView: UIView!
    @IBOutlet weak var firstIconImage: UIImageView!
    @IBOutlet weak var firstIconLabel: UILabel!
    @IBOutlet weak var centerView: UIView!
    @IBOutlet weak var secondIconImage: UIImageView!
    @IBOutlet weak var secondIconLabel: UILabel!
    @IBOutlet weak var patternDescriptionLabel: UITextView!
    @IBOutlet weak var instructionsButton: UIButton!
    @IBOutlet weak var yardageButton: UIButton!
    @IBOutlet weak var changingSecondButton: UIButton!
    @IBOutlet weak var expiredAlertViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var changingSecondButtonWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var patternDescriptionImageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var customisationView: UIView!
    @IBOutlet weak var customisationButton: UIButton!
    @IBOutlet weak var customisationViewWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var customisationArrowButton: UIButton!
    @IBOutlet weak var patternSizeLabel: UILabel!
    @IBOutlet weak var sizeLabelWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var patternDesignNameLabel: UILabel!
    @IBOutlet weak var lotteMessage: UILabel!
    @IBOutlet weak var statusRedLabel: UILabel!
    @IBOutlet weak var selectSizeView: UIView!
    @IBOutlet weak var selectViewCupSizeView: UIView!
    @IBOutlet weak var selectSizeButton: UIButton!
    @IBOutlet weak var selectViewCupSizeButton: UIButton!
    @IBOutlet weak var selectSizeArrow: UIButton!
    @IBOutlet weak var selectViewCupSizeArrow: UIButton!
    @IBOutlet weak var modifiedDateLabel: UILabel!
    @IBOutlet weak var spacebwnNamendDropDown: NSLayoutConstraint!
    //MARK: VARIABLE DECLARATION
    var patternDesViewModel = PatternDescriptionViewModel()
    var tailornovaService  = TailornovaApiService()
    var isFromUniversalLink: Bool = false
    var patternType = String()
    //MARK: Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = self.patternDescriptionLabel.layoutManager   // iOS 16 crash fix
        self.configureNavTitle()
        self.registerSetUpNib()
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(image: UIImage(named: ImageNames.backBeamImage), style: UIBarButtonItem.Style.plain, target: self, action: #selector(self.backbuttontapperd(sender:)))
        self.navigationItem.leftBarButtonItem = newBackButton
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(customisationTapped(recognizer:)))
        tapGesture.numberOfTapsRequired = 1
        self.customisationArrowButton.addGestureRecognizer(tapGesture)
        CommonConst.userDefault.set(true, forKey: IsInPage.patternDesc.rawValue)
        if self.patternDesViewModel.patternBrand == FormatsString.dittoBrandLabel {
            self.sizeLabelWidthConstraint.constant = self.patternDesViewModel.customSizeFitName != FormatsString.emptyString ?( UIDevice.isPhone ? 170 : 220) : (110)
            self.modifiedDateLabel.isHidden = self.patternDesViewModel.lastModifiedSizeDate != FormatsString.emptyString ? false : true
        } else {
            self.patternSizeLabel.isHidden = true
            self.sizeLabelWidthConstraint.constant = 0
        }
        if !self.patternDesViewModel.isExpired && !self.patternDesViewModel.isPaused {
            if self.patternDesViewModel.patternBrand == FormatsString.dittoBrandLabel {
                self.hitTailorNovaAPI()
            } else {
                self.hitThirdPartyAPI()
            }
        }
        let sizetapGesture = UITapGestureRecognizer(target: self, action: #selector(sizeViewTapped(recognizer:)))
        sizetapGesture.numberOfTapsRequired = 1
        self.selectSizeArrow.addGestureRecognizer(sizetapGesture)
        let viewcuptapGesture = UITapGestureRecognizer(target: self, action: #selector(viewCupSizeViewTapped(recognizer:)))
        viewcuptapGesture.numberOfTapsRequired = 1
        self.selectViewCupSizeArrow.addGestureRecognizer(viewcuptapGesture)
        CommonConst.linkTailornovaIdText = self.patternDesViewModel.purchasedSizeId
        self.title = FormatsString.PatternDetail
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.changingSecondButton.setTitle(self.patternDesViewModel.changingButtonTitle, for: .normal)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.tabBarController?.tabBar.isHidden = false
    }
    override func viewDidAppear(_ animated: Bool) {
        self.patternDescriptionLabel.flashScrollIndicators()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.patternDescriptionLabel.sizeToFit()
        if !self.isFromUniversalLink {
            self.detailsSetUp()
        }
        self.customButtonHandling()
        self.view.layoutIfNeeded()
    }
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self)
        CommonConst.userDefault.set(false, forKey: IsInPage.patternDesc.rawValue)
    }
    func registerSetUpNib() {
        self.patternDesViewModel.tableView.delegate = self
        self.patternDesViewModel.tableView.dataSource = self
        self.patternDesViewModel.tableView.separatorStyle = .none
        self.patternDesViewModel.tableView.borderWidth = 1.0
        self.patternDesViewModel.tableView.borderColor = CustomColor.textFieldBorder
        self.patternDesViewModel.tableView.isScrollEnabled = true
        Proxy.shared.registerNib(self.patternDesViewModel.tableView, nibName: ReusableCellIdentifiers.customisedListCellIdentifier, identifierCell: ReusableCellIdentifiers.customListIdentifier)
    }
    func hitThirdPartyAPI() {   // Third Party API call.
        if let manager = NetworkReachabilityManager(), manager.isReachable {
            self.patternDesViewModel.getThirdPartyPatternData { thirdPartyObject, errorParsingObject, errorMessage in
                if !errorParsingObject {
                    self.patternDesViewModel.thirdPartyApiHit = true
                    self.patternDesViewModel.thirdPartyObject = thirdPartyObject.product!.brandVariantData!.variation
                    self.patternDesViewModel.viewCupSizeList.removeAll()
                    self.patternDesViewModel.viewCupSizeList.append(FormatsString.selectViewCupSize)
                    self.selectViewCupSizeButton.setTitle(FormatsString.selectViewCupSize, for: .normal)
                    for item in self.patternDesViewModel.thirdPartyObject {
                        self.patternDesViewModel.viewCupSizeList.append(item.style)
                    }
                    if self.patternDesViewModel.viewCupSizeList.count > 1 {
                        self.selectViewCupSizeView.isHidden = false
                        self.selectSizeView.isHidden = false
                        self.spacebwnNamendDropDown.constant = 5
                    } else {
                        self.tailornovaErrorPopUp(responseError: AlertMessage.datafetchFailAlert)
                    }
                } else {
                    // Error Parsing Objects
                    self.tailornovaErrorPopUp(responseError: errorMessage)
                    self.dismissLottie()
                }
            }
        } else {
            self.selectSizeView.isHidden = self.patternDesViewModel.selectedSizeName != FormatsString.emptyString ? false : true
            self.selectViewCupSizeView.isHidden = self.patternDesViewModel.selectedViewCupSizeName != FormatsString.emptyString ? false : true
            self.selectSizeButton.setTitle(self.patternDesViewModel.selectedSizeName, for: .normal)
            self.selectViewCupSizeButton.setTitle(self.patternDesViewModel.selectedViewCupSizeName, for: .normal)
            self.selectSizeArrow.isHidden = true
            self.selectViewCupSizeArrow.isHidden = true
        }
    }
    func hitTailorNovaAPI() {  // API call based on conditions
        if self.patternDesViewModel.patternType != FormatsString.Trial {
            if self.patternDesViewModel.tailornovamannequinIDArray.isEmpty {
                self.customisationView.isHidden = true
                self.customisationViewWidthConstraint.constant = 0
                self.patternDesViewModel.designIdToPass = self.patternDesViewModel.purchasedSizeId
                if let manager = NetworkReachabilityManager(), manager.isReachable {
                    if self.patternDesViewModel.designIdToPass != FormatsString.emptyString && self.patternDesViewModel.tailornovaDesignId != FormatsString.emptyString {
                        self.hitTailorNova(designId: self.patternDesViewModel.tailornovaDesignId, purchaseId: self.patternDesViewModel.designIdToPass)
                    } else {
                        if self.patternDesViewModel.tailornovaDesignId == FormatsString.trialmake1 {
                            self.hitTailorNova(designId: self.patternDesViewModel.tailornovaDesignId, purchaseId: self.patternDesViewModel.designIdToPass)
                        } else {
                            self.patternDesViewModel.tailornovaApiHit = false
                            self.unabletoFetchDesignIDErrorPopUp()
                        }
                    }
                } else {
                    self.patternDesViewModel.tailornovaApiHit = false
                    ServiceManagerProxy.shared.displayerrorPopup(url: FormatsString.emptyString, responseError: AlertMessage.noConnectionDescription)
                }
            } else {
                self.patternDesViewModel.tailornovaApiHit = false
                for each in self.patternDesViewModel.tailornovamannequinIDArray {
                    self.patternDesViewModel.customisedNameList.append(each.mannequinName)
                    self.patternDesViewModel.customisedIdList.append(each.mannequinID)
                }
                if !self.patternDesViewModel.customisedNameList.isEmpty {
                    self.customisationButton.setTitle(self.patternDesViewModel.customisedNameList[0], for: .normal)
                }
            }
        } else {
            self.customisationView.isHidden = true
            self.customisationViewWidthConstraint.constant = 0
        }
    }
    func hitTailorNova(designId: String, purchaseId: String) {  // Tailornova API call response handling
        if let manager = NetworkReachabilityManager(), manager.isReachable {
            self.patternDesViewModel.tailornovaApiHit = false
            self.showLottie()
            if isFromUniversalLink {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.showLottie()
                }
            }
            self.tailornovaService.hitTailornovaApi(params: "\(designId)", purchaseParams: "\(purchaseId)") { patternObject, errorParsingObject, errorMessage   in
                if !errorParsingObject {
                    if self.isFromUniversalLink {
                        self.setuiForUniversalLinking(imgUrl: patternObject.thumbnailImageURL, name: patternObject.patternName, size: patternObject.size, desc: patternObject.tailornovaDescription)
                    }
                    guard patternObject.designID == self.patternDesViewModel.tailornovaDesignId else {
                        return
                    }
                    self.patternDesViewModel.patternNameDirectory = designId + "_" + purchaseId
                    self.tailornovaService.dowloadPatternImages(tailornova: patternObject.patternPieces, isTrail: false, index: designId + "_" + purchaseId) {
                        DispatchQueue.main.async {
                            self.patternDesViewModel.tailornovaModelObject = patternObject
                            patternObject.patternDescriptionImageURL = self.patternDesViewModel.descriptionImageURL
                            self.patternDesViewModel.tailornovaModelObjectArray = patternObject.patternPieces
                            self.patternDesViewModel.patternBrand = patternObject.brand
                            var filterPatternArray = patternObject.selvages.filter({$0.tabCategory.capitalized == FormatsString.garment})
                            filterPatternArray.removeAll()
                            for item in patternObject.selvages.filter({$0.tabCategory.capitalized == FormatsString.garment}) {
                                if !filterPatternArray.contains(where: {$0.fabricLength == item.fabricLength && $0.tabCategory.capitalized == FormatsString.garment}) {
                                    if item.fabricLength == ReferenceLayoutType.fourtyfive || item.fabricLength == ReferenceLayoutType.sixty {
                                        filterPatternArray.append(item)
                                    }
                                }
                            }
                            for item in patternObject.selvages.filter({$0.tabCategory.capitalized == FormatsString.lining}) {
                                if !filterPatternArray.contains(where: {$0.fabricLength == item.fabricLength && $0.tabCategory.capitalized == FormatsString.lining}) {
                                    if item.fabricLength == ReferenceLayoutType.fourtyfive || item.fabricLength == ReferenceLayoutType.sixty {
                                        filterPatternArray.append(item)
                                    }
                                }
                            }
                            for item in patternObject.selvages.filter({$0.tabCategory.capitalized == FormatsString.interfacing}) {
                                if !filterPatternArray.contains(where: {$0.fabricLength == item.fabricLength && $0.tabCategory == FormatsString.interfacing}) {
                                    if item.fabricLength == ReferenceLayoutType.twenty || item.fabricLength == ReferenceLayoutType.fourtyfive {
                                        filterPatternArray.append(item)
                                    }
                                }
                            }
                            for item in patternObject.selvages.filter({$0.tabCategory.capitalized == FormatsString.other}) {
                                if !filterPatternArray.contains(where: {$0.fabricLength == item.fabricLength && $0.tabCategory.capitalized == FormatsString.other}) {
                                    if item.fabricLength == ReferenceLayoutType.fourtyfive || item.fabricLength == ReferenceLayoutType.sixty {
                                        filterPatternArray.append(item)
                                    }
                                }
                            }
                            self.patternDesViewModel.tailornovaSelvagesModelObjectArray = filterPatternArray
                            self.patternDesViewModel.tailornovaInsUrl = patternObject.instructionURL
                            self.patternDesViewModel.tailornovaPatternTitle = patternObject.patternName
                            patternObject.tailornovaDescription = self.patternDesViewModel.patternDescription
                            self.patternDesViewModel.tailornovaApiHit = true
                            self.view.makeToast(MessageString.downloadPatternSuccessfully)
                            self.patternDesViewModel.tailornovaModelObject.isDownloaded = true
                            self.dismissLottie()
                            KAppDelegate.window?.rootViewController?.view.viewWithTag(TagValue.lottieTag)?.removeFromSuperview()
                            self.view.viewWithTag(TagValue.lottieTag)?.removeFromSuperview()
                        }
                    }
                } else {
                    // Error Parsing Objects
                    self.tailornovaErrorPopUp(responseError: errorMessage)
                    self.dismissLottie()
                }
            }
        }
    }
    func tailornovaErrorPopUp(responseError: String) {  // Tailornova error popup
        DispatchQueue.main.async {
            let viewc = Constants.AlertWithImageAndButtons.instantiateViewController(identifier: Constants.AlertWithImageAndButonsVCIdentifier) as AlertWithImageAndButtonsViewController
            let alertButton = responseError != AlertMessage.tailornovaAlertOne ? AlertTitle.OKButton : AlertTitle.goBackButton
            viewc.alertArray = [ImageNames.connectionFailImage, "\(responseError)", FormatsString.emptyString, alertButton, FormatsString.emptyString]
            viewc.modalPresentationStyle = .overFullScreen
            viewc.screenType = ScreenTypeString.tailornovaAlert
            viewc.onTailornovaAlertOKPressed = {
                self.pop()
            }
            if self.presentedViewController == nil {
                self.navigationController?.present(viewc, animated: false, completion: nil)
            }
        }
    }
    //Rohith
    
    func customButtonHandling() {  // Workspace button name handling based on pattern status
        if self.patternDesViewModel.patternType != FormatsString.Trial {
            if self.patternDesViewModel.tailornovamannequinIDArray.isEmpty {
                self.customisationView.isHidden = true
                self.customisationViewWidthConstraint.constant = 0
            }
        } else {
            self.customisationView.isHidden = true
            self.customisationViewWidthConstraint.constant = 0
        }
        if self.patternDesViewModel.isExpired || self.patternDesViewModel.isPaused {  // If pattern is Expired/Paused
            //when pattern got cancelled Hiding buttons
            self.changingSecondButton.isHidden = true
            self.instructionsButton.isHidden = true
            self.yardageButton.isHidden = true
            self.statusRedLabel.text = self.patternDesViewModel.isExpired ? AlertMessage.subscriptionExpiredText : AlertMessage.subscriptionPausedText
        } else {
            self.patternStatusView.isHidden = false
            self.expiredAlertView.isHidden = true
            self.expiredAlertViewHeightConstraint.constant = UIDevice.isPad ? 0 : 10
            self.centerView.isHidden = true
            self.secondIconImage.isHidden = true
            self.secondIconLabel.isHidden = true
        }
        self.patternDescriptionImageViewHeightConstraint.constant = UIDevice.isPad ? 110 : 30
    }
    func detailsSetUp() {  // Setting up the UI values in normal navigation
        let imageURL = self.patternDesViewModel.descriptionImageURL
            self.patternDescriptionImageView.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: ImageNames.placeholderImage)) { (image, err, _, _) in
                self.patternDescriptionImageView.image = (err == nil) ? image : UIImage(named: ImageNames.placeholderImage)
            }
        self.titleLabel.text = self.patternDesViewModel.patternTitle
        DispatchQueue.main.async {
            self.patternDescriptionLabel.text = self.patternDesViewModel.patternDescription.htmlToString
            self.patternDesignNameLabel.text = self.patternDesViewModel.tailornovaDesignName
            self.patternSizeLabel.text = self.patternDesViewModel.patternBrand == FormatsString.dittoBrandLabel ? self.patternDesViewModel.customSizeFitName == FormatsString.emptyString ? "\(FormatsString.Size) : \(self.patternDesViewModel.patternSize)" : "\(FormatsString.Size) : \(self.patternDesViewModel.customSizeFitName)" : FormatsString.emptyString
            self.modifiedDateLabel.text = self.patternDesViewModel.lastModifiedSizeDate != FormatsString.emptyString ? "\(FormatsString.modifiedLabel) : \(self.patternDesViewModel.lastModifiedSizeDate)" : FormatsString.emptyString
        }
    }
    func setuiForUniversalLinking(imgUrl: String, name: String, size: String, desc: String) {  // Setting UI when coming through deeplinking
        self.patternDescriptionImageView.sd_setImage(with: URL(string: imgUrl), placeholderImage: UIImage(named: ImageNames.placeholderImage)) { (image, err, _, _) in
            self.patternDescriptionImageView.image = (err == nil) ? image : UIImage(named: ImageNames.placeholderImage)
        }
        self.titleLabel.text = name
        self.patternDesViewModel.tailornovaDesignName = name
        self.patternDescriptionLabel.text = desc
        self.patternDesignNameLabel.text = FormatsString.emptyString
        self.patternSizeLabel.text = self.patternDesViewModel.patternBrand == FormatsString.dittoBrandLabel ?  self.patternDesViewModel.customSizeFitName == FormatsString.emptyString ? "\(FormatsString.Size) : \(self.patternDesViewModel.patternSize)" : "\(size) : \(self.patternDesViewModel.customSizeFitName)" : FormatsString.emptyString
        self.modifiedDateLabel.text = self.patternDesViewModel.lastModifiedSizeDate != FormatsString.emptyString ? "\(FormatsString.modifiedLabel) : \(self.patternDesViewModel.lastModifiedSizeDate)" : FormatsString.emptyString
    }
    //MARK: OUTLET ACTIONS
    @IBAction func changingSecondButtonAction(_ sender: Any) {   // workspace button tap action
        if !self.patternDesViewModel.isExpired && !self.patternDesViewModel.isPaused, let manager = NetworkReachabilityManager() {
            if self.patternDesViewModel.patternType == FormatsString.Trial {
                self.hitTailorNova(designId: self.patternDesViewModel.tailornovaDesignId, purchaseId: self.patternDesViewModel.designIdToPass)
            } else if !self.patternDesViewModel.tailornovaModelObject.isDownloaded && self.patternDesViewModel.patternType != FormatsString.Trial && manager.isReachable {  // if entire pattern pieces is not downloaded to local
                if !self.selectViewCupSizeView.isHidden && self.selectViewCupSizeButton.title(for: .normal)! == FormatsString.selectViewCupSize {   // if 3P dropdowns Select view/ cup size is present, and selection is not done
                    if !self.selectSizeView.isHidden && self.selectSizeButton.title(for: .normal)! == FormatsString.selectSize {   // if 3P dropdowns Select Size is present, and selection is not done
                        ServiceManagerProxy.shared.displayerrorPopup(url: FormatsString.emptyString, responseError: MessageString.selectAnysizeAndCupSize)
                    } else {
                        ServiceManagerProxy.shared.displayerrorPopup(url: FormatsString.emptyString, responseError: MessageString.selectAnyViewCupSize)
                    }
                } else if !self.selectSizeView.isHidden && self.selectSizeButton.title(for: .normal)! == FormatsString.selectSize {   // if 3P dropdowns Select Size is present, and selection is not done
                    ServiceManagerProxy.shared.displayerrorPopup(url: FormatsString.emptyString, responseError: MessageString.selectAnySize)
                } else if self.customisationButton.title(for: .normal)! == FormatsString.addcustomisation && !self.customisationView.isHidden {  // if Add customisation dropdown is present, and selection is not done
                    ServiceManagerProxy.shared.displayerrorPopup(url: FormatsString.emptyString, responseError: MessageString.selectAnyCustomisation)
                } else {
                    if !self.patternDesViewModel.tailornovamannequinIDArray.isEmpty {   // if mannequin array is not empty, i.e., when add customisation drop down is present and selection is made
                        if self.patternDesViewModel.designIdToPass == FormatsString.emptyString {
                            ServiceManagerProxy.shared.displayerrorPopup(url: FormatsString.emptyString, responseError: MessageString.selectAnyCustomisation)
                        } else {
                            if self.patternDesViewModel.designIdToPass != FormatsString.emptyString || self.patternDesViewModel.tailornovaDesignId != FormatsString.emptyString {
                                self.hitTailorNova(designId: self.patternDesViewModel.tailornovaDesignId, purchaseId: self.patternDesViewModel.designIdToPass)
                            } else {
                                self.unabletoFetchDesignIDErrorPopUp()
                            }
                        }
                    } else {   // if mannequin array is empty, i.e., when add customisation drop down is not present
                        if self.patternDesViewModel.patternBrand.lowercased() != FormatsString.dittoBrandLabel.lowercased() && !self.patternDesViewModel.thirdPartyApiHit {  // Check if it is 3P pattern and if 3P api call is done...else hit that 3P api
                            self.hitThirdPartyAPI()
                        } else {  // Check if it is ditto pattern and if tailornova api call is done...else hit that api and download image to local
                            if !self.patternDesViewModel.tailornovaApiHit {
                                if self.patternDesViewModel.designIdToPass != FormatsString.emptyString || self.patternDesViewModel.tailornovaDesignId != FormatsString.emptyString {
                                    self.hitTailorNova(designId: self.patternDesViewModel.tailornovaDesignId, purchaseId: self.patternDesViewModel.designIdToPass)
                                } else {
                                    self.unabletoFetchDesignIDErrorPopUp()
                                }
                            }
                        }
                    }
                }
            } else {   // if entire pattern pieces is downloaded to local after tailornova API call
                self.showLottie()
                self.lotteMessage.isHidden = false
                if Network.reachability.isReachable {
                       Proxy.shared.saveAllWorkedPatternsID(patternID: self.patternDesViewModel.patternNameDirectory)
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.goToWorkspace()
                    self.lotteMessage.isHidden = true
                }
            }
        }
    }
    @IBAction func hamburgerAction(_ sender: UIButton) {   // Hamburger menu tap action
        KAppDelegate.sideMenuVC.openRight()
    }
    func savePDF(path: URL) {  // Open PDF
        DispatchQueue.main.async {
            guard let pdfViewController = Constants.patternInstructions.instantiateViewController(withIdentifier: Constants.PatternInstructionsIdentifier) as? PatternInstructionsViewController else { return }
            pdfViewController.patternInstViewModel.fromSewingInstruction = false
            pdfViewController.patternInstViewModel.fromPatternDescription = true
            pdfViewController.patternInstViewModel.isPresentedFromWorkSpace = true
            pdfViewController.patternInstViewModel.fileURL = path
            pdfViewController.patternInstViewModel.mainURL = self.patternDesViewModel.tailornovaInsUrl
            pdfViewController.patternInstViewModel.titleLable = self.patternDesViewModel.patternTitle
            let navController = UINavigationController(rootViewController: pdfViewController)
            navController.modalPresentationStyle = .overFullScreen
            if self.presentedViewController == nil {
                self.navigationController?.present(navController, animated: false, completion: nil)
            }
        }
    }
    @IBAction func instructionsAction(_ sender: UIButton) { // Instruction button tap action
        if !self.patternDesViewModel.isExpired && !self.patternDesViewModel.isPaused {
            if !self.selectViewCupSizeView.isHidden && self.selectViewCupSizeButton.title(for: .normal)! == FormatsString.selectViewCupSize {  // if 3P dropdowns Select view/ cup size is present, and selection is not done
                if !self.selectSizeView.isHidden && self.selectSizeButton.title(for: .normal)! == FormatsString.selectSize {  // if 3P dropdowns Select size is present, and selection is not done
                    ServiceManagerProxy.shared.displayerrorPopup(url: FormatsString.emptyString, responseError: MessageString.selectAnysizeAndCupSize)
                } else {
                    ServiceManagerProxy.shared.displayerrorPopup(url: FormatsString.emptyString, responseError: MessageString.selectAnyViewCupSize)
                }
            } else if !self.selectSizeView.isHidden && self.selectSizeButton.title(for: .normal)! == FormatsString.selectSize {  // if 3P dropdowns Select size is present, and selection is not done
                ServiceManagerProxy.shared.displayerrorPopup(url: FormatsString.emptyString, responseError: MessageString.selectAnySize)
            } else {  // if no drop down is present / selection is made for all dropdowns correctly
                let url = self.patternDesViewModel.tailornovaInsUrl
                let fileName = "\(self.patternDesViewModel.patternTitle + FormatsString.instructionPdfLabel).pdf"
                let documentsURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
                let finalPath = documentsURL.appendingPathComponent("\(self.patternDesViewModel.patternTitle + FormatsString.instructionPdfLabel).pdf")
                if !FileManager.default.fileExists(atPath: finalPath.path) {
                    if Network.reachability.isReachable {
                        if url != FormatsString.emptyString {
                            self.savePdf(urlString: url, fileName: fileName) { (status) in
                                if status {
                                    if !self.selectViewCupSizeView.isHidden && self.selectViewCupSizeButton.title(for: .normal)! == FormatsString.selectViewCupSize {   // if 3P dropdowns Select view/ cup size is present, and selection is not done
                                        if !self.selectSizeView.isHidden && self.selectSizeButton.title(for: .normal)! == FormatsString.selectSize {
                                            ServiceManagerProxy.shared.displayerrorPopup(url: url, responseError: MessageString.selectAnysizeAndCupSize)
                                        } else {
                                            ServiceManagerProxy.shared.displayerrorPopup(url: url, responseError: MessageString.selectAnyViewCupSize)
                                        }
                                    } else if !self.selectSizeView.isHidden && self.selectSizeButton.title(for: .normal)! == FormatsString.selectSize {  // if 3P dropdowns Select size is present, and selection is not done
                                        ServiceManagerProxy.shared.displayerrorPopup(url: url, responseError: MessageString.selectAnySize)
                                    } else if self.customisationButton.title(for: .normal)! == FormatsString.addcustomisation && !self.customisationView.isHidden {   // if Add customisation dropdown is present, and selection is not done
                                        ServiceManagerProxy.shared.displayerrorPopup(url: url, responseError: MessageString.selectAnyCustomisation)
                                    } else {
                                        self.savePDF(path: finalPath)
                                    }
                                } else {
                                    self.displayErrorPopUp()
                                }
                            }
                        } else if !self.patternDesViewModel.tailornovamannequinIDArray.isEmpty && !self.patternDesViewModel.tailornovaApiHit {
                            ServiceManagerProxy.shared.displayerrorPopup(url: url, responseError: MessageString.selectAnyCustomisation)
                        } else {
                            ServiceManagerProxy.shared.displayerrorPopup(url: url, responseError: MessageString.noPdftoDisplay)
                        }
                    } else {
                        ServiceManagerProxy.shared.displayerrorPopup(url: url, responseError: AlertMessage.noConnectionDescription)
                    }
                } else {
                    if self.customisationButton.title(for: .normal)! == FormatsString.addcustomisation && !self.customisationView.isHidden {
                        ServiceManagerProxy.shared.displayerrorPopup(url: url, responseError: MessageString.selectAnyCustomisation)
                    } else {
                        if let pdfViewController = Constants.patternInstructions.instantiateViewController(withIdentifier: Constants.PatternInstructionsIdentifier) as? PatternInstructionsViewController {
                            pdfViewController.patternInstViewModel.fromSewingInstruction = false
                            pdfViewController.patternInstViewModel.fromPatternDescription = true
                            pdfViewController.patternInstViewModel.fileURL = finalPath
                            pdfViewController.patternInstViewModel.mainURL = self.patternDesViewModel.tailornovaInsUrl
                            pdfViewController.patternInstViewModel.titleLable = self.patternDesViewModel.patternTitle
                            self.navigationController?.pushViewController(pdfViewController, animated: true)
                        }
                    }
                }
            }
        }
    }
    @IBAction func yardageAction(_ sender: Any) { // Move to Yardage screen
        if self.patternDesViewModel.yardageDetails.isEmpty && self.patternDesViewModel.notionDetails.isEmpty && self.patternDesViewModel.yardagePdfUrl.isEmpty {
            ServiceManagerProxy.shared.displayerrorPopup(url: FormatsString.emptyString, responseError: MessageString.noYardagetoDisplay)
        } else {
            if !self.patternDesViewModel.yardagePdfUrl.isEmpty {
                let url = self.patternDesViewModel.yardagePdfUrl
                let fileName = "\(self.patternDesViewModel.patternTitle + FormatsString.yardagePdfLabel).pdf"
                let documentsURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
                let finalPath = documentsURL.appendingPathComponent("\(self.patternDesViewModel.patternTitle + FormatsString.yardagePdfLabel).pdf")
                if !FileManager.default.fileExists(atPath: finalPath.path) {
                    if Network.reachability.isReachable {
                        if url != FormatsString.emptyString {
                            self.savePdf(urlString: url, fileName: fileName) { (status) in
                                if status {
                                    DispatchQueue.main.async {
                                        if let yardageVC = Constants.Yardage.instantiateViewController(withIdentifier: Constants.YardageViewControllerIdentifier) as? YardageViewController {
                                            yardageVC.yardageViewModel.notionDetails = self.patternDesViewModel.notionDetails
                                            yardageVC.yardageViewModel.yardageDetails = self.patternDesViewModel.yardageDetails
                                            yardageVC.yardageViewModel.yardagePdfUrl = self.patternDesViewModel.yardagePdfUrl
                                            yardageVC.yardageViewModel.fileURL = finalPath
                                            self.navigationController?.pushViewController(yardageVC, animated: true)
                                        }
                                    }
                                } else {
                                    self.displayErrorPopUp()
                                }
                            }
                        }
                    } else {
                        ServiceManagerProxy.shared.displayerrorPopup(url: FormatsString.emptyString, responseError: AlertMessage.noConnectionDescription)
                    }
                } else {
                    DispatchQueue.main.async {
                        if let yardageVC = Constants.Yardage.instantiateViewController(withIdentifier: Constants.YardageViewControllerIdentifier) as? YardageViewController {
                            yardageVC.yardageViewModel.notionDetails = self.patternDesViewModel.notionDetails
                            yardageVC.yardageViewModel.yardageDetails = self.patternDesViewModel.yardageDetails
                            yardageVC.yardageViewModel.yardagePdfUrl = self.patternDesViewModel.yardagePdfUrl
                            yardageVC.yardageViewModel.fileURL = finalPath
                            self.navigationController?.pushViewController(yardageVC, animated: true)
                        }
                    }
                }
            } else {
                    DispatchQueue.main.async {
                        if let yardageVC = Constants.Yardage.instantiateViewController(withIdentifier: Constants.YardageViewControllerIdentifier) as? YardageViewController {
                            yardageVC.yardageViewModel.notionDetails = self.patternDesViewModel.notionDetails
                            yardageVC.yardageViewModel.yardageDetails = self.patternDesViewModel.yardageDetails
                            yardageVC.yardageViewModel.yardagePdfUrl = self.patternDesViewModel.yardagePdfUrl
                            self.navigationController?.pushViewController(yardageVC, animated: true)
                        }
                    }
                }
        }
    }
    @objc func backbuttontapperd(sender: UIBarButtonItem) {  // back button tap action
        if KAppDelegate.isFromUniversalLinking {
            CommonConst.navCheckValue = 1
            self.rootWithDrawer(mainVCStoryboard: .dashboard, mainVCIdentifier: Constants.HomeViewControllerIdentifier, sideVCStoryboard: .dashboard, sideVCIdentifier: Constants.HamburgerViewControllerIdentifier)
            KAppDelegate.goToPatternDesc = false
            KAppDelegate.isFromUniversalLinking = false
        } else {
            self.pop()
        }
    }
}
