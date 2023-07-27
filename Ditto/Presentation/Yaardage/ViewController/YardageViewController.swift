//
//  YardageViewController.swift
//  Ditto
//
//  Created by Gokul Ramesh on 22/11/22.
//  Copyright © 2022 Infosys. All rights reserved.
//

import UIKit
import PDFKit

class YardageViewController: UIViewController {
    // MARK: - VARIABLE DECLARATION
    var yardageViewModel = YardageVIewModel()
    // MARK: - UI COMPONENT OUTLETS
    @IBOutlet weak var yardageHeaderLbl: UILabel!
    @IBOutlet weak var yardageTxtView: UITextView!
    @IBOutlet weak var notionLbl: UILabel!
    @IBOutlet weak var notionTxtView: UITextView!
    @IBOutlet weak var yardagePDFView: UIView!
    @IBOutlet weak var notionMainView: UIView!
    @IBOutlet weak var yardageMainView: UIView!
    @IBOutlet weak var pdfViewHeight: NSLayoutConstraint!
    // MARK: - View Life Cycle Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUI()
    }
    func setUI() {   // Setting up UI based on availability from API
        self.yardageMainView.isHidden = self.yardageViewModel.yardagePdfUrl.isEmpty ? self.yardageViewModel.yardageDetails.isEmpty ? true : false : true
        self.notionMainView.isHidden = self.yardageViewModel.yardagePdfUrl.isEmpty ? self.yardageViewModel.notionDetails.isEmpty ? true : false : true
        self.yardageTxtView.text = self.yardageViewModel.yardageDetails.getStringValueRemovingSpecialCharacter()
        self.yardagePDFView.isHidden = self.yardageViewModel.yardagePdfUrl.isEmpty ? true : false
        self.yardageTxtView.layoutIfNeeded()
        self.notionTxtView.text = self.yardageViewModel.notionDetails.getStringValueRemovingSpecialCharacter()
        self.notionTxtView.layoutIfNeeded()
        self.view.layoutIfNeeded()
        if !self.yardagePDFView.isHidden {
            let pdfpath = self.yardageViewModel.loadPDFPath()
            if let doc = PDFDocument(url: pdfpath!) {
                self.setpdfView(document: doc)
            } else {
                self.displayErrorPopUp()
            }
        } else {
            self.pdfViewHeight.constant = 0
        }
    }
    func setpdfView(document: PDFDocument) {   // Setting up the PDF view
        let pdfView = PDFView()
        self.yardagePDFView.addSubview(pdfView)
        pdfView.backgroundColor = UIColor.clear
        pdfView.translatesAutoresizingMaskIntoConstraints = false
        pdfView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        pdfView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
        pdfView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        pdfView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        pdfView.displayMode = .singlePageContinuous
        pdfView.document = document
    }
    func downloadPDF() {   // Download PDF file to show in offline case
        let url = self.yardageViewModel.yardagePdfUrl
        let fileName = "\(self.yardageViewModel.patternTitle + FormatsString.yardagePdfLabel).pdf"
        let documentsURL = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)[0]
        let finalPath = documentsURL.appendingPathComponent(fileName)
        if Network.reachability.isReachable {
            if url != FormatsString.emptyString {
                self.savePdf(urlString: url, fileName: fileName) { (status) in
                    if status {
                        self.yardageViewModel.fileURL = finalPath
                        let pdfpath = self.yardageViewModel.loadPDFPath()
                        if let doc = PDFDocument(url: pdfpath!) {
                            self.setpdfView(document: doc)
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
    func displayErrorPopUp() {   // Popup when Error inDownloading PDF
        DispatchQueue.main.async {
            let viewc = Constants.AlertWithImageAndButtons.instantiateViewController(identifier: Constants.AlertWithImageAndButonsVCIdentifier) as AlertWithImageAndButtonsViewController
            viewc.alertArray = [ConnectivityUtils.failedImage, AlertMessage.unabletoLoadFIle, AlertTitle.RETRY, AlertTitle.CANCEL, FormatsString.emptyString]
            viewc.screenType = ScreenTypeString.PatternDesc
            viewc.modalPresentationStyle = .overFullScreen
            viewc.onRetryPressed = {
                self.dismiss(animated: false, completion: nil)
                self.downloadPDF()
            }
            viewc.onCancelPressed = {
                self.pop()
            }
            if self.presentedViewController == nil {
                self.present(viewc, animated: false, completion: nil)
            }
        }
    }
    // MARK: - IBActions
    @IBAction func didClickBackButton(_ sender: Any) {   // Back button tap action
        self.pop()
    }
}
