//
//  Ext+WSBVC+DragDelegate.swift
//  Ditto
//
//  Created by Gaurav Rajan on 21/04/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit

extension WorkspaceBaseViewController: UIDragInteractionDelegate {
    // drag delegate functions
    func collectionView(_ collectionView: UICollectionView, previewForDismissingContextMenuWithConfiguration configuration: UIContextMenuConfiguration) -> UITargetedPreview? {
        return UITargetedPreview.init(view: UIView())
    }
    func dragInteraction(_ interaction: UIDragInteraction, itemsForAddingTo session: UIDragSession, withTouchAt point: CGPoint) -> [UIDragItem] {
        var dragItemArr = [UIDragItem]()
        for view in self.workspaceAreaView.workAreaView.subviews {
            if let imageView = view as? UIImageView, let image = imageView.image {
                let provider = NSItemProvider(object: image)
                let item = UIDragItem(itemProvider: provider)
                item.localObject = image
                dragItemArr.append(item)
            }
        }
        return dragItemArr
    }
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        let touched = session.location(in: self.view)
        if let touchedHit = self.view.subviews.first?.hitTest(touched, with: nil) as? UIImageView, let touchedImage = touchedHit.image {
            self.objNewWorkSpaceBaseViewModel.tappedImgVw = touchedHit
            touchedHit.layer.borderWidth = 1
            touchedHit.layer.borderColor = UIColor.white.cgColor
            let itemProvider = NSItemProvider(object: touchedImage)
            let dragItem = UIDragItem(itemProvider: itemProvider)
            dragItem.localObject = touchedHit
            self.objNewWorkSpaceBaseViewModel.xVal = touchedHit.frame.origin.x
            self.objNewWorkSpaceBaseViewModel.yVal = touchedHit.frame.origin.y
            self.objNewWorkSpaceBaseViewModel.width = touchedHit.frame.size.width
            self.objNewWorkSpaceBaseViewModel.height = touchedHit.frame.size.height
            return [dragItem]
        }
        return []
    }
    func dragInteraction(_ interaction: UIDragInteraction, willAnimateLiftWith animator: UIDragAnimating, session: UIDragSession) {
        session.items.forEach { _ in
        }
    }
    func dragInteraction(_ interaction: UIDragInteraction, item: UIDragItem, willAnimateCancelWith animator: UIDragAnimating, session: UIDragSession) {
        session.items.forEach { _ in
        }
    }
}
