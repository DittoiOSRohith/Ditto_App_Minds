//
//  WorkSpaceViewModel.swift
//  Ditto
//
//  Created by Gaurav.rajan on 29/06/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit
import FastSocket
import CoreData
import Alamofire

class WorkspaceBaseViewModel {
    //MARK: VARIABLE DECLARATION
    var isFromInstructionView = false
    //MARK: FUNCTION LOGICS
    func getDroppedPatternPieceObject(tailornovaIndex: Int, droppedImageVw: UIImageView, imagePath: String, imageId: Int, location: CGPoint, tag: Int) -> PatternPieces {   // Saving workspace dropped piece values to array
        let patternObj = PatternPieces()
        patternObj.tailrnovaIndexId = tailornovaIndex
        patternObj.height = Double(droppedImageVw.frame.size.height)
        patternObj.image = droppedImageVw.image
        patternObj.width = Double(droppedImageVw.frame.size.width)
        patternObj.image = droppedImageVw.image
        patternObj.isDisabled = false
        patternObj.imageView = droppedImageVw
        patternObj.imagePath = imagePath
        patternObj.imageId = imageId
        patternObj.tagValue = tag
        patternObj.transfromD = Constants.defaultTransformValue
        patternObj.transfromA = Constants.defaultTransformValue
        droppedImageVw.tag = tag
        patternObj.xcor = droppedImageVw.frame.origin.x
        patternObj.ycor = droppedImageVw.frame.origin.y
        return patternObj
    }
}
