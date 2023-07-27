//
//  Ext+WSBVC+CollectionViewDropDelegate.swift
//  Ditto
//
//  Created by Gaurav.rajan on 04/08/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit
import SDWebImage

extension WorkspaceBaseViewController: UICollectionViewDropDelegate {
    // Collection view Drop delegate
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
    }
    func collectionView(_ collectionView: UICollectionView, dragSessionAllowsMoveOperation session: UIDragSession) -> Bool {  // WHILE MOVING
        self.objNewWorkSpaceBaseViewModel.isCellSelected = true
        if let cell = collectionView.cellForItem(at: self.objNewWorkSpaceBaseViewModel.selectedIndexPath) as? PatternCollectionViewCell {
            cell.labelMainTitle.isHidden = true
            cell.labelCutQuantity.isHidden = true
            cell.buttonIsSelected.isHidden = true
            cell.patternImageVeiw.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
            cell.patternImageVeiw.reloadInputViews()
        }
        let cellSize = CGSize(width: 120, height: UIDevice.isPad ? 150 : 100)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = cellSize
        self.patternsView.patternCollectionView?.setCollectionViewLayout(layout, animated: true)
        return true
    }
    func collectionView(_ collectionView: UICollectionView, dragSessionDidEnd session: UIDragSession) {
        self.objNewWorkSpaceBaseViewModel.isCellSelected  = false
        if let cell = collectionView.cellForItem(at: self.objNewWorkSpaceBaseViewModel.selectedIndexPath) as? PatternCollectionViewCell {
            cell.labelMainTitle.isHidden = false
            cell.labelCutQuantity.isHidden = false
            cell.buttonIsSelected.isHidden = false
        }
        let cellSize = CGSize(width: collectionView.frame.width, height: UIDevice.isPad ? 150 : 100)
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = cellSize
        self.patternsView.patternCollectionView?.setCollectionViewLayout(layout, animated: true)
    }
}

extension WorkspaceBaseViewController: UICollectionViewDragDelegate {
    // Collection view Drag delegate
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        var color = UIImage()
        let patternObject = self.objNewWorkSpaceBaseViewModel.getPatternPiecesBasedOnTab(tabType: self.objNewWorkSpaceBaseViewModel.selectedTabCategory)
        if indexPath.row < patternObject.count && indexPath.row >= 0 {
            color = self.getImageForPatternPiece(id: patternObject[indexPath.row].tailornovaIndex)
            let itemProvider = NSItemProvider(object: color)
            let dragItem = UIDragItem(itemProvider: itemProvider)
            dragItem.localObject = color
            if self.showAlertForSplicedImage(patternObj: patternObject[indexPath.row]) {
                return []
            }
            self.objNewWorkSpaceBaseViewModel.currentIndexPath = indexPath.row
            self.objNewWorkSpaceBaseViewModel.lastSelectedIndexPath = indexPath.row
            self.objNewWorkSpaceBaseViewModel.selectedIndexPath = indexPath
            return [dragItem]
        }
        return []
    }
}
