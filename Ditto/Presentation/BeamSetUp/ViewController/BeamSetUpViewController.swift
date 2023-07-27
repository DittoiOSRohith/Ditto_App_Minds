//
//  BeamSetUpViewController.swift
//  JoannTraceApp
//
//  Created by Infosys on 03/08/20.
//  Copyright © 2020 Infosys. All rights reserved.

import UIKit
import FastSocket
import FabricTraceTransformFrx

var textSize: CGFloat = UIDevice.isPad ? 18 : 14

class BeamSetUpViewController: UIViewController {
    //MARK: UI COMPONENT OUTLETS
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var previousLabel: UILabel!
    @IBOutlet weak var nextLabel: UILabel!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var beamSegment: UISegmentedControl!
    @IBOutlet weak var segmentHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var topspaceConstraint: NSLayoutConstraint!
    @IBOutlet weak var skipTutorialButton: UIButton!
    @IBOutlet weak var segmentContainerViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var beamSetUpLabel: UILabel!
    @IBOutlet weak var beamSetUpTakeDownLabel: UILabel!
    @IBOutlet weak var selctionDividerViewLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var beamSetUpSegmentHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var beamSetUpSegmentView: UIView!
    //MARK: VARIABLE DECLARATION
    var collectionView: UICollectionView!
    let beamSetUpViewModel = BeamSetupViewModel()
    @objc open dynamic var currentIndex: Int = 0 {
        didSet {
            self.updateAccessoryViews()
        }
    }
    //MARK: View Life Cycle Methods
    override func viewDidLoad() {
        self.configureNavTitle()
        UIFont.familyNames.sorted(by: {$0 < $1}).forEach({ print("\($0)"); UIFont.fontNames(forFamilyName: "\($0)").sorted(by: {$0 < $1}).forEach({ print("   \($0)") }) })
        super.viewDidLoad()
        if self.beamSetUpViewModel.ishandleBackForCamera {
            CommonConst.isFromInstructionbBackCheck = false
            CommonConst.intructionBackCheck = true
            CommonConst.userDefault.synchronize()
        }
        self.addCollectionView()
        self.registerSetUpNib()
        self.pageControl.clipsToBounds = true
        self.beamSetUpViewModel.fetchInstructionFormDataBase {
            self.reloadCollectionViewData()
        }
        self.beamSetUpSegmentHeightConstraint.constant = 0
        self.beamSetUpSegmentView.isHidden = true
        self.pageControl.isHidden = true
        self.nextButton.isHidden = true
        self.previousButton.isHidden = true
        self.previousLabel.isHidden = true
        self.nextLabel.isHidden = true
        self.title = self.beamSetUpViewModel.fetchType
        self.beamSetUpSegmentHeightConstraint.constant = self.beamSetUpViewModel.fetchType == TutorialDataFetchType.beamSetup ? UIDevice.isPad ? 70 : 50 : 0
        if self.beamSetUpViewModel.fetchType == TutorialDataFetchType.beamSetup {
            self.beamSetUpSegmentView.isHidden = false
            self.selctionDividerViewLeadingConstraint.constant = 44
            self.beamSetUpLabel.textColor =  UIColor.black
            self.beamSetUpTakeDownLabel.textColor = CustomColor.darkGrayColor
        }
        if CommonConst.navCheckValue == 1 {
            self.navigationItem.rightBarButtonItem = nil
        } else {
            self.skipTutorialButton.isHidden = self.beamSetUpViewModel.fromScreenType == FromScreenType.calibrationn.rawValue ? true : false
        }
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = false
        self.title = self.beamSetUpViewModel.fetchType
        self.navigationController?.navigationBar.tintColor = UIColor.black
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.addPageControl()
        self.hidePageControl(isHidden: true)
        self.beamSegment.isHidden = true
        self.segmentHeightConstraint.constant = (self.beamSetUpViewModel.fetchType == TutorialDataFetchType.beamSetup) ? (UIDevice.isPad ? 40 : 30) : 0
        self.topspaceConstraint.constant = (self.beamSetUpViewModel.fetchType == TutorialDataFetchType.beamSetup) ? (UIDevice.isPad ? 20 : 10) : 0
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.leftBarButtonItem = nil
        self.reloadCollectionViewData()
    }
    func registerSetUpNib() {   // Register UINib for collection view
        Proxy.shared.registerCollViewNib(self.collectionView, nibName: ReusableCellIdentifiers.beamSetUpCollectionViewCellIdentifier, identifierCell: ReusableCellIdentifiers.beamsetupCellIdentifier)
    }
    func updateAccessoryViews() {   // Handling pagecontrol selection and arrow button highlight based on page selected
        self.pageControl!.numberOfPages = self.collectionView.numberOfItems(inSection: 0)
        self.pageControl!.currentPage = self.currentIndex
        self.nextButton!.isEnabled = self.currentIndex < self.collectionView.numberOfItems(inSection: 0) - 1
        self.previousButton!.isEnabled = self.currentIndex > 0
        self.nextLabel.isEnabled = self.nextButton.isEnabled
        self.previousLabel.isEnabled = self.previousButton.isEnabled
    }
    func hidePageControl(isHidden: Bool) {   // Hiding Pagecontrol, previous and next buttons based on no: of screens present
        self.pageControl.isHidden = isHidden
        self.nextButton.isHidden = isHidden
        self.previousButton.isHidden = isHidden
        self.previousLabel.isHidden = isHidden
        self.nextLabel.isHidden = isHidden
    }
    func addPageControl() {   // AddPageControl to view if more than one screen in a tab
        if self.view.viewWithTag(TagValue.scrollTag) == nil {
            self.view.bringSubviewToFront(self.nextButton)
            self.view.bringSubviewToFront(self.previousButton)
            self.view.bringSubviewToFront(self.nextLabel)
            self.view.bringSubviewToFront(self.previousLabel)
            self.pageControl.currentPageIndicatorTintColor = UIColor.black
            self.beamSetUpViewModel.typeofScreen = self.beamSetUpViewModel.fetchType
            if self.beamSetUpViewModel.fetchType == TutorialDataFetchType.calibration || self.beamSetUpViewModel.fetchType == TutorialDataFetchType.connectivity {
                self.beamSetUpViewModel.selectedIndex = FormatsString.emptyString
            }
            let inst = self.beamSetUpViewModel.getArrayForSelectedIndex(selectedTabIndex: self.beamSetUpViewModel.selectedIndex,
                                                                        type: self.beamSetUpViewModel.typeofScreen)
            self.pageControl.numberOfPages = inst.count
            self.pageControl.pageIndicatorTintColor = UIColor.lightGray
            self.pageControl.currentPageIndicatorTintColor = (self.pageControl.numberOfPages == 1) ? UIColor.lightGray : CustomColor.activeLabel
            self.currentIndex = self.pageControl.currentPage
            self.hidePageControl(isHidden: (self.pageControl.numberOfPages == 0))
            self.view.bringSubviewToFront(self.pageControl)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.title = FormatsString.emptyString
    }
    //MARK: UI COMPONENT ACTIONS
    @IBAction func pageChanged(_ sender: UIPageControl) {   // Move to previous and next screen if more than one screen in a tab
        self.moveToPage(sender.currentPage, animated: true)
    }
    @IBAction func previousButtonClicked(_ sender: Any) {   // Previous button tap action if more than one screen in a tab
        self.moveToPage(currentIndex - 1, animated: true)
    }
    @IBAction func nextButtonClicked(_ sender: Any) {   // Next button tap action if more than one screen in a tab
        self.moveToPage(currentIndex + 1, animated: true)
    }
    @IBAction func beamTakeDownButtonClicked(_ sender: UIButton) {   // Beam Takedown Segment tap action
        self.selctionDividerViewLeadingConstraint.constant = 205
        self.beamSetUpLabel.textColor = CustomColor.darkGrayColor
        self.beamSetUpTakeDownLabel.textColor = AppColor.needleGrey
        self.beamSetUpViewModel.selectedIndex = FormatsString.oneLabel
        self.reloadCollectionViewData()
    }
    @IBAction func beamSetupButtonClicked(_ sender: UIButton) {   // Beam Setup Segment tap action
        self.selctionDividerViewLeadingConstraint.constant = 44
        self.beamSetUpLabel.textColor = AppColor.needleGrey
        self.beamSetUpTakeDownLabel.textColor = CustomColor.darkGrayColor
        self.beamSetUpViewModel.selectedIndex = FormatsString.zeroLabel
        self.reloadCollectionViewData()
    }
}
