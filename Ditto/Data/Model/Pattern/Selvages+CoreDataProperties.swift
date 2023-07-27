//
//  Selvages+CoreDataProperties.swift
//  JoannTraceApp
//
//  Created by Shefrin Hakeem on 20/09/20.
//  Copyright © 2020 Infosys. All rights reserved.
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
