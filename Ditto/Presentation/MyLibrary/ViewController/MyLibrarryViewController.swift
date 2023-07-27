//
//  MyLibrarryViewController.swift
//  JoannTraceApp Test
//
//  Created by Shefrin Hakeem on 13/08/20.
//  Copyright © 2020 Infosys. All rights reserved.
//

import UIKit
import Alamofire

@objc protocol MylibraryVCDelegate {
    func setofflinepatternsfromMylibrary(networkStatus: Bool)
    func reloadfromMyLibVC()
}

class MyLibrarryViewController: UIViewController {
    // MARK: - UI COMPONENT OUTLETS
    @IBOutlet weak var navigationLabelXContraint: NSLayoutConstraint!
    @IBOutlet weak var allPatternsLabel: UILabel!
    @IBOutlet weak var myFoldersLabel: UILabel!
    @IBOutlet weak var filterResultView: UIView!
    @IBOutlet weak var completedProjectLabel: UILabel!
    @IBOutlet weak var activeProjectLabel: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var completedProjectButton: UIButton!
    @IBOutlet weak var activeProjectButton: UIButton!
    @IBOutlet weak var allPatternsButton: UIButton!
    @IBOutlet weak var addProjectView: UIView!
    @IBOutlet weak var activeProjectView: UIView!
    @IBOutlet weak var completedProjectView: UIView!
    @IBOutlet weak var allPatternsView: UIView!
    @IBOutlet weak var addProjectButton: UIButton!
    @IBOutlet weak var noActivityLabel: UILabel!
    @IBOutlet weak var searchResultCountLabel: UILabel!
    @IBOutlet weak var navigationView: UIView!
    @IBOutlet weak var navigationtitleLabel: UILabel!
    @IBOutlet weak var topViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var noPatternsAvailableView: UIView!
    @IBOutlet weak var syncButton: UIButton!
    @IBOutlet weak var allPatternsUnderLineLbl: UILabel!
    @IBOutlet weak var myFolderUnderLineLbl: UILabel!
    @IBOutlet weak var filterButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var allpatternsView: UIView!
    @IBOutlet weak var myfolderView: UIView!
    // MARK: - VARIABLE DECLARATION
    var myLibraryViewModel = MyLibraryViewModel()
    var searchText: SearchTextField!
    var searchController = UISearchController()
    var searchBar = UISearchBar()
    var folderSwitch: Bool = false
    var delegate: FilterDelegate?
    var objMylibraryData = MyLibraryData()
    var canSearchandFilterFolder = Bool()
    var whenAllPatternsTapped = Bool()
    var filterappliedinPatternLibrary = Bool()
    var shouldhideIndicationLbl: Bool = false
    var filteredResultinFolderisNull = Bool()
    var selectedFolderName = String()
    var searchTermAfterFilter = String()
    var pageID = Int()
    var isLoading = false
    var myLibVCDelegate: MylibraryVCDelegate?
    var isFromUniversalLink: Bool = false
    var homeViewModel = HomeViewModel()
    var isinFavoriteFolder: Bool = false
    var totalPatternCount = String()
    var isInFolder: Bool = false
    var selectedFolderIndex = Int()
    // MARK: - View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addObservers()
        if KAppDelegate.goToMyLibrary {
            self.syncAPICall(needtoclearFilter: true)
        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(tapClearResponse))
        self.activeProjectView.addGestureRecognizer(tapGesture)
        self.registernib()
        self.myLibraryViewModel.removeFilterUserDefaults()
        self.filterButton.isSelected = false
        self.collectionView.showsVerticalScrollIndicator = false
        self.myLibraryViewModel.reloadCollectionView = {
            self.collectionView.reloadData()
        }
        self.myLibraryViewModel.getFolder(completion: { _ in
            self.myLibraryViewModel.apimyFolderCompleted = true
            self.collectionView.reloadData()
            self.view.viewWithTag(TagValue.lottieTag)?.removeFromSuperview()
        })
        CommonConst.userDefault.set(true, forKey: IsInPage.myLibrary.rawValue)
        self.addProjectView.isHidden = true
        self.totalPatternCount = "\(self.objMylibraryData.prod.count)"
        self.myLibraryViewModel.DBFetch()
        self.noPatternsAvailableView.isHidden = true
        self.navigationtitleLabel.text = self.canSearchandFilterFolder ? "\(self.selectedFolderName) (\(self.objMylibraryData.totalPatternCount))": "\(FormatsString.PatternLibrary) (\(self.objMylibraryData.totalPatternCount))"
        self.topViewHeightConstraint.constant = UIDevice.isPad ? 30: 0
        self.myLibraryViewModel.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.myFolderUnderLineLbl.isHidden = true
        self.myFoldersLabel.textColor = UIColor(rgb: 0x707070)
        self.myfolderView.isUserInteractionEnabled = true
        self.setOfflineUI()
    }
    func registernib() {   // Register UINib for the CollectionView
        Proxy.shared.registerCollViewNib(self.collectionView, nibName: ReusableCellIdentifiers.homeCollectionViewCellIdentifier, identifierCell: ReusableCellIdentifiers.homeCollectionViewCellIdentifier)
        let loadingReusableNib = UINib(nibName: ReusableCellIdentifiers.collectionViewLoaderIdentifier, bundle: nil)
        self.collectionView.register(loadingReusableNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: ReusableCellIdentifiers.loadingresuableviewidIdentifier)
    }
    func setOfflineUI() {   // Set Offline UIView when Internet is turned Off
        if let manager = NetworkReachabilityManager(), !manager.isReachable {
            self.searchButton.isHidden = true
            self.filterButton.isHidden = true
            self.allpatternsView.isHidden = true
            self.myfolderView.isHidden = false
            self.myfolderView.isUserInteractionEnabled = false
            self.myFolderUnderLineLbl.isHidden = false
            self.myFoldersLabel.textColor = ColorHandler.allpatternLableColor
            Proxy.shared.dismissLottie()
            self.myFoldersLabel.text = FormatsString.offlinepatterns
            if CommonConst.guestUserCheck {
                self.navigationtitleLabel.text = "\(FormatsString.PatternLibrary) (\(self.myLibraryViewModel.trailPatternArray.count))"
            } else {
                self.navigationtitleLabel.text = !self.myLibraryViewModel.offlinePattern.isEmpty ? "\(FormatsString.PatternLibrary) (\(self.myLibraryViewModel.offlinePattern.count))": (!self.myLibraryViewModel.trailPatternArray.isEmpty ? "\(FormatsString.PatternLibrary) (\(self.myLibraryViewModel.trailPatternArray.count))": "\(FormatsString.PatternLibrary) (0)")
            }
        }
    }
    func setOnlineUI() {   // Set Online UIView when Internet is turned On
        self.searchButton.isHidden = false
        self.filterButton.isHidden = false
        self.allpatternsView.isHidden = false
        self.myfolderView.isHidden = false
        self.myfolderView.isUserInteractionEnabled = true
        self.myFolderUnderLineLbl.isHidden = true
        self.allPatternsLabel.textColor = ColorHandler.allpatternLableColor
        self.myFoldersLabel.textColor = ColorHandler.myfolderLableColor
        self.allPatternsUnderLineLbl.isHidden = false
        self.myFoldersLabel.text = FormatsString.myfolders
        if CommonConst.guestUserCheck {
            self.navigationtitleLabel.text = "\(FormatsString.PatternLibrary) (\(self.myLibraryViewModel.objMylibData.prod.count))"
        } else {
            self.navigationtitleLabel.text = "\(FormatsString.PatternLibrary) (\(self.myLibraryViewModel.objMylibData.totalPatternCount))"
            self.isLoading = false
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
        self.navigationController?.navigationBar.isHidden = true
        self.tabBarController?.tabBar.isHidden = false
        self.myLibraryViewModel.objMylibData = self.objMylibraryData
    }
    override func viewDidAppear(_ animated: Bool) {
        self.myLibraryViewModel.DBFetch()
        if let manager = NetworkReachabilityManager(), manager.isReachable {
            self.navigationtitleLabel.text = self.canSearchandFilterFolder ? "\(self.selectedFolderName) (\(self.objMylibraryData.totalPatternCount))": "\(FormatsString.PatternLibrary) (\(self.objMylibraryData.totalPatternCount))"
        } else {
            self.navigationtitleLabel.text = !self.myLibraryViewModel.offlinePattern.isEmpty ? "\(FormatsString.PatternLibrary) (\(self.myLibraryViewModel.offlinePattern.count))" : (!self.myLibraryViewModel.trailPatternArray.isEmpty ? "\(FormatsString.PatternLibrary) (\(self.myLibraryViewModel.trailPatternArray.count))" : "\(FormatsString.PatternLibrary) (0)")
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.title = " "
        self.navigationController?.navigationBar.isHidden = false
        CommonConst.userDefault.set(false, forKey: IsInPage.myLibrary.rawValue)
    }
    @objc func tapClearResponse(recognizer: UITapGestureRecognizer) {   // Clear Filter Response
        self.pageID = 1
        self.syncTapped(self.syncButton)
    }
    func closeSearchText() {   // Dismiss the search bar
        self.myLibraryViewModel.isSearching = false
        if let searchText = self.searchText {
            searchText.removeFromSuperview()
        }
        self.navigationLabelXContraint.constant = 0
        self.collectionView.reloadData()
    }
    func searchAPICall(searchText: String) {   // Search for a Pattern in the list
        self.pageID = 1
        let prodFilter = CommonConst.userDefault.object([String: [String]].self, with: CommonConst.SelectedFilterObjectss)
        DispatchQueue.main.async {
            self.myLibraryViewModel.getMyLibraryData(atributeType: .myLibrary, prodfilter: prodFilter != nil ? prodFilter!: [:], cleareProdArray: true, pageid: FormatsString.oneLabel, searchStr: "\(searchText)") { (response) in
                self.filterResultView.isHidden = (response.prod.isEmpty && prodFilter != nil) ? true: false
                if self.canSearchandFilterFolder {
                    self.navigationtitleLabel.text = "\(self.selectedFolderName) (\(response.totalPatternCount))"
                } else {
                    self.navigationtitleLabel.text = "\(FormatsString.PatternLibrary) (\(response.totalPatternCount))"
                    self.searchResultCountLabel.text = response.totalPatternCount > 9 ? "\(FormatsString.showfilterResults) (\(response.totalPatternCount))": "\(FormatsString.showfilterResults) (0\(response.totalPatternCount))"
                }
                self.collectionView.reloadData()
            }
        }
    }
    func searchOrFilterInFolder(fromSearchOnlyinFolder: Bool=false, filterInFolderisNill: Bool = false, canHideTab: Bool = false, cancelTappedWhenSearchinFilterFolder: Bool = false, isfromFilter: Bool = false, searchText: String, folderName: String = FormatsString.emptyString, isfilternillwhenappliied: Bool = false) {   // Search/sync Function inside the Folder Tab
        self.pageID = 1
        var prodFilter = CommonConst.userDefault.object([String: [String]].self, with: CommonConst.SelectedFilterObjectss)
        var produtFilterisEmpty: Bool = false
        if isfromFilter || filterInFolderisNill {
            prodFilter?.removeAll()
            self.myLibraryViewModel.removeFilterUserDefaults()
            self.filterButton.isSelected = false
            produtFilterisEmpty = true
        }
        if fromSearchOnlyinFolder && prodFilter == nil {
            produtFilterisEmpty = true
        }
        let updatedFolderName = folderName == FormatsString.favorite ? "\(folderName)": "\(self.selectedFolderName)"
        DispatchQueue.main.async {
            self.myLibraryViewModel.getMyLibraryData(atributeType: .onClickFolder, prodfilter: prodFilter != nil ? prodFilter!: [:], cleareProdArray: true, pageid: FormatsString.oneLabel, foldername: "\(updatedFolderName)", searchStr: searchText) { (response) in
                self.filteredResultinFolderisNull = false
                self.shouldhideIndicationLbl = false
                let folderNameAfterResponse = folderName == FormatsString.favorite ? "\(FormatsString.favorite)s": folderName
                if !response.prod.isEmpty && !produtFilterisEmpty && !isfromFilter {
                    if isfilternillwhenappliied {
                        self.topViewHeightConstraint.constant = 0
                        self.activeProjectView.isHidden = true
                        self.searchResultCountLabel.isHidden = true
                    } else {
                        self.topViewHeightConstraint.constant = 30
                        self.activeProjectView.isHidden = false
                        self.searchResultCountLabel.isHidden = false
                    }
                    self.searchResultCountLabel.text = response.totalPatternCount > 9 ? "\(FormatsString.showfilterResults) (\(response.totalPatternCount))" : "\(FormatsString.showfilterResults) (0\(response.totalPatternCount))"
                } else if response.prod.isEmpty && !produtFilterisEmpty && !isfromFilter {
                    self.topViewHeightConstraint.constant = 30
                    self.activeProjectView.isHidden = false
                    self.searchResultCountLabel.isHidden = false
                    self.shouldhideIndicationLbl = true
                    self.searchResultCountLabel.text = response.totalPatternCount > 9 ? "\(FormatsString.showfilterResults) (\(response.totalPatternCount))": "\(FormatsString.showfilterResults) (0\(response.totalPatternCount))"
                } else if self.myLibraryViewModel.myFolderArray.contains(folderNameAfterResponse) && produtFilterisEmpty && isfromFilter {
                    self.topViewHeightConstraint.constant = UIDevice.isPad ? 30: 0
                    self.activeProjectView.isHidden = true
                    self.searchResultCountLabel.isHidden = true
                } else {
                    self.topViewHeightConstraint.constant = UIDevice.isPad ? 30: 0
                    self.activeProjectView.isHidden = true
                    self.searchResultCountLabel.isHidden = true
                    self.filteredResultinFolderisNull = true
                    if isfromFilter && !cancelTappedWhenSearchinFilterFolder {
                        self.canSearchandFilterFolder = false
                    }
                }
                self.navigationtitleLabel.text = self.canSearchandFilterFolder ? "\(self.selectedFolderName) (\(response.totalPatternCount))" : "\(FormatsString.PatternLibrary) (\(response.totalPatternCount))"
                self.allpatternsView.isHidden = canHideTab ? true: false
                self.myfolderView.isHidden = canHideTab ? true: false
                self.collectionView.reloadData()
            }
        }
    }
    func syncAPICall(whenAllPatterntappedfromFolder: Bool = false, needtoclearFilter: Bool) {   // Hit Sync Api when inside Mylibrary
        self.pageID = 1
        self.isLoading = false
        if needtoclearFilter {
            CommonConst.userDefault.removeObject(forKey: CommonConst.SelectedFilterObjectss)
            self.filterButton.isSelected = false
        }
        let prodFilter =  CommonConst.userDefault.object([String: [String]].self, with: CommonConst.SelectedFilterObjectss)
        DispatchQueue.main.async {
            self.myLibraryViewModel.getMyLibraryData(atributeType: .sync, prodfilter: prodFilter != nil ? prodFilter!: [:], cleareProdArray: true, pageid: FormatsString.oneLabel) { (response) in
                if needtoclearFilter {
                    self.myLibraryViewModel.removeFilterUserDefaults()
                    self.filterButton.isSelected = false
                    self.filterappliedinPatternLibrary = false
                }
                self.filterResultView.isHidden = (response.prod.isEmpty && prodFilter != nil) ? true: false
                self.navigationtitleLabel.text = self.folderSwitch ? FormatsString.myfolders: "\(FormatsString.PatternLibrary) (\(self.objMylibraryData.totalPatternCount))"
                if !self.folderSwitch {
                    self.searchResultCountLabel.text = response.totalPatternCount > 9 ? "\(FormatsString.showfilterResults) (\(response.totalPatternCount))" : "\(FormatsString.showfilterResults) (0\(response.totalPatternCount))"
                }
                if whenAllPatterntappedfromFolder {
                    self.folderSwitch = false
                    self.whenAllPatternsTapped = false
                    self.collectionView.reloadData()
                    self.myFolderUnderLineLbl.isHidden = true
                    self.allPatternsUnderLineLbl.isHidden = false
                    self.navigationtitleLabel.text = "\(FormatsString.PatternLibrary) (\(self.objMylibraryData.totalPatternCount))"
                    self.allPatternsLabel.textColor = ColorHandler.allpatternLableColor
                    self.myFoldersLabel.textColor = ColorHandler.myfolderLableColor
                }
                self.setOnlineUI()
                self.allpatternsView.isHidden = false
                self.myfolderView.isHidden = false
                self.canSearchandFilterFolder = false
                self.collectionView.reloadData()
            }
        }
    }
    func moveToMyFolder() {   // Load MyFolder related items collection view datas
        defer {
            self.searchController.isActive = false
            self.allpatternsView.isHidden = false
            self.myfolderView.isHidden = false
        }
        self.isInFolder = true
        self.myLibraryViewModel.myFolderArray.removeAll()
        if !self.myLibraryViewModel.folderData.folderNameArray.isEmpty {
            self.myLibraryViewModel.myFolderArray = self.myLibraryViewModel.folderData.folderNameArray
        }
        self.myLibraryViewModel.addDefaultFolders()
        self.folderSwitch = true
        self.myFolderUnderLineLbl.isHidden = false
        self.allPatternsUnderLineLbl.isHidden = true
        self.navigationtitleLabel.text = FormatsString.myfolders
        self.allPatternsLabel.textColor = ColorHandler.myfolderLableColor
        self.myFoldersLabel.textColor = ColorHandler.allpatternLableColor
        self.myLibraryViewModel.removeFilterUserDefaults()
        self.filterButton.isSelected = false
        if self.filterappliedinPatternLibrary {
            self.topViewHeightConstraint.constant = UIDevice.isPad ? 30: 0
            self.activeProjectView.isHidden = true
            self.searchResultCountLabel.isHidden = true
        }
        self.collectionView.reloadData()
    }
    func filter(searchText: String) {   // Filter Action Applied to patterns
        self.myLibraryViewModel.filterdpatternDBArray = myLibraryViewModel.patternDBArray.filter({ (pattern) -> Bool in
            if searchText != FormatsString.emptyString {
                let searchTextMatch = pattern.patternTitle?.lowercased().contains(searchText.lowercased())
                self.myLibraryViewModel.isSearching = true
                self.activeProjectView.isHidden = false
                self.searchResultCountLabel.isHidden = false
                return searchTextMatch ?? false
            }
            self.myLibraryViewModel.isSearching = false
            return false
        })
        self.topViewHeightConstraint.constant = 30
        self.searchResultCountLabel.text = self.myLibraryViewModel.filterdpatternDBArray.count > 9 ? "\(FormatsString.showfilterResults) (\(self.myLibraryViewModel.filterdpatternDBArray.count))": "\(FormatsString.showfilterResults) (0\(self.myLibraryViewModel.filterdpatternDBArray.count))"
        self.collectionView.reloadData()
    }
    func buttonClickAction(label: UILabel, view: UIView, type: String, sender: UIButton) {
        label.textColor = UIColor.white
        view.backgroundColor = UIColor.black
        self.deSelectRestOfButtons(sender: sender)
        _ = self.myLibraryViewModel.butonActionFunction(type: type)
    }
    func deSelectRestOfButtons(sender: UIButton) {
        switch sender {
        case allPatternsButton, addProjectButton:
            self.addProjectButton.isHidden = true
            self.myLibraryViewModel.DBFetch()
        case activeProjectButton:
            self.noActivityLabel.text = self.myLibraryViewModel.noActivityActiveLabel
            self.allPatternsView.backgroundColor = UIColor.white
            self.completedProjectLabel.textColor = UIColor.darkGray
            self.completedProjectView.backgroundColor = UIColor.white
        case completedProjectButton:
            self.allPatternsView.backgroundColor = UIColor.white
            self.activeProjectLabel.textColor = UIColor.darkGray
            self.activeProjectView.backgroundColor = UIColor.white
        default:
            break
        }
    }
    func goToPatternInstructions(index: Int) {   // Open Pattern Instruction Page
        if let patternDesc = Constants.patternDescription.instantiateViewController(withIdentifier: StoryBoardType.patternDescription.rawValue) as? PatternDescriptionViewController {
            var libraryPattern = MyLibraryPatterns()
            if let manager = NetworkReachabilityManager(), manager.isReachable {
                patternDesc.patternDesViewModel.customisedNameList = [FormatsString.addcustomisation]
                if self.objMylibraryData.prod.isEmpty {
                    guard !self.objMylibraryData.prod.isEmpty, self.objMylibraryData.prod.indices.contains(index) else {
                        return
                    }
                    libraryPattern = self.objMylibraryData.prod[index]
                } else {
                    guard !self.objMylibraryData.prod.isEmpty, self.objMylibraryData.prod.indices.contains(index) else {
                        self.view.makeToast(AlertMessage.datafetchFailAlert)
                        return
                    }
                    libraryPattern = self.objMylibraryData.prod[index]
                }
            } else {
                if !self.myLibraryViewModel.offlinePattern.isEmpty, self.myLibraryViewModel.offlinePattern.indices.contains(index) {
                    libraryPattern = self.myLibraryViewModel.offlinePattern[index]
                } else {
                    guard !self.objMylibraryData.prod.isEmpty, self.objMylibraryData.prod.indices.contains(index) else {
                        self.view.makeToast(FormatsString.patternNotdownloaded)
                        return
                    }
                    libraryPattern = self.objMylibraryData.prod[index]
                }
            }
            if libraryPattern.status == FormatsString.OWNED {
                patternDesc.patternDesViewModel.isOwned = true
            } else if libraryPattern.status == FormatsString.EXPIRED {
                patternDesc.patternDesViewModel.isExpired = true
            } else if libraryPattern.status == FormatsString.PAUSED {
                patternDesc.patternDesViewModel.isPaused = true
            } else {
                patternDesc.patternDesViewModel.isOwned = false
            }
            patternDesc.patternDesViewModel.productId = libraryPattern.id
            patternDesc.patternDesViewModel.patternTitle = libraryPattern.name
            patternDesc.patternDesViewModel.patternDescription = libraryPattern.prodDescription
            patternDesc.patternDesViewModel.tailornovaDesignId =  libraryPattern.tailornovaDesignID
            patternDesc.patternDesViewModel.descriptionImageURL = libraryPattern.image
            patternDesc.patternDesViewModel.patternBrand = libraryPattern.brand
            patternDesc.patternDesViewModel.savednotes = libraryPattern.notes
            patternDesc.patternType = libraryPattern.patternType
            patternDesc.patternDesViewModel.orderNo = libraryPattern.orderNo
            patternDesc.patternDesViewModel.dropPieceArray = libraryPattern.dropPieceArray
            patternDesc.patternDesViewModel.selectedTabCategory = libraryPattern.selectedTabCategory
            if libraryPattern.patternType != FormatsString.Trial {
                patternDesc.patternDesViewModel.tailornovamannequinIDArray = libraryPattern.mannequinIDArray
                patternDesc.patternDesViewModel.purchasedSizeId = libraryPattern.purchasedSizeID
            }
            if self.myLibraryViewModel.fetchType == Constants.fromAllPatterns {
                patternDesc.patternDesViewModel.currentSelectedPatterny = self.myLibraryViewModel.pattern
                patternDesc.patternDesViewModel.screenType = Constants.fromAllPatterns
            } else if self.myLibraryViewModel.fetchType == Constants.fromCOMPLETED {
                patternDesc.patternDesViewModel.currenSelectedWorkspace = self.myLibraryViewModel.workSpace!
                patternDesc.patternDesViewModel.currentSelectedPatterny = self.myLibraryViewModel.workSpace!.parentPattern!
                patternDesc.patternDesViewModel.screenType = Constants.fromCOMPLETED
            } else {
                patternDesc.patternDesViewModel.currenSelectedWorkspace = self.myLibraryViewModel.workSpace!
                patternDesc.patternDesViewModel.currentSelectedPatterny = self.myLibraryViewModel.workSpace!.parentPattern!
                patternDesc.patternDesViewModel.screenType = Constants.fromActive
            }
            patternDesc.patternDesViewModel.patternType = libraryPattern.patternType
            patternDesc.patternDesViewModel.subscriptionExpiryDate = libraryPattern.subscriptionExpiryDate
            patternDesc.patternDesViewModel.tailornovaDesignName = libraryPattern.tailornovaDesignName
            patternDesc.patternDesViewModel.patternSize = libraryPattern.size
            patternDesc.patternDesViewModel.patternStatus = libraryPattern.status
            patternDesc.patternDesViewModel.yardageDetails = libraryPattern.yardagedetails
            patternDesc.patternDesViewModel.notionDetails = libraryPattern.notiondetails
            patternDesc.patternDesViewModel.yardagePdfUrl = libraryPattern.yardagePdfUrl
            patternDesc.patternDesViewModel.lastModifiedSizeDate = libraryPattern.lastModifiedSizeDate
            patternDesc.patternDesViewModel.customSizeFitName = libraryPattern.customSizeFitName
            patternDesc.patternDesViewModel.selectedSizeName = libraryPattern.selectedSizeName
            patternDesc.patternDesViewModel.selectedViewCupSizeName = libraryPattern.selectedViewCupSizeName
            self.myLibraryViewModel.currentSelectedPatternIndex = index
            self.navigationController?.pushViewController(patternDesc, animated: true)
        }
    }
    func goToWorkspace() {   // Open Workspace Page
        if let workspaceViewController = Constants.workspaceStoryBoard.instantiateViewController(withIdentifier: Constants.WorkspaceBaseViewControllerIdentifier) as? WorkspaceBaseViewController, let workspace = self.myLibraryViewModel.workSpace {
            workspaceViewController.objNewWorkSpaceBaseViewModel.workSpace = workspace
            workspaceViewController.objNewWorkSpaceBaseViewModel.screenType = Constants.fromActive
            self.navigationController?.pushViewController(workspaceViewController, animated: true)
        }
    }
    // MARK: - UI COMPONENT ACTIONS
    @IBAction func addProjectButtonClicked(_ sender: UIButton) {
        self.allPatternsView.backgroundColor = UIColor.black
        self.addProjectView.isHidden = true
        self.deSelectRestOfButtons(sender: sender)
    }
    @IBAction func allPatternsButtonClicked(_ sender: UIButton) {
        self.buttonClickAction(label: allPatternsLabel, view: allPatternsView, type: "AllPatterns", sender: sender)
    }
    @IBAction func completedProjectsButtonCliked(_ sender: UIButton) {
        self.buttonClickAction(label: completedProjectLabel, view: completedProjectView, type: "Completed", sender: sender)
    }
    @IBAction func allPatternsClicked(_ sender: UIButton) {   // Load normal mylibrary collection view datas
        self.isInFolder = false
        if self.whenAllPatternsTapped || self.canSearchandFilterFolder {
            self.syncAPICall(whenAllPatterntappedfromFolder: true, needtoclearFilter: true)
            self.topViewHeightConstraint.constant = UIDevice.isPad ? 30: 0
            self.activeProjectButton.isHidden = true
            self.activeProjectView.isHidden = true
            self.searchResultCountLabel.isHidden = true
        } else {
            self.folderSwitch = false
            self.myFolderUnderLineLbl.isHidden = true
            self.allPatternsUnderLineLbl.isHidden = false
            self.navigationtitleLabel.text = "\(FormatsString.PatternLibrary) (\(self.objMylibraryData.totalPatternCount))"
            self.allPatternsLabel.textColor = ColorHandler.allpatternLableColor
            self.myFoldersLabel.textColor = ColorHandler.myfolderLableColor
            self.topViewHeightConstraint.constant = self.filterappliedinPatternLibrary ? 30 : (UIDevice.isPad ? 30: 0)
            self.activeProjectView.isHidden = self.filterappliedinPatternLibrary ? false: true
            self.searchResultCountLabel.isHidden = self.filterappliedinPatternLibrary ? false: true
            self.collectionView.reloadData()
        }
    }
    @IBAction func myFolderClicked(_ sender: UIButton) {   // Move to Myfolders Tab
        if CommonConst.guestUserCheck {
            ServiceManagerProxy.shared.displayerrorPopup(url: FormatsString.emptyString, responseError: MessageString.guestusernotAllowed)
        } else {
            if self.myLibraryViewModel.apimyFolderCompleted {
                self.moveToMyFolder()
            } else {
                self.myLibraryViewModel.getFolder { _ in
                    self.moveToMyFolder()
                    self.myLibraryViewModel.apimyFolderCompleted = true
                }
            }
        }
    }
    @IBAction func backButtonAction(_ sender: UIButton) {   // Go back to Home Page
        if self.canSearchandFilterFolder {   // Load MyFolder related items collection view datas
            self.folderSwitch = true
            self.canSearchandFilterFolder = false
            self.topViewHeightConstraint.constant = UIDevice.isPad ? 30: 0
            self.activeProjectView.isHidden = true
            self.searchResultCountLabel.isHidden = true
            self.whenAllPatternsTapped = true
            self.myLibraryViewModel.removeFilterUserDefaults()
            self.filterButton.isSelected = false
            self.myLibraryViewModel.myFolderArray.removeAll()
            self.myLibraryViewModel.myFolderArray = self.myLibraryViewModel.folderData.folderNameArray
            self.myLibraryViewModel.addDefaultFolders()
            self.isinFavoriteFolder = false
            self.myFolderUnderLineLbl.isHidden = false
            self.allPatternsUnderLineLbl.isHidden = true
            self.navigationtitleLabel.text = FormatsString.myfolders
            self.collectionView.reloadData()
        } else {
            if let manager = NetworkReachabilityManager(), manager.isReachable {
                self.syncAPICall(needtoclearFilter: true)
                self.myLibVCDelegate?.reloadfromMyLibVC()
            } else {
                self.myLibVCDelegate?.setofflinepatternsfromMylibrary(networkStatus: false)
            }
            if KAppDelegate.isFromUniversalLinking {
                CommonConst.navCheckValue = 1
                self.rootWithDrawer(mainVCStoryboard: .dashboard, mainVCIdentifier: Constants.HomeViewControllerIdentifier, sideVCStoryboard: .dashboard, sideVCIdentifier: Constants.HamburgerViewControllerIdentifier)
                KAppDelegate.goToMyLibrary = false
                KAppDelegate.isFromUniversalLinking = false
            } else {
                self.pop()
            }
        }
    }
    @IBAction func serchTapped(_ sender: UIButton) {   // Search button tapped
        if CommonConst.guestUserCheck {
            ServiceManagerProxy.shared.displayerrorPopup(url: FormatsString.emptyString, responseError: MessageString.guestusernotAllowed)
        } else {
            self.setSearchVC()
        }
    }
    @IBAction func filterTapped(_ sender: UIButton) {   // Filter Button Tapped
        if CommonConst.guestUserCheck {
            ServiceManagerProxy.shared.displayerrorPopup(url: FormatsString.emptyString, responseError: MessageString.guestusernotAllowed)
        } else {
            DispatchQueue.main.async {
                self.closeSearchText()
                let filterViewController = Constants.myLibrary.instantiateViewController(withIdentifier: Constants.FilterViewControllerIdentifier) as? FilterViewController
                filterViewController!.modalPresentationStyle = .overFullScreen
                filterViewController!.updatedFilterObj = self.objMylibraryData.filter
                filterViewController!.delegate = self
                if self.presentedViewController == nil {
                    self.present(filterViewController!, animated: false, completion: nil)
                }
            }
        }
    }
    @IBAction func syncTapped(_ sender: UIButton) {   // Sync all patterns in the Library
        self.topViewHeightConstraint.constant = UIDevice.isPad ? 30: 0
        self.activeProjectButton.isHidden = true
        self.activeProjectView.isHidden = true
        self.searchResultCountLabel.isHidden = true
        let updateFolerName = self.isinFavoriteFolder ? FormatsString.favorite : self.selectedFolderName
        if self.canSearchandFilterFolder {
            if sender.tag == 1 {
                if self.filteredResultinFolderisNull {
                    if self.isInFolder {  // If synced while coming from offline to online when in folder
                        self.searchOrFilterInFolder(filterInFolderisNill: true, searchText: FormatsString.emptyString, folderName: "\(updateFolerName)")
                    } else {
                        self.syncAPICall(needtoclearFilter: true)
                    }
                } else {
                    if self.isInFolder { // If synced while coming from offline to online when in folder
                        self.searchOrFilterInFolder(filterInFolderisNill: true, searchText: FormatsString.emptyString, folderName: "\(updateFolerName)")
                    } else {
                        self.syncAPICall(needtoclearFilter: true)
                    }
                }
            } else {
                self.searchOrFilterInFolder(isfromFilter: true, searchText: FormatsString.emptyString, folderName: "\(updateFolerName)")
            }
        } else {
            if self.navigationtitleLabel.text == FormatsString.myfolders {
                self.myLibraryViewModel.getFolder(completion: { _ in
                    self.myFolderClicked(UIButton())
                })
            } else {
                if CommonConst.guestUserCheck {   // Guest User
                    if let manager = NetworkReachabilityManager(), manager.isReachable {
                        self.setOnlineUI()
                        self.showLottie()
                        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                            self.dismissLottie()
                        }
                    } else {
                        Proxy.shared.openSettingApp()
                    }
                } else {
                    if let manager = NetworkReachabilityManager(), manager.isReachable {
                        self.syncAPICall(needtoclearFilter: true)
                    } else {
                        Proxy.shared.openSettingApp()
                        self.setpatterns(network: false)
                    }
                }
                self.syncButton.tag = 0
            }
        }
        self.searchController.dismiss(animated: true)
    }
    @IBAction func hamburgerAction(_ sender: UIButton) {   // Open Hamburger Menu
        KAppDelegate.sideMenuVC.openRight()
    }
}
// MARK: - CollectionView Delegates
extension MyLibrarryViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.folderSwitch {
            let aarrayCount = self.myLibraryViewModel.myFolderArray.count
            self.noPatternsAvailableView.isHidden = (aarrayCount == 0 && !self.shouldhideIndicationLbl) ? false : true
            return aarrayCount
        } else {
            var aarrayCount = Int()
            if let manager = NetworkReachabilityManager(), manager.isReachable {
                aarrayCount = self.myLibraryViewModel.numOfItemsCollectionView()
            } else {   // loggedIn User: Guest User
                aarrayCount = !CommonConst.guestUserCheck ? self.myLibraryViewModel.offlinePattern.count : self.myLibraryViewModel.trailPatternArray.count
            }
            self.noPatternsAvailableView.isHidden = (aarrayCount == 0 && !self.shouldhideIndicationLbl) ? false : true
            return aarrayCount
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellsAcross = self.myLibraryViewModel.cellsAcross
        let spaceBetweenCells = self.myLibraryViewModel.spaceBetweenCells
        let width = (collectionView.frame.size.width / cellsAcross) - (spaceBetweenCells * (cellsAcross - 1))
        let dim = (collectionView.bounds.width - (cellsAcross - 1) * spaceBetweenCells) / cellsAcross
        return CGSize(width: width, height: dim)
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReusableCellIdentifiers.homeCollectionViewCellIdentifier, for: indexPath) as? HomeCollectionViewCell
        let returncell = self.myLibraryViewModel.cellOfCollectionView(addtofolderimgstatus: self.canSearchandFilterFolder, cell: cell!, index: indexPath.row)
        if let manager = NetworkReachabilityManager() {
            self.searchButton.isHidden = self.folderSwitch ? true : manager.isReachable ? false : true
            self.filterButton.isHidden = self.folderSwitch ? true : manager.isReachable ? false : true
        }
        return returncell
    }
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if self.objMylibraryData.currentPageID < self.objMylibraryData.totalPageCount && indexPath.row == self.objMylibraryData.prod.count - 1 {
            self.pageID += 1
            self.loadMoreData()
        }
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row >= 0 {
            if self.folderSwitch {
                if indexPath.row == 0 {
                    self.myLibraryViewModel.createOrRenameFolderAlert(screentype: ScreenTypeString.myLibraryFolder)
                } else {
                    if !self.myLibraryViewModel.myFolderArray.isEmpty && self.myLibraryViewModel.myFolderArray.indices.contains(indexPath.row) {
                        let foldername = self.myLibraryViewModel.myFolderArray[indexPath.row]
                        self.myLibraryViewModel.onClickFolder(folderName: foldername) { _ in  // Load normal mylibrary collection view datas
                            self.folderSwitch = false
                            self.canSearchandFilterFolder = true
                            self.syncButton.tag = 1
                            self.myFolderUnderLineLbl.isHidden = false
                            self.allPatternsUnderLineLbl.isHidden = true
                            self.selectedFolderIndex = indexPath.row
                            self.pageID = 1
                            self.selectedFolderName = self.myLibraryViewModel.myFolderArray[indexPath.row]
                            self.isinFavoriteFolder = indexPath.row == 2 ? true: false
                            self.navigationtitleLabel.text = "\(self.myLibraryViewModel.myFolderArray[indexPath.row]) (\(self.myLibraryViewModel.objMylibData.totalPatternCount))"
                            self.allPatternsLabel.textColor = ColorHandler.myfolderLableColor
                            self.myFoldersLabel.textColor = ColorHandler.allpatternLableColor
                            collectionView.reloadData()
                        }
                    }
                }
            } else {
                self.goToPatternInstructions(index: indexPath.row)
            }
        }
    }
}
