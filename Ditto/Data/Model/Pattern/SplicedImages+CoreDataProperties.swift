//
//  SplicedImages+CoreDataProperties.swift
//  Ditto
//
//  Created by abiya.joy on 10/10/22.
//  Copyright © 2022 Infosys. All rights reserved.
//
//

import Foundation
import CoreData

extension SplicedImages {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<SplicedImages> {
        return NSFetchRequest<SplicedImages>(entityName: "SplicedImages")
    }
    @NSManaged public var coloumn: Int16
    @NSManaged public var id: Int16
    @NSManaged public var imagePath: String?
    @NSManaged public var referenceSplice: String?
    @NSManaged public var row: Int16
    @NSManaged public var patternPiece: PatternPieceDetails?
}

extension SplicedImages: Identifiable {

}
