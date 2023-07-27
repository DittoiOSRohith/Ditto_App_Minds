//
//  Instruction+CoreDataProperties.swift
//  Ditto
//
//  Created by abiya.joy on 21/02/23.
//  Copyright © 2023 Infosys. All rights reserved.
//
//

import Foundation
import CoreData

extension Instruction {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Instruction> {
        return NSFetchRequest<Instruction>(entityName: "Instruction")
    }
    @NSManaged public var insOverviewTitle: String?
    @NSManaged public var instructionDescription: String?
    @NSManaged public var instructionImage: String?
    @NSManaged public var instructionOverviewDescription: String?
    @NSManaged public var instructionOverviewImagePath: String?
    @NSManaged public var instructionTitle: String?
    @NSManaged public var instructionType: String?
    @NSManaged public var instructionVideo: String?
    @NSManaged public var instructionVideoPath: String?
    @NSManaged public var tabIndex: String?
    @NSManaged public var tabName: String?
    @NSManaged public var tutorialPdfUrl: String?
}

extension Instruction: Identifiable {

}
