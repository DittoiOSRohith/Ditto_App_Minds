//
//  BeamSetUpUseCase.swift
//  JoannTraceApp
//
//  Created by Infosys on 03/08/20.
//  Copyright © 2020 Infosys. All rights reserved.
//

import UIKit
import RxSwift

public protocol BeamSetUpUseCaseProtocol {
    func fetchInstructionsFromDataBase(fetchType: String) -> Observable<[Instruction]>
}

struct BeamSetUpUseCaseImplementation: BeamSetUpUseCaseProtocol {
    let beamSetUpProtocol: BeamSetUpProtocol
    init(beamSetUpProtocol: BeamSetUpProtocol) {
        self.beamSetUpProtocol  = beamSetUpProtocol
    }
    func fetchInstructionsFromDataBase(fetchType: String) -> Observable<[Instruction]> {
        return self.beamSetUpProtocol.fetchInstructonsFromDb(fetchType: fetchType)
    }

}
