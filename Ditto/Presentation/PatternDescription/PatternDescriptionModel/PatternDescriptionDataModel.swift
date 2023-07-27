//
//  PatternDescriptionDataModel.swift
//  Ditto
//
//  Created by Gokul Ramesh on 15/09/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit

class PatternDescriptionDataModel {
    var orderCreationDate = String()
    var instructionFileName = String()
    var instructionUrl = String()
    var thumbnailImageUrl = String()
    var thumbnailImageName = String()
    var thumbnailEnlargedImageName = String()
    var patternDescriptionImageUrl = String()
    var selvages = [SelvagesDataModel]()
    var patternPieces = [PatternPiecesDataModel]()
    var brand = String()
    var size = Int()
    var gender = String()
    var customization = String()
    var type = Int()
    var season = Int()
    var suitableFor = Int()
    var occasion = Int()
    var designId = String()
    var name = String()
    var description = String()
    var patternType = String()
    var tailornovaInstructionURL = FormatsString.emptyString
    var numberOfPieces = NumberOfPiecesDataModel()
    func setPatternDescriptionDataModel(dictData: [String: AnyObject]) {
        self.orderCreationDate = dictData["orderCreationDate"] as? String ?? FormatsString.emptyString
        self.instructionFileName = dictData["instructionFileName"] as? String ?? FormatsString.emptyString
        self.instructionUrl = dictData["instructionUrl"] as? String ?? FormatsString.emptyString
        self.thumbnailImageUrl = dictData["thumbnailImageUrl"] as? String ?? FormatsString.emptyString
        self.thumbnailImageName = dictData["thumbnailImageName"] as? String ?? FormatsString.emptyString
        self.thumbnailEnlargedImageName = dictData["thumbnailEnlargedImageName"] as? String ?? FormatsString.emptyString
        self.patternDescriptionImageUrl = dictData["patternDescriptionImageUrl"] as? String ?? FormatsString.emptyString
        self.name = dictData["name"] as? String ?? FormatsString.emptyString
        self.description = dictData["description"] as? String ?? FormatsString.emptyString
        if let selvagesArray = dictData["selvages"] as? [[String: AnyObject]] {
            for selvage in selvagesArray {
                let objSelvageModel = SelvagesDataModel()
                objSelvageModel.setSelvagesDataModel(dictData: selvage)
                self.selvages.append(objSelvageModel)
            }
        }
        if let patternPiecesArray = dictData["patternPieces"] as? [[String: AnyObject]] {
            for patternPiece in patternPiecesArray {
                let objPatternPieceModel = PatternPiecesDataModel()
                objPatternPieceModel.setPatternPiecesDataModel(dictData: patternPiece)
                self.patternPieces.append(objPatternPieceModel)
            }
        }
        self.brand = dictData["brand"] as? String ?? FormatsString.emptyString
        self.size = dictData["size"] as? Int ?? 0
        self.gender = dictData["gender"] as? String ?? FormatsString.emptyString
        self.customization = dictData["customization"] as? String ?? FormatsString.emptyString
        self.type = dictData["type"] as? Int ?? 0
        self.season = dictData["season"] as? Int ?? 0
        self.suitableFor = dictData["suitableFor"] as? Int ?? 0
        self.occasion = dictData["occasion"] as? Int ?? 0
        self.designId = dictData["designId"] as? String ?? FormatsString.emptyString
        self.name = dictData["name"] as? String ?? FormatsString.emptyString
        self.description = dictData["description"] as? String ?? FormatsString.emptyString
        self.patternType = dictData["patternType"] as? String ?? FormatsString.emptyString
        if let numberOfPieceDict = dictData["numberOfPieces"] as? [String: AnyObject] {
                let objNumberOfPieces = NumberOfPiecesDataModel()
                objNumberOfPieces.setNumberofPiecesDataModel(dictData: numberOfPieceDict)
                self.numberOfPieces = objNumberOfPieces
        }
    }
}
class NumberOfPiecesDataModel {
    var garment = Int()
    var lining = Int()
    var interface = Int()
    var other = Int()
    func setNumberofPiecesDataModel(dictData: [String: AnyObject]) {
        self.garment = dictData["garment"] as? Int ?? 0
        self.lining = dictData["lining"] as? Int ?? 0
        self.interface = dictData["interface"] as? Int ?? 0
        self.other = dictData["other"] as? Int ?? 0
    }
}
