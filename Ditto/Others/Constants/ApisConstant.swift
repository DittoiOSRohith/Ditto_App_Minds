//
//  ApisConstant.swift
//  Ditto
//
//  Created by Gaurav Rajan on 27/04/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import Foundation

enum  Apis {
    static let signUp = "\(CommonConst.baseUrlConstant)/on/demandware.store/Sites-ditto-Site/default/Login-Show"
    static let seeMore = "https://storage.googleapis.com/exoplayer-test-media-0/BigBuckBunny_320x180.mp4"
    static let renewSubscription = "\(CommonConst.baseUrlConstant)/on/demandware.store/Sites-ditto-Site/default/Recurly-GetSubscriptionPlan"
    static let forgotPassword = "\(CommonConst.baseUrlConstant)/on/demandware.store/Sites-ditto-Site/default/Account-PasswordReset"
    static let baseUrl = "\(CommonConst.baseUrlConstant)/s/ditto/dw/shop/v19_1/"
    static let baseUrl2 = "\(CommonConst.baseUrlConstant)/"
    static let joannSite = "https://www.joann.com/ditto"
    static let BMTokenURL = "\(CommonConst.bmTokenURLConstant)"
    static let authLogin = "customers/auth?client_id=\(AppKeys.clientKeyServerAuth)"
    static let MyLibraryURL = "\(CommonConst.baseUrlConstant)/on/demandware.store/Sites-ditto-Site/default/TraceAppMyLibrary-Shows"
    static let PatternDescURL = "https://splicing.tailornova.com/api/v1/patterns/demo-design-id-png?os=IOS"
    // static let authLogin = "s/JoAnn/dw/shop/v19_1/customers/auth?client_id=\(AppKeys.clientKeyServerAuth)"
    // static let landingContent = "content/LandingContent?client_id=\(AppKeys.clientKeyServerAuth)"
    // MARK: - Folder API
    static let createUpdateFolderURL = "\(CommonConst.baseUrlConstant)/on/demandware.store/Sites-ditto-Site/default/TraceAppLibraryFolder-Modify?method=update"
    static let getFolderURL = "\(CommonConst.baseUrlConstant)/on/demandware.store/Sites-ditto-Site/default/TraceAppLibraryFolder-Modify?method=getFolders"
    static let onClickFolderURL =
        "\(CommonConst.baseUrlConstant)/on/demandware.store/Sites-ditto-Site/default/TraceAppMyLibrary-Shows"
    static let renameFolderURL = "\(CommonConst.baseUrlConstant)/on/demandware.store/Sites-ditto-Site/default/TraceAppLibraryFolder-Modify?method=rename"
    static let updateFavouriteURL = "\(CommonConst.baseUrlConstant)/on/demandware.store/Sites-ditto-Site/default/TraceAppLibraryFolder-Modify?method="
    static let removeFoldeURL =
        "\(CommonConst.baseUrlConstant)/on/demandware.store/Sites-ditto-Site/default/TraceAppLibraryFolder-Modify?method=remove"
    // MARK: - WorkSpace Apis
    static let getCOWorkSpace = "s/ditto/dw/shop/v19_1/custom_objects/traceWorkSpace/"
    static let createCOWorkSpace = "s/-/dw/data/v19_1/custom_objects/traceWorkSpace/"
    static let updateCOWorkSpace = "s/-/dw/data/v19_1/custom_objects/traceWorkSpace/"
    // MARK: - Account Deletion Api
    static let deleteAccount = "s/-/dw/data/v19_1/customer_lists/ditto/customers/"
    // MARK: - 3P Pattern URL
    static let thirdPartyPatternURL = "\(CommonConst.baseUrlConstant)/on/demandware.store/Sites-ditto-Site/default/TraceAppThirdParty-Shows"
}
enum ApiUrlStrings {
    static let loginApiUrl = "customers/auth?client_id="
    static let landingScreenUrl = "content/LandingContent?client_id="
    static let tailornovaApiOne = "https://ditto-splicing.tailornova.com/api/v1/patterns/"
    static let tailornovaApiTwo = "?os=IOS&mannequinId="
    static let trialApiURL = "https://ditto-splicing.tailornova.com/api/v1/patterns/IOS/trial"
    static let getWSUrl = "?client_id=\(AppKeys.clientKeyServerAuth)"
    static let updateWSUrl = "?method=PATCH&client_id=\(AppKeys.clientKeyServerAuth)&site_id=\(AppKeys.siteId)"
    static let createWSUrl = "?client_id=\(AppKeys.clientKeyServerAuth)&site_id=\(AppKeys.siteId)"
    static let signatureURL = "v=\(AppInfo.version)&o=ios&AccessKeyId=\(AppKeys.accessKeyId)\("&Timestamp=")\(AppKeys.timestamp)&Connect=\(AppKeys.server)"
    static let getBMTokenURLfirst = "\(Apis.BMTokenURL)\("/ditto/session?v=\(AppInfo.version)&o=ios&AccessKeyId=")\(AppKeys.accessKeyId)\("&Timestamp=")\(AppKeys.timestamp)\("&Signature=")"
    static let versionURLfirst = "\(Apis.BMTokenURL)/ditto/version?v=\(AppInfo.version)&o=ios&AccessKeyId=\(AppKeys.accessKeyId)\("&Timestamp=")\(AppKeys.timestamp)\("&Signature=")"
    static let getBMTokenURLlast = "&Connect=\(AppKeys.server)"
    static let wsSettingsURL = "customers/\(CommonConst.customerIDText)?client_id=\(AppKeys.clientKeyServerAuth)"
    static let aboutAppURL = "\(Apis.baseUrl)content/privacy-policy?client_id=\(AppKeys.clientKeyServerAuth)"
    static let faqDataURL = "content/hamburgerAsset?client_id=\(AppKeys.clientKeyServerAuth)"
    static let emailOpenURL = "mailto:\(CommonConst.customerCareEmailText)"
    static let callDialerOpenURL = "tel://\(CommonConst.customerCareePhoneText.components(separatedBy: CharacterSet.decimalDigits.inverted).joined())"
    static let animationVideoUrl = "https://youtu.be/IH1ZNEE_bwc"
    static let getStartedURL = "content/tutorial?client_id="
    static let filterUrl = "on/demandware.store/Sites-JoAnn-Site/default/TraceAppMyLibrary-Shows"
}
enum EnvChanges {
    static let dittoBaseUrl = "https://www.dittopatterns.com"
    static let devBaseUrl = "https://development.dittopatterns.com"
    static let dev11BaseUrl = "https://dev11-na03-joann.demandware.net"
    static let siteId = "ditto"
    static let dev11siteId = "JoAnn"
    static let dittoClientKey = "7734380a-c2b8-471d-b813-377aee89e4ec"
    static let devClientKey = "59eb4dd9-026d-4bac-adb5-2e5848d91263"
    static let dev11ClientKey = "aaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"
    static let dittoServer = "production"
    static let devServer = "dev"
    static let dev11Server = "staging"
    static let dittoSiteUrl = "https://www.dittopatterns.com"
    static let devSiteUrl = "https://development.dittopatterns.com"
    static let dev11SiteUrl = "https://dev11-na03-joann.demandware.net/on/demandware.store/Sites-ditto-Site/default/Home-Show/"
    static let dittoTokenUrl = "https://www.handmadewithjoann.com"
    static let devTokenUrl = "https://staging.handmadewithjoann.com"
    static let dev11TokenUrl = "https://staging.handmadewithjoann.com"
    static let dittoTrackingId = "5goxe48xLwY0yJeTPr7CUs3xcQmQdGWB"
    static let devTrackingId = "ZGl0dG9pb3M="
}
struct ApiResponse {
    var success: Bool
    var jsonData: Data?
    var data: [String: AnyObject]?
    var message: String?
}
