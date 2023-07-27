//
//  FaqTableViewExtension.swift
//  Ditto
//
//  Created by abiya.joy on 29/09/22.
//  Copyright © 2022 Infosys. All rights reserved.
//

import UIKit

extension FaqViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: Table view functions
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.selectedModel == 1 {    // FAQ tab section count values
            return self.objFaqViewModel.arrFaqModel.count
        } else if self.selectedModel == 2 {    // Glossary tab section count values
            return self.objFaqViewModel.arrGlossaryFaqModel.count
        } else if self.selectedModel == 3 {    // Video tab section count values
            return self.objFaqViewModel.arrVideoFaqModel.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.selectedSection == section {
            if self.selectedModel == 1 {   // FAQ tab row count values
                let faqCount = (self.objFaqViewModel.arrFaqModel.count > section) ? self.objFaqViewModel.arrFaqModel[section].arrSubAnswer.count : 0
                return 1 + faqCount
            } else if self.selectedModel == 2 {   // Glossary tab row count values
                let glossaryCount = (self.objFaqViewModel.arrGlossaryFaqModel.count > section) ? self.objFaqViewModel.arrGlossaryFaqModel[section].arrSubAnswer.count : 0
                return 1 + glossaryCount
            } else if self.selectedModel == 3 {   // Video tab row count values
                let videoCount = (self.objFaqViewModel.arrVideoFaqModel.count > section) ? self.objFaqViewModel.arrVideoFaqModel[section].arrSubAnswer.count : 0
                return 1 + videoCount
            }
        }
        return 0
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var dictData = FaqModel()
        var defaultCell = UITableViewCell()
        if self.selectedModel == 1 && self.objFaqViewModel.arrFaqModel.count > section {   // FAQ tab section header values
            dictData = self.objFaqViewModel.arrFaqModel[section]
        } else if self.selectedModel == 2 && self.objFaqViewModel.arrGlossaryFaqModel.count > section {   // Glossary tab section header values
            dictData = self.objFaqViewModel.arrGlossaryFaqModel[section]
        } else if self.selectedModel == 3 && self.objFaqViewModel.arrVideoFaqModel.count > section {   // Video tab section header values
            dictData = self.objFaqViewModel.arrVideoFaqModel[section]
        }
        if let headerCell = tableView.dequeueReusableCell(withIdentifier: ReusableCellIdentifiers.faqHeaderTableViewCellIdentifier) as? FaqHeaderTableViewCell {
            headerCell.btnIsSelected.tag = section
            headerCell.lblQuestion.text = dictData.question
            headerCell.viewMain.borderWidth = (self.selectedSection == -1 || self.selectedSection != section) ? 1 : 0
            headerCell.viewIfOpen.isHidden = (self.selectedSection == -1 || self.selectedSection != section) ? true : false
            headerCell.btnIsSelected.isSelected = (self.selectedSection == -1 || self.selectedSection != section) ? false : true
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.headerTapped(_ :)))
            tapGesture.numberOfTapsRequired = 1
            headerCell.tag = section
            headerCell.addGestureRecognizer(tapGesture)
            headerCell.btnIsSelected.addTarget(self, action: #selector(self.expandCell(_ :)), for: .touchUpInside)
            headerCell.viewMain.backgroundColor = CustomColor.whitishGrayColor
            headerCell.viewMain.layer.borderColor = CustomColor.lightGrayColor.cgColor
            headerCell.viewMain.clipsToBounds = false
            headerCell.viewMain.addShadow()
            defaultCell = headerCell
        }
        return defaultCell
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tableViewCell = UITableViewCell()
        var dictData = FaqModel()
        if self.selectedModel == 1 && (indexPath.section < self.objFaqViewModel.arrFaqModel.count) {   // FAQ tab row values
            dictData = self.objFaqViewModel.arrFaqModel[indexPath.section]
        } else if self.selectedModel == 2 && (indexPath.section < self.objFaqViewModel.arrGlossaryFaqModel.count) {   // Glossary tab row values
            dictData = self.objFaqViewModel.arrGlossaryFaqModel[indexPath.section]
        } else if self.selectedModel == 3 && (indexPath.section < self.objFaqViewModel.arrVideoFaqModel.count) {   // Video tab row values
            dictData = self.objFaqViewModel.arrVideoFaqModel[indexPath.section]
        } else {
            return tableViewCell
        }
        if indexPath.row == 0 {
            if let cellAnswer = tableView.dequeueReusableCell(withIdentifier: ReusableCellIdentifiers.faqAnswerTableViewCellIdentifier) as? FaqAnswerTableViewCell {
                cellAnswer.lblANswer.text = dictData.answer.replacingOccurrences(of: "<br>", with: "\n").replacingOccurrences(of: "<br/>", with: "\n")
                cellAnswer.lblANswer.sizeToFit()
                cellAnswer.viewBottomBorder.isHidden = !dictData.arrSubAnswer.isEmpty
                cellAnswer.watchVideoView.isHidden = dictData.videoPath == FormatsString.emptyString ? true : false
                cellAnswer.shareView.isHidden = dictData.webLinkUrl == FormatsString.emptyString ? true : false
                cellAnswer.stackViewHeightConstraint.constant = (cellAnswer.watchVideoView.isHidden && cellAnswer.shareView.isHidden) ? 0 : 40
                cellAnswer.shareBtnAction = {
                    if let url = URL(string: dictData.webLinkUrl) {
                        UIApplication.shared.open(url)
                    }
                }
                cellAnswer.watchVideoBtnAction = {
                    DispatchQueue.main.async {
                        if let watchVideoController = Constants.loginStoryBoard.instantiateViewController(withIdentifier: Constants.AdvertisementVideoControllerIdentifier) as? AdvertisementVideoController {
                            watchVideoController.modalPresentationStyle = .custom
                            if dictData.videoPath != FormatsString.emptyString {
                                watchVideoController.videoUrl = dictData.videoPath
                            }
                            if self.selectedModel == 2 {
                                watchVideoController.videoTitle = dictData.question
                                watchVideoController.isFromSceen = ScreenTypeString.fAQScreen
                            } else if self.selectedModel == 3 {
                                watchVideoController.isFromSceen = ScreenTypeString.fAQVideoScreen
                                watchVideoController.videoTitle = "   \(dictData.question)"
                            }
                            if self.presentedViewController == nil {
                                self.present(watchVideoController, animated: true, completion: nil)
                            }
                        }
                    }
                }
                cellAnswer.bottomConstratintForShadow.constant = (dictData.arrSubAnswer.isEmpty) ? 10 : 0
                cellAnswer.innerView.layer.cornerRadius = (dictData.arrSubAnswer.isEmpty) ? 5 : 0
                if dictData.arrSubAnswer.isEmpty {
                    cellAnswer.viewMain.backgroundColor = UIColor.white
                    cellAnswer.viewMain.clipsToBounds = false
                    cellAnswer.viewMain.addShadow()
                }
                tableViewCell = cellAnswer
            }
        } else {
            if let cellAnswer = tableView.dequeueReusableCell(withIdentifier: ReusableCellIdentifiers.faqTableViewCellIdentifier) as? FaqTableViewCell {
                if !dictData.arrSubAnswer.isEmpty {
                    cellAnswer.labelTitle.text = dictData.arrSubAnswer[indexPath.row - 1].title
                    cellAnswer.labelShortDescription.text = dictData.arrSubAnswer[indexPath.row - 1].shortDescription.replacingOccurrences(of: "<br>", with: "\n").replacingOccurrences(of: "<br/>", with: "\n")
                    let imageURL = dictData.arrSubAnswer[indexPath.row - 1].imagePath
                    cellAnswer.imageViewSubAnswer.sd_setImage(with: URL(string: imageURL), placeholderImage: UIImage(named: ImageNames.placeholderImage)) { (image, err, _, _) in
                        cellAnswer.imageViewSubAnswer.image = (err == nil) ? image : UIImage(named: ImageNames.placeholderImage)
                    }
                }
                cellAnswer.bottomConstratintForShadow.constant = (indexPath.row == dictData.arrSubAnswer.count) ? 10 : 0
                cellAnswer.innerView.layer.cornerRadius = (indexPath.row == dictData.arrSubAnswer.count) ? 5 : 0
                cellAnswer.viewMain.backgroundColor = UIColor.white
                cellAnswer.viewMain.layer.borderColor = CustomColor.lightGrayColor.cgColor
                cellAnswer.viewMain.clipsToBounds = false
                cellAnswer.viewMain.addShadow()
                cellAnswer.viewBottomBorder.isHidden = !(dictData.arrSubAnswer.count == indexPath.row)
                tableViewCell = cellAnswer
            }
        }
        return tableViewCell
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UIDevice.isPad ? 90 : 70
    }
    // MARK: Other functions
    @objc func headerTapped(_ gestureRecognizer: UIGestureRecognizer) {   // Header tap function
        guard let section = gestureRecognizer.view?.tag else { return }
        self.selectedSection = (self.selectedSection == section) ? -1 : section
        DispatchQueue.main.async {
            self.faqTableView.reloadData()
        }
    }
    @objc func expandCell(_ sender: UIButton) {   // Function to expand cell
        self.selectedSection = (self.selectedSection == sender.tag) ? -1 : sender.tag
        DispatchQueue.main.async {
            sender.isSelected = !sender.isSelected
            self.faqTableView.reloadData()
        }
    }
}
