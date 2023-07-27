//
//  FilterTableViewExtension.swift
//  Ditto
//
//  Created by abiya.joy on 10/10/22.
//  Copyright © 2022 Infosys. All rights reserved.
//

import UIKit

extension FilterViewController: UITableViewDataSource, UITableViewDelegate {
    // MARK: - Table View Datasource & Delegate methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableView == self.titleTableView ? self.updatedFilterObj.updatedFilterArr.count: self.contentArray.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 45.0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tableViewCell = UITableViewCell()
        if tableView == self.titleTableView {
            if let titleCell = tableView.dequeueReusableCell(withIdentifier: ReusableCellIdentifiers.FiltertitleCell, for: indexPath) as? TitleTableViewCell {
                if indexPath.row < self.updatedFilterObj.updatedFilterArr.count && indexPath.row >= 0 {
                    let title = self.updatedFilterObj.updatedFilterArr[indexPath.row].title
                    titleCell.titleLabel.text = title == FormatsString.productTypes ? FormatsString.pRODUCTTypes : title == FormatsString.productType ? FormatsString.pRODUCTType : title.capitalized
                    titleCell.arrowBtn.isHidden = self.selectedCategory == indexPath.row ? false: true
                    titleCell.backgroundColor = self.selectedCategory == indexPath.row ? UIColor.white : ColorHandler.FilterTitleTablebgColor
                    titleCell.titleLabel.font = self.selectedCategory == indexPath.row ?  UIFont.boldSystemFont(ofSize: UIDevice.isPhone ? 12: 19): UIFont(name: FontName.avenirNextLtPro, size: UIDevice.isPhone ? 12: 19)
                    tableViewCell = titleCell
                }
            }
        } else {
            if let contentsCell = tableView.dequeueReusableCell(withIdentifier: ReusableCellIdentifiers.FiltercontentCell, for: indexPath) as? ContentsTableViewCell {
                if indexPath.row < self.contentArray.count && indexPath.row >= 0 {
                    let content = self.contentArray[indexPath.row]
                    contentsCell.contentLabel.text = content
                    if self.dictIndices[self.selectedTitle]?.contains(indexPath.row) != nil && self.dictIndices[self.selectedTitle]!.contains(indexPath.row) {
                        contentsCell.contentSelectedBtnImage.image = UIImage(named: ImageNames.selectedSquare)
                    } else {
                        contentsCell.contentSelectedBtnImage.image = UIImage(named: ImageNames.unSelectedsquare)
                    }
                    contentsCell.selectionItem  = {
                        if contentsCell.contentSelectedBtnImage?.image == UIImage(named: ImageNames.unSelectedsquare) {
                            contentsCell.contentSelectedBtnImage.image = UIImage(named: ImageNames.selectedSquare)
                            self.selectedContents.append(indexPath.row)
                            self.tempArr.append(self.contentArray[indexPath.row])
                            var contentTempStrArr: [String] = []
                            var contentTempIndArr: [Int] = []
                            if self.filterDictionary[self.selectedTitle] == nil {
                                contentTempStrArr = self.tempArr
                                contentTempIndArr = self.selectedContents
                            } else {
                                var someArr: [String] = []
                                someArr.append(self.contentArray[indexPath.row])
                                var someIndArr: [Int] = []
                                someIndArr.append(indexPath.row)
                                contentTempStrArr = self.filterDictionary[self.selectedTitle]! + someArr
                                contentTempIndArr = self.dictIndices[self.selectedTitle]! + someIndArr
                            }
                            self.dictIndices[self.selectedTitle] = contentTempIndArr
                            self.filterDictionary[self.selectedTitle] = contentTempStrArr
                        } else {
                            contentsCell.contentSelectedBtnImage.image = UIImage(named: ImageNames.unSelectedsquare)
                            let theContent = self.contentArray[indexPath.row]
                            let selectIndices = self.filterDictionary[self.selectedTitle]!
                            if let thatIndex = selectIndices.firstIndex(of: theContent) {
                                self.dictIndices[self.selectedTitle]?.remove(at: thatIndex)
                                self.filterDictionary[self.selectedTitle]?.remove(at: thatIndex)
                            }
                        }
                    }
                    tableViewCell = contentsCell
                }
            }
        }
        return tableViewCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.titleTableView {
            let tempArray = self.updatedFilterObj.updatedFilterArr
            if indexPath.row < tempArray.count && indexPath.row >= 0 {
                self.selectedCategory = indexPath.row
                self.selectedTitle = tempArray[indexPath.row].title
                tableView.reloadData()
                self.tempArr.removeAll()
                self.selectedContents.removeAll()
                self.getContentsForSelectedTitle(selectedTitle: indexPath.row)
            }
        }
    }
    // MARK: - Getting the contents for the title selected
    func getContentsForSelectedTitle(selectedTitle: Int) {
        self.contentArray.removeAll()
        if self.updatedFilterObj.updatedFilterArr.count > selectedTitle {
            self.contentArray = self.updatedFilterObj.updatedFilterArr[selectedTitle].subArr
        }
        self.contentsTableView.reloadData()
    }
}
