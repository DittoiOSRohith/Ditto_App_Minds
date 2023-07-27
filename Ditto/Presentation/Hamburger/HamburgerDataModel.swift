//
//  HamburgerDataModel.swift
//  Ditto
//
//  Created by Abiya Joy on 24/04/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import Foundation

class HamburgerObject: NSObject {
    var iconImage: String = FormatsString.emptyString
    var titleText: String = FormatsString.emptyString
    var isOpened: Bool = false
    var subMenuItems = [HamburgerInnerObject]()
    init(iconImage: String, titleText: String, isOpened: Bool, subMenuItems: [HamburgerInnerObject]) {
        self.iconImage = iconImage
        self.titleText = titleText
        self.isOpened = isOpened
        self.subMenuItems = subMenuItems
    }
}

class HamburgerInnerObject: NSObject {
    var iconImage: String = FormatsString.emptyString
    var titleText: String = FormatsString.emptyString
    init(iconImage: String, titleText: String) {
        self.iconImage = iconImage
        self.titleText = titleText
    }
}
