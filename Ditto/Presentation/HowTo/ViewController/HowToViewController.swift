//
//  HowToViewController.swift
//  JoannTraceApp
//
//  Created by Keerthana Satheesh on 18/08/20.
//  Copyright © 2020 Infosys. All rights reserved.
//

import UIKit
import SDWebImage

class HowToViewController: UIViewController {
    //MARK: UI COMPONENT OUTLETS
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var segmentCollectionView: UICollectionView!
    @IBOutlet weak var pageComingSoonView: PageComingSoonView!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var previousLabel: UILabel!
    @IBOutlet weak var nextLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    //MARK: VARIABLE DECLARATION
    let objHowToViewModel = HowToViewModel()
    @objc open dynamic var currentIndex: Int = 0 {
        didSet {
            self.updateAccessoryViews()
        }
    }
    //MARK: View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hidePageControl(isHidden: true)
        self.configureNavTitle()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.pageComingSoonView.isHidden = true
        self.pageControl.tintColor = UIColor.black
        if CommonConst.navCheckValue == 1 {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        if self.view.viewWithTag(TagValue.pageControlTag) == nil {
            self.addCollectionView()
            self.registerSetUpNib()
            self.addPageControl()
        }
        self.objHowToViewModel.fetchAllInstructions {
            self.objHowToViewModel.tabTitles.removeAll()
            for inst in self.objHowToViewModel.instructionArray.filter({$0.instructionType == TutorialDataFetchType.howTo}) where !self.objHowToViewModel.tabTitles.contains(inst.tabName!) {
                self.objHowToViewModel.tabTitles.append(inst.tabName!)
            }
            self.segmentCollectionView.reloadData()
            self.objHowToViewModel.setUpcollectionView.reloadData()
        }
        self.refreshContent(index: objHowToViewModel.presentindex)
        self.segmentCollectionView?.selectItem(at: self.objHowToViewModel.howToIndexPath, animated: false, scrollPosition: .top)
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if self.objHowToViewModel.setUpcollectionView != nil {
            self.refreshContent(index: self.objHowToViewModel.presentindex)
        }
    }
    override func viewDidLayoutSubviews() {
        if self.objHowToViewModel.setUpcollectionView != nil {
            self.refreshContent(index: self.objHowToViewModel.presentindex)
        }
    }
    func registerSetUpNib() {
        Proxy.shared.registerCollViewNib(self.objHowToViewModel.setUpcollectionView, nibName: ReusableCellIdentifiers.beamSetUpCollectionViewCellIdentifier, identifierCell: ReusableCellIdentifiers.beamsetupCellIdentifier)
    }
    func updateAccessoryViews() {   // Handling pagecontrol selection and arrow button highlight based on page selected
        self.pageControl!.numberOfPages = self.objHowToViewModel.setUpcollectionView.numberOfItems(inSection: 0)
        self.pageControl!.currentPage = self.currentIndex
        self.nextButton!.isEnabled = self.currentIndex < self.objHowToViewModel.setUpcollectionView.numberOfItems(inSection: 0) - 1
        self.previousButton!.isEnabled = self.currentIndex > 0
        self.nextLabel.isEnabled = self.nextButton.isEnabled
        self.previousLabel.isEnabled = self.previousButton.isEnabled
    }
    func addPageControl() {   // AddPageControl to view if more than one screen in a tab
        self.pageControl.currentPageIndicatorTintColor = CustomColor.activeLabel
        self.pageControl.numberOfPages =  4
        self.pageControl.pageIndicatorTintColor = CustomColor.tutorialGrayColor
        self.view.bringSubviewToFront(self.nextButton)
        self.view.bringSubviewToFront(self.previousButton)
        self.view.bringSubviewToFront(self.nextLabel)
        self.view.bringSubviewToFront(self.previousLabel)
        self.view.bringSubviewToFront(self.pageControl)
    }
    func addCollectionView() {   // Adding collection view to window
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        self.objHowToViewModel.setUpcollectionView = UICollectionView(frame: self.baseView.frame, collectionViewLayout: layout)
        self.objHowToViewModel.setUpcollectionView.tag = 101
        self.objHowToViewModel.setUpcollectionView.dataSource = self
        self.objHowToViewModel.setUpcollectionView.delegate = self
        self.objHowToViewModel.setUpcollectionView.backgroundColor = UIColor.clear
        self.objHowToViewModel.setUpcollectionView.isPagingEnabled = true
        self.objHowToViewModel.setUpcollectionView.showsHorizontalScrollIndicator = false
        self.view.addSubview(self.objHowToViewModel.setUpcollectionView)
        self.addPageControl()
    }
    func getApiIndex(index: String) -> String {   // Calculating index of tab cells comparing index from API
        switch index {
        case FormatsString.zeroLabel:
            return FormatsString.zeroLabel
        case FormatsString.oneLabel:
            return FormatsString.oneLabel
        case FormatsString.twoLabel:
            return FormatsString.twoLabel
        case FormatsString.threeLabel:
            return FormatsString.threeLabel
        case FormatsString.fourLabel:
            return FormatsString.sixLabel
        default:
            return FormatsString.zeroLabel
        }
    }
    func refreshContent(index: Int) {   // Refreshing content of collection view based on cases
        self.objHowToViewModel.presentindex = index
        switch index {
        case 0:
            self.objHowToViewModel.setUpcollectionView.isHidden = false
            self.objHowToViewModel.collectionViewType = FormatsString.workspaceLabel
            self.objHowToViewModel.setUpcollectionView.reloadData()
            self.pageComingSoonView.isHidden = true
            self.pageControl.numberOfPages = self.objHowToViewModel.getArrayForSelectedIndex(selectedTabIndex: self.getApiIndex(index: "\(index)"), type: TutorialDataFetchType.howTo).count
            UIView.animate(withDuration: 0.5, delay: 0.0, animations: {
                self.objHowToViewModel.setUpcollectionView.scrollToItem(at: IndexPath(item: self.currentIndex, section: 0), at: .centeredHorizontally, animated: false)
            }, completion: nil)
        case 1:
            self.objHowToViewModel.collectionViewType = FormatsString.cuttingLabel
            self.objHowToViewModel.setUpcollectionView.reloadData()
            self.objHowToViewModel.setUpcollectionView.isHidden = false
            self.pageComingSoonView.isHidden = true
            self.pageControl.numberOfPages = self.objHowToViewModel.getArrayForSelectedIndex(selectedTabIndex: self.getApiIndex(index: "\(index)"), type: TutorialDataFetchType.howTo).count
            UIView.animate(withDuration: 0.5, delay: 0.0, animations: {
                self.objHowToViewModel.setUpcollectionView.scrollToItem(at: IndexPath(item: self.currentIndex, section: 0), at: .centeredHorizontally, animated: false)
            }, completion: nil)
        case 2:
            self.objHowToViewModel.collectionViewType = FormatsString.splicingLabel
            self.objHowToViewModel.setUpcollectionView.reloadData()
            self.objHowToViewModel.setUpcollectionView.isHidden = false
            self.pageComingSoonView.isHidden = true
            self.pageControl.numberOfPages = self.objHowToViewModel.getArrayForSelectedIndex(selectedTabIndex: self.getApiIndex(index: "\(index)"), type: TutorialDataFetchType.howTo).count
            UIView.animate(withDuration: 0.5, delay: 0.0, animations: {
                self.objHowToViewModel.setUpcollectionView.scrollToItem(at: IndexPath(item: self.currentIndex, section: 0), at: .centeredHorizontally, animated: false)
            }, completion: nil)
        case 3:
            self.objHowToViewModel.collectionViewType = FormatsString.mirroringLabel
            self.objHowToViewModel.setUpcollectionView.reloadData()
            self.objHowToViewModel.setUpcollectionView.isHidden = false
            self.pageComingSoonView.isHidden = true
            self.pageControl.numberOfPages = self.objHowToViewModel.getArrayForSelectedIndex(selectedTabIndex: self.getApiIndex(index: "\(index)"), type: TutorialDataFetchType.howTo).count
            UIView.animate(withDuration: 0.5, delay: 0.0, animations: {
                self.objHowToViewModel.setUpcollectionView.scrollToItem(at: IndexPath(item: self.currentIndex, section: 0), at: .centeredHorizontally, animated: false)
            }, completion: nil)
        default:
            self.objHowToViewModel.presentindex = 0
            self.objHowToViewModel.setUpcollectionView.isHidden = true
            self.hidePageControl(isHidden: true)
            self.pageControl.numberOfPages = 0
            self.pageComingSoonView.isHidden = false
        }
        self.hidePageControl(isHidden: !(pageControl.numberOfPages > 1))
        if self.pageControl.numberOfPages > 1 {
            self.pageControl.pageIndicatorTintColor =  CustomColor.tutorialGrayColor
            self.pageControl.currentPageIndicatorTintColor = CustomColor.activeLabel
        }
    }
    func moveToPage(_ page: Int, animated: Bool) {   // Screen scroll to previous and next logic
        if page < 0 || page >= self.objHowToViewModel.setUpcollectionView.numberOfItems(inSection: 0) {
            return
        }
        self.currentIndex = page
        UIView.animate(withDuration: 0.5, delay: 0.0, animations: {
            self.objHowToViewModel.setUpcollectionView.scrollToItem(at: IndexPath(item: self.currentIndex, section: 0), at: .centeredHorizontally, animated: false)
        }, completion: nil)
    }
    func hidePageControl(isHidden: Bool) {   // Hiding Pagecontrol, previous and next buttons based on no: of screens present
        self.pageControl.isHidden = isHidden
        self.nextButton.isHidden = isHidden
        self.previousButton.isHidden = isHidden
        self.previousLabel.isHidden = isHidden
        self.nextLabel.isHidden = isHidden
    }
    //MARK: UI COMPONENT ACTIONS
    @IBAction func previousButtonClicked(_ sender: Any) {   // Previous button tap action if more than one screen in a tab
        self.currentIndex -= 1
        self.moveToPage(self.currentIndex, animated: true)
    }
    @IBAction func nextButtonClicked(_ sender: Any) {   // Next button tap action if more than one screen in a tab
        self.currentIndex += 1
        self.moveToPage(self.currentIndex, animated: true)
    }
    @IBAction func pageControlAction(_ sender: UIPageControl) {   // Move to previous and next screen if more than one screen in a tab
        self.moveToPage(sender.currentPage, animated: true)
    }
    @objc func watchVideoButtonClicked() {   // Watch Video button tap action
        DispatchQueue.main.async {
            if let watchVideoController = Constants.loginStoryBoard.instantiateViewController(withIdentifier: Constants.AdvertisementVideoControllerIdentifier) as? AdvertisementVideoController {
                watchVideoController.modalPresentationStyle = .custom
                if self.objHowToViewModel.resourceName != FormatsString.emptyString {
                    watchVideoController.videoUrl = self.objHowToViewModel.resourceName
                    if self.objHowToViewModel.tabTitles.indices.contains(self.objHowToViewModel.selectedIndex) {
                        watchVideoController.videoTitle = self.objHowToViewModel.tabTitles[self.objHowToViewModel.selectedIndex]
                    }
                    watchVideoController.isFromSceen = ScreenTypeString.tutorial
                    if self.presentedViewController == nil {
                        self.present(watchVideoController, animated: true)
                    }
                }
            }
        }
    }
    @objc func pdfButtonClicked(_ sender: UIButton) {   // PDF Image button tap action
        if let tag = sender.tag as Int? {
            let inst = self.objHowToViewModel.getArrayForSelectedIndex(selectedTabIndex: "\(self.getApiIndex(index: "\(self.objHowToViewModel.selectedIndex)"))", type: TutorialDataFetchType.howTo)
            if inst.count > tag {
                let tutorialPdfUrl = inst[tag].tutorialPdfUrl ?? FormatsString.emptyString
                if !tutorialPdfUrl.isEmpty {
                    let fileName = "\(self.objHowToViewModel.tabTitles[self.objHowToViewModel.selectedIndex] + FormatsString.tutorialPdfLabel).pdf"
                    let documentsURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
                    let finalPath = documentsURL.appendingPathComponent("\(self.objHowToViewModel.tabTitles[self.objHowToViewModel.selectedIndex] + FormatsString.tutorialPdfLabel).pdf")
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
                                            if self.objHowToViewModel.tabTitles.indices.contains(self.objHowToViewModel.selectedIndex) {
                                                pdfViewController.patternInstViewModel.titleLable = self.objHowToViewModel.tabTitles[self.objHowToViewModel.selectedIndex]
                                            }
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
                                if self.objHowToViewModel.tabTitles.indices.contains(self.objHowToViewModel.selectedIndex) {
                                    pdfViewController.patternInstViewModel.titleLable = self.objHowToViewModel.tabTitles[self.objHowToViewModel.selectedIndex]
                                }
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
