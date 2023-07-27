//
//  PatternPieceDetails+CoreDataProperties.swift
//  Ditto
//
//  Created by abiya.joy on 14/12/22.
//  Copyright © 2022 Infosys. All rights reserved.
//
//

import Foundation
import CoreData

extension PatternPieceDetails {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PatternPieceDetails> {
        return NSFetchRequest<PatternPieceDetails>(entityName: "PatternPieceDetails")
    }
    @NSManaged public var centerX: Float
    @NSManaged public var centerY: Float
    @NSManaged public var cutOnFold: Bool
    @NSManaged public var cutQuantity: String?
    @NSManaged public var id: Int16
    @NSManaged public var imagePath: String?
    @NSManaged public var isMirrored: String?
    @NSManaged public var isRotated: String?
    @NSManaged public var isSelected: Bool
    @NSManaged public var mirrorH: String?
    @NSManaged public var mirrorOption: Bool
    @NSManaged public var mirrorTranformD: Float
    @NSManaged public var mirrorTransformA: Float
    @NSManaged public var mirrorV: String?
    @NSManaged public var parentPatten: String?
    @NSManaged public var pieceDescription: String?
    @NSManaged public var pieceHieght: Float
    @NSManaged public var pieceNumber: String?
    @NSManaged public var pieceWidth: Float
    @NSManaged public var pieceX: Float
    @NSManaged public var pieceY: Float
    @NSManaged public var positionInTabLineUp: String?
    @NSManaged public var rotatedAngle: Float
    @NSManaged public var size: String?
    @NSManaged public var splice: Bool
    @NSManaged public var spliceDirection: String?
    @NSManaged public var spliceScreenQuantity: String?
    @NSManaged public var tabCategory: String?
    @NSManaged public var tailornovaIndex: Int32
    @NSManaged public var thumbnailImagePath: String?
    @NSManaged public var view: String?
    @NSManaged public var contrast: String?
    @NSManaged public var pattern: Pattern?
    @NSManaged public var splicedImages: NSSet?
    @NSManaged public var workSpace: Workspace?
    @NSManaged public var workSpaceBin: Workspace?
}

// MARK: Generated accessors for splicedImages
extension PatternPieceDetails {

    @objc(addSplicedImagesObject:)
    @NSManaged public func addToSplicedImages(_ value: SplicedImages)

    @objc(removeSplicedImagesObject:)
    @NSManaged public func removeFromSplicedImages(_ value: SplicedImages)

    @objc(addSplicedImages:)
    @NSManaged public func addToSplicedImages(_ values: NSSet)

    @objc(removeSplicedImages:)
    @NSManaged public func removeFromSplicedImages(_ values: NSSet)

}

extension PatternPieceDetails: Identifiable {

}
