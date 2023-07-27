// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let tailornova = try? newJSONDecoder().decode(Tailornova.self, from: jsonData)
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let tailornova = try? newJSONDecoder().decode(Tailornova.self, from: jsonData)

import Foundation

class  PatternModelObject: NSObject {
    var instructionFileName: String = FormatsString.emptyString
    var instructionURL: String = FormatsString.emptyString
    var thumbnailImageURL: String = FormatsString.emptyString
    var thumbnailImageName = FormatsString.emptyString
    var thumbnailEnlargedImageName: String = FormatsString.emptyString
    var patternDescriptionImageURL = FormatsString.emptyString
    var brand = FormatsString.emptyString
    var size = FormatsString.emptyString
    var gender = FormatsString.emptyString
    var customization = false
    var type = FormatsString.emptyString
    var season = FormatsString.emptyString
    var suitableFor = FormatsString.emptyString
    var occasion = FormatsString.emptyString
    var designID = FormatsString.emptyString
    var patternName = FormatsString.emptyString
    var tailornovaDescription = FormatsString.emptyString
    var patternType = FormatsString.emptyString
    var isDownloaded = false
    var orderNo = FormatsString.emptyString
    var selvages = [SelvagesModelObject]()
    var patternPieces = [PatternPieceModelObject]()
    var mannequinIDObjects = [MannequinIDObject]()
    var purchasedSizeId = FormatsString.emptyString
}

class  SelvagesModelObject: NSObject {
    var id: Int = 0
    var imageURL  = FormatsString.emptyString
    var imageName = FormatsString.emptyString
    var tabCategory = FormatsString.emptyString
    var fabricLength = FormatsString.emptyString
}

class SpliceModelObject: NSObject {
    var designID = FormatsString.emptyString
    var pieceID = 0
    var id = 0
    var row = 0
    var column = 0
    var imageURL = FormatsString.emptyString
    var imageName = FormatsString.emptyString
    var mapImageURL = FormatsString.emptyString
    var mapImageName = FormatsString.emptyString
}

class PatternPieceModelObject: NSObject {
    var id = 0
    var imageURL = FormatsString.emptyString
    var imageName = FormatsString.emptyString
    var thumbnailImageURL = FormatsString.emptyString
    var thumbnailImageName = FormatsString.emptyString
    var view = FormatsString.emptyString
    var pieceNumber = FormatsString.emptyString
    var pieceDescription = FormatsString.emptyString
    var positionInTab = FormatsString.emptyString
    var tabCategory = FormatsString.emptyString
    var cutQuantity = FormatsString.zeroLabel
    var isSpliced = false
    var mirrorOption = false
    var spliceDirection = FormatsString.emptyString
    var spliceScreenQuantity = FormatsString.emptyString
    var cutOnFold = false
    var splicedImages = [SpliceModelObject]()
    var transformA = Float(0.0)
    var transformD = Float(0.0)
    var isRotated = false
    var centerX = Float()
    var centerY = Float()
    var rotatedAngle = Float()
    var tailornovaIndex = 0
    var isSelected = false
    var contrast = FormatsString.emptyString
}
class NoOfPieceModel: NSObject {
    var garment = 0
    var lining = 0
    var interface = 0
    var other = 0
}
// MARK: - Tailornova
struct PatternTailornovaObject: Codable {
    let instructionFileName: String
    let instructionURL: String
    let thumbnailImageURL: String
    let thumbnailImageName, thumbnailEnlargedImageName: String
    let patternDescriptionImageURL: String
    let selvages: [SelvageTailornovaObject]
    let patternPieces: [PatternPieceTailornovaObject]
    let brand, size, gender: String
    let customization: Bool
    let type, season, suitableFor, occasion: String
    let designID, patternName, tailornovaDescription, patternType: String
    let numberOfPieces: NumberOfPiecesTailornovaObject
    enum CodingKeys: String, CodingKey {
        case instructionFileName
        case instructionURL = "instructionUrl"
        case thumbnailImageURL = "thumbnailImageUrl"
        case thumbnailImageName, thumbnailEnlargedImageName
        case patternDescriptionImageURL = "patternDescriptionImageUrl"
        case selvages, patternPieces, brand, size, gender, customization, type, season, suitableFor, occasion
        case designID = "designId"
        case patternName
        case tailornovaDescription = "description"
        case patternType, numberOfPieces
    }
}
// MARK: - NumberOfPieces
struct NumberOfPiecesTailornovaObject: Codable {
    let garment, lining, interface, other: Int
}
// MARK: - PatternPiece
struct PatternPieceTailornovaObject: Codable {
    let id: Int
    let imageURL: String
    let imageName: String
    let thumbnailImageURL: String
    let thumbnailImageName, view, pieceNumber, pieceDescription: String
    let positionInTab, tabCategory, cutQuantity, contrast: String
    let isSpliced, mirrorOption: Bool
    let spliceDirection, spliceScreenQuantity: String
    let cutOnFold: Bool
    let splicedImages: [SplicedImageTailornoavObject]
    enum CodingKeys: String, CodingKey {
        case id
        case imageURL = "imageUrl"
        case imageName
        case thumbnailImageURL = "thumbnailImageUrl"
        case thumbnailImageName, view, pieceNumber, pieceDescription, positionInTab, tabCategory, cutQuantity, isSpliced, mirrorOption, spliceDirection, spliceScreenQuantity, cutOnFold, splicedImages, contrast
    }
}
// MARK: - SplicedImage
struct SplicedImageTailornoavObject: Codable {
    let designID: String
    let pieceID, id, row, column: Int
    let imageURL: String
    let imageName: String
    let mapImageURL: String
    let mapImageName: String
    enum CodingKeys: String, CodingKey {
        case designID = "designId"
        case pieceID = "pieceId"
        case id, row, column
        case imageURL = "imageUrl"
        case imageName
        case mapImageURL = "mapImageUrl"
        case mapImageName
    }
}
// MARK: - Selvage
struct SelvageTailornovaObject: Codable {
    let id: Int
    let imageURL: String
    let imageName, tabCategory, fabricLength: String
    enum CodingKeys: String, CodingKey {
        case id
        case imageURL = "imageUrl"
        case imageName, tabCategory, fabricLength
    }
}
