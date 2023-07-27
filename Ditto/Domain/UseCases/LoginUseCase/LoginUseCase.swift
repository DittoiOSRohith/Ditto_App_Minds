//
//  LoginUseCase.swift
//  JoannTraceApp
//
//  Created by Infosys on 03/08/20.
//  Copyright © 2020 Infosys. All rights reserved.
//

import Foundation
import RxSwift

public protocol LoginUseCaseProtocol {
    func login(user: User) -> Observable<Any?> // surya needs to change the parameter.
}

struct LoginUseCaseImplementation: LoginUseCaseProtocol {
    let userAuthManager: LoginProtocol
    init(userAuthManager: LoginProtocol) {
        self.userAuthManager = userAuthManager
    }
    func login(user: User) -> Observable<Any?> {
        DatabaseHelper().saveChanges()
        return self.userAuthManager.login(user: user)
    }
}
