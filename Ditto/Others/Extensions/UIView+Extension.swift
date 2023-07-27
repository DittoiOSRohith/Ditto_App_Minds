//
//  UIView+Extension.swift
//  JoannTraceApp
//
//  Created by Prabha Rajalakshmi N on 04/09/20.
//  Copyright © 2020 Infosys. All rights reserved.
//

import UIKit

extension UIView {
    func removeAllSubviews() {
        for subview in subviews {
            subview.removeFromSuperview()
        }
    }
}

class ProgressBar: UIView {
    var label: UILabel = UILabel()
    var borderLayer: CAShapeLayer = CAShapeLayer()
    let progressLayer: CAShapeLayer = CAShapeLayer()
    var totalCutBinPieces = 0
    var lblView: UIView!
    var totalCutPieces = 0
    let imageVw = UIImageView()
    var progress = CGFloat()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func draw(_ rect: CGRect) {
        self.addCutView()
        self.addProgress()
    }
    func addCutView() {
        self.lblView = UIView()
        let color = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        self.lblView.backgroundColor = color
        self.lblView.layer.cornerRadius = 5
        self.lblView.frame = CGRect(x: self.frame.size.width - 70, y: UIDevice.isPad ? 0 : 5, width: 60, height: UIDevice.isPad ? 25 : 20)
        self.label.font = UIFont(name: FontName.openSans, size: UIDevice.isPad ? 12.0 : 10.0)
        self.label.frame = CGRect(x: 5, y: 0, width: 50, height: lblView.frame.height)
        self.label.text = String(format: "%d/%d pc", self.totalCutBinPieces, self.totalCutPieces)
        self.label.textColor = .white
        self.label.textAlignment = .center
        self.label.clipsToBounds = true
        self.lblView.clipsToBounds = true
        self.lblView.addSubview(self.label)
        self.lblView.bringSubviewToFront(self.label)
        self.addSubview(self.lblView)
    }
    func addProgress() {
        let borderView = UIView()
        borderView.backgroundColor = .white
        borderView.layer.cornerRadius = 5
        borderView.frame = CGRect(x: 10, y: self.lblView.frame.size.height + 5, width: self.frame.size.width - 20, height: 7)
        let progressView = UIProgressView()
        progressView.frame = CGRect(x: 5, y: 3, width: borderView.frame.width - 10, height: 6)
        progressView.transform = CGAffineTransform(scaleX: 1, y: 1.1)
        progressView.layer.cornerRadius = 5
        progressView.progress = Float(self.progress)
        progressView.progressTintColor = UIColor(red: 133/255, green: 187/255, blue: 56/255, alpha: 1.0)
        self.imageVw.frame = UIDevice.isPad ? CGRect(x: 0, y: -10, width: 20, height: 20) : CGRect(x: 0, y: -7, width: 15, height: 15)
        self.imageVw.image = UIImage(named: ImageNames.sissorsImage)
        self.imageVw.center.x = CGFloat(self.progress) * progressView.frame.width
        progressView.addSubview(self.imageVw)
        progressView.bringSubviewToFront(self.imageVw)
        borderView.addSubview(progressView)
        self.addSubview(borderView)
    }
}
