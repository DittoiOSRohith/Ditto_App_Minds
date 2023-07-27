//
//  PatternPieces.swift
//  Ditto
//
//  Created by Gaurav Rajan on 20/04/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit

class PatternPieces: NSObject {
    var xcor: CGFloat = 0
    var ycor: CGFloat = 0
    var width = 0.0
    var height = 0.0
    var image: UIImage?
    var isDisabled: Bool = false
    var imageView: UIImageView?
    var tagValue = 0
    var isMirrordH: Bool! = false
    var isMirrorV: Bool! = false
    var isRotated: Bool = false
    var degree: CGFloat = 0
    var imagePath = FormatsString.emptyString
    var isSpliced = false
    var imageId: Int = 0
    var centerX: Float = 0.0
    var centerY: Float = 0.0
    var patternPieceId  = 0
    var isCompleted = false
    var mirrorOption = false
    var showMirrorDialog = false
    var currentSplicedPieceNo = FormatsString.emptyString
    var currentSplicedPieceRow = 0
    var currentSplicedPieceColumn = 0
    var transfromA = Constants.defaultTransformValue
    var transfromD = Constants.defaultTransformValue
    var tailrnovaIndexId  = 0
}
