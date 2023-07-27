//
//  DropPiecesDetails+CoreDataProperties.swift
//  Ditto
//
//  Created by abiya.joy on 28/01/23.
//  Copyright © 2023 Infosys. All rights reserved.
//
//

import Foundation
import CoreData

extension DropPiecesDetails {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DropPiecesDetails> {
        return NSFetchRequest<DropPiecesDetails>(entityName: "DropPiecesDetails")
    }
    @NSManaged public var centerX: Float
    @NSManaged public var centerY: Float
    @NSManaged public var currentSplicedPieceColumn: Int16
    @NSManaged public var currentSplicedPieceRow: Int16
    @NSManaged public var idVal: Int32
    @NSManaged public var isRotated: Bool
    @NSManaged public var patternName: String?
    @NSManaged public var patternType: String?
    @NSManaged public var rotatedAngle: Float
    @NSManaged public var tabCategory: String?
    @NSManaged public var tailornovaIndex: Int32
    @NSManaged public var transformA: Float
    @NSManaged public var transformD: Float
    @NSManaged public var xVal: Float
    @NSManaged public var yVal: Float
    @NSManaged public var showMirrorDialog: Bool
    @NSManaged public var pattern: Pattern?
}

extension DropPiecesDetails: Identifiable {

}
