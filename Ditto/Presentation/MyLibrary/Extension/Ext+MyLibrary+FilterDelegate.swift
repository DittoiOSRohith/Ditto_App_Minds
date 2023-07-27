//
//  Ext+MyLibrary+FilterDelegate.swift
//  Ditto
//
//  Created by Gokul Ramesh on 23/03/22.
//  Copyright © 2022 Infosys. All rights reserved.
//

import Foundation
import UIKit

extension MyLibrarryViewController: FilterDelegate {
    //MARK: Filter Operations
    func applyProductFilter(isFilterParamsPresent: Bool) {   // Call API with the dictionary provided from Userdefaults
        if let prodFilter = CommonConst.userDefault.object([String: [String]].self, with: CommonConst.SelectedFilterObjectss) {
            self.filterButton.isSelected = !prodFilter.isEmpty ? true: false
            if canSearchandFilterFolder {
                if let folderName = self.navigationtitleLabel.text?.split(separator: "(").first?.description.replacingOccurrences(of: " ", with: FormatsString.emptyString) {
                    let updatedFlolderName = folderName == FormatsString.Favorites ? FormatsString.favorite: "\(folderName)"
                    self.searchOrFilterInFolder(searchText: "\(self.searchTermAfterFilter)", folderName: "\(updatedFlolderName)", isfilternillwhenappliied: !isFilterParamsPresent)
                }
            } else {
                self.pageID = 1
                self.myLibraryViewModel.getMyLibraryData(atributeType: .myLibrary, prodfilter: prodFilter, cleareProdArray: true, pageid: "\(self.pageID)") { response in
                    self.topViewHeightConstraint.constant = (!prodFilter.isEmpty ? (isFilterParamsPresent ? 30: 0): (UIDevice.isPad ? 30: 0))
                    self.activeProjectView.isHidden = (!prodFilter.isEmpty ? (isFilterParamsPresent ? false: true): true)
                    self.searchResultCountLabel.isHidden = (!prodFilter.isEmpty ? (isFilterParamsPresent ? false: true): true)
                    self.filterappliedinPatternLibrary = !prodFilter.isEmpty ? true: false
                    self.filterButton.isSelected = isFilterParamsPresent ? true: false
                    self.searchResultCountLabel.text = response.totalPatternCount > 9 ? "\(MessageString.showingFilterResults) (\(response.totalPatternCount))": "\(MessageString.showingFilterResults) (0\(response.totalPatternCount))"
                    self.navigationtitleLabel.text = "\(FormatsString.PatternLibrary) (\(response.totalPatternCount))"
                    self.collectionView.reloadData()
                }
            }
        }
    }
    func clearProductFilter() {   // Cleare filter results when tapped the clear button in MyLibrary
        self.topViewHeightConstraint.constant = UIDevice.isPad ? 30: 0
        self.activeProjectButton.isHidden = true
        self.activeProjectView.isHidden = true
        self.searchResultCountLabel.isHidden = true
        if self.canSearchandFilterFolder {
            if self.syncButton.tag == 1 {
                if self.filteredResultinFolderisNull {
                    if let folderName = self.navigationtitleLabel.text?.split(separator: "(").first?.description.replacingOccurrences(of: " ", with: FormatsString.emptyString) {
                        self.searchOrFilterInFolder(filterInFolderisNill: true, searchText: FormatsString.emptyString, folderName: "\(folderName)")
                    }
                } else {
                    self.searchOrFilterInFolder(filterInFolderisNill: true, searchText: FormatsString.emptyString)
                }
            } else {
                if let folderName = self.navigationtitleLabel.text?.split(separator: "(").first?.description.replacingOccurrences(of: " ", with: FormatsString.emptyString) {
                    self.searchOrFilterInFolder(isfromFilter: true, searchText: FormatsString.emptyString, folderName: "\(folderName)")
                }
            }
        } else {
            self.syncAPICall(needtoclearFilter: true)
            self.syncButton.tag = 0
        }
    }
}
