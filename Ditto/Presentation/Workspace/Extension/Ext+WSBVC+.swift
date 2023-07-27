//
//  Ext+WSBVC+.swift
//  Ditto
//
//  Created by Gaurav Rajan on 21/04/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit

extension WorkspaceBaseViewController: mirrorDelegate {
    func mirrorDone(done: Bool, imgV: UIImageView, isMirrorV: Bool) {   // Ok action on mirrow tap
        if done {
            let pattern = self.objNewWorkSpaceBaseViewModel.patternPiecesArray.filter({$0.imageView?.tag == imgV.tag})
            if !pattern.isEmpty {
                pattern[0].xcor = imgV.frame.origin.x
                pattern[0].ycor = imgV.frame.origin.y
                pattern[0].isMirrorV = (imgV.transform.d == -1)
                pattern[0].isMirrordH = (imgV.transform.a == -1)
                pattern[0].isRotated = false
                pattern[0].transfromA = "\(imgV.transform.a)"
                pattern[0].transfromD = "\(imgV.transform.d)"
                pattern[0].degree = 0
                pattern[0].isRotated = false
                pattern[0].showMirrorDialog = self.workspaceAreaView.checkAlertShown
            }
            let piece = self.objNewWorkSpaceBaseViewModel.piecesDroppedArray.filter({$0.imageView?.tag == imgV.tag})
            if !piece.isEmpty {
                pattern[0].xcor = imgV.frame.origin.x
                pattern[0].ycor = imgV.frame.origin.y
                piece[0].isMirrorV = (imgV.transform.d == -1)
                piece[0].isMirrordH = (imgV.transform.a == -1)
                piece[0].isRotated = false
                piece[0].transfromA = "\(imgV.transform.a)"
                piece[0].transfromD = "\(imgV.transform.d)"
                piece[0].degree = 0
                piece[0].isRotated = false
                piece[0].showMirrorDialog = self.workspaceAreaView.checkAlertShown
            }
        }
    }
    func mirrorAlertCancelTap(imgV: UIImageView) {   // Cancel tap on mirror alert
        let pattern = self.objNewWorkSpaceBaseViewModel.patternPiecesArray.filter({$0.imageView?.tag == imgV.tag})
        if !pattern.isEmpty {
            pattern[0].showMirrorDialog = self.workspaceAreaView.checkAlertShown
        }
        let piece = self.objNewWorkSpaceBaseViewModel.piecesDroppedArray.filter({$0.imageView?.tag == imgV.tag})
        if !piece.isEmpty {
            piece[0].showMirrorDialog = self.workspaceAreaView.checkAlertShown
        }
    }
}
