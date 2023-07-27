//
//  Pattern+CoreDataProperties.swift
//  Ditto
//
//  Created by abiya.joy on 20/12/22.
//  Copyright © 2022 Infosys. All rights reserved.
//
//

import Foundation
import CoreData

extension Pattern {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pattern> {
        return NSFetchRequest<Pattern>(entityName: "Pattern")
    }
    @NSManaged public var customSizeFitName: String?
    @NSManaged public var lastModifiedSizeDate: String?
    @NSManaged public var notiondetails: String?
    @NSManaged public var orderNo: String?
    @NSManaged public var patternBrand: String?
    @NSManaged public var patternDescriptionImage: String?
    @NSManaged public var patternImage: String?
    @NSManaged public var patternIndex: Int16
    @NSManaged public var patternInstruction: String?
    @NSManaged public var patternPDF: String?
    @NSManaged public var patternSize: String?
    @NSManaged public var patternTitle: String?
    @NSManaged public var addNotes: String?
    @NSManaged public var patternType: String?
    @NSManaged public var productId: String?
    @NSManaged public var purchasedSizeID: String?
    @NSManaged public var selectedSizeName: String?
    @NSManaged public var selectedTabCategory: String?
    @NSManaged public var selectedViewCupSizeName: String?
    @NSManaged public var status: String?
    @NSManaged public var subscriptionExpiryDate: String?
    @NSManaged public var tailornovadesignID: String?
    @NSManaged public var tailornovaDesignName: String?
    @NSManaged public var totalPieces: Int16
    @NSManaged public var yardagedetails: String?
    @NSManaged public var yardagePdfUrl: String?
    @NSManaged public var descImages: NSSet?
    @NSManaged public var dropPiecesDetails: NSSet?
    @NSManaged public var mannequins: NSSet?
    @NSManaged public var patternPiece: NSSet?
    @NSManaged public var patternSelvages: NSSet?
    @NSManaged public var workSpace: NSSet?
}

// MARK: Generated accessors for descImages
extension Pattern {

    @objc(addDescImagesObject:)
    @NSManaged public func addToDescImages(_ value: DescriptionImages)

    @objc(removeDescImagesObject:)
    @NSManaged public func removeFromDescImages(_ value: DescriptionImages)

    @objc(addDescImages:)
    @NSManaged public func addToDescImages(_ values: NSSet)

    @objc(removeDescImages:)
    @NSManaged public func removeFromDescImages(_ values: NSSet)

}

// MARK: Generated accessors for dropPiecesDetails
extension Pattern {

    @objc(addDropPiecesDetailsObject:)
    @NSManaged public func addToDropPiecesDetails(_ value: DropPiecesDetails)

    @objc(removeDropPiecesDetailsObject:)
    @NSManaged public func removeFromDropPiecesDetails(_ value: DropPiecesDetails)

    @objc(addDropPiecesDetails:)
    @NSManaged public func addToDropPiecesDetails(_ values: NSSet)

    @objc(removeDropPiecesDetails:)
    @NSManaged public func removeFromDropPiecesDetails(_ values: NSSet)

}

// MARK: Generated accessors for mannequins
extension Pattern {

    @objc(addMannequinsObject:)
    @NSManaged public func addToMannequins(_ value: Mannequin)

    @objc(removeMannequinsObject:)
    @NSManaged public func removeFromMannequins(_ value: Mannequin)

    @objc(addMannequins:)
    @NSManaged public func addToMannequins(_ values: NSSet)

    @objc(removeMannequins:)
    @NSManaged public func removeFromMannequins(_ values: NSSet)

}

// MARK: Generated accessors for patternPiece
extension Pattern {

    @objc(addPatternPieceObject:)
    @NSManaged public func addToPatternPiece(_ value: PatternPieceDetails)

    @objc(removePatternPieceObject:)
    @NSManaged public func removeFromPatternPiece(_ value: PatternPieceDetails)

    @objc(addPatternPiece:)
    @NSManaged public func addToPatternPiece(_ values: NSSet)

    @objc(removePatternPiece:)
    @NSManaged public func removeFromPatternPiece(_ values: NSSet)

}

// MARK: Generated accessors for patternSelvages
extension Pattern {

    @objc(addPatternSelvagesObject:)
    @NSManaged public func addToPatternSelvages(_ value: Selvages)

    @objc(removePatternSelvagesObject:)
    @NSManaged public func removeFromPatternSelvages(_ value: Selvages)

    @objc(addPatternSelvages:)
    @NSManaged public func addToPatternSelvages(_ values: NSSet)

    @objc(removePatternSelvages:)
    @NSManaged public func removeFromPatternSelvages(_ values: NSSet)

}

// MARK: Generated accessors for workSpace
extension Pattern {

    @objc(addWorkSpaceObject:)
    @NSManaged public func addToWorkSpace(_ value: Workspace)

    @objc(removeWorkSpaceObject:)
    @NSManaged public func removeFromWorkSpace(_ value: Workspace)

    @objc(addWorkSpace:)
    @NSManaged public func addToWorkSpace(_ values: NSSet)

    @objc(removeWorkSpace:)
    @NSManaged public func removeFromWorkSpace(_ values: NSSet)

}

extension Pattern: Identifiable {

}
