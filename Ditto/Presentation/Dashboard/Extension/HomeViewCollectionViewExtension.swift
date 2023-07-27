//
//  HomeViewCollectionViewExtension.swift
//  Ditto
//
//  Created by abiya.joy on 29/09/22.
//  Copyright © 2022 Infosys. All rights reserved.
//

import UIKit
import Alamofire

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.homeViewModel.homeObjectsArray.count
    }
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row >= 0 {
            let indexPath = Section(rawValue: indexPath.row)
            switch indexPath {
            case .patternLibrary:
                if self.objMyLibViewModel.objMylibData.totalPatternCount != 0 || !self.objMyLibViewModel.offlinePattern.isEmpty || self.homeViewModel.trailPatternArray.isEmpty {
                    if let myLibraryVC = Constants.dashBoardStoryBoard.instantiateViewController(identifier: Constants.MyLibrarryViewControllerIdentifier) as? MyLibrarryViewController {
                        myLibraryVC.myLibraryViewModel.trailPatternArray = self.homeViewModel.trailPatternArray
                        myLibraryVC.objMylibraryData = self.objMyLibViewModel.objMylibData
                        myLibraryVC.pageID = self.objMyLibViewModel.objMylibData.currentPageID
                        myLibraryVC.myLibVCDelegate = self
                        if let manager = NetworkReachabilityManager(), !manager.isReachable {
                            myLibraryVC.myLibraryViewModel.offlinePattern = self.homeViewModel.offlineDataArray
                        }
                        self.navigationController?.pushViewController(myLibraryVC, animated: true)
                    }
                }
            case .dittopatterns:
                guard let url = URL(string: CommonConst.siteURLConstant), !url.absoluteString.isEmpty else {
                    return
                }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            case .joann:
                guard let url = URL(string: Apis.joannSite), !url.absoluteString.isEmpty else {
                    return
                }
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            case .tutorial:
                CommonConst.navCheckValue = 1
                self.pushToNext(storyBoard: .getStarted, identifier: StoryBoardIdentifiers.getStartedd.rawValue, animated: true, titleStr: FormatsString.emptyString)
            case .none:
                break
            }
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var collectionViewCell = UICollectionViewCell()
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ReusableCellIdentifiers.homeCellIdentifier, for: indexPath) as? HomeScreenCollectionViewCell {
            cell.backgroundColor = .clear
            if indexPath.row < self.homeViewModel.homeObjectsArray.count && indexPath.row >= 0 {
                collectionViewCell = self.homeViewModel.cellOfCollectionView(index: indexPath.row, cell: cell)
            }
        }
        return collectionViewCell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellAcross = self.homeViewModel.cellsAcross
        let spaceBetweenCells = self.homeViewModel.spaceBetweenCells
        let dim = (collectionView.bounds.width - (cellAcross - 5) * spaceBetweenCells) / cellAcross
        let hte = UIDevice.isPad ? (dim - 90) : ( dim - 70)
        return CGSize(width: dim, height: hte)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        let inset = self.homeViewModel.insetValues
        return UIEdgeInsets(top: inset, left: 20, bottom: inset, right: 20)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return self.homeViewModel.spaceBetweenCells
    }
}
