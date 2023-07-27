//
//  TailornovaApiService.swift
//  Ditto
//
//  Created by shefrin on 03/08/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit
import Alamofire

class TailornovaApiService: FetchableImage {
    // Downloading images in workspace for the opened pattern and saving in cache.
    func dowloadPatternImages(tailornova: [PatternPieceModelObject], isTrail: Bool, index: String, completion: @escaping() -> Void) {
        let originalImagePathArray = tailornova.map { $0.imageURL}
        let spliceimageObjects: [SpliceModelObject] = tailornova.flatMap {$0.splicedImages}
        let spliceImageURLArray = spliceimageObjects.map {$0.imageURL}
        let thumbnailImage = tailornova.map { $0.thumbnailImageURL}
        let array = originalImagePathArray + spliceImageURLArray + thumbnailImage
        var isPatternTrail = false
        isPatternTrail = isTrail
        let option: FetchableImageOptions = FetchableImageOptions(storeInCachesDirectory: false, allowLocalStorage: true, customFileName: nil)
        fetchBatchImages(using: array, isTrail: isPatternTrail, patternName: index, options: option) { (_, _) in
        } completion: {
            completion()
        }
    }
    func parseTailornovaResponse(data: Data, completion: @escaping (PatternModelObject) -> Void) { // fetching tailornova data from API json and setting it to array.
        do {
            if let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                let pattern = PatternModelObject()
                if let designId = jsonData["designId"] as? String {
                    pattern.designID = designId
                }
                if let patternName = jsonData["patternName"] as? String {
                    pattern.patternName = patternName
                }
                if let patternType = jsonData["patternType"] as? String {
                    pattern.patternType = patternType
                }
                if let typeofpattern = jsonData["type"] as? String {
                    pattern.type = typeofpattern
                }
                if let descriptionpattern = jsonData["description"] as? String {
                    pattern.tailornovaDescription = descriptionpattern
                }
                if let suitableFor = jsonData["suitableFor"] as? String {
                    pattern.suitableFor = suitableFor
                }
                if let occasion = jsonData["occasion"] as? String {
                    pattern.occasion = occasion
                }
                if let season = jsonData["season"] as? String {
                    pattern.season = season
                }
                if let customization = jsonData["customization"] as? Bool {
                    pattern.customization = customization
                }
                if let gender = jsonData["gender"] as? String {
                    pattern.gender = gender
                }
                if let size = jsonData["size"] as? String {
                    pattern.size = size
                }
                if let brand = jsonData["brand"] as? String {
                    pattern.brand = brand
                }
                if let instructionfilename = jsonData["instructionFileName"] as? String {
                    pattern.instructionFileName = instructionfilename
                }
                if let instructionUrl = jsonData["instructionUrl"] as? String {
                    pattern.instructionURL = instructionUrl
                }
                if let thumbnailImageUrl = jsonData["thumbnailImageUrl"] as? String {
                    pattern.thumbnailImageURL = thumbnailImageUrl
                }
                if let thumbnailImageName = jsonData["thumbnailImageName"] as? String {
                    pattern.thumbnailImageName = thumbnailImageName
                }
                if let patternDescriptionImageUrl = jsonData["patternDescriptionImageUrl"] as? String {
                    pattern.patternDescriptionImageURL = patternDescriptionImageUrl
                }
                if let patternDescriptionImageUrl = jsonData["patternDescriptionImageUrl"] as? String {
                    pattern.patternDescriptionImageURL = patternDescriptionImageUrl
                }
                var selvageArray = [SelvagesModelObject]()
                if let selvages = jsonData["selvages"] as? NSArray {
                    selvageArray.removeAll()
                    for selvage in selvages {
                        let selvageObject = SelvagesModelObject()
                        if let selvageDictionary = selvage as? NSDictionary {
                            if let imageUrl = selvageDictionary["imageUrl"] as?  String {
                                selvageObject.imageURL = imageUrl
                            }
                            if let idValue = selvageDictionary["id"] as? Int {
                                selvageObject.id = idValue
                            }
                            if let tabCategory = selvageDictionary["tabCategory"] as?  String {
                                selvageObject.tabCategory = tabCategory.capitalized
                            }
                            if let fabricLength = selvageDictionary["fabricLength"] as?  String {
                                selvageObject.fabricLength = fabricLength
                            }
                            if (selvageDictionary["tabCategory"] as? String)?.capitalized == FormatsString.garment {
                                if((((selvageDictionary["fabricLength"] as? String) == ReferenceLayoutType.fourtyfive) && (!selvageArray.contains(where: {$0.fabricLength == ReferenceLayoutType.fourtyfive && $0.tabCategory.capitalized == FormatsString.garment}))) || (((selvageDictionary["fabricLength"] as? String) == ReferenceLayoutType.sixty) && (!selvageArray.contains(where: {$0.fabricLength == ReferenceLayoutType.sixty && $0.tabCategory.capitalized == FormatsString.garment})))) {
                                    selvageArray.append(selvageObject)
                                    pattern.selvages.append(selvageObject)
                                }
                            } else if (selvageDictionary["tabCategory"] as? String)?.capitalized == FormatsString.lining {
                                if((((selvageDictionary["fabricLength"] as? String) == ReferenceLayoutType.fourtyfive) && (!selvageArray.contains(where: {$0.fabricLength == ReferenceLayoutType.fourtyfive && $0.tabCategory.capitalized == FormatsString.lining}))) || (((selvageDictionary["fabricLength"] as? String) == ReferenceLayoutType.sixty) && (!selvageArray.contains(where: {$0.fabricLength == ReferenceLayoutType.sixty && $0.tabCategory.capitalized == FormatsString.lining})))) {
                                    selvageArray.append(selvageObject)
                                    pattern.selvages.append(selvageObject)
                                }
                            } else if (selvageDictionary["tabCategory"] as? String)?.capitalized == FormatsString.interfacing {
                                if((((selvageDictionary["fabricLength"] as? String) == ReferenceLayoutType.twenty) && (!selvageArray.contains(where: {$0.fabricLength == ReferenceLayoutType.twenty && $0.tabCategory.capitalized == FormatsString.interfacing}))) || (((selvageDictionary["fabricLength"] as? String) == ReferenceLayoutType.fourtyfive) && (!selvageArray.contains(where: {$0.fabricLength == ReferenceLayoutType.fourtyfive && $0.tabCategory.capitalized == FormatsString.interfacing})))) {
                                    selvageArray.append(selvageObject)
                                    pattern.selvages.append(selvageObject)
                                }
                            } else if (selvageDictionary["tabCategory"] as? String)?.capitalized == FormatsString.other {
                                if((((selvageDictionary["fabricLength"] as? String) == ReferenceLayoutType.fourtyfive) && (!selvageArray.contains(where: {$0.fabricLength == ReferenceLayoutType.fourtyfive && $0.tabCategory.capitalized == FormatsString.other}))) || (((selvageDictionary["fabricLength"] as? String) == ReferenceLayoutType.sixty) && (!selvageArray.contains(where: {$0.fabricLength == ReferenceLayoutType.sixty && $0.tabCategory.capitalized == FormatsString.other})))) {
                                    selvageArray.append(selvageObject)
                                    pattern.selvages.append(selvageObject)
                                }
                            }
                        }
                    }
                }
                if let mannequinArr = jsonData["mannequin"]  as? NSArray {
                    for mannequin in mannequinArr {
                        let mannequinObject = MannequinIDObject()
                        if let mannequinDictionary = mannequin as? NSDictionary {
                            if let mannequinId = mannequinDictionary["mannequinId"] as?  String {
                                mannequinObject.mannequinID = mannequinId
                            }
                            if let mannequinName = mannequinDictionary["mannequinName"] as?  String {
                                mannequinObject.mannequinName = mannequinName
                            }
                        }
                        pattern.mannequinIDObjects.append(mannequinObject)
                    }
                }
                if let patternPiecesArray = jsonData["patternPieces"] as? NSArray {
                    for (item, piece) in patternPiecesArray.enumerated() {
                        let pieceObject = PatternPieceModelObject()
                        if let pieceDictionary = piece as? NSDictionary {
                            if let idvalue = pieceDictionary["id"] as?  Int {
                                pieceObject.tailornovaIndex = idvalue
                            }
                            pieceObject.id = item
                            if let imageUrl = pieceDictionary["imageUrl"] as?  String {
                                pieceObject.imageURL = imageUrl
                            }
                            if let imageName = pieceDictionary["imageName"] as?  String {
                                pieceObject.imageName = imageName
                            }
                            if let thumbnailImageUrl = pieceDictionary["thumbnailImageUrl"] as?  String {
                                pieceObject.thumbnailImageURL = thumbnailImageUrl
                            }
                            if let view = pieceDictionary["view"] as?  String {
                                pieceObject.view = view
                            }
                            if let thumbnailImageName = pieceDictionary["thumbnailImageName"] as?  String {
                                pieceObject.thumbnailImageName = thumbnailImageName
                            }
                            if let pieceNumber = pieceDictionary["pieceNumber"] as?  String {
                                pieceObject.pieceNumber = pieceNumber
                            }
                            if let pieceDescription = pieceDictionary["pieceDescription"] as?  String {
                                pieceObject.pieceDescription = pieceDescription
                            }
                            if let positionInTab = pieceDictionary["positionInTab"] as?  String {
                                pieceObject.positionInTab = positionInTab
                            }
                            if let tabCategory = pieceDictionary["tabCategory"] as?  String {
                                pieceObject.tabCategory = tabCategory.capitalized
                            }
                            if let cutQuantity = pieceDictionary["cutQuantity"] as?  String {
                                pieceObject.cutQuantity = cutQuantity
                            }
                            if let isSpliced = pieceDictionary["isSpliced"] as?  Bool {
                                pieceObject.isSpliced = isSpliced
                            }
                            if let mirrorOption = pieceDictionary["mirrorOption"] as?  Bool {
                                pieceObject.mirrorOption = mirrorOption
                            }
                            if let spliceDirection = pieceDictionary["spliceDirection"] as?  String {
                                pieceObject.spliceDirection = spliceDirection
                            }
                            if let spliceScreenQuantity = pieceDictionary["spliceScreenQuantity"] as?  String {
                                pieceObject.spliceScreenQuantity = spliceScreenQuantity
                            }
                            if let cutOnFold = pieceDictionary["cutOnFold"] as?  Bool {
                                pieceObject.cutOnFold = cutOnFold
                            }
                            if let contrast = pieceDictionary["contrast"] as? String {
                                pieceObject.contrast = contrast
                            }
                            if let splicedImagesArray = pieceDictionary["splicedImages"] as?  NSArray {
                                for splice in splicedImagesArray {
                                    let spliceObject = SpliceModelObject()
                                    if let spliceDictionary = splice as? NSDictionary {
                                        if let designId = spliceDictionary["designId"] as?  String {
                                            spliceObject.designID = designId
                                        }
                                        if let pieceId = spliceDictionary["pieceId"] as?  Int {
                                            spliceObject.pieceID = pieceId
                                        }
                                        if let idValue = spliceDictionary["id"] as?  Int {
                                            spliceObject.id = idValue
                                        }
                                        if let row = spliceDictionary["row"] as?  Int {
                                            spliceObject.row = row
                                        }
                                        if let column = spliceDictionary["column"] as?  Int {
                                            spliceObject.column = column
                                        }
                                        if let imageUrl = spliceDictionary["imageUrl"] as?  String {
                                            spliceObject.imageURL = imageUrl
                                        }
                                        if let imageName = spliceDictionary["imageName"] as?  String {
                                            spliceObject.imageName = imageName
                                        }
                                        if let mapImageUrl = spliceDictionary["mapImageUrl"] as?  String {
                                            spliceObject.mapImageURL = mapImageUrl
                                        }
                                        if let mapImageName = spliceDictionary["mapImageName"] as?  String {
                                            spliceObject.mapImageName = mapImageName
                                        }
                                        pieceObject.splicedImages.append(spliceObject)
                                    }
                                }
                            }
                        }
                        pattern.patternPieces.append(pieceObject)
                    }
                }
                completion(pattern)
            }
        } catch _ as NSError {
        }
    }
    func hitTailornovaApi(params: String, purchaseParams: String, completion: @escaping (_ PatternModelObject: PatternModelObject, _ error: Bool, _ message: String) -> Void) {  // Tailornova API call
        let urlString = "\(ApiUrlStrings.tailornovaApiOne)\(params)\(ApiUrlStrings.tailornovaApiTwo)\(purchaseParams)"
        ServiceManagerProxy.shared.getTailornovaPatternDetailsFrom(urlStr: urlString) { resp in
            if let dataJson = resp, dataJson.success {
                self.parseTailornovaResponse(data: dataJson.jsonData!) { (pattern) in
                    dump(pattern)
                    completion(pattern, false, FormatsString.emptyString)
                }
            } else {
                completion(PatternModelObject(), true, resp?.message ?? FormatsString.emptyString)
            }
        }
    }
}
