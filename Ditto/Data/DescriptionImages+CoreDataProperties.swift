//
//  DescriptionImages+CoreDataProperties.swift
//  
//
//  Created by Prabha Rajalakshmi N on 03/09/20.
//
//

import Foundation
import CoreData

extension DescriptionImages {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<DescriptionImages> {
        return NSFetchRequest<DescriptionImages>(entityName: "DescriptionImages")
    }
    @NSManaged public var id: Int16
    @NSManaged public var imagePath: String?
    @NSManaged public var pattern: Pattern?
}
