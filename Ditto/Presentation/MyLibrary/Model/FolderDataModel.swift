//
//  FolderDataModel.swift
//  Ditto
//
//  Created by Gokul Ramesh on 27/09/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import Foundation

class FolderDataModel {
    var action = String()
    var queryString = String()
    var locale = String()
    var folderNameArray = [String]()
    func setGetFolderData(dictData: [String: AnyObject]) {
        self.action = dictData["action"] as? String ?? FormatsString.emptyString
        self.queryString = dictData["queryString"] as? String ?? FormatsString.emptyString
        self.locale = dictData["locale"] as? String ?? FormatsString.emptyString
        if let folderArray = dictData["responseStatus"] as? [String] {
            for folderName in folderArray {
                self.folderNameArray.append(folderName)
            }
        } else if let folderArray = dictData["responseVal"] as? [String] {
            for folderName in folderArray {
                self.folderNameArray.append(folderName)
            }
        }
    }
}
