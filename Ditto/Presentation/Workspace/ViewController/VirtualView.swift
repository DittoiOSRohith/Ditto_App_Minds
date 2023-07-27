//
//  VirtualView.swift
//  JoannTraceApp
//
//  Created by Sanchu Bose on 13/09/20.
//  Copyright © 2020 Infosys. All rights reserved.
//

import UIKit

class VirtualView: UIView {
    //MARK: VARIABLE DECLARATION
    var pattern = [PatternPieces]()
    var scaleF = CGFloat()
    var isMirrorV = Bool()
    var isMirrorH = Bool()
    var mirrorH = CGAffineTransform()
    var mirrorV = CGAffineTransform()
    var img = UIImage()
}
class VirtualLayer: CALayer {
    //MARK: VARIABLE DECLARATION
    var pattern = [PatternPieces]()
    var scaleF = CGFloat()
    var img = UIImage()
    override func draw(in ctx: CGContext) {   // Code to draw pattern piece in virtual workspace
        self.drawsAsynchronously = true
        if !self.pattern.isEmpty {
            for patterns in self.pattern {
                if let im1 = patterns as PatternPieces? {
                    if im1.imageView?.transform.b != nil {
                        let wdth: CGFloat = (im1.imageView?.image?.size.width)!
                        let hite: CGFloat = (im1.imageView?.image?.size.height)!
                        let size = CGSize(width: wdth * self.scaleF, height: hite * self.scaleF)
                        if im1.transfromD == Constants.changingTransformValue && im1.transfromA == Constants.defaultTransformValue {   // mirrorv done
                            self.img = im1.image!.resizeImage(targetSize: size)!.flipImageVertically()!
                        } else if im1.transfromD == Constants.defaultTransformValue && im1.transfromA == Constants.changingTransformValue {   // mirrorh done
                            self.img = im1.image!.resizeImage(targetSize: size)!.withHorizontallyFlippedOrientation()
                        } else if im1.transfromD == Constants.changingTransformValue && im1.transfromA == Constants.changingTransformValue {   // both mirrorh and mirrorv together done
                            self.img = im1.image!.resizeImage(targetSize: size)!.flipImageVertically()!.withHorizontallyFlippedOrientation()
                        } else {   // normal piece
                            self.img = im1.image!.resizeImage(targetSize: size)!
                        }
                        if im1.isRotated {   // Code to draw rotated piece which can be mirrored or not.
                            let degree = Float(im1.degree.degreesToRadians)
                            self.img = self.img.rotateImage(radians: degree)!
                        }
                        let location = CGPoint(x: im1.xcor * self.scaleF, y: im1.ycor * self.scaleF)
                        self.img.draw(at: location)
                        self.contents = self.img
                    }
                }
            }
        }
        UIGraphicsGetCurrentContext()
    }
}
