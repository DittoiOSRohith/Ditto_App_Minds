//
//  UIImage+Extension.swift
//  JoannTraceApp
//
//  Created by Prabha Rajalakshmi N on 04/09/20.
//  Copyright © 2020 Infosys. All rights reserved.
//

import UIKit
import Accelerate

extension UIImage {
    func rotateImage(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext() as UIImage? ?? self
        UIGraphicsEndImageContext()
        return newImage
    }
    func flipImageVertically() -> UIImage? {
        guard let cgImg = self.cgImage else {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        let bitmap = UIGraphicsGetCurrentContext()!
        bitmap.translateBy(x: size.width / 2, y: size.height / 2)
        bitmap.scaleBy(x: 1.0, y: 1.0)
        bitmap.translateBy(x: -size.width / 2, y: -size.height / 2)
        bitmap.draw(cgImg, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let image = UIGraphicsGetImageFromCurrentImageContext() as UIImage? ?? self
        UIGraphicsEndImageContext()
        return image
    }
    func resizeImage(targetSize: CGSize) -> UIImage? {
        let size = self.size
        let format = imageRendererFormat
        let widthRatio  = targetSize.width  / self.size.width
        let heightRatio = targetSize.height / self.size.height
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        self.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if newImage != nil {
            return UIGraphicsImageRenderer(size: newImage!.size, format: format).image { _ in
                draw(in: CGRect(origin: .zero, size: newImage!.size))
            }
        }
        return UIImage()
    }
    func imageWithColor(tintColor: UIColor) -> UIImage {
        guard let cgImg = self.cgImage else {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        guard  let context = UIGraphicsGetCurrentContext(), let image = cgImage else { return self }
        context.translateBy(x: 0, y: size.height)
        context.scaleBy(x: 1, y: -1)
        context.setBlendMode(.normal)
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height) as CGRect
        //        context.clip(to: rect, mask: self.cgImage!)
        tintColor.setFill()
        UIRectFill(rect)
        context.fill(rect)
        context.clip(to: rect, mask: cgImg)
        context.draw(image, in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext() as UIImage? ?? self
        UIGraphicsEndImageContext()
        return newImage
    }
    func withBackground(color: UIColor, opaque: Bool = true) -> UIImage {
        guard let cgImg = self.cgImage else {
            return self
        }
        UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
        guard let ctx = UIGraphicsGetCurrentContext(), let image = cgImage else { return self }
        defer { UIGraphicsEndImageContext() }
        let rect = CGRect(origin: .zero, size: size)
        ctx.setFillColor(color.cgColor)
        ctx.fill(rect)
        ctx.concatenate(CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: size.height))
        ctx.clip(to: rect, mask: cgImg)
        ctx.draw(image, in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext() as UIImage? ?? self
        UIGraphicsEndImageContext()
        return newImage
    }
    func addPadding(_ padding: CGFloat) -> UIImage {
        let alignmentInset = UIEdgeInsets(top: -padding, left: -padding,
                                          bottom: -padding, right: -padding)
        return withAlignmentRectInsets(alignmentInset)
    }
}
