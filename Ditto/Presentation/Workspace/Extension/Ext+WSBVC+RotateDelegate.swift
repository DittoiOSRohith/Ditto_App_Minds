//
//  Ext+WSBVC+RotateDelegate.swift
//  Ditto
//
//  Created by abiya.joy on 27/03/23.
//  Copyright © 2023 Infosys. All rights reserved.
//

import UIKit

extension WorkspaceBaseViewController: rotateDelegate {
    @objc func rotateDropDownTapped() {   // Rotate drop down tap action
        let frames = UIDevice.isPad ? self.workspaceAreaView.rotateDropDowniPadView.frame : self.workspaceAreaView.rotateDropDowniPhoneView.frame
        if !self.objNewWorkSpaceBaseViewModel.rotateSelected {
            self.objNewWorkSpaceBaseViewModel.transparentView.frame = KAppDelegate.window?.frame ?? self.view.frame
            self.view.addSubview(self.objNewWorkSpaceBaseViewModel.transparentView)
            let removeListTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.removeRotateListView))
            self.objNewWorkSpaceBaseViewModel.transparentView.addGestureRecognizer(removeListTapGesture)
            let frameX = frames.origin.x + Proxy.shared.keyWindow!.safeAreaInsets.left
            var frameY = frames.origin.y + frames.size.height + Proxy.shared.keyWindow!.safeAreaInsets.top + 5 + self.headerView.frame.height
            self.objNewWorkSpaceBaseViewModel.tableView.frame = CGRect(x: frameX, y: frameY, width: frames.size.width, height: 0)
            self.view.addSubview(self.objNewWorkSpaceBaseViewModel.tableView)
            self.objNewWorkSpaceBaseViewModel.tableView.layer.cornerRadius = 0
            self.objNewWorkSpaceBaseViewModel.tableView.reloadData()
            self.objNewWorkSpaceBaseViewModel.tableView.layer.borderColor = ColorHandler.tableViewBorderColor.cgColor
            self.objNewWorkSpaceBaseViewModel.tableView.layer.borderWidth = 1
            self.objNewWorkSpaceBaseViewModel.tableView.layer.shadowOpacity = 0.5
            UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
                var dropHeight = CGFloat(self.objNewWorkSpaceBaseViewModel.rotationList.count * (UIDevice.isPad ? 37 : 27))
                if dropHeight + Proxy.shared.keyWindow!.safeAreaInsets.bottom + frameY - 5 >= (KAppDelegate.window?.frame.height)! {
                    frameY = frames.origin.y + Proxy.shared.keyWindow!.safeAreaInsets.top + self.headerView.frame.height - (dropHeight + 5)
                } else if dropHeight + Proxy.shared.keyWindow!.safeAreaInsets.bottom + frameY >= (KAppDelegate.window?.frame.height)! {
                    dropHeight = (KAppDelegate.window?.frame.height)! - (Proxy.shared.keyWindow!.safeAreaInsets.bottom + frameY + 2)
                }
                self.objNewWorkSpaceBaseViewModel.tableView.frame = CGRect(x: frameX, y: frameY, width: frames.size.width, height: dropHeight)
                self.objNewWorkSpaceBaseViewModel.tableView.flashScrollIndicators()
                self.objNewWorkSpaceBaseViewModel.rotateSelected = !self.objNewWorkSpaceBaseViewModel.rotateSelected
            }, completion: nil)
        } else {
            self.removeRotateListView()
        }
    }
    @objc func removeRotateListView() {  // Closing the drop down view
        let frames = UIDevice.isPad ? self.workspaceAreaView.rotateDropDowniPadView.frame : self.workspaceAreaView.rotateDropDowniPhoneView.frame
        self.objNewWorkSpaceBaseViewModel.rotateSelected = !self.objNewWorkSpaceBaseViewModel.rotateSelected
        self.objNewWorkSpaceBaseViewModel.transparentView.removeFromSuperview()
        let frameX = frames.origin.x + Proxy.shared.keyWindow!.safeAreaInsets.left
        var frameY = frames.origin.y + frames.size.height + Proxy.shared.keyWindow!.safeAreaInsets.top + 5  + self.headerView.frame.height
        UIView.animate(withDuration: 0.4, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: .curveEaseInOut, animations: {
            let dropHeight = CGFloat(self.objNewWorkSpaceBaseViewModel.rotationList.count * (UIDevice.isPad ? 37 : 27))
            if dropHeight + Proxy.shared.keyWindow!.safeAreaInsets.bottom + frameY - 5 >= (KAppDelegate.window?.frame.height)! {
                frameY = frames.origin.y + Proxy.shared.keyWindow!.safeAreaInsets.top + self.headerView.frame.height - 5
            }
            self.objNewWorkSpaceBaseViewModel.tableView.frame = CGRect(x: frameX, y: frameY, width: frames.size.width, height: 0)
        }, completion: nil)
    }
    func rotateButtonFunction() {
        if let recognizerView = self.objNewWorkSpaceBaseViewModel.tappedImgVw as UIImageView? {
            let currentPiece = self.objNewWorkSpaceBaseViewModel.piecesDroppedArray.filter {($0.imageView?.tag == recognizerView.tag)}
            let finalAngle = self.objNewWorkSpaceBaseViewModel.rotationSelection == 0 ? Constants.rotationRoundValue : -Constants.rotationRoundValue
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: {
                if (self.workspaceAreaView.checkFlippedV && !self.workspaceAreaView.checkFlippedH) || (self.workspaceAreaView.checkFlippedH && !self.workspaceAreaView.checkFlippedV) {
                    recognizerView.transform = recognizerView.transform.rotated(by: CGFloat(-finalAngle.degreesToRadians))
                } else {
                    recognizerView.transform = recognizerView.transform.rotated(by: CGFloat(finalAngle.degreesToRadians))
                }
                self.objNewWorkSpaceBaseViewModel.isRotated = true
                self.objNewWorkSpaceBaseViewModel.lastangle = finalAngle
                self.rotationRecalculationFunction(tag: recognizerView.tag)
                self.objNewWorkSpaceBaseViewModel.degree = self.objNewWorkSpaceBaseViewModel.lastangle
                if self.isAnyCornersOusideTheWorkspace(recognizerView: recognizerView) || (recognizerView.frame.origin.x < 0) || (recognizerView.frame.origin.y < 0) || ((recognizerView.frame.origin.y + recognizerView.frame.height) > self.workspaceAreaView.workAreaView.frame.height) || ((recognizerView.frame.origin.x + recognizerView.frame.width) > self.workspaceAreaView.workAreaView.frame.width) {
                    DispatchQueue.main.async {
                        self.view.makeToast(AlertMessage.rotationExceedMessage, duration: 3.0)
                    }
                    if (self.workspaceAreaView.checkFlippedV && !self.workspaceAreaView.checkFlippedH) || (self.workspaceAreaView.checkFlippedH && !self.workspaceAreaView.checkFlippedV) {
                        recognizerView.transform = recognizerView.transform.rotated(by: CGFloat(finalAngle.degreesToRadians))
                    } else {
                        recognizerView.transform = recognizerView.transform.rotated(by: CGFloat(-finalAngle.degreesToRadians))
                    }
                    self.workspaceAreaView.rotateDropDowniPhoneButton.setTitle(FormatsString.rotateLabel, for: .normal)
                    self.workspaceAreaView.rotateDropDowniPadButton.setTitle(FormatsString.rotateLabel, for: .normal)
                    self.objNewWorkSpaceBaseViewModel.degree = !currentPiece.isEmpty ? currentPiece[0].degree : CGFloat(0)
                    self.objNewWorkSpaceBaseViewModel.isRotated = !currentPiece.isEmpty ? currentPiece[0].isRotated : false
                    return
                }
            }, completion: { _ in
                for img in self.objNewWorkSpaceBaseViewModel.piecesDroppedArray {
                    if let im1 = img as PatternPieces? {
                        if recognizerView.tag == im1.imageView?.tag {
                            im1.isRotated = self.objNewWorkSpaceBaseViewModel.isRotated
                            im1.degree = im1.isRotated ? self.objNewWorkSpaceBaseViewModel.degree : !currentPiece.isEmpty ? currentPiece[0].degree : CGFloat(0)
                            let center = recognizerView.frame.origin
                            im1.centerX = Float(center.x)
                            im1.centerY = Float(center.y)
                        }
                    }
                }
                for img in self.objNewWorkSpaceBaseViewModel.patternPiecesArray {
                    if let im1 = img as PatternPieces? {
                        if recognizerView.tag == im1.imageView?.tag {
                            im1.isRotated = self.objNewWorkSpaceBaseViewModel.isRotated
                            im1.degree = im1.isRotated ? self.objNewWorkSpaceBaseViewModel.degree : !currentPiece.isEmpty ? currentPiece[0].degree : CGFloat(0)
                            im1.xcor = recognizerView.frame.origin.x
                            im1.ycor = recognizerView.frame.origin.y
                            recognizerView.layer.setValue(self.objNewWorkSpaceBaseViewModel.degree, forKey: "rotateValue")
                        }
                    }
                }
                self.objNewWorkSpaceBaseViewModel.prevdegree = self.objNewWorkSpaceBaseViewModel.degree
                self.objNewWorkSpaceBaseViewModel.lastangle = 0
            })
        }
    }
}
