//
//  MyLlibraryUseCase.swift
//  JoannTraceApp
//
//  Created by Shefrin Hakeem on 18/08/20.
//  Copyright © 2020 Infosys. All rights reserved.
//

import UIKit
import RxSwift

public protocol MyLibraryUseCaseProtocol {
    func fetchPatternsFromDb(fetchType: String) -> Observable<[Pattern]>
}

struct MyLibraryUseCaseImplementation: MyLibraryUseCaseProtocol {
    let myLibraryProtocol: MyLibraryProtocol
    init(myLibraryProtocol: MyLibraryProtocol) {
        self.myLibraryProtocol  = myLibraryProtocol
    }
    func fetchPatternsFromDb(fetchType: String) -> Observable<[Pattern]> {
        return self.myLibraryProtocol.fetchPatternsFromDb(fetchType: fetchType)
    }
}
