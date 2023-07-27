//
//  Ext+MyLibrary+SearchDelegate.swift
//  Ditto
//
//  Created by Gokul Ramesh on 24/03/22.
//  Copyright © 2022 Infosys. All rights reserved.
//

import Foundation
import UIKit

extension MyLibrarryViewController: UISearchBarDelegate {
    func setSearchVC() {   // Search Operation in MuLibray VC
        let view = UIView()
        view.frame = self.view.frame
        self.searchController.loadViewIfNeeded()
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.searchBar.enablesReturnKeyAutomatically = false
        self.searchController.searchBar.returnKeyType = UIReturnKeyType.search
        self.definesPresentationContext = true
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.placeholder = FormatsString.searchPatternLibrary
        self.searchController.searchBar.frame = self.searchBar.frame
        view.addSubview(self.searchController.searchBar)
        navigationItem.hidesSearchBarWhenScrolling = false
        self.searchController.searchBar.clipsToBounds = true
        self.searchController.searchBar.showsCancelButton = true
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.text = FormatsString.emptyString
        self.present(self.searchController, animated: true, completion: nil)
        self.allpatternsView.isHidden = true
        self.myfolderView.isHidden = true
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {   // search button on the Keyoard is tapped
        if self.canSearchandFilterFolder {
            if let folderName = self.navigationtitleLabel.text?.split(separator: "(").first?.description.replacingOccurrences(of: " ", with: "") {
                let updatedFlolderName = folderName == "\(FormatsString.favorite)s" ? FormatsString.favorite: "\(folderName)"
                self.searchOrFilterInFolder(fromSearchOnlyinFolder: true, canHideTab: true, searchText: searchBar.text ?? FormatsString.emptyString, folderName: "\(updatedFlolderName)")
            }
        } else {
            self.searchAPICall(searchText: searchBar.text ?? FormatsString.emptyString)
        }
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {   // SearchBar cancel button is tapped 
        if self.canSearchandFilterFolder {
            if !self.activeProjectView.isHidden {
                self.searchOrFilterInFolder(cancelTappedWhenSearchinFilterFolder: true, searchText: FormatsString.emptyString, folderName: self.isinFavoriteFolder ? FormatsString.favorite: self.selectedFolderName)
            } else {
                self.myLibraryViewModel.onClickFolder(folderName: self.selectedFolderName) { _ in   // Load normal mylibrary collection view datas
                    self.folderSwitch = false
                    if self.myLibraryViewModel.myFolderArray.contains(self.selectedFolderName) {
                        self.canSearchandFilterFolder = true
                        self.myFolderUnderLineLbl.isHidden = false
                        self.allPatternsUnderLineLbl.isHidden = true
                    } else {
                        self.folderSwitch = false
                        self.canSearchandFilterFolder = false
                        self.myFolderUnderLineLbl.isHidden = true
                        self.allPatternsUnderLineLbl.isHidden = false
                    }
                    self.collectionView.reloadData()
                    self.navigationtitleLabel.text = "\(self.selectedFolderName) (\(self.myLibraryViewModel.objMylibData.totalPatternCount))"
                    self.allpatternsView.isHidden = false
                    self.myfolderView.isHidden = false
                }
            }
        } else {
            self.syncAPICall(needtoclearFilter: false)
        }
    }
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      if searchText.isEmpty {
          self.searchBarCancelButtonClicked(self.searchBar)
      }
    }
}
