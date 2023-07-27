//
//  WSMainPostModel.swift
//  Ditto
//
//  Created by Gaurav.rajan on 24/10/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import Foundation

class WSWorkSpaceIteamModel {
    var id = 0
    var patternPiecesId = 0 // Parent Piece ID
    var isCompleted = false
    var xcoordinate = 0.0
    var ycoordinate = 0.0
    var pivotX = 0.0
    var pivotY = 0.0
    var transformA = Constants.defaultTransformValue
    var transformD = Constants.defaultTransformValue
    var rotationAngle = 0.0
    var isMirrorH = false
    var isMirrorV = false
    var mirrorOption = false
    var showMirrorDialog = false
    var currentSplicedPieceNo = FormatsString.emptyString
    var currentSplicedPieceRow = 0
    var currentSplicedPieceColumn = 0
    func setData(dict: [String: AnyObject]) {
        self.id = dict["id"] as? Int ?? 0
        self.patternPiecesId = dict["patternPiecesId"] as? Int ?? 0
        self.isCompleted = dict["isCompleted"] as? Bool ?? false
        self.xcoordinate = dict["xcoordinate"] as? Double ?? 0.0
        self.ycoordinate = dict["ycoordinate"] as? Double ?? 0.0
        self.pivotX = dict["pivotX"] as? Double ?? 0.0
        self.pivotY = dict["pivotY"] as? Double ?? 0.0
        self.transformA = dict["transformA"] as? String ?? Constants.defaultTransformValue
        self.transformD = dict["transformD"] as? String ?? Constants.defaultTransformValue
        self.rotationAngle = dict["rotationAngle"] as? Double ?? 0.0
        self.isMirrorH = dict["isMirrorH"] as? Bool ?? false
        self.isMirrorV = dict["isMirrorV"] as? Bool ?? false
        self.mirrorOption = dict["mirrorOption"] as? Bool ?? false
        self.showMirrorDialog = dict["showMirrorDialog"] as? Bool ?? false
        self.currentSplicedPieceNo = dict["currentSplicedPieceNo"] as? String ?? FormatsString.emptyString
        self.currentSplicedPieceRow = dict["currentSplicedPieceRow"] as? Int ?? 0
        self.currentSplicedPieceColumn = dict["currentSplicedPieceColumn"] as? Int ?? 0
    }
}

class WSNumberOfCompletedPiecesModel {
    var garment = Int()
    var lining = Int()
    var interface = Int()
    var other = Int()
    func setData(dict: [String: AnyObject]) {
        self.garment = dict["garment"] as? Int ?? 0
        self.lining = dict["lining"] as? Int ?? 0
        self.interface = dict["interface"] as? Int ?? 0
        self.other = dict["other"] as? Int ?? 0
    }
}

class WSPatternPiecesModel {
    var id = 0
    var isCompleted = false
    func setData(dict: [String: AnyObject]) {
        self.id = dict["id"] as? Int ?? 0
        self.isCompleted = dict["isCompleted"] as? Bool ?? false
    }
}

class WSMainPostModel {
    var tailornaovaDesignId = FormatsString.emptyString
    var time = FormatsString.emptyString
    var selectedTab = FormatsString.emptyString
    var notes = FormatsString.emptyString
    var status = FormatsString.emptyString
    var numberOfCompletedPiece = WSNumberOfCompletedPiecesModel()
    var patternPieces = [WSPatternPiecesModel]()
    var garmetWorkspaceItems = [WSWorkSpaceIteamModel]()
    var liningWorkspaceItems = [WSWorkSpaceIteamModel]()
    var interfaceWorkspaceItems = [WSWorkSpaceIteamModel]()
    var otherWorkspaceItems = [WSWorkSpaceIteamModel]()
    func setData(dict: [String: AnyObject]) {
        self.patternPieces.removeAll()
        self.garmetWorkspaceItems.removeAll()
        self.liningWorkspaceItems.removeAll()
        self.interfaceWorkspaceItems.removeAll()
        self.otherWorkspaceItems.removeAll()
        self.tailornaovaDesignId = dict["tailornaovaDesignId"] as? String ?? FormatsString.emptyString
        self.selectedTab = dict["selectedTab"] as? String ?? FormatsString.emptyString
        self.notes = dict["notes"] as? String ?? FormatsString.emptyString
        self.status = dict["status"] as? String ?? FormatsString.emptyString
        if let dictCompletedPieces = dict["numberOfCompletedPiece"] as? [String: AnyObject] {
            let temp = WSNumberOfCompletedPiecesModel()
            temp.setData(dict: dictCompletedPieces)
            self.numberOfCompletedPiece = temp
        }
        if let arrPatternPieces = dict["patternPieces"] as? [[String: AnyObject]] {
            for dict in arrPatternPieces {
                let objpatternPieces = WSPatternPiecesModel()
                objpatternPieces.setData(dict: dict)
                self.patternPieces.append(objpatternPieces)
            }
        }
        if let arrGarmetWorkspaceItems = dict["garmetWorkspaceItems"] as? [[String: AnyObject]] {
            for dict in arrGarmetWorkspaceItems {
                let objWSWorkSpaceIteamModelGW = WSWorkSpaceIteamModel()
                objWSWorkSpaceIteamModelGW.setData(dict: dict)
                self.garmetWorkspaceItems.append(objWSWorkSpaceIteamModelGW)
            }
        }
        if let arrliningWorkspaceItems = dict["liningWorkspaceItems"] as? [[String: AnyObject]] {
            for dict in arrliningWorkspaceItems {
                let objWSWorkSpaceIteamModelLW = WSWorkSpaceIteamModel()
                objWSWorkSpaceIteamModelLW.setData(dict: dict)
                self.liningWorkspaceItems.append(objWSWorkSpaceIteamModelLW)
            }
        }
        if let arrInterfaceWorkspaceItems = dict["interfaceWorkspaceItems"] as? [[String: AnyObject]] {
            for dict in arrInterfaceWorkspaceItems {
                let objWSWorkSpaceIteamModelL = WSWorkSpaceIteamModel()
                objWSWorkSpaceIteamModelL.setData(dict: dict)
                self.interfaceWorkspaceItems.append(objWSWorkSpaceIteamModelL)
            }
        }
        if let arrOtherWorkspaceItems = dict["otherWorkspaceItems"] as? [[String: AnyObject]] {
            for dict in arrOtherWorkspaceItems {
                let objWSWorkSpaceIteamModelL = WSWorkSpaceIteamModel()
                objWSWorkSpaceIteamModelL.setData(dict: dict)
                self.otherWorkspaceItems.append(objWSWorkSpaceIteamModelL)
            }
        }
    }
}
