//
//  MyLibraryUseCaseInteractor.swift
//  JoannTraceApp
//
//  Created by Shefrin Hakeem on 18/08/20.
//  Copyright © 2020 Infosys. All rights reserved.
//

import UIKit

public protocol MyLibraryUseCaseInteractorProtocol {
    func fetchPatternsFromDB() -> MyLibraryUseCaseProtocol
}

struct MyLibraryUseCaseInteractorImplementation: MyLibraryUseCaseInteractorProtocol {
    let  myLibraryUseCase: MyLibraryUseCaseProtocol
    init(requester layer: MyLibraryUseCaseProtocol) {
        myLibraryUseCase = layer
    }
    func fetchPatternsFromDB() -> MyLibraryUseCaseProtocol {
        return myLibraryUseCase
    }
}
