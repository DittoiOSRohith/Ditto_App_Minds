//
//  LoginUseCaseInteractor.swift
//  JoannTraceApp
//
//  Created by Surya Beegam Veliyil Badar on 2020-07-28.
//  Copyright © 2020 Infosys. All rights reserved.
//

import Foundation
import RxSwift

public protocol LoginUseCaseInteractorProtocol {
    func makeUserLoginCase() -> LoginUseCaseProtocol
}

struct LoginUseCaseInteractorImplementation: LoginUseCaseInteractorProtocol {
    let userLoginUseCase: LoginUseCaseProtocol
    init(requester layer: LoginUseCaseProtocol) {
        userLoginUseCase = layer
    }
    func makeUserLoginCase() -> LoginUseCaseProtocol {
        return userLoginUseCase
    }
}
