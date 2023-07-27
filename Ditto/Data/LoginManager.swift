//
//  LoginManager.swift
//  JoannTraceApp
//
//  Created by Infosys on 2020-07-29.
//  Copyright © 2020 Infosys. All rights reserved.
//

import Foundation
import RxSwift

struct LoginManager: LoginProtocol {
func login(user: User) -> Observable<Any?> {
    return Observable.create { observer in
        do {
            observer.onNext("test")
            observer.onCompleted()
        }
            return Disposables.create()
        }
    }
}
