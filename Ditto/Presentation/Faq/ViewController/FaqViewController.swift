//
//  FaqViewController.swift
//  Ditto
//
//  Created by Gaurav Rajan on 06/05/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit

class FaqViewController: UIViewController {
    //  MARK: UI COMPONENT OUTLETS
    @IBOutlet weak var faqTableView: UITableView!
    @IBOutlet weak var faqLbl: UILabel!
    @IBOutlet weak var faqUnderLine: UILabel!
    @IBOutlet weak var glossaryLbl: UILabel!
    @IBOutlet weak var glossaryUnderLine: UILabel!
    @IBOutlet weak var faqButton: UIButton!
    @IBOutlet weak var glossaryButton: UIButton!
    @IBOutlet weak var videoUnderLine: UILabel!
    @IBOutlet weak var videoLbl: UILabel!
    @IBOutlet weak var videoButton: UIButton!
    @IBOutlet weak var navBarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var additionalNavBarView: UIView!
    // MARK: VARIABLE DECLARATION
    var selectedSection = -1
    var objFaqViewModel = FaqViewModel()
    var selectedModel = 1
    // MARK: View LifeCycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = FormatsString.faqGlossaryLabel
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: CustomFont.avenirLtProMedium(size: UIDevice.isPhone ? 21 : 28) ?? UIFont.systemFont(ofSize: UIDevice.isPhone ? 21 : 28)]
        self.glossaryLbl.textColor = CustomColor.darkGrayColor
        self.glossaryUnderLine.isHidden = true
        self.videoLbl.textColor = CustomColor.darkGrayColor
        self.videoUnderLine.isHidden = true
        self.faqTableView.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.objFaqViewModel.getFaqData {
            DispatchQueue.main.async {
                self.faqTableView.reloadData()
            }
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navBarHeightConstraint.constant = !self.objFaqViewModel.isFromWorkspace || self.objFaqViewModel.isFromCalibFailure ? 0 : 50
        if !self.objFaqViewModel.isFromWorkspace || self.objFaqViewModel.isFromCalibFailure {
            self.additionalNavBarView.isHidden = true
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.async {
            self.faqTableView.reloadData()
        }
    }
    //MARK: UI COMPONENT ACTIONS
    @IBAction func backAction(_ sender: UIButton) {   // Back button action
        self.pop()
    }
    @IBAction func faqAction(_ sender: UIButton) {   // FAQ tab action
        self.glossaryUnderLine.isHidden = true
        self.videoUnderLine.isHidden = true
        self.faqUnderLine.isHidden = false
        self.videoLbl.textColor = CustomColor.darkGrayColor
        self.glossaryLbl.textColor = CustomColor.darkGrayColor
        self.faqLbl.textColor = UIColor.black
        self.selectedModel = 1
        self.selectedSection = -1
        self.faqTableView.reloadData()
    }
    @IBAction func glossaryAction(_ sender: UIButton) {   // Glossary tab action
        self.faqUnderLine.isHidden = true
        self.videoUnderLine.isHidden = true
        self.glossaryUnderLine.isHidden = false
        self.faqLbl.textColor = CustomColor.darkGrayColor
        self.videoLbl.textColor = CustomColor.darkGrayColor
        self.glossaryLbl.textColor = UIColor.black
        self.selectedModel = 2
        self.selectedSection = -1
        self.faqTableView.reloadData()
    }
    @IBAction func videoAction(_ sender: UIButton) {   // Video tab action
        self.glossaryUnderLine.isHidden = true
        self.faqUnderLine.isHidden = true
        self.videoUnderLine.isHidden = false
        self.faqLbl.textColor = CustomColor.darkGrayColor
        self.glossaryLbl.textColor = CustomColor.darkGrayColor
        self.videoLbl.textColor = UIColor.black
        self.selectedModel = 3
        self.selectedSection = -1
        self.faqTableView.reloadData()
    }
}
