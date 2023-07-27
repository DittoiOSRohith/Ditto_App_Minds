//
//  Selvages+CoreDataProperties.swift
//  
//
//  Created by Prabha Rajalakshmi N on 03/09/20.
//
//

import Foundation
import CoreData

extension Selvages {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Selvages> {
        return NSFetchRequest<Selvages>(entityName: "Selvages")
    }

    @NSManaged public var fabricLength: String?
    @NSManaged public var id: Int16
    @NSManaged public var imagePath: String?
    @NSManaged public var tabCategory: String?
    @NSManaged public var pattern: Pattern?

}
