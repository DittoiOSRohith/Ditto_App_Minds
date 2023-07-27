//
//  GetStartedUseCaseInteractor.swift
//  Ditto
//
//  Created by abiya.joy on 19/10/22.
//  Copyright © 2022 Infosys. All rights reserved.
//

import Foundation
import RxSwift

protocol GetStartedUseCaseInteractorProtocol {
    func makeGetStrtdUseCase() -> GetStartedUseCaseProtocol
    func fetchGetStartedData() -> GetStartedUseCaseProtocol
}

struct GetStartedUseCaseImplementation: GetStartedUseCaseInteractorProtocol {
    let getStarted: GetStartedUseCaseProtocol
    init(requester layer: GetStartedUseCaseProtocol) {
          getStarted = layer
    }
    func makeGetStrtdUseCase() -> GetStartedUseCaseProtocol {
        return getStarted
    }
    func fetchGetStartedData() -> GetStartedUseCaseProtocol {
        return getStarted
    }
}
