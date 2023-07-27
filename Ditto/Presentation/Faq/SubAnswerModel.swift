//
//  SubAnswerModel.swift
//  Ditto
//
//  Created by Gaurav Rajan on 18/05/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import Foundation

class SubAnswerModel {
    var title = String()
    var shortDescription = String()
    var imagePath = String()
    func setData(dictData: [String: AnyObject]) {
        self.title = dictData["title"] as? String ?? FormatsString.emptyString
        self.shortDescription = dictData["short_description"] as? String ?? FormatsString.emptyString
        self.imagePath = dictData["image_path"] as? String ?? FormatsString.emptyString
    }
}
