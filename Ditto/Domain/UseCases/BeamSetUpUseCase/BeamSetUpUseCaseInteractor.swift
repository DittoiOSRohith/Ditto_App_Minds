//
//  BeamSetUpUseCaseInteractor.swift
//  JoannTraceApp
//
//  Created by Infosys on 03/08/20.
//  Copyright © 2020 Infosys. All rights reserved.
//

import UIKit

public protocol BeamSetUpUseCaseInteractorProtocol {
    func fetchInstrunctionfromDataBase() -> BeamSetUpUseCaseProtocol
}
struct BeamSetUpUseCaseInteractorImplementation: BeamSetUpUseCaseInteractorProtocol {
    let beamSetUpUseCase: BeamSetUpUseCaseProtocol
    init(requester layer: BeamSetUpUseCaseProtocol) {
        beamSetUpUseCase = layer
    }
    func fetchInstrunctionfromDataBase() -> BeamSetUpUseCaseProtocol {
        return beamSetUpUseCase
    }
}
