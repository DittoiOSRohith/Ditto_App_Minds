import Foundation
/*
// OLD
 {
     "tailornaovaDesignId":"1",
     "selectedTab":"1",
     "status":"New",
     "numberOfCompletedPieces":{
         "garment":6,
         "lining":4,
         "interface":5
     },
     "patternPieces":[ {
             "id":1,
             "isCompleted":"Yes"
         },
         {
             "id":2,
             "isCompleted":"Yes"
         }
     ],
     "garmetWorkspaceItems":[ {
             "id":1,
             "patternPiecesId":1,
             "isCompleted":"Yes",
             "xcoordinate":"",
             "ycoordinate":"",
             "pivotX":"",
             "pivotY":"",
             "transformA":"0.0",
             "transformD":"0.0",
             "rotationAngle":"",
             "isMirrorH":"Yes",
             "isMirrorV":"No",
             "showMirrorDialog":"Yes",
             "currentSplicedPieceNo":"1"
         },
         {
             "id":2,
             "patternPiecesId":1,
             "isCompleted":"Yes",
             "xcoordinate":"",
             "ycoordinate":"",
             "pivotX":"",
             "pivotY":"",
             "transformA":"0.0",
             "transformD":"0.0",
             "rotationAngle":"",
             "isMirrorH":"Yes",
             "isMirrorV":"No",
             "showMirrorDialog":"Yes",
             "currentSplicedPieceNo":"2"
         }
     ],
     "liningWorkspaceItems":[ {
             "id":1,
             "patternPiecesId":1,
             "isCompleted":"Yes",
             "xcoordinate":"",
             "ycoordinate":"",
             "pivotX":"",
             "pivotY":"",
             "transformA":"0.0",
             "transformD":"0.0",
             "rotationAngle":"",
             "isMirrorH":"Yes",
             "isMirrorV":"No",
             "showMirrorDialog":"Yes",
             "currentSplicedPieceNo":"1"
         }
     ],
     "interfaceWorkspaceItems":[ {
             "id":1,
             "patternPiecesId":1,
             "isCompleted":"Yes",
             "xcoordinate":"",
             "ycoordinate":"",
             "pivotX":"",
             "pivotY":"",
             "transformA":"0.0",
             "transformD":"0.0",
             "rotationAngle":"",
             "isMirrorH":"Yes",
             "isMirrorV":"No",
             "showMirrorDialog":"Yes",
             "currentSplicedPieceNo":"1"
         }
     ]
 }











// NEW

 {
     "tailornaovaDesignId":"",
     "dateOfModification":"Wed Sep 01 07:59:20 GMT 2021",
     "selectedTab":"",
     "status":"",
     "numberOfCompletedPieces":{
         "garment":7,
         "lining":4,
         "interface":5
     },
     "patternPieces":[
         {
             "id":0,
             "isCompleted":false
         },
         {
             "id":0,
             "isCompleted":false
         }
     ],
     "garmetWorkspaceItems":[
         {
             "id":0,
             "patternPiecesId":0,
             "isCompleted":false,
             "xcoordinate":0.0,
             "ycoordinate":"",
             "pivotX":"",
             "pivotY":"",
             "transformA":"",
             "transformD":"",
             "rotationAngle":"",
             "isMirrorH":"",
             "isMirrorV":"",
             "showMirrorDialog":"",
             "currentSplicedPieceNo":""
         },
         {
             "id":0,
             "patternPiecesId":0,
             "isCompleted":false,
             "xcoordinate":0.0,
             "ycoordinate":"",
             "pivotX":"",
             "pivotY":"",
             "transformA":"",
             "transformD":"",
             "rotationAngle":"",
             "isMirrorH":"",
             "isMirrorV":"",
             "showMirrorDialog":"",
             "currentSplicedPieceNo":""
         }
     ],
     "liningWorkspaceItems":[
         {
             "id":0,
             "patternPiecesId":0,
             "isCompleted":false,
             "xcoordinate":0.0,
             "ycoordinate":"",
             "pivotX":"",
             "pivotY":"",
             "transformA":"",
             "transformD":"",
             "rotationAngle":"",
             "isMirrorH":"",
             "isMirrorV":"",
             "showMirrorDialog":"",
             "currentSplicedPieceNo":""
         }
     ],
     "interfaceWorkspaceItems":[
         {
             "id":0,
             "patternPiecesId":0,
             "isCompleted":false,
             "xcoordinate":0.0,
             "ycoordinate":"",
             "pivotX":"",
             "pivotY":"",
             "transformA":"",
             "transformD":"",
             "rotationAngle":"",
             "isMirrorH":"",
             "isMirrorV":"",
             "showMirrorDialog":"",
             "currentSplicedPieceNo":""
         }
     ]
 }
  */
 class WSWorkSpaceIteamModel {
    var id = 0
    var patternPiecesId = 0 // Parent Piece ID
    var isCompleted = false
    var xcoordinate = 0.0
    var ycoordinate = 0.0
    var pivotX = ""
    var pivotY = ""
    var transformA = ""
    var transformD = ""
    var rotationAngle = ""
    var isMirrorH = ""
    var isMirrorV = ""
    var showMirrorDialog = ""
    var currentSplicedPieceNo = ""
    /*
     var imageId : Int = 0
    var isSpliced = false
    var x : CGFloat = 0
    var y : CGFloat = 0
    var mirrorH : CGAffineTransform?
    var mirrorV : CGAffineTransform?
    var isRotated : Bool!
    var degree : CGFloat = 0
    var isMirrordH : Bool! = false
    var isMirrorV : Bool! = false */
 }
 class WSNumberOfCompletedPiecesModel {
    var garment = Int()
    var lining = Int()
    var interface = Int()
}
 class WSPatternPiecesModel {
    var id = 0
    var isCompleted = false
 }
 class WSMainPostModel {
    var tailornaovaDesignId = ""
    var dateOfModification = ""  // :"Wed Sep 01 07:59:20 GMT 2021",
    var selectedTab = ""
    var status = ""
    var numberOfCompletedPieces = WSNumberOfCompletedPiecesModel()
    var patternPieces = [WSPatternPiecesModel]()
    var garmetWorkspaceItems = [WSWorkSpaceIteamModel]()
    var liningWorkspaceItems = [WSWorkSpaceIteamModel]()
    var interfaceWorkspaceItems = [WSWorkSpaceIteamModel]()
    /*
    init() {
        defer {
            numberOfCompletedPieces.garment = 1
            numberOfCompletedPieces.lining = 2
            numberOfCompletedPieces.interface = 3
            
            self.tailornaovaDesignId = "1"
            self.dateOfModification = "Wed Sep 01 07:59:20 GMT 2021"
            self.selectedTab = "1"
            self.status = "New"
        }
        
        for i in 0...2{
            let objWSPatternPiecesModel = WSPatternPiecesModel()
            objWSPatternPiecesModel.id = i
            objWSPatternPiecesModel.isCompleted = true
            patternPieces.append(objWSPatternPiecesModel)
        }
        
        for i in 0...2{
            let objWSWorkSpaceIteamModel = WSWorkSpaceIteamModel()
            objWSWorkSpaceIteamModel.id = i
            objWSWorkSpaceIteamModel.patternPiecesId = i
            objWSWorkSpaceIteamModel.isCompleted = false
            objWSWorkSpaceIteamModel.xcoordinate = 0.5
            objWSWorkSpaceIteamModel.ycoordinate = 1.0
            objWSWorkSpaceIteamModel.pivotX = ""
            objWSWorkSpaceIteamModel.pivotY = ""
            objWSWorkSpaceIteamModel.transformA = ""
            objWSWorkSpaceIteamModel.transformD = ""
            objWSWorkSpaceIteamModel.rotationAngle = ""
            objWSWorkSpaceIteamModel.isMirrorH = ""
            objWSWorkSpaceIteamModel.isMirrorV = ""
            objWSWorkSpaceIteamModel.showMirrorDialog = "false"
            objWSWorkSpaceIteamModel.currentSplicedPieceNo = "1"
            
            garmetWorkspaceItems.append(objWSWorkSpaceIteamModel)
            liningWorkspaceItems.append(objWSWorkSpaceIteamModel)
            interfaceWorkspaceItems.append(objWSWorkSpaceIteamModel)
        }
    } */
 }

// extension NewWorkSpaceBaseViewModel {
//    
//    weak var objWSMainPostModel: WSMainPostModel? {
//        return WSMainPostModel()
//    }
//
// }
