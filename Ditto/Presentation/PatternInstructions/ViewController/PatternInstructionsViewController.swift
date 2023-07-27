//
//  PatternInstructionsViewController.swift
//  JoannTraceApp
//
//  Created by Abiya Joy on 15/04/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit
import PDFKit
import Alamofire

class PatternInstructionsViewController: UIViewController {
    //MARK: UI COMPONENT OUTLETS
    @IBOutlet weak var constraintHeigthNavBar: NSLayoutConstraint!
    @IBOutlet weak var labelNavTitle: UILabel!
    @IBOutlet weak var buttonBack: UIButton!
    //MARK: VARIABLE DECLARATION
    var patternInstViewModel = PatternInstructionsViewModel()
    //MARK: View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        if self.patternInstViewModel.fromTutorial {
            self.title = self.patternInstViewModel.titleLable
        }
        if let pdfpath = self.patternInstViewModel.loadPDFPath() {
            if let doc = PDFDocument(url: pdfpath) {
            self.loadPDF(document: doc)
        } else {
            self.displayErrorPopUp()
        }
    }
}
override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.constraintHeigthNavBar.constant = self.patternInstViewModel.isPresentedFromWorkSpace ? 50 : 0
    self.labelNavTitle.isHidden = self.patternInstViewModel.isPresentedFromWorkSpace ? false : true
    self.buttonBack.isHidden = self.patternInstViewModel.isPresentedFromWorkSpace ? false : true
    if self.patternInstViewModel.isPresentedFromWorkSpace {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    } else {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.navigationBar.isHidden = false
        let backButton = UIBarButtonItem()
        backButton.title = " "
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        self.navigationItem.rightBarButtonItem = nil
        self.tabBarController?.tabBar.isHidden = true
    }
}
override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    self.patternInstViewModel.disappearFunction()
}
func loadPDF(document: PDFDocument) {   // Loading PDF screen with proper constraints
    let pdfView = PDFView()
    self.view.addSubview(pdfView)
    pdfView.backgroundColor = UIColor.clear
    pdfView.translatesAutoresizingMaskIntoConstraints = false
    pdfView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
    pdfView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
    pdfView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
    pdfView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: self.patternInstViewModel.isPresentedFromWorkSpace ? 50 : 0).isActive = true
    pdfView.displayMode = .singlePageContinuous
    pdfView.document = document
}
func displayErrorPopUp() {   // Popup when Error inDownloading PDF
    DispatchQueue.main.async {
        let viewc = Constants.AlertWithImageAndButtons.instantiateViewController(identifier: Constants.AlertWithImageAndButonsVCIdentifier) as AlertWithImageAndButtonsViewController
        viewc.alertArray = [ConnectivityUtils.failedImage, AlertMessage.unabletoLoadFIle, AlertTitle.RETRY, AlertTitle.CANCEL, FormatsString.emptyString]
        viewc.screenType = ScreenTypeString.PatternDesc
        viewc.modalPresentationStyle = .overFullScreen
        viewc.onRetryPressed = {
            self.dismiss(animated: false, completion: nil)
            self.downloadPdfDocument()
        }
        viewc.onCancelPressed = {
            self.actionBack(UIButton())
        }
        if self.presentedViewController == nil {
            self.present(viewc, animated: false, completion: nil)
        }
    }
}
func downloadPdfDocument() {   // Downloading PDF
    let url = self.patternInstViewModel.mainURL
    let fileName = "\(self.patternInstViewModel.titleLable + FormatsString.instructionPdfLabel).pdf"
    let documentsURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
    let finalPath = documentsURL.appendingPathComponent(fileName)
    if let manager = NetworkReachabilityManager(), manager.isReachable {
        if url != FormatsString.emptyString {
            self.savePdf(urlString: url, fileName: fileName) { status in
                if status {
                    self.patternInstViewModel.fileURL = finalPath
                    if let pdfpath = self.patternInstViewModel.loadPDFPath() {
                        if let doc = PDFDocument(url: pdfpath) {
                            self.loadPDF(document: doc)
                        }
                    }
                } else {
                    do {
                        let fileManager = FileManager.default
                        if fileManager.fileExists(atPath: finalPath.path) {
                            try fileManager.removeItem(atPath: finalPath.path)
                        }
                    } catch _ as NSError {
                    }
                    self.displayErrorPopUp()
                }
            }
        }
    }
}
//MARK: UI COMPONENT ACTIONS
@IBAction func hamburgerAction(_ sender: UIBarButtonItem) {   // Hamburger menu action
    KAppDelegate.sideMenuVC.openRight()
}
@IBAction func actionBack(_ sender: UIButton) {   // back button action
    if self.patternInstViewModel.fromPatternDescription {
        self.pop()
    }
    if self.patternInstViewModel.isPresentedFromWorkSpace {
        self.dismiss(animated: true, completion: nil)
    }
}
}
