//
//  GetStartedManager.swift
//  Ditto
//
//  Created by abiya.joy on 19/10/22.
//  Copyright © 2022 Infosys. All rights reserved.
//

import Foundation
import RxSwift

struct GetStartedManager: GetStartedProtocol {
    func updateStatus(status: Int16) -> Observable<Any?> {
        return Observable.create { observer in
            do {
                observer.onNext("test")
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
    func fetchTutorialsInstructionsFromDb() -> Observable<[Instruction]> {
        return Observable<[Instruction]>.create { observer in
            do {
                //                    let context = DatabaseHelper().managedObjectContext
                let fetchedObjects = DatabaseHelper().fetchAllObjectsOfEntity(DBEntities.instructionDb) as! [Instruction]
                observer.onNext(fetchedObjects)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
