//
//  Pattern+CoreDataProperties.swift
//  
//
//  Created by Prabha Rajalakshmi N on 03/09/20.
//
//

import Foundation
import CoreData

extension Pattern {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Pattern> {
        return NSFetchRequest<Pattern>(entityName: "Pattern")
    }

    @NSManaged public var patternBrand: String?
    @NSManaged public var patternDescriptionImage: String?
    @NSManaged public var patternImage: String?
    @NSManaged public var patternIndex: Int16
    @NSManaged public var patternInstruction: String?
    @NSManaged public var patternTitle: String?
    @NSManaged public var status: String?
    @NSManaged public var totalPieces: Int16
    @NSManaged public var descImages: NSSet?
    @NSManaged public var patternPiece: NSSet?
    @NSManaged public var patternSelvages: NSSet?

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
