//
//  PatternPieceDetails+CoreDataProperties.swift
//  
//
//  Created by Prabha Rajalakshmi N on 03/09/20.
//
//

import Foundation
import CoreData

extension PatternPieceDetails {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PatternPieceDetails> {
        return NSFetchRequest<PatternPieceDetails>(entityName: "PatternPieceDetails")
    }
    @NSManaged public var cutOnFold: Bool
    @NSManaged public var cutQuantity: String?
    @NSManaged public var id: Int16
    @NSManaged public var imagePath: String?
    @NSManaged public var mirrorOption: Bool
    @NSManaged public var parentPatten: String?
    @NSManaged public var pieceDescription: String?
    @NSManaged public var pieceNumber: String?
    @NSManaged public var positionInTabLineUp: String?
    @NSManaged public var size: String?
    @NSManaged public var splice: Bool
    @NSManaged public var spliceDirection: String?
    @NSManaged public var spliceScreenQuantity: String?
    @NSManaged public var tabCategory: String?
    @NSManaged public var view: String?
    @NSManaged public var pattern: Pattern?
    @NSManaged public var splicedImages: NSSet?
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
