//
//  HomeViewController.swift
//  JoannTraceApp
//
//  Created by Infosys on 03/08/20.
//  Copyright © 2020 Infosys. All rights reserved.
//

import UIKit
import SystemConfiguration
import Alamofire

class HomeViewController: UIViewController, MylibraryVCDelegate {
    //MARK: UI COMPONENT OUTLETS
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var appLogoImgView: UIImageView!

    var languageStr = ""
    //MARK: VARIABLE DECLARATION
    var homeViewModel = HomeViewModel()
    var objMyLibViewModel = MyLibraryViewModel()
    enum Section: Int { case patternLibrary, tutorial, dittopatterns, joann }
    //MARK: View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.homeViewModel.isinHomeScreen = true
        self.collectionViewReloadingFunction()
        self.collectionView.backgroundColor = .clear
    }
    override func viewWillAppear(_ animated: Bool) {
        self.title = FormatsString.emptyString
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.setBackgroundImage(_: UIImage(), for: .any, barMetrics: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isHidden = false
        self.collectionViewReloadingFunction()
        
        //Rohith
        // handling wethere user is for the first time login or Second time login
        
        let isChecked = UserDefaults.standard.bool(forKey: "isChecked")
        if isChecked == false {
         
            //for the first time login
            //Handling user selected multi language option

            DispatchQueue.main.async {
                self.welcomeLabel.text = "\("title".localizeString(string: "en"))\(CommonConst.firstNameValue)"
                UserDefaults.standard.set("en", forKey: "language")
                UserDefaults.standard.set(true, forKey: "isChecked")
                if let viewc = Constants.LanguagePopupBoard.instantiateViewController(identifier: Constants.LanguagePopupVCIdentifier) as?  languagePopupVC {
                    viewc.modalPresentationStyle = .overFullScreen
                    viewc.onEnglishTapped = {
                        
                        self.dismiss(animated: false, completion: {// Navigation to Update Projector Screen
                            print("English")
                            
                            self.welcomeLabel.text = "\("title".localizeString(string: "en"))\(CommonConst.firstNameValue)"
                            UserDefaults.standard.set("en", forKey: "language")

                            self.dismiss(animated: false, completion: nil)

                        })
                    }
                    viewc.onFrenchTapped = {
                        self.dismiss(animated: false, completion: {// Navigation to Update Projector Screen
                            
                            print("French")
                            self.welcomeLabel.text = "\("title".localizeString(string: "fr"))\(CommonConst.firstNameValue)"
                            UserDefaults.standard.set("fr", forKey: "language")
                            self.dismiss(animated: false, completion: nil)

                        })
                    }
                    if self.presentedViewController == nil {
                        self.present(viewc, animated: false, completion: nil)
                    }
                }
            }
       
        }else{
            // second time login
            //Handling user selected multi language option
            self.welcomeLabel.text = "\("title".localizeString(string: "en"))\(CommonConst.firstNameValue)"
            UserDefaults.standard.set("en", forKey: "language")
            UserDefaults.standard.set(true, forKey: "isChecked")

        }
        NotificationCenter.default.addObserver(self, selector: #selector(handleLanguageNotification), name: NSNotification.Name("UserLanguage"), object: nil)

      
        
        
        
       // self.welcomeLabel.attributedText = homeViewModel.getHomeScreenTitles()
        self.reloadMylibraryfromWorkspaceVC()
        
        //Rohith
        // retriving Created Notification  Center for multilanguage action here
        NotificationCenter.default.addObserver(self, selector: #selector(self.selectorName), name: NSNotification.Name(rawValue: FormatsString.forgroundLabel), object: nil)
        self.goToMylibraryFromLink()
        self.goToPatternInstructions()
    }
    //Rohith
    // Handling multilanguage action here
    @objc private func handleLanguageNotification(_ notification: NSNotification) {
        
        DispatchQueue.main.async {
            if let viewc = Constants.LanguagePopupBoard.instantiateViewController(identifier: Constants.LanguagePopupVCIdentifier) as?  languagePopupVC {
                viewc.modalPresentationStyle = .overFullScreen
                viewc.onEnglishTapped = {
                    

                    
                    self.dismiss(animated: false, completion: {// Navigation to Update Projector Screen
                        print("English")
                        
                        self.welcomeLabel.text = "\("title".localizeString(string: "en"))\(CommonConst.firstNameValue)"
                        UserDefaults.standard.set("en", forKey: "language")

                        self.dismiss(animated: false, completion: nil)

                    })
                }
                viewc.onFrenchTapped = {
                    self.dismiss(animated: false, completion: {// Navigation to Update Projector Screen
                        
                        print("French")
                        self.welcomeLabel.text = "\("title".localizeString(string: "fr"))\(CommonConst.firstNameValue)"
                        UserDefaults.standard.set("fr", forKey: "language")
                        self.dismiss(animated: false, completion: nil)

                    })
                }
                if self.presentedViewController == nil {
                    self.present(viewc, animated: false, completion: nil)
                }
            }
        }
        
        
          /*
          {name = UserLoggedOut; userInfo = {
             userId = 123;
          }}
          */
       }
    //Rohith
    // changing language here for user selection
    func changeLanguage(lang: String) {
        welcomeLabel.text = "title".localizeString(string: lang)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.collectionViewReloadingFunction()
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.homeViewModel.isinHomeScreen = false
    }
    func addObservers() {   // Removing and adding observers
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "goToMyLibrary"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "goToMyPatternLibrary"), object: nil)
        NotificationCenter.default.removeObserver(self, name: Notification.Name(rawValue: "NetworkStatus"), object: nil)
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "NetworkStatus"), object: nil, queue: OperationQueue.main) { (notify: Notification) in
            if self.homeViewModel.isinHomeScreen {
                if let networkStatus = notify.object as? Bool {
                    if let isinMylibrary = CommonConst.userDefault.value(forKey: IsInPage.myLibrary.rawValue) as? Bool, !isinMylibrary {
                        if !KAppDelegate.isFromUniversalLinking {
                            self.setpatterns(network: networkStatus)
                        }
                    }
                }
            }
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "goToMyLibrary"), object: nil, queue: OperationQueue.main) { _ in
            if KAppDelegate.goToMyLibrary {
                self.goToMylibraryFromLink()
            }
        }
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "goToMyPatternLibrary"), object: nil, queue: OperationQueue.main) { _ in
            if KAppDelegate.goToPatternDesc {
                self.goToPatternInstructions()
            }
        }
    }
    func setpatterns(network: Bool) {   // setting patterns collection view based on network status
        DispatchQueue.main.asyncAfter(deadline: .now()) {
            if network {
                if !CommonConst.guestUserCheck {   // Logged In User
                    self.homeViewModel.getMyLibraryData { mylibraryData  in
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.collectionView.reloadData()
                            KAppDelegate.window?.rootViewController?.view.viewWithTag(TagValue.lottieTag)?.removeFromSuperview()
                            self.view.viewWithTag(TagValue.lottieTag)?.removeFromSuperview()
                        }
                        self.objMyLibViewModel.objMylibData = mylibraryData
                        self.collectionView.reloadData()
                    }
                } else {   // Guest User
                    self.collectionView.reloadData()
                }
            } else {
                if !CommonConst.guestUserCheck {   // Logged In User
                    self.setOfflineFlow()
                    self.collectionView.reloadData()
                } else {   // Guest User
                    self.collectionView.reloadData()
                }
            }
        }
    }
    func setofflinepatternsfromMylibrary(networkStatus: Bool) {
        self.setpatterns(network: networkStatus)
    }
    func reloadfromMyLibVC() {   // Reload Home screen collection view when coming from pattern library screen
        CommonConst.userDefault.set(false, forKey: IsInPage.patternDesc.rawValue)
        CommonConst.userDefault.set(false, forKey: IsInPage.myLibrary.rawValue)
        self.collectionView.reloadData()
    }
    @objc func selectorName() {
        if self.homeViewModel.isinHomeScreen {
            self.collectionView.reloadData()
        }
    }
    func reloadMylibraryfromWorkspaceVC() {    // Reload Home screen collection view when coming from exit tap of Workspace
        if KAppDelegate.reloadMyLirary {
            self.homeViewModel.objMyLibraryModel.prod.removeAll()
            if CommonConst.guestUserCheck {
                self.homeViewModel.objMyLibraryModel.setMyLibTrailData(trailArray: self.homeViewModel.trailPatternArray)
                UserDefaults.standard.removeObject(forKey: CommonConst.SelectedFilterObjectss)
                self.objMyLibViewModel.objMylibData = self.homeViewModel.objMyLibraryModel
                self.collectionView.reloadData()
                KAppDelegate.reloadMyLirary = false
            } else {
                self.homeViewModel.getMyLibraryData { mylibraryData  in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        self.collectionView.reloadData()
                        self.view.viewWithTag(TagValue.lottieTag)?.removeFromSuperview()
                    }
                    self.objMyLibViewModel.objMylibData = mylibraryData
                    KAppDelegate.reloadMyLirary = false
                }
            }
        }
    }
    func collectionViewReloadingFunction() {  // Logic to reload collection view(no: of patterns) based on api change
        Proxy.shared.registerCollViewNib(self.collectionView, nibName: ReusableCellIdentifiers.homeScreenCollectionViewCellIdentifier, identifierCell: ReusableCellIdentifiers.homeCellIdentifier)
        self.addObservers()
        if !CommonConst.guestUserCheck {   // Logged In User
            if let manager = NetworkReachabilityManager(), manager.isReachable {
                self.homeViewModel.getMyLibraryData { mylibraryData  in
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        KAppDelegate.window?.rootViewController?.view.viewWithTag(TagValue.lottieTag)?.removeFromSuperview()
                        self.view.viewWithTag(TagValue.lottieTag)?.removeFromSuperview()
                    }
                    CommonConst.userDefault.set(false, forKey: IsInPage.patternDesc.rawValue)
                    CommonConst.userDefault.set(false, forKey: IsInPage.myLibrary.rawValue)
                    self.objMyLibViewModel.objMylibData = mylibraryData
                    CommonConst.myLibPatternCount = "\(mylibraryData.totalPatternCount)"
                }
            } else {
                self.setOfflineFlow()
            }
        } else {   // Guest User
            if let manager = NetworkReachabilityManager(), !manager.isReachable {
                self.collectionView.reloadData()
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.collectionView.reloadData()
            KAppDelegate.window?.rootViewController?.view.viewWithTag(TagValue.lottieTag)?.removeFromSuperview()
            self.view.viewWithTag(TagValue.lottieTag)?.removeFromSuperview()
        }
//        self.setCoachmark()
    }
    func goToMylibraryFromLink() {   // Go To Pattern Library screen if coming from multiple purchase deeplinking flow
        if let manager = NetworkReachabilityManager(), manager.isReachable {
            if KAppDelegate.goToMyLibrary {
                self.homeViewModel.getMyLibraryData { mylibraryData  in
                    self.collectionView.reloadData()
                    self.objMyLibViewModel.objMylibData = mylibraryData
                    if !self.objMyLibViewModel.objMylibData.prod.isEmpty {
                        if let myLibraryVC = Constants.dashBoardStoryBoard.instantiateViewController(identifier: Constants.MyLibrarryViewControllerIdentifier) as? MyLibrarryViewController {
                            myLibraryVC.objMylibraryData = self.objMyLibViewModel.objMylibData
                            myLibraryVC.pageID = self.objMyLibViewModel.objMylibData.currentPageID
                            myLibraryVC.isFromUniversalLink = true
                            myLibraryVC.myLibraryViewModel.trailPatternArray = self.homeViewModel.trailPatternArray
                            if KAppDelegate.goToMyLibrary {
                                self.navigationController?.pushViewController(myLibraryVC, animated: true)
                            }
                        }
                    }
                    KAppDelegate.goToMyLibrary = false
                }
            }
        } else {
            Proxy.shared.dismissLottie()
            Proxy.shared.openSettingApp()
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    @IBAction func hamburgerAction(_ sender: UIButton) {   // Hamburger button tap action
        KAppDelegate.sideMenuVC.openRight()
    }
    func setOfflineFlow() {   // Setting offline flow
        if !CommonConst.guestUserCheck {   // Logged In User
            if CommonConst.offlineDesignIdText != FormatsString.emptyString {
                self.objMyLibViewModel.DBFetch()
            }
            self.objMyLibViewModel.setofflineData(trailArray: self.homeViewModel.trailPatternArray)
            self.homeViewModel.offlineDataArray.removeAll()
            self.homeViewModel.offlineDataArray = self.objMyLibViewModel.offlinePattern
        } else {   // Guest User
            self.homeViewModel.offlineDataArray.removeAll()
            Proxy.shared.openSettingApp()
        }
    }
    func goToPatternInstructions() {   // Go To Pattern Detail screen if coming from single purchase deeplinking flow
        if let manager = NetworkReachabilityManager(), manager.isReachable {
            if KAppDelegate.goToPatternDesc {
                self.homeViewModel.getMyLibraryData { mylibraryData  in
                    self.collectionView.reloadData()
                    if let patternDesc = Constants.patternDescription.instantiateViewController(withIdentifier: StoryBoardType.patternDescription.rawValue) as? PatternDescriptionViewController {
                        patternDesc.patternDesViewModel.patternType = FormatsString.OWNED
                        if self.objMyLibViewModel.fetchType == Constants.fromAllPatterns {
                            self.objMyLibViewModel.DBFetch()
                            patternDesc.patternDesViewModel.currentSelectedPatterny = self.objMyLibViewModel.pattern
                            patternDesc.patternDesViewModel.screenType = Constants.fromAllPatterns
                        }
                        patternDesc.isFromUniversalLink = true
                        patternDesc.patternDesViewModel.purchasedSizeId = KAppDelegate.tailorNovaMID
                        patternDesc.patternDesViewModel.tailornovaDesignId = KAppDelegate.tailorNovaDID
                        let maniquinIDObj = mylibraryData.prod.filter({$0.tailornovaDesignID == KAppDelegate.tailorNovaDID})
                        if !maniquinIDObj.isEmpty {
                            patternDesc.patternDesViewModel.customisedNameList = [FormatsString.addcustomisation]
                        }
                        if let workspace = self.homeViewModel.workspace {
                            patternDesc.patternDesViewModel.currenSelectedWorkspace = workspace
                            patternDesc.patternDesViewModel.currentSelectedPatterny = workspace.parentPattern
                        }
                        if KAppDelegate.goToPatternDesc {
                            self.navigationController?.pushViewController(patternDesc, animated: true)
                        }
                        KAppDelegate.goToPatternDesc = false
                    }
                }
            }
        } else {
            Proxy.shared.dismissLottie()
            Proxy.shared.openSettingApp()
        }
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    func setnavgationforUniversalLinking(product: MyLibraryPatterns, data: MyLibraryData) {  // Navigation in case of Deeplinking
        if let patternDesc = Constants.patternDescription.instantiateViewController(withIdentifier: StoryBoardType.patternDescription.rawValue) as? PatternDescriptionViewController {
            if product.status == FormatsString.OWNED {
                patternDesc.patternDesViewModel.isOwned = true
            } else if product.status == FormatsString.EXPIRED {
                patternDesc.patternDesViewModel.isExpired = true
            } else if product.status == FormatsString.PAUSED {
                patternDesc.patternDesViewModel.isExpired = true
            } else {
                patternDesc.patternDesViewModel.isOwned = false
            }
            patternDesc.patternDesViewModel.productId = product.id
            patternDesc.patternDesViewModel.dropPieceArray = product.dropPieceArray
            patternDesc.patternDesViewModel.patternTitle = product.name
            patternDesc.patternDesViewModel.patternDescription = product.prodDescription
            patternDesc.patternDesViewModel.tailornovaDesignId = product.tailornovaDesignID
            patternDesc.patternDesViewModel.descriptionImageURL = product.image
            patternDesc.patternDesViewModel.patternType = FormatsString.OWNED
            patternDesc.patternDesViewModel.subscriptionExpiryDate = product.subscriptionExpiryDate
            patternDesc.patternDesViewModel.tailornovaDesignName = product.tailornovaDesignName
            patternDesc.patternDesViewModel.patternSize = product.size
            patternDesc.patternDesViewModel.patternBrand = product.brand
            patternDesc.patternDesViewModel.lastModifiedSizeDate = product.lastModifiedSizeDate
            patternDesc.patternDesViewModel.customSizeFitName = product.customSizeFitName
            if self.objMyLibViewModel.fetchType == Constants.fromAllPatterns {
                self.objMyLibViewModel.DBFetch()
                patternDesc.patternDesViewModel.currentSelectedPatterny = self.objMyLibViewModel.pattern
                patternDesc.patternDesViewModel.screenType = Constants.fromAllPatterns
            }
            let maniquinIDObj = data.prod.filter({$0.tailornovaDesignID == KAppDelegate.tailorNovaDID})
            if !maniquinIDObj.isEmpty {
                let maniquinnIDArray = maniquinIDObj[0].mannequinIDArray
                if maniquinIDObj[0].patternType != FormatsString.Trial {
                    if let manager = NetworkReachabilityManager(), manager.isReachable {
                        patternDesc.patternDesViewModel.customisedNameList = [FormatsString.addcustomisation]
                    }
                    patternDesc.patternDesViewModel.tailornovamannequinIDArray = maniquinnIDArray
                    patternDesc.patternDesViewModel.purchasedSizeId = KAppDelegate.tailorNovaMID
                    patternDesc.isFromUniversalLink = true
                }
            }
            if let workspace = self.homeViewModel.workspace {
                patternDesc.patternDesViewModel.currenSelectedWorkspace = workspace
                patternDesc.patternDesViewModel.currentSelectedPatterny = workspace.parentPattern
            }
            KAppDelegate.goToPatternDesc = false
            self.navigationController?.pushViewController(patternDesc, animated: true)
        }
    }
}
extension String {
    func localizeString(string: String) -> String {
        let path = Bundle.main.path(forResource: string, ofType: "lproj")
        let bundle = Bundle(path: path!)
        return NSLocalizedString(self, tableName: nil, bundle: bundle!, value: "", comment: "")
    }
}
