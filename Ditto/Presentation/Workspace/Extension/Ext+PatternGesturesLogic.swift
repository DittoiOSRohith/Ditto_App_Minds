//
//  Ext+PatternGesturesLogic.swift
//  Ditto
//
//  Created by abiya.joy on 16/12/22.
//  Copyright © 2022 Infosys. All rights reserved.
//

import UIKit
import Alamofire

extension WorkspaceBaseViewController {
    func addGestureRecognizerToView() {   // Adding gestures to view
        self.objNewWorkSpaceBaseViewModel.longPressGesture = UITapGestureRecognizer(target: self, action: #selector(self.longPress(gestureRecognizer:)))
        self.objNewWorkSpaceBaseViewModel.longPressGesture.numberOfTapsRequired = 2
        self.objNewWorkSpaceBaseViewModel.rotate = UIRotationGestureRecognizer(target: self, action: #selector(self.rotatedView(_:)))
        self.objNewWorkSpaceBaseViewModel.tapGr = UITapGestureRecognizer(target: self, action: #selector(self.touchDetect(_:)))
    }
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {   // dismiss zoom popup view
        self.objNewWorkSpaceBaseViewModel.titleLabel.removeFromSuperview()
        self.objNewWorkSpaceBaseViewModel.imagvPopUp.removeFromSuperview()
        self.objNewWorkSpaceBaseViewModel.popup.removeFromSuperview()
        self.objNewWorkSpaceBaseViewModel.popupBackground.removeFromSuperview()
    }
    @objc func longPress(gestureRecognizer: UITapGestureRecognizer) {   // zoom with double tap gesture
        if gestureRecognizer.state == .changed || gestureRecognizer.state == .ended {
            if gestureRecognizer.view != nil {
                self.objNewWorkSpaceBaseViewModel.popupBackground.frame = UIScreen.main.bounds
                self.objNewWorkSpaceBaseViewModel.popupBackground.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                self.objNewWorkSpaceBaseViewModel.tappedImgVw.layer.borderWidth = 0
                self.objNewWorkSpaceBaseViewModel.tappedImgVw = gestureRecognizer.view! as! UIImageView
                let patternObj = self.objNewWorkSpaceBaseViewModel.piecesDroppedArray.filter {($0.tagValue == self.objNewWorkSpaceBaseViewModel.tappedImgVw.tag)}
                guard let patternFirst = patternObj.first else {
                    return
                }
                let selected = self.getImageForPatternPiece(id: patternFirst.tailrnovaIndexId)
                self.objNewWorkSpaceBaseViewModel.selctd = selected
                if gestureRecognizer.state == .recognized {
                    self.showZoomPopUp(isForReference: false)
                }
            }
        }
    }
    func showZoomPopUp(isForReference: Bool) {   // Bring zoom popup over screen
        if !isForReference {
            DispatchQueue.main.async {
                NewWorkSpaceBaseViewModel.zoomLabelShown = true
                self.workspaceAreaView.doubleTapToZoomLabel.isHidden = true
            }
        }
        self.objNewWorkSpaceBaseViewModel.popup.frame = UIDevice.isPad ? CGRect(x: 0, y: 0, width: 900, height: 700) : CGRect(x: 0, y: 0, width: 490, height: 307)
        self.objNewWorkSpaceBaseViewModel.popupBackground.frame = UIScreen.main.bounds
        self.objNewWorkSpaceBaseViewModel.popupBackground.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        self.objNewWorkSpaceBaseViewModel.tappedImgVw.layer.borderWidth = 0
        self.objNewWorkSpaceBaseViewModel.popup.center = self.view.center
        self.objNewWorkSpaceBaseViewModel.popup.backgroundColor = UIColor.white
        self.objNewWorkSpaceBaseViewModel.popup.layer.borderWidth = 1
        self.objNewWorkSpaceBaseViewModel.popup.layer.borderColor = UIColor.white.cgColor
        self.objNewWorkSpaceBaseViewModel.imagvPopUp.tintColor = UIColor.black
        self.objNewWorkSpaceBaseViewModel.imagvPopUp.alpha = 1.0
        let topFrame = UIImageView()
        topFrame.frame = CGRect(x: 0, y: 0, width: self.objNewWorkSpaceBaseViewModel.popup.frame.size.width, height: 40)
        topFrame.backgroundColor = .white
        var closeButton = UIButton()
        let closeButtonFrame = CGRect(x: self.objNewWorkSpaceBaseViewModel.popup.frame.size.width - 50, y: (UIDevice.isPad ? 40 : 15) - 6, width: 30, height: 30)
        closeButton = UIButton(frame: closeButtonFrame )
        let closeImage = UIImage(named: ImageNames.closeButtonImage)
        closeButton.setImage(closeImage, for: UIControl.State.normal)
        closeButton.contentVerticalAlignment = .fill
        closeButton.contentHorizontalAlignment = .fill
        closeButton.imageEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        var scrollView = UIScrollView()
        scrollView = UIScrollView(frame: self.objNewWorkSpaceBaseViewModel.popup.bounds)
        scrollView.tag = 123
        scrollView.delegate = self
        scrollView.isScrollEnabled = true
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 4
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.clipsToBounds = true
        // adding imageview as a subview of scroll view
        scrollView.addSubview(self.objNewWorkSpaceBaseViewModel.imagvPopUp)
        // content size of the scroll view is the size of the image
        scrollView.contentSize = self.objNewWorkSpaceBaseViewModel.popup.bounds.size
        scrollView.zoomScale = 1
        closeButton.isUserInteractionEnabled = true
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.dismissFullscreenImage))
        closeButton.addGestureRecognizer(tapRecognizer)
        self.objNewWorkSpaceBaseViewModel.imagvPopUp.isUserInteractionEnabled = true
        self.objNewWorkSpaceBaseViewModel.imagvPopUp.image = self.objNewWorkSpaceBaseViewModel.selctd
        self.objNewWorkSpaceBaseViewModel.popup.addSubview(scrollView)
        self.objNewWorkSpaceBaseViewModel.imagvPopUp.translatesAutoresizingMaskIntoConstraints = false
        self.objNewWorkSpaceBaseViewModel.imagvPopUp.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        self.objNewWorkSpaceBaseViewModel.imagvPopUp.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor).isActive = true
        self.objNewWorkSpaceBaseViewModel.imagvPopUp.widthAnchor.constraint(equalToConstant: scrollView.frame.width - 2 * (UIDevice.isPad ? 50 : 20)).isActive = true
        self.objNewWorkSpaceBaseViewModel.imagvPopUp.heightAnchor.constraint(equalToConstant: scrollView.frame.height - 2 * (UIDevice.isPad ? 40 : 15)).isActive = true
        let topSpace = isForReference ? (CGFloat(UIDevice.isPad ? 40 : 15) + 40) : 50
        self.objNewWorkSpaceBaseViewModel.imagvPopUp.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: topSpace ).isActive = true
        self.objNewWorkSpaceBaseViewModel.imagvPopUp.clipsToBounds = true
        self.objNewWorkSpaceBaseViewModel.imagvPopUp.contentMode = .scaleAspectFit
        self.objNewWorkSpaceBaseViewModel.popup.clipsToBounds = true
        self.objNewWorkSpaceBaseViewModel.popup.addSubview(closeButton)
        self.objNewWorkSpaceBaseViewModel.popup.addSubview(topFrame)
        self.objNewWorkSpaceBaseViewModel.popup.bringSubviewToFront(closeButton)
        if isForReference {   // Title only for refernce layout zoom popup
            self.objNewWorkSpaceBaseViewModel.titleLabel.frame = CGRect(x: (UIDevice.isPad ? 50 : 20), y: (UIDevice.isPad ? 40 : 15), width: 300, height: 30)
            self.objNewWorkSpaceBaseViewModel.titleLabel.textColor = UIColor.black
            self.objNewWorkSpaceBaseViewModel.titleLabel.font = CustomFont.avenirLtProMedium(size: (UIDevice.isPad ? 26 : 16))
            self.objNewWorkSpaceBaseViewModel.titleLabel.text = FormatsString.referenceLayoutLabel
            self.objNewWorkSpaceBaseViewModel.popup.addSubview(self.objNewWorkSpaceBaseViewModel.titleLabel)
            self.objNewWorkSpaceBaseViewModel.popup.bringSubviewToFront(self.objNewWorkSpaceBaseViewModel.titleLabel)
        }
        self.objNewWorkSpaceBaseViewModel.popupBackground.addSubview(self.objNewWorkSpaceBaseViewModel.popup)
        self.view.addSubview(self.objNewWorkSpaceBaseViewModel.popupBackground)
    }
    @objc func handlePan(gestureRecognizer: UIPanGestureRecognizer) {   // Pan gesture handling
        let translation = gestureRecognizer.translation(in: self.workspaceAreaView.workAreaView)
        let superview = gestureRecognizer.view?.superview
        let superviewSize = superview?.bounds.size
        let thisSize = gestureRecognizer.view?.frame.size
        var center = CGPoint(x: gestureRecognizer.view!.center.x + translation.x, y: gestureRecognizer.view!.center.y + translation.y)
        self.objNewWorkSpaceBaseViewModel.tappedImgVw = gestureRecognizer.view! as! UIImageView
        if gestureRecognizer.state == UIGestureRecognizer.State.changed {
            if !self.objNewWorkSpaceBaseViewModel.isSelectAll {
                self.setSelectionForDroppedPatternPiece(gesture: gestureRecognizer.view! as! UIImageView)
                self.checkPatternPiecForMirroringAndSplicing(image: self.objNewWorkSpaceBaseViewModel.tappedImgVw)
                for view in self.workspaceAreaView.workAreaView.subviews {
                    if let imageView1 = view as? UIImageView {
                        if imageView1 != self.objNewWorkSpaceBaseViewModel.tappedImgVw {
                            for gesture in imageView1.gestureRecognizers! {
                                if let recognizer = gesture as? UIPanGestureRecognizer {
                                    recognizer.isEnabled = false
                                }
                            }
                        }
                    }
                }
            }
            var resetTranslation = CGPoint(x: translation.x, y: translation.y)
            if center.x - (thisSize?.width)!/2 < 0 {
                center.x = (thisSize?.width)!/2
            } else if center.x + (thisSize?.width)!/2 > (superviewSize?.width)! {
                center.x = (superviewSize?.width)!-(thisSize?.width)!/2
            } else {
                resetTranslation.x = 0 // Only reset the horizontal translation if the view *did* translate horizontally
            }
            if center.y - (thisSize?.height)!/2 < 0 {
                center.y = (thisSize?.height)!/2
            } else if center.y + (thisSize?.height)!/2 > (superviewSize?.height)! {
                center.y = (superviewSize?.height)!-(thisSize?.height)!/2
            } else {
                resetTranslation.y = 0 // Only reset the vertical translation if the view *did* translate vertically
            }
            gestureRecognizer.view?.center = center
            gestureRecognizer.setTranslation(CGPoint(x: 0, y: 0), in: self.workspaceAreaView.workAreaView)
        } else if gestureRecognizer.state == .ended {
            self.objNewWorkSpaceBaseViewModel.tappedImgVw = gestureRecognizer.view! as! UIImageView
            for view in self.workspaceAreaView.workAreaView.subviews {
                if let imageView1 = view as? UIImageView {
                    if imageView1 != self.objNewWorkSpaceBaseViewModel.tappedImgVw {
                        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(gestureRecognizer:)))
                        imageView1.addGestureRecognizer(panGesture)
                    }
                }
            }
            if self.objNewWorkSpaceBaseViewModel.isSpliceImageAddedToWorkspace {
                var imgcen: CGPoint = .zero
                if self.objNewWorkSpaceBaseViewModel.currentSpliceDirection == SpliceDirectionType.leftToRightSplicing.rawValue {
                    imgcen = CGPoint(x: self.objNewWorkSpaceBaseViewModel.originalSplicePosition.midX, y: center.y)
                } else {
                    imgcen = CGPoint(x: center.x, y: self.objNewWorkSpaceBaseViewModel.originalSplicePosition.midY)
                }
                self.objNewWorkSpaceBaseViewModel.xVal = (gestureRecognizer.view?.frame.origin.x)!
                self.objNewWorkSpaceBaseViewModel.yVal =  (gestureRecognizer.view?.frame.origin.y)!
                if self.objNewWorkSpaceBaseViewModel.currentSpliceIndex == 2 {
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        gestureRecognizer.view?.center = CGPoint(x: self.objNewWorkSpaceBaseViewModel.originalSplicePosition.midX, y: self.objNewWorkSpaceBaseViewModel.originalSplicePosition.midY)
                        if self.objNewWorkSpaceBaseViewModel.currentSpliceDirection == SpliceDirectionType.leftToRightSplicing.rawValue {
                            self.objNewWorkSpaceBaseViewModel.yVal =  self.objNewWorkSpaceBaseViewModel.originalSplicePosition.origin.y
                        } else {
                            self.objNewWorkSpaceBaseViewModel.xVal =  self.objNewWorkSpaceBaseViewModel.originalSplicePosition.origin.x
                        }
                    })
                } else {
                    UIView.animate(withDuration: 0.3, animations: { () -> Void in
                        gestureRecognizer.view?.center = imgcen
                    })
                }
            }
            let id = gestureRecognizer.view?.tag
            for drop in self.objNewWorkSpaceBaseViewModel.piecesDroppedArray.filter({ $0.imageView?.tag == id}) {
                drop.centerY = Float(center.y)
                drop.centerX = Float(center.x)
            }
            for piece in self.objNewWorkSpaceBaseViewModel.patternPiecesArray.filter({ $0.imageView?.tag == id}) {
                if self.objNewWorkSpaceBaseViewModel.isSpliceImageAddedToWorkspace {
                    if self.objNewWorkSpaceBaseViewModel.currentSpliceDirection == SpliceDirectionType.leftToRightSplicing.rawValue {
                        gestureRecognizer.view?.center = CGPoint(x: self.objNewWorkSpaceBaseViewModel.originalSplicePosition.midX, y: center.y)
                    } else {
                        gestureRecognizer.view?.center = CGPoint(x: center.x, y: self.objNewWorkSpaceBaseViewModel.originalSplicePosition.midY)
                    }
                    if self.objNewWorkSpaceBaseViewModel.currentSpliceIndex == 2 {
                        gestureRecognizer.view?.center = CGPoint(x: self.objNewWorkSpaceBaseViewModel.originalSplicePosition.midX, y: self.objNewWorkSpaceBaseViewModel.originalSplicePosition.midY)
                    } else {
                        self.objNewWorkSpaceBaseViewModel.xVal = (gestureRecognizer.view?.frame.origin.x)!
                        self.objNewWorkSpaceBaseViewModel.yVal = (gestureRecognizer.view?.frame.origin.y)!
                        piece.xcor = (gestureRecognizer.view?.frame.origin.x)!
                        piece.ycor = (gestureRecognizer.view?.frame.origin.y)!
                    }
                } else {
                    piece.xcor = (gestureRecognizer.view?.frame.origin.x)!
                    piece.ycor = (gestureRecognizer.view?.frame.origin.y)!
                    piece.height = Double(piece.height)
                    piece.width = Double(piece.width)
                }
            }
        }
    }
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        if touch.view?.isDescendant(of: self.workspaceAreaView.workAreaView) == true {
            return true
        }
        return true
    }
    func rotationRecalculationFunction(tag: Int) {   // Rotation angle keeping within -180 to 180 range
        let img = self.objNewWorkSpaceBaseViewModel.piecesDroppedArray.filter({ $0.tagValue == tag})
        self.objNewWorkSpaceBaseViewModel.haveAngle = !img.isEmpty ? img[0].degree : CGFloat(0)
        self.objNewWorkSpaceBaseViewModel.lastangle = CGFloat(round((self.objNewWorkSpaceBaseViewModel.lastangle + self.objNewWorkSpaceBaseViewModel.haveAngle) / Constants.rotationRoundValue) * Constants.rotationRoundValue)
        if self.objNewWorkSpaceBaseViewModel.lastangle > Constants.rotationCheckLower {
            self.objNewWorkSpaceBaseViewModel.lastangle -= Constants.rotationCheckHigher
        } else if self.objNewWorkSpaceBaseViewModel.lastangle < -Constants.rotationCheckLower {
            self.objNewWorkSpaceBaseViewModel.lastangle += Constants.rotationCheckHigher
        }
        if self.objNewWorkSpaceBaseViewModel.lastangle > Constants.rotationCheckLower && self.objNewWorkSpaceBaseViewModel.lastangle < -Constants.rotationCheckLower {
            self.rotationRecalculationFunction(tag: tag)
        }
    }
    func isAnyCornersOusideTheWorkspace(recognizerView: UIView) -> Bool {   // Rotation Outside Corner Check
        let view = recognizerView
        let corners = ViewCorners(view: view)
        if !self.workspaceAreaView.workAreaView.bounds.contains(corners.topLeft!) || !self.workspaceAreaView.workAreaView.bounds.contains(corners.topRight!) || !self.workspaceAreaView.workAreaView.bounds.contains(corners.bottomLeft!) || !self.workspaceAreaView.workAreaView.bounds.contains(corners.bottomRight!) {
            return true
        } else {
            return false
        }
    }
    @objc func rotatedView(_ recognizer: UIRotationGestureRecognizer) {   // Rotation gesture handling
        if let recognizerView = self.objNewWorkSpaceBaseViewModel.tappedImgVw as UIImageView? {
            self.workspaceAreaView.workAreaView.clipsToBounds = true
            let currentPiece = self.objNewWorkSpaceBaseViewModel.piecesDroppedArray.filter {($0.imageView?.tag == recognizerView.tag)}
            let firstAngle = atan2( Double(recognizerView.transform.b), Double(recognizerView.transform.a))
            if (self.workspaceAreaView.checkFlippedV && !self.workspaceAreaView.checkFlippedH) || (self.workspaceAreaView.checkFlippedH && !self.workspaceAreaView.checkFlippedV) {
                recognizerView.transform = recognizerView.transform.rotated(by: -recognizer.rotation)
            } else {
                recognizerView.transform = recognizerView.transform.rotated(by: recognizer.rotation)
            }
            self.objNewWorkSpaceBaseViewModel.lastangle += recognizer.rotation.radiansToDegrees
            recognizer.rotation = 0
            if recognizer.state == .began {
                objNewWorkSpaceBaseViewModel.initialAngle = (round((atan2(Double(recognizerView.transform.b), Double(recognizerView.transform.a)).radiansToDegrees)/Constants.rotationRoundValue)) * Constants.rotationRoundValue
            }
            if recognizer.state == .ended || recognizer.state == .cancelled {
                var finalAngle = (round(atan2( Double(recognizerView.transform.b), Double(recognizerView.transform.a)).radiansToDegrees / Constants.rotationRoundValue)) * Constants.rotationRoundValue
                self.rotationRecalculationFunction(tag: recognizerView.tag)
                self.objNewWorkSpaceBaseViewModel.degree = self.objNewWorkSpaceBaseViewModel.lastangle
                finalAngle = round(finalAngle - firstAngle.radiansToDegrees)
                if (self.workspaceAreaView.checkFlippedV && !self.workspaceAreaView.checkFlippedH) || (self.workspaceAreaView.checkFlippedH && !self.workspaceAreaView.checkFlippedV) {
                    finalAngle = -finalAngle
                }
                UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1.0, options: .curveEaseIn, animations: {
                    recognizerView.transform = recognizerView.transform.rotated(by: CGFloat(finalAngle.degreesToRadians))
                    if self.isAnyCornersOusideTheWorkspace(recognizerView: recognizerView) || (recognizerView.frame.origin.x < 0) || (recognizerView.frame.origin.y < 0) || ((recognizerView.frame.origin.y + recognizerView.frame.height) > self.workspaceAreaView.workAreaView.frame.height) || ((recognizerView.frame.origin.x + recognizerView.frame.width) > self.workspaceAreaView.workAreaView.frame.width) {
                        let radians: Double = atan2( Double(recognizerView.transform.b), Double(recognizerView.transform.a))
                        let finalAngle = CGFloat(radians.radiansToDegrees) - CGFloat(self.objNewWorkSpaceBaseViewModel.initialAngle)
                        if (self.workspaceAreaView.checkFlippedV && !self.workspaceAreaView.checkFlippedH) || (self.workspaceAreaView.checkFlippedH && !self.workspaceAreaView.checkFlippedV) {
                            recognizerView.transform = recognizerView.transform.rotated(by: CGFloat(finalAngle.degreesToRadians))
                        } else {
                            recognizerView.transform = recognizerView.transform.rotated(by: CGFloat(-finalAngle.degreesToRadians))
                        }
                        self.objNewWorkSpaceBaseViewModel.lastangle = self.objNewWorkSpaceBaseViewModel.initialAngle
                        self.objNewWorkSpaceBaseViewModel.degree = !currentPiece.isEmpty ? currentPiece[0].degree : CGFloat(0)
                        self.objNewWorkSpaceBaseViewModel.isRotated = !currentPiece.isEmpty ? currentPiece[0].isRotated : false
                        return
                    }
                    self.objNewWorkSpaceBaseViewModel.isRotated = true
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
                            if recognizerView.tag  == im1.imageView?.tag {
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
                    recognizer.rotation = 0
                })
            }
        }
    }
}
