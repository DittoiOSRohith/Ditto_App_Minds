//
//  UserModel.swift
//  Ditto
//
//  Created by Gaurav Rajan on 17/05/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit

var objUserModel = UserModel()
class UserModel: NSObject {
    var name = String()
    var email = String()
    var customerId = String()
    var customerNo = String()
    func setData(dictData: [String: AnyObject]) {
        self.name = dictData["first_name"] as? String ?? FormatsString.emptyString
        self.email = dictData["email"] as? String ?? FormatsString.emptyString
        self.customerId = dictData["customer_id"] as? String ?? FormatsString.emptyString
        self.customerNo = dictData["customer_no"] as? String ?? FormatsString.emptyString
    }
}
