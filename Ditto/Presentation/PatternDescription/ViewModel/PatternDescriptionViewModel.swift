//
//  PatternDescriptionViewModel.swift
//  JoannTraceApp
//
//  Created by Abiya Joy on 15/04/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit.UIImage
import FabricTraceTransformFrx
import CoreData
import Alamofire

class PatternDescriptionViewModel {
    //MARK: VARIABLE DECLARATION
    var pattern = PatternObject()
    var currentSelectedPatterny: Pattern?
    var currenSelectedWorkspace: Workspace?
    var savednotes = String()
    var screenType =  FormatsString.emptyString
    var host = String()
    var port = Int32()
    var isYes: Bool = false
    var calibImg = UIImage()
    var isProjecting: Bool = false
    var isExpired: Bool = false
    var isOwned: Bool = false
    var isActive: Bool = false
    var isPaused: Bool = false
    let patternDescriptionModel = PatternDescriptionDataModel()
    var tailornovaPatternTitle = FormatsString.emptyString
    var tailornovaDesignId = FormatsString.emptyString
    var tailornovaInsUrl = FormatsString.emptyString
    var orderNo = FormatsString.emptyString
    var patternTitle = FormatsString.emptyString
    var patternDescription = FormatsString.emptyString
    var descriptionImageURL = FormatsString.emptyString
    var patternNameDirectory = FormatsString.emptyString
    var tailornovaModelObject = PatternModelObject()
    var tailornovaModelObjectArray = [PatternPieceModelObject]()
    var tailornovaSelvagesModelObjectArray = [SelvagesModelObject]()
    var tailornovamannequinIDArray = [MannequinIDObject]()
    var dropPieceArray = [UserDefaultWSSaveModel]()
    var thirdPartyObject = [ThirdPartyPatternVariation]()
    var selectedTabCategory = FormatsString.emptyString
    var purchasedSizeId = FormatsString.emptyString
    var selectedSizeName = FormatsString.emptyString
    var selectedViewCupSizeName = FormatsString.emptyString
    var customSelected = false
    var productId = FormatsString.emptyString
    var sizeSelected = false
    var viewCupSizeSelected = false
    let tableView = UITableView()
    var designIdToPass = FormatsString.emptyString
    var customisedNameList = [String]()
    var customisedIdList = [String]()
    var sizeList = [String]()
    var viewCupSizeList = [String]()
    var viewTapped = UIView()
    var selectedViewList = [String]()
    var sizeDesignIdList = [String]()
    var sizeMannequinIdList = [String]()
    let cellheight = UIDevice.isPad ? 37 : 27
    var tailornovaApiHit = true
    var thirdPartyApiHit = false
    var patternType = FormatsString.Trial
    var subscriptionExpiryDate = FormatsString.emptyString
    var tailornovaDesignName = FormatsString.emptyString
    var patternSize = FormatsString.emptyString
    var patternStatus = FormatsString.emptyString
    var trailPatternArray = [PatternModelObject]()
    var safeAreaInsets = Proxy.shared.keyWindow!.safeAreaInsets
    let transparentView = UIView()
    var changingButtonTitle = FormatsString.WORKSPACE
    var patternBrand = FormatsString.emptyString
    var lastModifiedSizeDate = FormatsString.emptyString
    var customSizeFitName = FormatsString.emptyString
    var notionDetails = FormatsString.emptyString
    var yardageDetails = FormatsString.emptyString
    var yardagePdfUrl = FormatsString.emptyString
    var objThirdPartyPatternWelcomeData = ThirdPartyPatternWelcome()
    //MARK: FUNCTION LOGICS
    func mapPatternPiecesFromDbtowokrspaceArrya(patternsArray: [PatternPieceDetails], selvageArray: [Selvages], completion: @escaping (PatternModelObject) -> Void) {  // Fetching pattern piece details from Db and setting data to ws array
        if !patternsArray.isEmpty {
            let patternObject = PatternModelObject()
            for piece in patternsArray {
                let pieceObject = PatternPieceModelObject()
                pieceObject.id = Int(piece.id)
                if let imageUrl = piece.imagePath {
                    pieceObject.imageURL = imageUrl
                }
                if let thumbnailImageUrl = piece.thumbnailImagePath {
                    pieceObject.thumbnailImageURL = thumbnailImageUrl
                }
                if let view = piece.view {
                    pieceObject.view = view
                }
                if let pieceNumber = piece.pieceNumber {
                    pieceObject.pieceNumber = pieceNumber
                }
                if let tailornovaId = piece.tailornovaIndex as Int32? {
                    pieceObject.tailornovaIndex = Int(tailornovaId)
                }
                if let isSelected = piece.isSelected as Bool? {
                    pieceObject.isSelected = isSelected
                }
                if let pieceDescription = piece.pieceDescription {
                    pieceObject.pieceDescription = pieceDescription
                }
                if let positionInTab = piece.positionInTabLineUp {
                    pieceObject.positionInTab = positionInTab
                }
                if let tabCategory = piece.tabCategory {
                    pieceObject.tabCategory = tabCategory
                }
                if let cutQuantity = piece.cutQuantity {
                    pieceObject.cutQuantity = cutQuantity
                }
                pieceObject.isSpliced = piece.splice
                pieceObject.mirrorOption = piece.mirrorOption
                if let spliceDirection = piece.spliceDirection {
                    pieceObject.spliceDirection = spliceDirection
                }
                if let spliceScreenQuantity = piece.spliceScreenQuantity {
                    pieceObject.spliceScreenQuantity = spliceScreenQuantity
                }
                if let mirrorTransformA = piece.mirrorTransformA as Float? {
                    pieceObject.transformA = (mirrorTransformA)
                }
                if let mirrorTransformD = piece.mirrorTranformD as Float? {
                    pieceObject.transformD = (mirrorTransformD)
                }
                if let isRotatedA = piece.isRotated as String? {
                    pieceObject.isRotated = isRotatedA == FormatsString.trueLabel ? true : false
                }
                if let rotatedAngleA = piece.rotatedAngle as Float? {
                    pieceObject.rotatedAngle = rotatedAngleA
                }
                if let centerx = piece.centerX as Float? {
                    pieceObject.centerX = centerx
                }
                if let centery = piece.centerY as Float? {
                    pieceObject.centerY = centery
                }
                if let contrast = piece.contrast as String? {
                    pieceObject.contrast = contrast
                }
                pieceObject.cutOnFold = piece.cutOnFold
                if  let splicedImagesArray = piece.splicedImages?.allObjects as? [SplicedImages] {
                    for splice in splicedImagesArray {
                        let spliceObject = SpliceModelObject()
                        spliceObject.id = Int(splice.id)
                        spliceObject.row = Int(splice.row)
                        spliceObject.column = Int(splice.coloumn)
                        spliceObject.imageURL = splice.imagePath!
                        spliceObject.mapImageURL = splice.referenceSplice!
                        pieceObject.splicedImages.append(spliceObject)
                    }
                }
                patternObject.patternPieces.append(pieceObject)
            }
            self.mapDBSelvagesToWorkspaceSelvagesArray(patternModelObject: patternObject, selvagesArray: selvageArray) { (pattenObg) in
                completion(pattenObg)
            }
        }
    }
    func mapDBSelvagesToWorkspaceSelvagesArray(patternModelObject: PatternModelObject, selvagesArray: [Selvages], completion: @escaping (PatternModelObject) -> Void) {  // Fetching pattern piece selvage details from Db and setting data to ws array
        var selvageArray = [SelvagesModelObject]()
        if !selvagesArray.isEmpty {
            for selvage in selvagesArray {
                let selvageObject = SelvagesModelObject()
                if  let imageUrl = selvage.imagePath {
                    selvageObject.imageURL = imageUrl
                }
                selvageObject.id = Int(selvage.id)
                if  let fabricLength = selvage.fabricLength {
                    selvageObject.fabricLength = fabricLength
                }
                if  let tabCategory = selvage.tabCategory {
                    selvageObject.tabCategory = tabCategory
                }
                if selvage.tabCategory!.capitalized == FormatsString.garment {
                    if(((selvage.fabricLength! == ReferenceLayoutType.fourtyfive) && (!selvageArray.contains(where: {$0.fabricLength == ReferenceLayoutType.fourtyfive && $0.tabCategory.capitalized == FormatsString.garment}))) || ((selvage.fabricLength! == ReferenceLayoutType.sixty) && (!selvageArray.contains(where: {$0.fabricLength == ReferenceLayoutType.sixty && $0.tabCategory.capitalized == FormatsString.garment})))) {
                        selvageArray.append(selvageObject)
                        patternModelObject.selvages.append(selvageObject)
                    }
                } else if selvage.tabCategory!.capitalized == FormatsString.lining {
                    if(((selvage.fabricLength! == ReferenceLayoutType.fourtyfive) && (!selvageArray.contains(where: {$0.fabricLength == ReferenceLayoutType.fourtyfive && $0.tabCategory.capitalized == FormatsString.lining}))) || ((selvage.fabricLength! == ReferenceLayoutType.sixty) && (!selvageArray.contains(where: {$0.fabricLength == ReferenceLayoutType.sixty && $0.tabCategory.capitalized == FormatsString.lining})))) {
                        selvageArray.append(selvageObject)
                        patternModelObject.selvages.append(selvageObject)
                    }
                } else if selvage.tabCategory!.capitalized == FormatsString.interfacing {
                    if(((selvage.fabricLength! == ReferenceLayoutType.twenty) && (!selvageArray.contains(where: {$0.fabricLength == ReferenceLayoutType.twenty && $0.tabCategory.capitalized == FormatsString.interfacing}))) || ((selvage.fabricLength! == ReferenceLayoutType.fourtyfive) && (!selvageArray.contains(where: {$0.fabricLength == ReferenceLayoutType.fourtyfive && $0.tabCategory.capitalized == FormatsString.interfacing})))) {
                        selvageArray.append(selvageObject)
                        patternModelObject.selvages.append(selvageObject)
                    }
                } else if selvage.tabCategory!.capitalized == FormatsString.other {
                    if(((selvage.fabricLength! == ReferenceLayoutType.fourtyfive) && (!selvageArray.contains(where: {$0.fabricLength == ReferenceLayoutType.fourtyfive && $0.tabCategory.capitalized == FormatsString.other}))) || ((selvage.fabricLength! == ReferenceLayoutType.sixty) && (!selvageArray.contains(where: {$0.fabricLength == ReferenceLayoutType.sixty && $0.tabCategory.capitalized == FormatsString.other})))) {
                        selvageArray.append(selvageObject)
                    }
                }
            }
        } else {
            let selvageObject = SelvagesModelObject()
            patternModelObject.selvages.append(selvageObject)
        }
        completion(patternModelObject)
    }
    func getPatternOffline(id: String, completion: @escaping (PatternModelObject) -> Void) {  // Getting the patterns in offline case
        var arrPatternPieceDetails = [PatternPieceDetails]()
        var selvagesArray = [Selvages]()
        var request = NSFetchRequest<NSFetchRequestResult>(entityName: "Pattern")
        let predicate = NSPredicate(format: "tailornovadesignID == %@", id)
        request = Pattern.fetchRequest()
        request.predicate = predicate
        request.returnsObjectsAsFaults = false
        do {
            let fetchedObjects = try contextData.fetch(request) as! [Pattern]
            if !fetchedObjects.isEmpty && ((fetchedObjects[0] as Pattern?) != nil) {
                arrPatternPieceDetails = (fetchedObjects[0] as Pattern?)?.patternPiece?.allObjects as! [PatternPieceDetails]
                selvagesArray = (fetchedObjects[0] as Pattern?)?.patternSelvages?.allObjects as! [Selvages]
                self.mapPatternPiecesFromDbtowokrspaceArrya(patternsArray: arrPatternPieceDetails, selvageArray: selvagesArray) { (patternObj) in
                    completion(patternObj)
                }
            }
        } catch {
            // Handle the error!
        }
    }
    func getThirdPartyPatternData(completion: @escaping ( _ thirdPartyPattern: ThirdPartyPatternWelcome, _ error: Bool, _ message: String) -> Void) {   // 3P pattern API call
        let params = ["productId": self.productId] as? [String: Any]
        ServiceManagerProxy.shared.postData(urlStr: "\(Apis.thirdPartyPatternURL)", params: params, showIndicator: true, forMyLib: true, shouldPassAuth: true) { response in
            if let resp = response {
                if resp.success {
                    if let dictData = resp.data {
                        let error = dictData["errorMsg"] as? String ?? FormatsString.emptyString
                        if error.isEmpty {
                            self.objThirdPartyPatternWelcomeData.setWelcomeData(dictData: dictData)
                            completion(self.objThirdPartyPatternWelcomeData, false, FormatsString.emptyString)
                        } else {
                            completion(ThirdPartyPatternWelcome(), true, error)
                        }
                    }
                } else {
                    completion(ThirdPartyPatternWelcome(), true, resp.message ?? FormatsString.emptyString)
                }
            }
        }
    }
}
