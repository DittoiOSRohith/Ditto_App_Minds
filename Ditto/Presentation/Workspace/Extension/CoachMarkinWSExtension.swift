//
//  CoachMarkinWSExtension.swift
//  Ditto
//
//  Created by Abiya Joy on 28/03/22.
//  Copyright © 2022 Infosys. All rights reserved.
//

import UIKit

extension WorkspaceBaseViewController {
    func setThumbnailView() {   // Show animation thumbanil view
        if CommonConst.showCThumbnailAnimationCheck {
            self.displayanimationView()
            CommonConst.showCThumbnailAnimationCheck = false
        } else {
            if CommonConst.animationCompleteStatusCheck {
                self.displayanimationView()
            }
        }
    }
    func displayanimationView() {   // Show animation view
        let noninteractionview = UIView.init(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height))
        noninteractionview.tag = 2000
        noninteractionview.backgroundColor = .clear
        self.view.addSubview(noninteractionview)
        self.view.addSubview(self.thumbnailView)
        var viewY = CGFloat()
        var widt = UIDevice.isPhone ? self.thumbnailView.frame.size.width : self.thumbnailView.frame.size.width + 80
        var hite = UIDevice.isPhone ? self.thumbnailView.frame.size.height : self.thumbnailView.frame.size.height + 80
        if UIDevice.isPhone {
            viewY = (self.view.frame.maxY - self.thumbnailView.frame.size.height  - 30) + 450
        } else {
            viewY = (self.view.frame.maxY - self.thumbnailView.frame.size.height  - 100) + 550
        }
        self.thumbnailView.frame = CGRect(x: self.workspaceSpliceReferenceView.frame.origin.x, y: viewY, width: widt, height: hite)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.moveViewUp(yposition: viewY)
        }
    }
    func moveViewUp(yposition: CGFloat) {   // Move animation view to ws Bottom position to view the animation frame
        UIView.animate(withDuration: 1, delay: 0.1, options: .curveEaseInOut, animations: {
            var val = CGFloat()
            val = UIDevice.isPhone ? 450 : 550
            let xPosition: CGFloat = UIDevice.isPhone && UIDevice.current.hasNotch ? self.workspaceSpliceReferenceView.frame.origin.x : self.workspaceSpliceReferenceView.frame.origin.x - 15
            self.thumbnailView.frame = CGRect(x: xPosition, y: yposition - val, width: self.thumbnailView.frame.size.width, height: self.thumbnailView.frame.size.height)
        }, completion: { _ in
        })
    }
    func removeWithZoomOutAnimation() {   // Remove animation thumbanil view
        UIView.animate(withDuration: 0.5, delay: 0.1, options: .curveEaseInOut, animations: {
            self.thumbnailView.transform = CGAffineTransform(scaleX: 0.01, y: 0.01)
        }, completion: { _ in
            self.thumbnailView.removeFromSuperview()
            self.addinstructionImg()
        })
    }
    func moveThumbnail(view: UIView) {   // dismiss animation view to bottom of Workspace
        let duration: Double = 0.5
        UIView.animate(withDuration: duration) {
            self.removeWithZoomOutAnimation()
            view.center.x = UIDevice.isPhone ? (self.workspaceAreaView.frame.minX + 125) : (self.workspaceAreaView.frame.minX + 80)
            view.center.y = UIDevice.isPhone ? (UIDevice.current.hasNotch ? self.workspaceAreaView.frame.maxY - 30 : self.workspaceAreaView.frame.maxY - 60) : (self.workspaceAreaView.frame.minY + 40)
        }
        let viewTag = self.view.subviews.filter({ $0.tag == 2000 })
        for view in viewTag {
            view.removeFromSuperview()
        }
        CommonConst.animationCompleteStatusCheck = false
    }
    func movetoVideoVC() {   // Show animation video view as full screen
        DispatchQueue.main.async {
            if let watchVideoController = Constants.loginStoryBoard.instantiateViewController(withIdentifier: Constants.AdvertisementVideoControllerIdentifier) as? AdvertisementVideoController {
                watchVideoController.modalPresentationStyle = .custom
                watchVideoController.videoUrl = ApiUrlStrings.animationVideoUrl
                watchVideoController.videoTitle = FormatsString.WorkSpace
                watchVideoController.isFromSceen = FormatsString.workspaceLabel
                watchVideoController.closeThumbnail = {
                    self.moveThumbnail(view: self.thumbnailView)
                }
                if self.presentedViewController == nil {
                    self.present(watchVideoController, animated: false, completion: nil)
                }
                CommonConst.animationCompleteStatusCheck = false
            }
        }
    }
    func addinstructionImg() {   // After dismissing animation view, displaying popup saying video can be seen later in Tutorial at WS bottom left
        self.view.addSubview(self.instructionimgView)
        var xPos = CGFloat()
        var yPos = CGFloat()
        var hite = CGFloat()
        var widt = CGFloat()
        xPos = UIDevice.isPhone ? (self.workspaceAreaView.frame.minX + 90) : (self.workspaceAreaView.frame.minX + 60)
        yPos = UIDevice.isPhone ? (UIDevice.current.hasNotch ? self.workspaceAreaView.frame.maxY - 110 : self.workspaceAreaView.frame.maxY - 150) : (self.workspaceAreaView.frame.minY - 80)
        hite = UIDevice.isPhone ? (self.instructionimgView.frame.size.height - 40) : self.instructionimgView.frame.size.height
        widt = UIDevice.isPhone ? (self.instructionimgView.frame.size.width - 50) : self.instructionimgView.frame.size.width
        self.instructionimgView.frame = CGRect(x: xPos, y: yPos, width: widt, height: hite)
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.instructionimgView.removeFromSuperview()
        }
    }
}
