//
//  SelvagesDataModel.swift
//  Ditto
//
//  Created by Gokul Ramesh on 15/09/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit

class SelvagesDataModel: NSObject {
    var id = String()
    var imageUrl = String()
    var imageName = String()
    var tabCategory = String()
    var fabricLength = Int()
    func setSelvagesDataModel(dictData: [String: AnyObject]) {
        self.id = dictData["id"] as? String ?? FormatsString.emptyString
        self.imageUrl = dictData["imageUrl"] as? String ?? FormatsString.emptyString
        self.imageName = dictData["imageName"] as? String ?? FormatsString.emptyString
        self.tabCategory = dictData["tabCategory"] as? String ?? FormatsString.emptyString
        self.fabricLength = dictData["fabricLength"] as? Int ?? 0
    }
}
