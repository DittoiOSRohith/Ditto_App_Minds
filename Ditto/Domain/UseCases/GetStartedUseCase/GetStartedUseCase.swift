//
//  GetStartedUseCase.swift
//  Ditto
//
//  Created by abiya.joy on 19/10/22.
//  Copyright © 2022 Infosys. All rights reserved.
//

import Foundation
import RxSwift

protocol GetStartedUseCaseProtocol {
    func updateStatus(status: Int16) -> Observable<Any?>
    func fetchTutorialsInstructionsFromDb() -> Observable<[Instruction]>
}

struct GetStartedImplementation: GetStartedUseCaseProtocol {
    let getStarted: GetStartedProtocol
    init(getStarted: GetStartedProtocol) {
        self.getStarted = getStarted
    }
    func updateStatus(status: Int16) -> Observable<Any?> {
        return self.getStarted.updateStatus(status: status)
    }
    func fetchTutorialsInstructionsFromDb() -> Observable<[Instruction]> {
        return self.getStarted.fetchTutorialsInstructionsFromDb()
    }
}
