//
//  PatternDescCustomisationTableViewExtension.swift
//  Ditto
//
//  Created by abiya.joy on 03/10/22.
//  Copyright © 2022 Infosys. All rights reserved.
//

import UIKit
import Alamofire

extension PatternDescriptionViewController: UITableViewDelegate, UITableViewDataSource {
    // table view functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.patternDesViewModel.selectedViewList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tableViewCell = UITableViewCell()
        if let cell = self.patternDesViewModel.tableView.dequeueReusableCell(withIdentifier: ReusableCellIdentifiers.customListIdentifier, for: indexPath) as? CustomisedListCell {
            if indexPath.row < self.patternDesViewModel.selectedViewList.count && indexPath.row >= 0 {
                cell.nameLabel?.text = self.patternDesViewModel.selectedViewList[indexPath.row]
                cell.selectionImage?.backgroundColor = .clear
                tableViewCell = cell
            }
        }
        return tableViewCell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(self.patternDesViewModel.cellheight)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.patternDesViewModel.viewTapped == self.selectSizeView {
            if indexPath.row < self.patternDesViewModel.sizeList.count && indexPath.row >= 0 {
                if self.selectSizeButton.titleLabel?.text! != self.patternDesViewModel.sizeList[indexPath.row] {
                    self.patternDesViewModel.tailornovaModelObject.isDownloaded = false
                }
                self.selectSizeButton.setTitle(self.patternDesViewModel.sizeList[indexPath.row], for: .normal)
                self.patternDesViewModel.tailornovaDesignId = (indexPath.row != 0) ? self.patternDesViewModel.sizeDesignIdList[indexPath.row - 1] : FormatsString.emptyString
                self.patternDesViewModel.designIdToPass = (indexPath.row != 0) ? self.patternDesViewModel.sizeMannequinIdList[indexPath.row - 1] : FormatsString.emptyString
                self.patternDesViewModel.purchasedSizeId = self.patternDesViewModel.designIdToPass
                if self.selectSizeButton.titleLabel?.text != FormatsString.selectSize {
                    self.patternDesViewModel.selectedSizeName = self.selectSizeButton.title(for: .normal)!
                    self.patternDesViewModel.selectedViewCupSizeName = self.selectViewCupSizeButton.title(for: .normal)!
                    self.hitTailorNova(designId: self.patternDesViewModel.tailornovaDesignId, purchaseId: self.patternDesViewModel.designIdToPass)
                }
            }
            self.removeDropListView()
        } else if self.patternDesViewModel.viewTapped == self.selectViewCupSizeView {
            if indexPath.row < self.patternDesViewModel.viewCupSizeList.count && indexPath.row >= 0 {
                if self.selectSizeButton.titleLabel?.text! != self.patternDesViewModel.viewCupSizeList[indexPath.row] {
                    self.patternDesViewModel.tailornovaModelObject.isDownloaded = false
                }
                self.selectViewCupSizeButton.setTitle(self.patternDesViewModel.viewCupSizeList[indexPath.row], for: .normal)
                self.patternDesViewModel.sizeList.removeAll()
                self.patternDesViewModel.sizeDesignIdList.removeAll()
                self.patternDesViewModel.sizeMannequinIdList.removeAll()
                self.selectSizeButton.setTitle(FormatsString.selectSize, for: .normal)
                if self.selectViewCupSizeButton.title(for: .normal)! != FormatsString.selectViewCupSize {
                    self.patternDesViewModel.sizeList.append(FormatsString.selectSize)
                    let viewStyle = self.patternDesViewModel.thirdPartyObject.filter({$0.style == self.patternDesViewModel.viewCupSizeList[indexPath.row]})[0].size
                    for item in viewStyle {
                        self.patternDesViewModel.sizeList.append(item.size)
                        self.patternDesViewModel.sizeDesignIdList.append(item.designID)
                        self.patternDesViewModel.sizeMannequinIdList.append(item.mannequinID)
                    }
                }
            }
            self.removeDropListView()
        } else if self.patternDesViewModel.viewTapped == self.customisationView {
            if indexPath.row < self.patternDesViewModel.customisedNameList.count && indexPath.row >= 0 {
                if self.customisationButton.titleLabel?.text != self.patternDesViewModel.customisedNameList[indexPath.row] {
                    self.patternDesViewModel.tailornovaModelObject.isDownloaded = false
                }
                self.customisationButton.setTitle(self.patternDesViewModel.customisedNameList[indexPath.row], for: .normal)
                self.patternDesViewModel.designIdToPass = (indexPath.row != 0) ? self.patternDesViewModel.customisedIdList[indexPath.row - 1] : FormatsString.emptyString
                if self.customisationButton.titleLabel?.text != FormatsString.addcustomisation {
                    self.hitTailorNova(designId: self.patternDesViewModel.tailornovaDesignId, purchaseId: self.patternDesViewModel.designIdToPass)
                }
            }
            self.removeDropListView()
        }
    }
    //MARK: OUTLET ACTIONS
    @IBAction func customisationButtonTapped(_ sender: UIButton) {  // Tap on Add Custmisation button
        self.customisationTap()
    }
    @IBAction func selectSizeButtonTapped(_ sender: UIButton) {  // Tap on Select Size button
        self.selectSizeTap()
    }
    @IBAction func selectViewCupButtonTapped(_ sender: UIButton) {  // Tap on Select View/Cup size button
        self.selectViewCupTap()
    }
    func customisationTap() {
        self.patternDesViewModel.selectedViewList.removeAll()
        self.patternDesViewModel.viewTapped = self.customisationView
        for item in self.patternDesViewModel.customisedNameList {
            self.patternDesViewModel.selectedViewList.append(item)
        }
        self.changeDropListView()
    }
    func selectSizeTap() {
        self.patternDesViewModel.selectedViewList.removeAll()
        self.patternDesViewModel.viewTapped = self.selectSizeView
        for item in self.patternDesViewModel.sizeList {
            self.patternDesViewModel.selectedViewList.append(item)
        }
        if !self.patternDesViewModel.selectedViewList.isEmpty {
            self.changeDropListView()
        } else {
            if let manager = NetworkReachabilityManager(), manager.isReachable {
                ServiceManagerProxy.shared.displayerrorPopup(url: FormatsString.emptyString, responseError: MessageString.selectAnyViewCupSize)
            }
        }
    }
    func selectViewCupTap() {
        self.patternDesViewModel.selectedViewList.removeAll()
        self.patternDesViewModel.viewTapped = self.selectViewCupSizeView
        for item in self.patternDesViewModel.viewCupSizeList {
            self.patternDesViewModel.selectedViewList.append(item)
        }
        self.changeDropListView()
    }
    @objc func customisationTapped(recognizer: UITapGestureRecognizer) {  // Tap on Add Custmisation button
        self.customisationTap()
    }
    @objc func sizeViewTapped(recognizer: UITapGestureRecognizer) {  // Tap on Select Size button
        self.selectSizeTap()
    }
    @objc func viewCupSizeViewTapped(recognizer: UITapGestureRecognizer) {   // Tap on Select View/Cup size button
        self.selectViewCupTap()
    }
    @objc func changeDropListView() {    // Opening and closing of drop down on different view tap
        let frames = self.patternDesViewModel.viewTapped.frame
        var viewOpenCheck = self.patternDesViewModel.customSelected
        if self.patternDesViewModel.viewTapped == self.selectSizeView {
            viewOpenCheck = self.patternDesViewModel.sizeSelected
        } else if self.patternDesViewModel.viewTapped == self.selectViewCupSizeView {
            viewOpenCheck = self.patternDesViewModel.viewCupSizeSelected
        } else if self.patternDesViewModel.viewTapped == self.customisationView {
            viewOpenCheck = self.patternDesViewModel.customSelected
        }
        if !viewOpenCheck {
            self.patternDesViewModel.transparentView.frame = KAppDelegate.window?.frame ?? self.view.frame
            self.view.addSubview(self.patternDesViewModel.transparentView)
            let removeListTapGesture = UITapGestureRecognizer(target: self, action: #selector(removeDropListView))
            self.patternDesViewModel.transparentView.addGestureRecognizer(removeListTapGesture)
            let frameX = frames.origin.x + self.patternDesViewModel.safeAreaInsets.left
            let expiredViewHeight = UIDevice.isPad ? CGFloat(48) : CGFloat(39)
            let frameY = frames.origin.y + frames.size.height + expiredViewHeight + self.patternDesViewModel.safeAreaInsets.top + 5
            self.patternDesViewModel.tableView.frame = CGRect(x: frameX, y: frameY, width: frames.size.width, height: 0)
            self.view.addSubview(self.patternDesViewModel.tableView)
            self.patternDesViewModel.tableView.layer.cornerRadius = 0
            self.patternDesViewModel.tableView.reloadData()
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                self.patternDesViewModel.tableView.frame = CGRect(x: frameX, y: frameY, width: frames.size.width, height: CGFloat(self.patternDesViewModel.selectedViewList.count * self.patternDesViewModel.cellheight))
                if CGFloat(self.patternDesViewModel.selectedViewList.count * self.patternDesViewModel.cellheight) > (KAppDelegate.window?.frame.height)! - frameY - 5 {
                    self.patternDesViewModel.tableView.frame = CGRect(x: frameX, y: frameY, width: frames.size.width, height: (KAppDelegate.window?.frame.height)! - frameY - 5)
                    self.patternDesViewModel.tableView.flashScrollIndicators()
                }
                self.changeViewOpenedStatus()
            }, completion: nil)
        } else {
            self.removeDropListView()
        }
    }
    func changeViewOpenedStatus() {   // Changing the status of opened view
        if self.patternDesViewModel.viewTapped == self.selectSizeView {
            self.patternDesViewModel.sizeSelected = !self.patternDesViewModel.sizeSelected
        } else if self.patternDesViewModel.viewTapped == self.selectViewCupSizeView {
            self.patternDesViewModel.viewCupSizeSelected = !self.patternDesViewModel.viewCupSizeSelected
        } else if self.patternDesViewModel.viewTapped == self.customisationView {
            self.patternDesViewModel.customSelected = !self.patternDesViewModel.customSelected
        }
    }
    @objc func removeDropListView() {  // Closing the drop down view
        let frames = self.patternDesViewModel.viewTapped.frame
        self.changeViewOpenedStatus()
        self.patternDesViewModel.transparentView.removeFromSuperview()
        let frameX = frames.origin.x + self.patternDesViewModel.safeAreaInsets.left
        let expiredViewHeight = UIDevice.isPad ? CGFloat(48) : CGFloat(39)
        let frameY = frames.origin.y + frames.size.height + expiredViewHeight + self.patternDesViewModel.safeAreaInsets.top + 5
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            self.patternDesViewModel.tableView.frame = CGRect(x: frameX, y: frameY, width: frames.size.width, height: 0)
        }, completion: nil)
    }
}
