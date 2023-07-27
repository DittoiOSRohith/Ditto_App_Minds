//
//  CoreDataManager.swift
//  WorkBench
//
//  Created by Shefrin Hakeem on 26/07/20.
//  Copyright © 2020 Infosys. All rights reserved.
//

import UIKit
import CoreData
import RxSwift

class CoreDataManager: NSObject {
    class func saveUsernameAndPasswordToDb(username: String, password: String, settingShown: Int16) {
        let context = CoreDataStack.persistentContainer.viewContext
        let user  = User(context: context)
        user.username = username
        user.password = password
        user.settingsShowAgain = settingShown
        CoreDataStack.saveContext()
    }
    class func fetchUserNameAndPasswordFromDb(username: String, password: String) -> (String, String) {
        let context = CoreDataStack.persistentContainer.viewContext
        do {
            let userDb: [User] = try context.fetch(User.fetchRequest())
            if !userDb.isEmpty {
                let user = userDb[0]
                var userName = FormatsString.emptyString
                var passWord = FormatsString.emptyString
                if let name = user.username {
                    userName = name
                }
                if let password = user.password {
                    passWord = password
                }
                return ("\(userName)", "\(passWord)")
            }
        } catch {
        }
        return (FormatsString.emptyString, FormatsString.emptyString)
    }
    class func grabAllPersons() -> (String, String) {
        var ppp: [User] = []
        do {
            let req = NSFetchRequest<NSFetchRequestResult>(entityName: DBEntities.userDb)
            let use = try CoreDataStack.persistentContainer.viewContext.fetch(req)
            ppp = (use as? [User])!
        } catch _ as NSError {
        }
        for uuu: User in ppp {
            return (uuu.username!, uuu.password!)
        }
        return (FormatsString.emptyString, FormatsString.emptyString)
    }
    class func updateStatus(status: Int16) -> Observable<Int64> {
        return Observable.create { _ in
            do {
                let context = CoreDataStack.persistentContainer.viewContext
                var ppp: [User] = []
                do {
                    let req = NSFetchRequest<NSFetchRequestResult>(entityName: DBEntities.userDb)
                    let use = try CoreDataStack.persistentContainer.viewContext.fetch(req)
                    ppp = (use as? [User])!
                } catch _ as NSError {
                }
                for uuu: User in ppp {
                    uuu.settingsShowAgain = status
                    do {
                        try context.save()
                    } catch {
                    }
                }
                return Disposables.create()
            }
        }
    }
    class func updateStatuss(status: Int16) {
        let context = CoreDataStack.persistentContainer.viewContext
        var ppp: [User] = []
        do {
            let req = NSFetchRequest<NSFetchRequestResult>(entityName: DBEntities.userDb)
            let use = try CoreDataStack.persistentContainer.viewContext.fetch(req)
            ppp = use as! [User]
        } catch _ as NSError {
        }
        for uuu: User in ppp {
            uuu.settingsShowAgain = status
            do {
                try context.save()
            } catch {
            }
        }
    }
    class func getStatus() -> Observable<Int16> {
        return Observable.create { _  in
            do {
                var ppp: [User] = []
                do {
                    let req = NSFetchRequest<NSFetchRequestResult>(entityName: DBEntities.userDb)
                    let use = try CoreDataStack.persistentContainer.viewContext.fetch(req)
                    ppp = use as! [User]
                } catch _ as NSError {
                }
                for _: User in ppp {
                    return Disposables.create()
                }
                return Disposables.create()
            }
        }
    }
}
