//
//  LoginParamValidation.swift
//  Ditto
//
//  Created by Gaurav Rajan on 27/04/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import Foundation

struct LoginParams {
    var email, password: String
    func isValidData() -> Bool {   // validation of email and password entered
        if self.email.isBlank {
            Proxy.shared.displayStatusAlert(message: AlertMessage.email)
        } else if !self.email.isValidEmail() {
            Proxy.shared.displayStatusAlert(message: AlertMessage.validEmail)
        } else if self.password.isBlank {
            Proxy.shared.displayStatusAlert(message: AlertMessage.password)
        } else {
            return true
        }
        return false
    }
}
