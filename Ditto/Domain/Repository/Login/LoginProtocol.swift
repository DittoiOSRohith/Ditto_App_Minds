//
//  LoginProtocol.swift
//  JoannTraceApp
//
//  Created by Surya Beegam Veliyil Badar on 2020-07-28.
//  Copyright © 2020 Infosys. All rights reserved.
//

import Foundation
import RxSwift

protocol LoginProtocol {
    func login(user: User) -> Observable<Any?>
}
