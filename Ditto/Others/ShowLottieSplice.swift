//
//  ShowLottieSplice.swift
//  Ditto
//
//  Created by Gaurav.rajan on 23/07/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit
import Lottie

class ShowLottieSplice: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        let jsonName = ConnectivityUtils.spliceArrow
        let animation = Animation.named(jsonName)
        animView = AnimationView(animation: animation)
        animView.frame.size = self.frame.size
        animView.loopMode = .loop
        switch self.tag {
        case SpliceConstant.spliceRight.rawValue:
            animView.transform = CGAffineTransform(rotationAngle: .pi / 2)
        case SpliceConstant.spliceBottom.rawValue:
            animView.transform = CGAffineTransform(rotationAngle: .pi / -1)
        case SpliceConstant.spliceLeft.rawValue:
            animView.transform = CGAffineTransform(rotationAngle: .pi / -2)
        default:
            break
        }
        for view in self.subviews {
            view.removeFromSuperview()
        }
        if  self.subviews.isEmpty {
            self.addSubview(animView)
        }
        animView.backgroundBehavior = .pauseAndRestore
        animView.play { _ in
            DispatchQueue.main.async {
            }
        }
    }
}
