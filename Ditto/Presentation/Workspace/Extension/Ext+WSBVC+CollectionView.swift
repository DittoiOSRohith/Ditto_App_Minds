//
//  Ext+WSBVC+CollectionView.swift
//  Ditto
//
//  Created by Gaurav Rajan on 21/04/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit
import SDWebImage

extension WorkspaceBaseViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    // Collection View functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.objNewWorkSpaceBaseViewModel.getPatternPiecesBasedOnTab(tabType: self.objNewWorkSpaceBaseViewModel.selectedTabCategory).count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var collectionViewCell = UICollectionViewCell()
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReusableCellIdentifiers.patternCollectionViewCellIdentifier, for: indexPath as IndexPath) as? PatternCollectionViewCell {
        let patternItems = self.objNewWorkSpaceBaseViewModel.getPatternPiecesBasedOnTab(tabType: "\(self.objNewWorkSpaceBaseViewModel.selectedTabCategory)")
            if indexPath.row < patternItems.count && indexPath.row >= 0 {
                let dictDataPattern = patternItems[indexPath.row]
                cell.tag = indexPath.row
                cell.labelCutQuantity.text = dictDataPattern.cutQuantity
                cell.labelMainTitle.text = "#\((dictDataPattern.pieceNumber)) \((dictDataPattern.pieceDescription))"
                cell.buttonIsSelected.tag = dictDataPattern.tailornovaIndex // indexPath.row
                cell.buttonIsSelected.addTarget(self, action: #selector(isSelected(_ :)), for: .touchUpInside)
                cell.layer.borderColor = UIColor.clear.cgColor
                cell.constraintLeadingTitleView.constant = UIDevice.isPad ? 30 : 15
                cell.patternImageVeiw.image = UIImage(named: ImageNames.placeholderImage)
                if let imageUrl = URL(string: dictDataPattern.thumbnailImageURL) {
                    cell.patternImageVeiw.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: ImageNames.placeholderImage)) { (image, err, _, _) in
                        cell.patternImageVeiw.image = (err == nil) ? image : UIImage(named: ImageNames.placeholderImage)
                    }
                }
                cell.patternImageVeiw.isUserInteractionEnabled = true
                cell.contrastLabel.text = "  \(dictDataPattern.contrast)  "
                cell.contrastLabel.isHidden = dictDataPattern.contrast.isEmpty
                if self.patternsSegmentedContol.selectedSegmentIndex == WorkAreaTabCategory.garment.rawValue {
                    cell.buttonIsSelected.isSelected = self.objNewWorkSpaceBaseViewModel.arrSelectedIndexGarment.contains(dictDataPattern.tailornovaIndex) ? true : false
                    cell.viewIsSelected.backgroundColor = self.objNewWorkSpaceBaseViewModel.arrSelectedIndexGarment.contains(dictDataPattern.tailornovaIndex) ? CustomColor.patternSelectedBGColor : UIColor.white
                } else if self.patternsSegmentedContol.selectedSegmentIndex == WorkAreaTabCategory.lining.rawValue {
                    cell.buttonIsSelected.isSelected = self.objNewWorkSpaceBaseViewModel.arrSelectedIndexLinings.contains(dictDataPattern.tailornovaIndex) ? true : false
                    cell.viewIsSelected.backgroundColor = self.objNewWorkSpaceBaseViewModel.arrSelectedIndexLinings.contains(dictDataPattern.tailornovaIndex) ? CustomColor.patternSelectedBGColor : UIColor.white
                } else if self.patternsSegmentedContol.selectedSegmentIndex == WorkAreaTabCategory.interfacing.rawValue {
                    cell.buttonIsSelected.isSelected = self.objNewWorkSpaceBaseViewModel.arrSelectedIndexInterfacing.contains(dictDataPattern.tailornovaIndex) ? true : false
                    cell.viewIsSelected.backgroundColor = self.objNewWorkSpaceBaseViewModel.arrSelectedIndexInterfacing.contains(dictDataPattern.tailornovaIndex) ? CustomColor.patternSelectedBGColor : UIColor.white
                } else if self.patternsSegmentedContol.selectedSegmentIndex == WorkAreaTabCategory.other.rawValue {
                    cell.buttonIsSelected.isSelected = self.objNewWorkSpaceBaseViewModel.arrSelectedIndexOthers.contains(dictDataPattern.tailornovaIndex) ? true : false
                    cell.viewIsSelected.backgroundColor = self.objNewWorkSpaceBaseViewModel.arrSelectedIndexOthers.contains(dictDataPattern.tailornovaIndex) ? CustomColor.patternSelectedBGColor : UIColor.white
                }
                cell.layoutIfNeeded()
                collectionViewCell = cell
            }
        }
        return collectionViewCell
    }
    func collectionView(_ collectionView: UICollectionView, didHighlightItemAt indexPath: IndexPath) {
        self.objNewWorkSpaceBaseViewModel.selectedIndexPath = indexPath
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath == objNewWorkSpaceBaseViewModel.selectedIndexPath && objNewWorkSpaceBaseViewModel.isCellSelected {
            return CGSize(width: 150, height: UIDevice.isPad ? 150 : 100)
        } else {
            return CGSize(width: collectionView.frame.width, height: UIDevice.isPad ? 150 : 100)
        }
    }
    @objc func isSelected(_ sender: UIButton) {
        // Collection view cell check box logic
        defer {
            self.patternsView.patternCollectionView?.reloadData()
            sender.isSelected = !sender.isSelected
        }
        if !self.objNewWorkSpaceBaseViewModel.tailornovaPatternArray.filter({$0.tailornovaIndex == sender.tag}).isEmpty {
            let dictData = self.objNewWorkSpaceBaseViewModel.tailornovaPatternArray.filter({$0.tailornovaIndex == sender.tag})[0]
            let cutQuantity: Int = Proxy.shared.getIntegerValuefromString(str: dictData.cutQuantity)
            var finalQuant = Int()
            if self.patternsSegmentedContol.selectedSegmentIndex == 0 {   // Check box logic for Garment tab
                if self.objNewWorkSpaceBaseViewModel.arrSelectedIndexGarment.contains(sender.tag) {   // Uncheck logic
                    self.objNewWorkSpaceBaseViewModel.arrSelectedIndexGarment = self.objNewWorkSpaceBaseViewModel.arrSelectedIndexGarment.filter { $0 != sender.tag }
                    finalQuant = Int(self.patternsView.labelSelectedCutCount.text!)! - cutQuantity
                    self.patternsView.labelSelectedCutCount.text = "\(finalQuant)"
                } else {   // Check logic
                    if cutQuantity > 1  && self.objNewWorkSpaceBaseViewModel.isCutNumberAlertShown {  // cut > 1 and WS settings screen allows cut popup
                        self.showAlert(indexVal: sender.tag) { (isCompleted, index)  in
                            if isCompleted {
                                self.objNewWorkSpaceBaseViewModel.arrSelectedIndexGarment.append(index)
                                finalQuant = Int(self.patternsView.labelSelectedCutCount.text!)! + cutQuantity
                                self.patternsView.labelSelectedCutCount.text = "\(finalQuant)"
                                self.patternsView.patternCollectionView?.reloadData()
                            }
                        }
                    } else {
                        self.objNewWorkSpaceBaseViewModel.arrSelectedIndexGarment.append(sender.tag)
                        finalQuant = Int(self.patternsView.labelSelectedCutCount.text!)! + cutQuantity
                        self.patternsView.labelSelectedCutCount.text = "\(finalQuant)"
                        self.patternsView.patternCollectionView?.reloadData()
                    }
                }
            } else if self.patternsSegmentedContol.selectedSegmentIndex == 1 {   // Check box logic for Lining tab
                if self.objNewWorkSpaceBaseViewModel.arrSelectedIndexLinings.contains(sender.tag) {   // Uncheck logic
                    self.objNewWorkSpaceBaseViewModel.arrSelectedIndexLinings = self.objNewWorkSpaceBaseViewModel.arrSelectedIndexLinings.filter { $0 != sender.tag }
                    finalQuant = Int(self.patternsView.labelSelectedCutCount.text!)! - cutQuantity
                    self.patternsView.labelSelectedCutCount.text = "\(finalQuant)"
                } else {   // Check logic
                    if cutQuantity > 1  && self.objNewWorkSpaceBaseViewModel.isCutNumberAlertShown {  // cut > 1 and WS settings screen allows cut popup
                        self.showAlert(indexVal: sender.tag) { (isCompleted, index)  in
                            if isCompleted {
                                self.objNewWorkSpaceBaseViewModel.arrSelectedIndexLinings.append(index)
                                finalQuant = Int(self.patternsView.labelSelectedCutCount.text!)! + cutQuantity
                                self.patternsView.labelSelectedCutCount.text = "\(finalQuant)"
                                self.patternsView.patternCollectionView?.reloadData()
                            }
                        }
                    } else {
                        self.objNewWorkSpaceBaseViewModel.arrSelectedIndexLinings.append(sender.tag)
                        finalQuant = Int(self.patternsView.labelSelectedCutCount.text!)! + cutQuantity
                        self.patternsView.labelSelectedCutCount.text = "\(finalQuant)"
                        self.patternsView.patternCollectionView?.reloadData()
                    }
                }
            } else if self.patternsSegmentedContol.selectedSegmentIndex == 2 {   // Check box logic for Interfacing tab
                if self.objNewWorkSpaceBaseViewModel.arrSelectedIndexInterfacing.contains(sender.tag) {   // Uncheck logic
                    self.objNewWorkSpaceBaseViewModel.arrSelectedIndexInterfacing = self.objNewWorkSpaceBaseViewModel.arrSelectedIndexInterfacing.filter { $0 != sender.tag }
                    finalQuant = Int(self.patternsView.labelSelectedCutCount.text!)! - cutQuantity
                    self.patternsView.labelSelectedCutCount.text = "\(finalQuant)"
                } else {   // Check logic
                    if cutQuantity > 1  && self.objNewWorkSpaceBaseViewModel.isCutNumberAlertShown {  // cut > 1 and WS settings screen allows cut popup
                        self.showAlert(indexVal: sender.tag) { (isCompleted, index)  in
                            if isCompleted {
                                self.objNewWorkSpaceBaseViewModel.arrSelectedIndexInterfacing.append(index)
                                finalQuant = Int(self.patternsView.labelSelectedCutCount.text!)! + cutQuantity
                                self.patternsView.labelSelectedCutCount.text = "\(finalQuant)"
                                self.patternsView.patternCollectionView?.reloadData()
                            }
                        }
                    } else {
                        self.objNewWorkSpaceBaseViewModel.arrSelectedIndexInterfacing.append(sender.tag)
                        finalQuant = Int(self.patternsView.labelSelectedCutCount.text!)! + cutQuantity
                        self.patternsView.labelSelectedCutCount.text = "\(finalQuant)"
                        self.patternsView.patternCollectionView?.reloadData()
                    }
                }
            } else if self.patternsSegmentedContol.selectedSegmentIndex == 3 {   // Check box logic for Others tab
                if self.objNewWorkSpaceBaseViewModel.arrSelectedIndexOthers.contains(sender.tag) {   // Uncheck logic
                    self.objNewWorkSpaceBaseViewModel.arrSelectedIndexOthers = self.objNewWorkSpaceBaseViewModel.arrSelectedIndexOthers.filter { $0 != sender.tag }
                    finalQuant = Int(self.patternsView.labelSelectedCutCount.text!)! - cutQuantity
                    self.patternsView.labelSelectedCutCount.text = "\(finalQuant)"
                } else {   // Check logic
                    if cutQuantity > 1  && self.objNewWorkSpaceBaseViewModel.isCutNumberAlertShown {  // cut > 1 and WS settings screen allows cut popup
                        self.showAlert(indexVal: sender.tag) { (isCompleted, index)  in
                            if isCompleted {
                                self.objNewWorkSpaceBaseViewModel.arrSelectedIndexOthers.append(index)
                                finalQuant = Int(self.patternsView.labelSelectedCutCount.text!)! + cutQuantity
                                self.patternsView.labelSelectedCutCount.text = "\(finalQuant)"
                                self.patternsView.patternCollectionView?.reloadData()
                            }
                        }
                    } else {
                        self.objNewWorkSpaceBaseViewModel.arrSelectedIndexOthers.append(sender.tag)
                        finalQuant = Int(self.patternsView.labelSelectedCutCount.text!)! + cutQuantity
                        self.patternsView.labelSelectedCutCount.text = "\(finalQuant)"
                        self.patternsView.patternCollectionView?.reloadData()
                    }
                }
            }
        }
    }
}
