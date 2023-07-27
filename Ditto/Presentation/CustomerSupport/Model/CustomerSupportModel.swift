//
//  CustomerSupportModel.swift
//  Ditto
//
//  Created by Neb Shaw on 5/10/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import Foundation

class CustomerSupportObj: NSObject {
    var iconImage = String()
    var title = String()
    var subtitle1 = String()
    var subtitle2 = String()
    var describe = String()
    init(iconImage: String, title: String, subtitle1: String, subtitle2: String, describe: String) {
        self.iconImage = iconImage
        self.title = title
        self.subtitle1 = subtitle1
        self.subtitle2 = subtitle2
        self.describe = describe
    }
}
