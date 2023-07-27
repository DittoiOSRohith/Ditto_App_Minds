//
//  Workspace+CoreDataProperties.swift
//  JoannTraceApp
//
//  Created by Shefrin Hakeem on 18/10/20.
//  Copyright © 2020 Infosys. All rights reserved.
//
//

import Foundation
import CoreData

extension Workspace {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<Workspace> {
        return NSFetchRequest<Workspace>(entityName: "Workspace")
    }
    @NSManaged public var index: Int16
    @NSManaged public var isSplicedState: Bool
    @NSManaged public var name: String?
    @NSManaged public var progressValue: Float
    @NSManaged public var selectedSelvagesTab: String?
    @NSManaged public var selectedTab: String?
    @NSManaged public var splicedIndex: Int16
    @NSManaged public var spliceDirection: String?
    @NSManaged public var status: String?
    @NSManaged public var totalCutbinpieces: Int16
    @NSManaged public var totalCutpieces: Int16
    @NSManaged public var workspaceHeight: Float
    @NSManaged public var workspaceWidth: Float
    @NSManaged public var workspaceX: Float
    @NSManaged public var workspaceY: Float
    @NSManaged public var cutBinArray: NSSet?
    @NSManaged public var cutPieces: NSSet?
    @NSManaged public var parentPattern: Pattern?
}

// MARK: Generated accessors for cutBinArray
extension Workspace {

    @objc(addCutBinArrayObject:)
    @NSManaged public func addToCutBinArray(_ value: PatternPieceDetails)

    @objc(removeCutBinArrayObject:)
    @NSManaged public func removeFromCutBinArray(_ value: PatternPieceDetails)

    @objc(addCutBinArray:)
    @NSManaged public func addToCutBinArray(_ values: NSSet)

    @objc(removeCutBinArray:)
    @NSManaged public func removeFromCutBinArray(_ values: NSSet)

}

// MARK: Generated accessors for cutPieces
extension Workspace {

    @objc(addCutPiecesObject:)
    @NSManaged public func addToCutPieces(_ value: PatternPieceDetails)

    @objc(removeCutPiecesObject:)
    @NSManaged public func removeFromCutPieces(_ value: PatternPieceDetails)

    @objc(addCutPieces:)
    @NSManaged public func addToCutPieces(_ values: NSSet)

    @objc(removeCutPieces:)
    @NSManaged public func removeFromCutPieces(_ values: NSSet)

}
