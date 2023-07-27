//
//  DatabaseManager.swift
//  JoannTraceApp
//
//  Created by Infosys on 2020-07-27.
//  Copyright © 2020 Infosys. All rights reserved.
//

import Foundation
import CoreData
import RxSwift

let contextData = DatabaseManager.sharedInstance.persistentContainer.viewContext
class DatabaseManager: NSObject {
    class var sharedInstance: DatabaseManager {
        // Singleton object creation
        if Static.instance == nil {
            Static.instance = DatabaseManager()
        }
        return Static.instance!
    }
    struct Static {
        fileprivate static var instance: DatabaseManager?
    }
    class func resetInstance() {
        Static.instance = nil
    }
    lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .libraryDirectory, in: .userDomainMask)
        return urls[urls.count-1]
    }()
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: "JoannTraceApp", withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
   /* lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator? = {
        var coordinator: NSPersistentStoreCoordinator? = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent("JoannTraceApp.sqlite")
        print(url)
        var error: NSError?
        let mOptions = [NSMigratePersistentStoresAutomaticallyOption: true,
                        NSInferMappingModelAutomaticallyOption: true]
        //let mOptions = [EncryptedStorePassphraseKey:"DB_KEY_HERE", NSInferMappingModelAutomaticallyOption:true]
        //Uncomment this line to encrypt the DB
        do {
            try coordinator!.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: mOptions)
        } catch var error1 as NSError {
            error = error1
            //coordinator = nil
            // Report any error we got.
            print("Unresolved error in persistentStoreCoordinator \(String(describing: error)), \(error!.userInfo)")
            abort()
        } catch {
            fatalError()
        }
        return coordinator
    }()*/
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "JoannTraceApp")
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    /**
     Clear db file
     */
    func clearAll() {
        DatabaseManager.Static.instance = nil
    }
}
