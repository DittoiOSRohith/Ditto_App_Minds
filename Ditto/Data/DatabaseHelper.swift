//
//  DatabaseHelper.swift
//  JoannTraceApp
//
//  Created by Infosys on 2020-07-29.
//  Copyright © 2020 Infosys. All rights reserved.
//

import Foundation
import CoreData

class DatabaseHelper: NSObject {
    override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(self.managedObjectContextSaved(_:)),
                                               name: NSNotification.Name.NSManagedObjectContextDidSave, object: nil)
    }
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    lazy var managedObjectContext: NSManagedObjectContext = {
        let coordinator = DatabaseManager.sharedInstance.persistentContainer.persistentStoreCoordinator
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        managedObjectContext.persistentStoreCoordinator = coordinator
        managedObjectContext.undoManager = nil
        return managedObjectContext
    }()
    lazy var backgroundContext: NSManagedObjectContext? = {
        let coordinator = DatabaseManager.sharedInstance.persistentContainer.persistentStoreCoordinator
        var backgroundContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        backgroundContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        backgroundContext.persistentStoreCoordinator = coordinator
        return backgroundContext
    }()
    internal func getValidContext() -> NSManagedObjectContext {
        let context: NSManagedObjectContext = (Thread.isMainThread) ? self.managedObjectContext : self.backgroundContext!
        return context
    }
    func createObjectForEntity(_ entityName: String) -> NSManagedObject {
        return self.createObjectForEntity(entityName, managedObjectContext: getValidContext())
    }
    fileprivate func createObjectForEntity(_ entityName: String, managedObjectContext context: NSManagedObjectContext) -> NSManagedObject {
        return NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
    }
    func fetchAllObjectsOfEntity(_ entityName: String) -> [NSManagedObject] {
        let objectList: [NSManagedObject] = self.fetchAllObjectsOfEntity(entityName, managedObjectContext: getValidContext())
        return objectList
    }
    fileprivate func fetchAllObjectsOfEntity(_ entityName: String, managedObjectContext context: NSManagedObjectContext) -> [NSManagedObject] {
        var objectList: [NSManagedObject] = []
        let fetchRequest: NSFetchRequest = self.getFetchRequestForEntity(entityName)
        objectList = self.executeFetchRequest(fetchRequest, inManagedObjectContext: context)
        return objectList
    }
    func fetchAllObjectsOfEntityAsDictionary(_ entityName: String, properties: [String], withPredicate predicate: NSPredicate?, sortComponent: String?, isAscendingSortOrder order: Bool) -> [AnyObject] {
        let objectList: [AnyObject] = self.fetchAllObjectsOfEntityAsDictionaryEntity(entityName,
                                                                                     properties: properties,
                                                                                     withPredicate: predicate,
                                                                                     managedObjectContext: getValidContext(),
                                                                                     sortComponent: sortComponent,
                                                                                     isAscendingSortOrder: order)
        return objectList
    }
    fileprivate func fetchAllObjectsOfEntityAsDictionaryEntity(_ entityName: String,
                                                               properties: [String],
                                                               withPredicate predicate: NSPredicate?,
                                                               managedObjectContext context: NSManagedObjectContext,
                                                               sortComponent: String?,
                                                               isAscendingSortOrder order: Bool) -> [AnyObject] {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        if sortComponent != nil {
            request.sortDescriptors = [NSSortDescriptor(key: sortComponent, ascending: order)]
        }
        if !properties.isEmpty {
            request.propertiesToFetch = properties
        }
        request.returnsObjectsAsFaults = false
        request.returnsDistinctResults = true
        request.resultType = .dictionaryResultType
        if predicate != nil {
            request.predicate = predicate!
        }
        do {
            let results = try context.fetch(request)
            return results as [AnyObject]
        } catch {
        }
        return []
    }
    func fetchAllObjectsOfEntity(_ entityName: String, withPredicate predicate: NSPredicate) -> [NSManagedObject] {
        let objectList: [NSManagedObject]  = self.fetchAllObjectsOfEntity(entityName,
                                                                              withPredicate: predicate,
                                                                              managedObjectContext: getValidContext())
        return objectList
    }
    func fetchAllObjectsOfEntity(_ entityName: String,
                                 withPredicate predicate: NSPredicate,
                                 managedObjectContext context: NSManagedObjectContext) -> [NSManagedObject] {
        var objectList: [NSManagedObject]  = []
        let fetchRequest: NSFetchRequest = self.getFetchRequestForEntity(entityName)
        fetchRequest.entity = self.getEntityDescription(entityName)
        fetchRequest.predicate = predicate
        objectList = self.executeFetchRequest(fetchRequest, inManagedObjectContext: context)
        return objectList
    }
    func fetchAllObjectsOfEntity(_ entityName: String, withPredicate predicate: NSPredicate, sortAttribute attribute: String,
                                 isAscendingSortOrder order: Bool) -> [NSManagedObject] {
        let objectList: [NSManagedObject]  = self.fetchAllObjectsOfEntity(entityName, withPredicate: predicate,
                                                                              sortAttribute: attribute,
                                                                              isAscendingSortOrder: order,
                                                                              managedObjectContext: getValidContext())
        return objectList
    }
    fileprivate func fetchAllObjectsOfEntity(_ entityName: String,
                                             withPredicate predicate: NSPredicate,
                                             sortAttribute attribute: String,
                                             isAscendingSortOrder order: Bool,
                                             managedObjectContext context: NSManagedObjectContext) -> [NSManagedObject] {
        var objectList: [NSManagedObject] = []
        let fetchRequest: NSFetchRequest = self.getFetchRequestForEntity(entityName)
        fetchRequest.entity = self.getEntityDescription(entityName, managedObjectContext: context)
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: attribute, ascending: order)]
        objectList = self.executeFetchRequest(fetchRequest, inManagedObjectContext: context)
        return objectList
    }
    func removeObject(_ object: NSManagedObject) {
        self.removeObject(object, managedObjectContext: getValidContext())
    }
    func removeObject(_ object: NSManagedObject, managedObjectContext context: NSManagedObjectContext) {
        context.performAndWait { () -> Void in
            context.delete(object)
        }
    }
    func removeAllObjectsOfEntity(_ entityName: String) {
        self.removeAllObjectsOfEntity(entityName, managedObjectContext: getValidContext())
    }
    fileprivate func removeAllObjectsOfEntity(_ entityName: String, managedObjectContext context: NSManagedObjectContext) {
        var objectList: [NSManagedObject] = []
        let entityDescription: NSEntityDescription = self.getEntityDescription(entityName, managedObjectContext: context)
        let fetchRequest: NSFetchRequest = self.getFetchRequestForEntity(entityName)
        fetchRequest.entity = entityDescription
        fetchRequest.includesPropertyValues = false
        objectList = self.executeFetchRequest(fetchRequest, inManagedObjectContext: context)
        for object in objectList {
            self.removeObject(object, managedObjectContext: context)
        }
    }
    func removeObjectOfEntity(_ entityName: String, withPredicate predicate: NSPredicate) {
        self.removeObjectOfEntity(entityName, withPredicate: predicate, managedObjectContext: getValidContext())
    }
    fileprivate func removeObjectOfEntity(_ entityName: String,
                                          withPredicate predicate: NSPredicate,
                                          managedObjectContext context: NSManagedObjectContext) {
        let list = self.fetchAllObjectsOfEntity(entityName,
                                                withPredicate: predicate,
                                                managedObjectContext: context)
        for object in list {
            self.removeObject(object, managedObjectContext: context)
        }
    }
    fileprivate func getEntityDescription(_ entityName: String) -> NSEntityDescription {
        return  self.getEntityDescription(entityName, managedObjectContext: getValidContext())
    }
    fileprivate func getEntityDescription(_ entityName: String, managedObjectContext context: NSManagedObjectContext) -> NSEntityDescription {
        return  NSEntityDescription.entity(forEntityName: entityName, in: context)!
    }
    fileprivate func getFetchRequestForEntity(_ entityName: String) -> NSFetchRequest<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        fetchRequest.returnsObjectsAsFaults = false
        return  fetchRequest
    }
    fileprivate func executeFetchRequest(_ fetchRequest: NSFetchRequest<NSFetchRequestResult>,
                                         inManagedObjectContext context: NSManagedObjectContext) -> [NSManagedObject] {
        var objectList: [NSManagedObject] = []
        context.performAndWait { () -> Void in
            do {
                objectList = try context.fetch(fetchRequest) as! [NSManagedObject]
            } catch {
            }
        }
        return objectList
    }
    func saveChanges() {
        self.saveContext(getValidContext())
    }
    func saveContext(_ context: NSManagedObjectContext) {
        if context.hasChanges {
            context.performAndWait {
                do {
                    try context.save()
                } catch {
                    _ = error as NSError
                    abort()
                }
            }
        }
    }
    @objc func managedObjectContextSaved(_ notification: Notification) {
        let sender = notification.object as! NSManagedObjectContext
        if sender === self.managedObjectContext {
            self.backgroundContext!.perform {
                self.backgroundContext!.mergeChanges(fromContextDidSave: notification)
            }
        } else if sender === self.backgroundContext {
            self.managedObjectContext.perform {
                self.managedObjectContext.mergeChanges(fromContextDidSave: notification)
            }
        } else {
            self.backgroundContext!.perform {
                self.backgroundContext!.mergeChanges(fromContextDidSave: notification)
            }
            self.managedObjectContext.perform {
                self.managedObjectContext.mergeChanges(fromContextDidSave: notification)
            }
        }
    }
    @discardableResult func insertNewRecordIntoEntity(_ entityName: String, withDict recordsDict: [String: AnyObject]) -> NSManagedObject {
        return self.insertNewRecordIntoEntity(entityName, withDict: recordsDict, managedObjectContext: getValidContext())
    }
    fileprivate func insertNewRecordIntoEntity(_ entityName: String,
                                               withDict recordsDict: [String: AnyObject],
                                               managedObjectContext context: NSManagedObjectContext) -> NSManagedObject {
        let entity =  NSEntityDescription.entity(forEntityName: entityName, in: context)
        let managedObject = NSManagedObject(entity: entity!, insertInto: context)
        managedObject.setValuesForKeys(recordsDict)
        saveChanges()
        return managedObject
    }
    func updateRecordInEntity(_ managedObject: NSManagedObject, withDict recordsDict: [String: AnyObject]) {
        managedObject.setValuesForKeys(recordsDict)
        saveChanges()
    }
    func deleteAllRowsFromTable(tableName: String) {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: tableName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do {
            try getValidContext().execute(deleteRequest)
            try getValidContext().save()
        } catch {
        }
    }
    func getPatternsForCategory(pattern: Pattern, tabCategory: String) -> [PatternPieceDetails] {
        var result =  [PatternPieceDetails]()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "PatternPieceDetails")
        let predicate = NSPredicate(format: "pattern == %@ && tabCategory == %@", pattern, tabCategory)
        request.predicate = predicate
        guard let context = pattern.managedObjectContext else {
            return []
        }
        do {
            if let patternPieceResults =  try context.fetch(request) as? [PatternPieceDetails] {
                result = patternPieceResults.filter { ($0 as AnyObject).tabCategory == tabCategory }
                return result
            }
        } catch {
            return []
        }
        return result
    }
    func getPatterns(pattern: Pattern, tabCategory: String) -> [PatternPieceDetails] {
        var patternPieceResults =  [PatternPieceDetails]()
        var request = NSFetchRequest<NSFetchRequestResult>(entityName: "PatternPieceDetails")
        let predicate = NSPredicate(format: "pattern == %@ && tabCategory == %@", pattern, tabCategory)
        request = PatternPieceDetails.fetchRequest()
        request.predicate = predicate
        request.returnsObjectsAsFaults = false
        // we will perform the request on the context associated with the School NSManagedObject
        guard let context = pattern.managedObjectContext else {
            return []
        }
        do {
            if let pieceResults =  try context.fetch(request) as? [PatternPieceDetails] {
                patternPieceResults = pieceResults
                return pieceResults
            }
        } catch {
            return []
        }
        return patternPieceResults
    }
    func getSelvagesForSelectedPattern(pattern: Pattern, tabCategory: String) -> [Selvages] {
        var result =  [Selvages]()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Selvages")
        let predicate = NSPredicate(format: "pattern == %@ ", pattern)
        request.predicate = predicate
        guard let context = pattern.managedObjectContext else {
            return []
        }
        do {
            if let selvagesResults =  try context.fetch(request) as? [Selvages] {
                result = selvagesResults.filter { ($0 as AnyObject).tabCategory == tabCategory }
                return result
            }
        } catch {
            return []
        }
        return result
    }
    func getSplicedImagesForSelectedPattern(patternPiece: PatternPieceDetails) -> [SplicedImages] {
        var result =  [SplicedImages]()
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "SplicedImages")
        let predicate = NSPredicate(format: "patternPiece == %@ ", patternPiece)
        request.predicate = predicate
        // we will perform the request on the context associated with the School NSManagedObject
        guard let context = patternPiece.managedObjectContext else {
            return []
        }
        do {
            if let splicedImagesResults =  try context.fetch(request) as? [SplicedImages] {
                result = splicedImagesResults
                return result
            }
        } catch {
            return []
        }
        return result
    }
}
