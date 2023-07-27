//
//  MyLibraryDataModel.swift
//  JoannTraceApp
//
//  Created by Abiya Joy on 26/03/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit

class PatternObject: NSObject {
    var patternTitle = FormatsString.emptyString
    var patternImage = FormatsString.emptyString
    var patternInstructions = FormatsString.emptyString
    var patternDescriptionImage = FormatsString.emptyString
}
// MARK: - MyLibraryData
class MyLibraryData {
    var action = String()
    var queryString = String()
    var locale = String()
    var prod = [MyLibraryPatterns]()
    var totalPatternCount = Int()
    var totalPageCount = Int()
    var currentPageID = Int()
    var filter = FilterModel()
    func setMyLibraryData(dictData: [String: AnyObject]) {
        self.action = dictData["action"] as? String ?? FormatsString.emptyString
        self.queryString = dictData["queryString"] as? String ?? FormatsString.emptyString
        self.locale = dictData["locale"] as? String ?? FormatsString.emptyString
        self.totalPatternCount = dictData["totalPatternCount"] as? Int ?? 0
        self.totalPageCount = dictData["totalPageCount"] as? Int ?? 0
        self.currentPageID = dictData["currentPageId"] as? Int ?? 0
        if let productArray = dictData["prod"] as? [[String: AnyObject]] {
            var trialdesignDict = [String: Any]()
            for dict in productArray {
                let objProductModel = MyLibraryPatterns()
                objProductModel.setProdData(dictData: dict)
                self.prod.append(objProductModel)
                if objProductModel.patternType == FormatsString.Trial {
                    trialdesignDict[objProductModel.tailornovaDesignID] = objProductModel.tailornovaDesignName
                }
            }
            Proxy.shared.savetrailPatternDesignName(nameDict: trialdesignDict)
        }
        if let filterDict = dictData["filter"] as? [String: AnyObject] {
            let objFilter = FilterModel()
            objFilter.setData(dictData: filterDict)
            self.filter = objFilter
        }
    }
    func setMyLibTrailData(trailArray: [PatternModelObject]) {
        let trailResponse =  trailArray
        self.action = FormatsString.emptyString
        self.queryString = FormatsString.emptyString
        self.locale = FormatsString.emptyString
        self.totalPatternCount = trailResponse.count
        self.totalPageCount = trailResponse.count
        self.currentPageID = 0
        for dict in trailResponse {
            let objProductModel = MyLibraryPatterns()
            objProductModel.setTrailProdData(dictData: dict)
            self.prod.append(objProductModel)
        }
        self.filter = FilterModel()
    }
}
