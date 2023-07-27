//
//  GetStartedProtocol.swift
//  Ditto
//
//  Created by abiya.joy on 19/10/22.
//  Copyright © 2022 Infosys. All rights reserved.
//

import Foundation
import RxSwift

protocol GetStartedProtocol {
    func updateStatus(status: Int16) -> Observable<Any?>
    func fetchTutorialsInstructionsFromDb() ->Observable<[Instruction]>
}
