//
//  BeamSetUpProtocol.swift
//  JoannTraceApp
//
//  Created by Shefrin Hakeem on 30/07/20.
//  Copyright © 2020 Infosys. All rights reserved.
//

import UIKit
import RxSwift

protocol BeamSetUpProtocol {
    func fetchInstructonsFromDb(fetchType: String) -> Observable<[Instruction]>
}

struct BeamSetUpManager: BeamSetUpProtocol {
    func fetchInstructonsFromDb(fetchType: String) -> Observable<[Instruction]> {
        return Observable<[Instruction]>.create { observer in
            do {
                let predicate = NSPredicate(format: "instructionType == %@", "\(fetchType)")
                let context = DatabaseHelper().managedObjectContext
                let fetchedObjects = DatabaseHelper().fetchAllObjectsOfEntity(DBEntities.instructionDb, withPredicate: predicate, managedObjectContext: context) as? [Instruction]
                observer.onNext(fetchedObjects!)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
