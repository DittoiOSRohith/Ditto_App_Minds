//
//  PatternPiecesDataModel.swift
//  Ditto
//
//  Created by Gokul Ramesh on 15/09/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit

class PatternPiecesDataModel {
    var id = String()
    var imageUrl = String()
    var imageName = String()
    var thumbnailImageUrl = String()
    var thumbnailImageName = String()
    var size = Int()
    var view = String()
    var pieceNumber = Int()
    var pieceDescription = String()
    var positionInTab = Int()
    var tabCategory = String()
    var cutQuantity = String()
    var isSpliced = String()
    var spliceDirection = Int()
    var spliceScreenQuantity = String()
    var cutOnFold = String()
    var contrast = String()
    var splicedImages = [SplicedImagesDataModel]()
    func setPatternPiecesDataModel(dictData: [String: AnyObject]) {
        self.id = dictData["id"] as? String ?? FormatsString.emptyString
        self.imageUrl = dictData["imageUrl"] as? String ?? FormatsString.emptyString
        self.imageName = dictData["imageName"] as? String ?? FormatsString.emptyString
        self.thumbnailImageUrl = dictData["thumbnailImageUrl"] as? String ?? FormatsString.emptyString
        self.thumbnailImageName = dictData["thumbnailImageName"] as? String ?? FormatsString.emptyString
        self.size = dictData["size"] as? Int ?? 0
        self.view = dictData["view"] as? String ?? FormatsString.emptyString
        self.pieceNumber = dictData["pieceNumber"] as? Int ?? 0
        self.pieceDescription = dictData["pieceDescription"] as? String ?? FormatsString.emptyString
        self.positionInTab = dictData["positionInTab"] as? Int ?? 0
        self.tabCategory = dictData["tabCategory"] as? String ?? FormatsString.emptyString
        self.cutQuantity = dictData["cutQuantity"] as? String ?? FormatsString.emptyString
        self.isSpliced = dictData["isSpliced"] as? String ?? FormatsString.emptyString
        self.spliceDirection = dictData["spliceDirection"] as? Int ?? 0
        self.spliceScreenQuantity = dictData["spliceScreenQuantity"] as? String ?? FormatsString.emptyString
        self.cutOnFold = dictData["cutOnFold"] as? String ?? FormatsString.emptyString
        self.contrast = dictData["contrast"] as? String ?? FormatsString.emptyString
        if let spliceImageArray = dictData["splicedImages"] as? [[String: AnyObject]] {
            for splice in spliceImageArray {
                let objSsplicedModel = SplicedImagesDataModel()
                objSsplicedModel.setSplicedImagesDataModel(dictData: splice)
                self.splicedImages.append(objSsplicedModel)
            }
        }
    }
}
class SplicedImagesDataModel {
    var designId = String()
    var pieceId = Int()
    var id = Int()
    var row = Int()
    var column = Int()
    var imageUrl = String()
    var imageName = String()
    var mapImageUrl = String()
    var mapImageName = String()
    func setSplicedImagesDataModel(dictData: [String: AnyObject]) {
        self.designId = dictData["designId"] as? String ?? FormatsString.emptyString
        self.pieceId = dictData["pieceId"] as? Int ?? 0
        self.id = dictData["id"] as? Int ?? 0
        self.row = dictData["row"] as? Int ?? 0
        self.column = dictData["column"] as? Int ?? 0
        self.imageUrl = dictData["imageUrl"] as? String ?? FormatsString.emptyString
        self.imageName = dictData["imageName"] as? String ?? FormatsString.emptyString
        self.mapImageUrl = dictData["mapImageUrl"] as? String ?? FormatsString.emptyString
        self.mapImageName = dictData["mapImageName"] as? String ?? FormatsString.emptyString
    }
}
