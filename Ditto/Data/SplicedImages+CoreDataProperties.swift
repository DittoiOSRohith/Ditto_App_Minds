//
//  SplicedImages+CoreDataProperties.swift
//  
//
//  Created by Prabha Rajalakshmi N on 03/09/20.
//
//

import Foundation
import CoreData

extension SplicedImages {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<SplicedImages> {
        return NSFetchRequest<SplicedImages>(entityName: "SplicedImages")
    }
    @NSManaged public var id: Int16
    @NSManaged public var imagePath: String?
    @NSManaged public var patternPiece: PatternPieceDetails?
}
