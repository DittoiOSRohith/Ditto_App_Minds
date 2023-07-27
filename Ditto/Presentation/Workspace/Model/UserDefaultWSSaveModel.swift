//
//  UserDefaultWSSaveModel.swift
//  Ditto
//
//  Created by Gaurav.rajan on 01/12/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import Foundation

class UserDefaultWSSaveModel {
    var idVal = Int()
    var tailornovaIndex = Int()
    var tabCategory = FormatsString.emptyString
    var xcor: Float = 0.0
    var ycor: Float = 0.0
    var centerX: Float = 0.0
    var centerY: Float = 0.0
    var rotatedAngle: Float = 0.0
    var isRotated = false
    var transformA: Float = 1.0
    var transformD: Float = 1.0
    var patternTitle = FormatsString.emptyString
    var addNotes = FormatsString.emptyString
    var patternType = FormatsString.emptyString
    var currentSplicedPieceRow: Int16 = 0
    var currentSplicedPieceColumn: Int16 = 0
    var showMirrorDialog = false
}
