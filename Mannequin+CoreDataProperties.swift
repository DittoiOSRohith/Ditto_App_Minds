//
//  Mannequin+CoreDataProperties.swift
//  Ditto
//
//  Created by Abiya Joy on 22/11/21.
//  Copyright © 2021 Infosys. All rights reserved.
//
//

import Foundation
import CoreData

extension Mannequin {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Mannequin> {
        return NSFetchRequest<Mannequin>(entityName: "Mannequin")
    }
    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var pattern: Pattern?
}

extension Mannequin: Identifiable {

}
