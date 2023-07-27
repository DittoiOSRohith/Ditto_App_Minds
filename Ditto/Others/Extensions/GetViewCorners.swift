//
//  GetViewCorners.swift
//  JoannTraceApp
//
//  Created by Shefrin Hakeem on 09/10/20.
//  Copyright © 2020 Infosys. All rights reserved.
//

import UIKit

struct ViewCorners {
    private(set) var topLeft: CGPoint!
    private(set) var topRight: CGPoint!
    private(set) var bottomLeft: CGPoint!
    private(set) var bottomRight: CGPoint!
    private let originalCenter: CGPoint
    private let transformedView: UIView
    private func pointWith(multipliedWidth: CGFloat, multipliedHeight: CGFloat) -> CGPoint {
        var xVal = self.originalCenter.x
        xVal += self.transformedView.bounds.width  / 2 * multipliedWidth
        var yVal = self.originalCenter.y
        yVal += self.transformedView.bounds.height / 2 * multipliedHeight
        var result = CGPoint(x: xVal, y: yVal).applying(self.transformedView.transform)
        result.x += self.transformedView.transform.tx
        result.y += self.transformedView.transform.ty
        return result
    }
    init(view: UIView) {
        self.transformedView = view
        self.originalCenter = view.center.applying(view.transform.inverted())
        self.topLeft = self.pointWith(multipliedWidth: -1, multipliedHeight: -1)
        self.topRight = self.pointWith(multipliedWidth: 1, multipliedHeight: -1)
        self.bottomLeft = self.pointWith(multipliedWidth: -1, multipliedHeight: 1)
        self.bottomRight = self.pointWith(multipliedWidth: 1, multipliedHeight: 1)

    }
}
