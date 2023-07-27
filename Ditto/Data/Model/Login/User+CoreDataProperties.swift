//
//  User+CoreDataProperties.swift
//  JoannTraceApp
//
//  Created by Shefrin Hakeem on 18/08/20.
//  Copyright © 2020 Infosys. All rights reserved.
//
//

import Foundation
import CoreData

extension User {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }
    @NSManaged public var password: String?
    @NSManaged public var settingsShowAgain: Int16
    @NSManaged public var username: String?
}
