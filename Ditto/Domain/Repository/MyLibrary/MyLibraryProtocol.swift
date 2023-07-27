//
//  MyLibraryProtocol.swift
//  JoannTraceApp
//
//  Created by Shefrin Hakeem on 18/08/20.
//  Copyright © 2020 Infosys. All rights reserved.
//

import UIKit
import RxSwift

protocol  MyLibraryProtocol {
    func fetchPatternsFromDb(fetchType: String) -> Observable<[Pattern]>
}

struct MyLibraryManager: MyLibraryProtocol {
    func fetchPatternsFromDb(fetchType: String) -> Observable<[Pattern]> {
        return Observable<[Pattern]>.create { observer in
            do {
                _ = DatabaseHelper().managedObjectContext
                let fetchedObjects = DatabaseHelper().fetchAllObjectsOfEntity("Pattern") as? [Pattern]
                observer.onNext(fetchedObjects!)
                observer.onCompleted()
            }
            return Disposables.create()
        }
    }
}
