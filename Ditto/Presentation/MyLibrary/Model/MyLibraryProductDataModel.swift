//
//  MyLibraryProductDataModel.swift
//  Ditto
//
//  Created by Gokul Ramesh on 03/08/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import Foundation

// MARK: - Prod
class MannequinIDObject: NSObject {
    var mannequinID = String()
    var mannequinName = String()
}

class MyLibraryPatterns {
    var status = String()
    var id = String()
    var image = String()
    var name = String()
    var notes = String()
    var prodDescription = String()
    var notiondetails = String()
    var yardagedetails = String()
    var yardagePdfUrl = String()
    var customization = String()
    var dateOfModification = String()
    var type = [String]()
    var seasons = [String]()
    var occasion = String()
    var suitableFor = String()
    var size = String()
    var gender = String()
    var brand = String()
    var creationDate = String()
    var patternType = String()
    var selectedTabCategory = String()
    var tailornovaDesignID = String()
    var subscriptionExpiryDate = String()
    var purchasedSizeID = String()
    var orderNo = String()
    var tailornovaDesignName = String()
    var isFavo = Bool()
    var mannequinIDArray = [MannequinIDObject]()
    var lastModifiedSizeDate = String()
    var customSizeFitName = String()
    var dropPieceArray = [UserDefaultWSSaveModel]()
    var selectedSizeName = FormatsString.emptyString
    var selectedViewCupSizeName = FormatsString.emptyString
    func setProdData(dictData: [String: AnyObject]) {
        self.status = dictData["status"] as? String ?? FormatsString.emptyString
        self.id = dictData["ID"] as? String ?? FormatsString.emptyString
        let productImg = dictData["image"] as? String ?? FormatsString.emptyString
        if let imageURL = productImg.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) {
            self.image = imageURL
        }
        self.isFavo = dictData["isFavourite"] as? Bool ?? false
        self.name = dictData["name"] as? String ?? FormatsString.emptyString
        if let notionDetail = dictData["notionDetails"] as? String {
            self.notiondetails = notionDetail
        }
        if let yardageDetails = dictData["yardageDetails"] as? [String] {
            self.yardagedetails = yardageDetails.joined(separator: "\n")
        }
        if let yardagePdfUrl = dictData["yardagePdfUrl"] as? String {
            self.yardagePdfUrl = yardagePdfUrl
        }
        self.prodDescription = dictData["description"] as? String ?? FormatsString.emptyString
        self.customization = dictData["customization"] as? String ?? FormatsString.emptyString
        self.dateOfModification = dictData["dateOfModification"] as? String ?? FormatsString.emptyString
        if let typeArr = dictData["type"] as? [String] {
            for type in typeArr {
                self.type.append(type)
            }
        }
        if let seasonArr = dictData["seasons"] as? [String] {
            for season in seasonArr {
                self.seasons.append(season)
            }
        }
        self.occasion = dictData["occasion"] as? String ?? FormatsString.emptyString
        self.suitableFor = dictData["suitableFor"] as? String ?? FormatsString.emptyString
        self.size = dictData["size"] as? String ?? FormatsString.emptyString
        self.gender = dictData["gender"] as? String ?? FormatsString.emptyString
        self.brand = dictData["brand"] as? String ?? FormatsString.emptyString
        self.creationDate = dictData["creationDate"] as? String ?? FormatsString.emptyString
        self.patternType = dictData["patternType"] as? String ?? FormatsString.emptyString
        self.tailornovaDesignID = dictData["tailornovaDesignId"] as? String ?? FormatsString.emptyString
        self.purchasedSizeID = dictData["purchasedSizeId"] as? String ?? FormatsString.emptyString
        self.subscriptionExpiryDate = dictData["subscriptionExpiryDate"] as? String ?? FormatsString.emptyString
        self.orderNo = dictData["orderNo"] as? String ?? FormatsString.emptyString
        if let tailornovaDesignName = dictData["tailornovaDesignName"] as? String {
            if tailornovaDesignName == FormatsString.emptyString {
                self.tailornovaDesignName = dictData["name"] as? String ?? FormatsString.emptyString
            } else {
                self.tailornovaDesignName = dictData["tailornovaDesignName"] as? String ?? FormatsString.emptyString
            }
        }
        self.selectedTabCategory = FormatsString.emptyString
        self.selectedSizeName = FormatsString.emptyString
        self.selectedViewCupSizeName = FormatsString.emptyString
        self.dropPieceArray = [UserDefaultWSSaveModel]()
        self.lastModifiedSizeDate = dictData["lastModifiedSizeDate"] as? String ?? FormatsString.emptyString
        self.customSizeFitName = dictData["customSizeFitName"] as? String ?? FormatsString.emptyString
        if let mannequinArr = dictData["mannequin"]  as? NSArray {
            for mannequin in mannequinArr {
                let mannequinObject = MannequinIDObject()
                if let mannequinDictionary = mannequin as? NSDictionary {
                    if  let mannequinId = mannequinDictionary["mannequinId"] as?  String {
                        mannequinObject.mannequinID = mannequinId
                    }
                    if  let mannequinName = mannequinDictionary["mannequinName"] as?  String {
                        mannequinObject.mannequinName = mannequinName
                    }
                }
                self.mannequinIDArray.append(mannequinObject)
            }
        }
    }
    func setTrailProdData(dictData: PatternModelObject) {
        self.status = FormatsString.emptyString
        self.id = FormatsString.emptyString
        self.image = dictData.patternDescriptionImageURL
        self.isFavo = false
        self.name = dictData.patternName
        self.prodDescription = dictData.tailornovaDescription
        self.customization = (dictData.customization) ? FormatsString.oneLabel : FormatsString.zeroLabel
        self.dateOfModification = FormatsString.emptyString
        self.type.append(dictData.type)
        self.seasons.append(dictData.season)
        self.occasion = dictData.occasion
        self.suitableFor = dictData.suitableFor
        self.size = dictData.size
        self.gender = dictData.gender
        self.brand = dictData.brand
        self.orderNo = dictData.orderNo
        self.tailornovaDesignName = dictData.patternName
        self.creationDate = FormatsString.emptyString
        self.patternType = dictData.patternType
        self.tailornovaDesignID = dictData.designID
        self.purchasedSizeID = FormatsString.emptyString
        self.subscriptionExpiryDate = FormatsString.emptyString
        self.mannequinIDArray = [MannequinIDObject]()
        self.dropPieceArray = [UserDefaultWSSaveModel]()
        self.selectedTabCategory = FormatsString.emptyString
        self.lastModifiedSizeDate = FormatsString.emptyString
        self.customSizeFitName = FormatsString.emptyString
        self.selectedSizeName = FormatsString.emptyString
        self.selectedViewCupSizeName = FormatsString.emptyString
    }
}
