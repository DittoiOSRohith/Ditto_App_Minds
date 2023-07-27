//
//  DescriptionImages+CoreDataProperties.swift
//  JoannTraceApp
//
//  Created by Shefrin Hakeem on 20/09/20.
//  Copyright © 2020 Infosys. All rights reserved.
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
