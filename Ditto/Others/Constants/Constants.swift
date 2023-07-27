//
//  Constants.swift
//  WorkBench
//
//  Created by Infosys on 27/09/19.
//  Copyright © 2019 Infosys. All rights reserved.
//

import UIKit
func getYoutubeId(youtubeUrl: String) -> String? {
    return URLComponents(string: youtubeUrl)?.queryItems?.first(where: { $0.name == "v" })?.value
}

enum AppInfo {
    // OLD
    static let mode = "development"
    static let appName = Bundle.main.infoDictionary![kCFBundleNameKey as String] as? String ?? FormatsString.emptyString
    static let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? FormatsString.emptyString
//    static let userAgent = "\(mode)/\(appName)/\(version)"
    // CURRENT
    static let buildNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? FormatsString.emptyString
    static let versionNumber = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? FormatsString.emptyString
    static let versionIN = "Version \(versionNumber)"
    static let userAgent = "JOANN/\(versionNumber)" + " CFNetwork/\(Proxy.shared.CFNetworkVersion()) Darwin/\(Proxy.shared.DarwinVersion())"
}
enum AppKeys {
    static let siteId = CommonConst.siteIdConstant
    static let clientKeyServerAuth = CommonConst.clientKeyServerAutConstant
    static let server = CommonConst.serverConstant
    static let accessKeyId = "IOS\(AppInfo.version)"
    static let timestamp = "\(Int(Date().timeIntervalSince1970))"
    static let appCenterKey = "ea4a6e3d-31e8-40a0-b570-f49b45105e42"  // "80a2f370-87c6-4903-ae04-1fd7a6aee842"
    static let trackingId = "\(CommonConst.trackingIdConstant)"
}
enum DeviceInfo {
    static let deviceName = UIDevice.current.name
    static let screenBound = UIScreen.main.bounds
    static let deviceHeight = UIScreen.main.bounds.height
    static let deviceWidth = UIScreen.main.bounds.width
}
enum SpliceConstant: Int {
    case spliceRight = 1003
    case spliceLeft = 1004
    case spliceTop = 1001
    case spliceBottom = 1002
}
enum StorageType {
    case userDefaults
    case fileSystem
}
enum CustomColor {
    static let activityBG = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
    static let lightGreyLine =  UIColor(red: 0.85, green: 0.83, blue: 0.83, alpha: 1.00)
    static let red = UIColor(red: 0.68, green: 0.13, blue: 0.10, alpha: 1.00)
    static let signIn = UIColor(red: 0.02, green: 0.24, blue: 0.95, alpha: 1.00)
    static let textFieldBorder =  UIColor(red: 0.44, green: 0.44, blue: 0.44, alpha: 1.00)
    static let ownedLabel = UIColor(red: 0.81, green: 0.63, blue: 0.04, alpha: 1.00)
    static let activeLabel = UIColor(red: 0.64, green: 0.13, blue: 0.12, alpha: 1.00)
    static let activeProjectorButtonBG = UIColor(rgb: 0xAD201A) // TRAC_564
    static let disabledProjectorButtonBG = UIColor(rgb: 0x656565) // TRAC_564
    static let patternSelectedBGColor = UIColor(red: 103/255.0, green: 118/255.0, blue: 137/255.0, alpha: 0.10)
    static let redCustom = UIColor(red: 164/255.0, green: 33/255.0, blue: 31/255.0, alpha: 1.0)
    static let lightGrayColor = UIColor(rgb: 0xCBCBCB)
    static let darkGrayColor = UIColor(rgb: 0xA8A7A8)
    static let whitishGrayColor = UIColor(rgb: 0xF5F5F5)
    static let lightblackColor = UIColor(red: 0.933, green: 0.933, blue: 0.933, alpha: 1)
    static let wsReferenceGrayColor = UIColor(red: 231/255, green: 231/255, blue: 231/255, alpha: 1.0)
    static let tutorialGrayColor = UIColor(red: 186/225, green: 186/225, blue: 186/225, alpha: 1)
    static let spliceEnableColor = UIColor(red: 0.958, green: 0.958, blue: 0.958, alpha: 1)
}
enum CustomFont { // TRAC_506_LANDINGUX
    static func avenirLtProBold(size: CGFloat) -> UIFont! {
        return UIFont(name: "AvenirNextLTPro-Bold", size: size)
    }
    static func avenirLtProRegular(size: CGFloat) -> UIFont! {
        return  UIFont(name: "AvenirNextLTPro-Regular", size: size)
    }
    static func avenirLtProDemi(size: CGFloat) -> UIFont! {
        return UIFont(name: "AvenirNextLTPro-Demi", size: size)
    }
    static func avenirLtProMedium(size: CGFloat) -> UIFont! {
        return UIFont(name: "AvenirNextLTPro-Medium", size: size)
    }
}

let lastSessionInitated = "Last session Initiated time:"
let alamofirerequestTimeOut: Double = 120
let numberOfQuickNotesWords: Int = 500
enum WSSaveApi {
    case create
    case patch
}
enum WorkAreaTabCategory: Int {
   case garment = 0, lining, interfacing, other
    var categoryName: String {
        switch self {
        case .garment:
            return "Garment"
        case .lining:
            return "Lining"
        case .interfacing:
            return "Interfacing"
        case .other:
            return "Other"
        }
    }
}
enum AppColor {
    static let scissorGreyLight = #colorLiteral(red: 0.8736502528, green: 0.856621325, blue: 0.8340338469, alpha: 1)
    static let bgScissorGreyLight = #colorLiteral(red: 0.9568627451, green: 0.9490196078, blue: 0.9450980392, alpha: 1)
    static let safetyPinYellow = #colorLiteral(red: 0.9882352941, green: 0.8901960784, blue: 0, alpha: 1)
    static let needleGrey = #colorLiteral(red: 0.1137254902, green: 0.1215686275, blue: 0.1647058824, alpha: 1)
}
enum TagValue {
    static let pageControlTag = 101
    static let scrollTag = 123
    static let lottieTag = 1993
    static let cameraButtonTag = 1001
    static let cameraBackTag = 1002
    static let instructionTag = 1003
    static let previewImageTag = 1007
    static let retakeTag = 1008
    static let submitTag = 1009
    static let previewPopupTag = 1010
}

enum DBEntities {
    static let pattenDb = "Pattern"
    static let workspaceDb = "Workspace"
    static let userDb = "User"
    static let instructionDb = "Instruction"
}
