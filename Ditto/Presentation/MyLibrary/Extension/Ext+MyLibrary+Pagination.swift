//
//  Ext+MyLibrary+Pagination.swift
//  Ditto
//
//  Created by Gokul Ramesh on 24/03/22.
//  Copyright © 2022 Infosys. All rights reserved.
//

import Foundation
import UIKit

extension MyLibrarryViewController {
    func reloadCollectionViewData(type: String) {   //
        DispatchQueue.main.async {
            self.myLibraryViewModel.fetchType = type
            if self.myLibraryViewModel.fetchType == Constants.fromActive {
                self.addProjectView.isHidden = self.myLibraryViewModel.workspaceArrayActive.count >= 0 ? true: false
                self.addProjectButton.isHidden = self.myLibraryViewModel.workspaceArrayActive.count >= 0 ? true: false
            } else if self.myLibraryViewModel.fetchType == Constants.fromCOMPLETED {
                if self.myLibraryViewModel.workspaceCompletedArray.count >= 0 {
                    self.addProjectView.isHidden = true
                    self.addProjectButton.isHidden = true
                }
            }
            self.collectionView.reloadData()
        }
    }
    func loadMoreData() {   // Pagination Operation for Mylibrary ColectionView
        let totalPaageCount = self.myLibraryViewModel.objMylibData.totalPageCount
        let prodFilter = UserDefaults.standard.object([String: [String]].self, with: CommonConst.SelectedFilterObjectss)
        if self.pageID <= totalPaageCount {
            self.myLibraryViewModel.getMyLibraryData(atributeType: !self.myFolderUnderLineLbl.isHidden ? .onClickFolder: .myLibrary, prodfilter: prodFilter != nil ? prodFilter!: [:], showLoader: false, pageid: "\(self.pageID)", foldername: !self.myFolderUnderLineLbl.isHidden ? self.selectedFolderName: FormatsString.emptyString) { _ in
                self.collectionView.reloadData()
                self.isLoading = false
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    Proxy.shared.dismissLottie()
                }
            }
        }
    }
}
