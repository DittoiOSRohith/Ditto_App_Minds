//
//  CommonConstants.swift
//  Ditto
//
//  Created by Abiya Joy on 23/03/22.
//  Copyright © 2022 Infosys. All rights reserved.
//

import Foundation

enum CommonConst {
    static let userDefault = UserDefaults.standard
    static let serviceConnected = "serviceConnected"
    static let accessToken = "access_token"
    static let lastConnectedProjector = "last_Connected_Projector"
    static let connectedHost = "connectedHost"
    static let connectedPort = "connectedPort"
    static let subscribedStartDate = "c_subscriptionPlanStartDate"
    static let subscribedEndDate = "c_subscriptionPlanEndDate"
    static let subscriptionValid = "c_subscriptionValid"
    static let subscriptionStatus = "c_subscriptionStatus"
    static let firstName = "FIRST_NAME"
    static let lastName = "last_name"
    static let loginEmail = "login_email"
    static let loginPhone = "phone_home"
    static let guestUser = "guestUser"
    static let customerID = "CUST_ID"
    static let customerCareEmail = "customerCareEmail"
    static let customerCareePhone = "customerCareePhone"
    static let customerCareeTiming = "customerCareeTiming"
    static let demoVideoURL = "demoVideoURL"
    static let navCheck = "Nav"
    static let bleCheck = "Ble"
    static let mirrorReminder = "c_mirrorReminder"
    static let cuttingReminder = "c_cuttingReminder"
    static let spliceReminder = "c_spliceReminder"
    static let spliceMultiplePieceReminder = "c_spliceMultiplePieceReminder"
    static let saveCalibPhotoReminder = "c_saveCalibrationPhotos"
    static let isworkspaceadded = "isWorkspaceAdded"
    static let SelectedFilterObjectss = "SelectedFilterObjectss"
    static let SelectedFilters = "SelectedFilters"
    static let SelectedFilterIndices = "SelectedFilterIndices"
    static let showCoachMark = "ShowCoachMark"
    static let coackmarkCompleteStatus = "CoachMarkCompleteStatus"
    static let isTrialDownloaded = "isTrailDownloaded"
    static let currentIndexPath = "currentIndexPath"
    static let isFromInstructionbBack = "isFromInstructionbBack"
    static let intructionBack = "intructionBack"
    static let selectedTabGarment = "selectedTabGarment"
    static let selectedTabLining = "selectedTabLining"
    static let selectedTabInterfacing = "selectedTabInterfacing"
    static let selectedTabOther = "selectedTabOther"
    static let showCThumbnailAnimation = "ShowCThumbnailAnimation"
    static let animationCompleteStatus = "AnimationCompleteStatus"
    static let hasLaunchedOnce = "HasLaunchedOnce"
    static let isInstructionSaved = "isInstructionSaved"
    static let trackingId = "trackingId"
    static let bmTokenURL = "tokenUrl"
    static let siteURL = "siteUrl"
    static let server = "server"
    static let clientKeyServerAut = "clientKeyServerAut"
    static let siteId = "siteId"
    static let baseUrl = "base_url"
    static let isProd = "isProd"
    static let patternCount = "patternCount"
    static let versionAlert = "versionAlert"
    static let savedNetworkStatus = "savedNetworkStatus"
    static let appUpdatedStatus = "AppUpdatedStatus"
    static let customerNo = "cust_no"
    static let offlineDesignId = "offiline_design_id"
    static let linkTailornovaId = "UniversalLink_Tailornova_did"
    static let trailPatternDesignName = "trailPatternDesignName"
    static let allWorkerPatterns = "allWorkerPatterns"
    static let ocAuthToken = "OCAuthToken"
    static let secretKey = "secret_Key"
    
    static var accessTokenText: String {
        get {
            return CommonConst.userDefault.value(forKey: CommonConst.accessToken) as? String ?? FormatsString.emptyString
        } set {
            CommonConst.userDefault.setValue(newValue, forKey: CommonConst.accessToken)
        }
    }
    static var serviceConnectedCheck: Bool {
        get {
            return CommonConst.userDefault.value(forKey: CommonConst.serviceConnected) as? Bool ?? false
        } set {
            CommonConst.userDefault.setValue(newValue, forKey: CommonConst.serviceConnected)
        }
    }
    static var animationCompleteStatusCheck: Bool {
        get {
            return CommonConst.userDefault.value(forKey: CommonConst.animationCompleteStatus) as? Bool ?? false
        } set {
            CommonConst.userDefault.setValue(newValue, forKey: CommonConst.animationCompleteStatus)
        }
    }
    static var showCThumbnailAnimationCheck: Bool {
        get {
            return CommonConst.userDefault.value(forKey: CommonConst.showCThumbnailAnimation) as? Bool ?? false
        } set {
            CommonConst.userDefault.setValue(newValue, forKey: CommonConst.showCThumbnailAnimation)
        }
    }
    static var coackmarkCompleteStatusCheck: Bool {
        get {
            return CommonConst.userDefault.value(forKey: CommonConst.coackmarkCompleteStatus) as? Bool ?? false
        } set {
            CommonConst.userDefault.setValue(newValue, forKey: CommonConst.coackmarkCompleteStatus)
        }
    }
    static var showCoachMarkCheck: Bool {
        get {
            return CommonConst.userDefault.value(forKey: CommonConst.showCoachMark) as? Bool ?? false
        } set {
            CommonConst.userDefault.setValue(newValue, forKey: CommonConst.showCoachMark)
        }
    }
    static var bleCheckValue: Bool {
        get {
            return CommonConst.userDefault.value(forKey: CommonConst.bleCheck) as? Bool ?? false
        } set {
            CommonConst.userDefault.setValue(newValue, forKey: CommonConst.bleCheck)
        }
    }
    static var isInstructionSavedCheck: Bool {
        get {
            return CommonConst.userDefault.value(forKey: CommonConst.isInstructionSaved) as? Bool ?? false
        } set {
            CommonConst.userDefault.setValue(newValue, forKey: CommonConst.isInstructionSaved)
        }
    }
    static var linkTailornovaIdText: String {
        get {
            return CommonConst.userDefault.value(forKey: CommonConst.linkTailornovaId) as? String ?? FormatsString.emptyString
        } set {
            CommonConst.userDefault.setValue(newValue, forKey: CommonConst.linkTailornovaId)
        }
    }
    static var offlineDesignIdText: String {
        get {
            return CommonConst.userDefault.value(forKey: CommonConst.offlineDesignId) as? String ?? FormatsString.emptyString
        } set {
            CommonConst.userDefault.setValue(newValue, forKey: CommonConst.offlineDesignId)
        }
    }
    static var customerNoText: String {
        get {
            return CommonConst.userDefault.value(forKey: CommonConst.customerNo) as? String ?? FormatsString.emptyString
        } set {
            CommonConst.userDefault.setValue(newValue, forKey: CommonConst.customerNo)
        }
    }
    static var appUpdatedStatusCheck: Bool {
        get {
            return CommonConst.userDefault.value(forKey: CommonConst.appUpdatedStatus) as? Bool ?? false
        } set {
            CommonConst.userDefault.setValue(newValue, forKey: CommonConst.appUpdatedStatus)
        }
    }
    static var savedNetworkStatusCheck: Bool {
        get {
            return CommonConst.userDefault.value(forKey: CommonConst.savedNetworkStatus) as? Bool ?? false
        } set {
            CommonConst.userDefault.setValue(newValue, forKey: CommonConst.savedNetworkStatus)
        }
    }
    static var versionAlertStatusOnLaunch: Bool {
        get {
            return CommonConst.userDefault.value(forKey: CommonConst.versionAlert) as? Bool ?? false
        } set {
            CommonConst.userDefault.setValue(newValue, forKey: CommonConst.versionAlert)
        }
    }
    static var myLibPatternCount: String {
        get {
            return CommonConst.userDefault.value(forKey: CommonConst.patternCount) as? String ?? FormatsString.emptyString
        } set {
            CommonConst.userDefault.setValue(newValue, forKey: CommonConst.patternCount)
        }
    }
    static var isProdCheck: Bool {
        get {
            return CommonConst.userDefault.value(forKey: CommonConst.isProd) as? Bool ?? false
        } set {
            CommonConst.userDefault.setValue(newValue, forKey: CommonConst.isProd)
        }
    }
    static var baseUrlConstant: String {
        get {
            return CommonConst.userDefault.value(forKey: CommonConst.baseUrl) as? String ?? FormatsString.emptyString
        } set {
            CommonConst.userDefault.setValue(newValue, forKey: CommonConst.baseUrl)
        }
    }
    static var siteIdConstant: String {
        get {
            return CommonConst.userDefault.value(forKey: CommonConst.siteId) as? String ?? FormatsString.emptyString
        } set {
            CommonConst.userDefault.setValue(newValue, forKey: CommonConst.siteId)
        }
    }
    static var clientKeyServerAutConstant: String {
        get {
            return CommonConst.userDefault.value(forKey: CommonConst.clientKeyServerAut) as? String ?? FormatsString.emptyString
        } set {
            CommonConst.userDefault.setValue(newValue, forKey: CommonConst.clientKeyServerAut)
        }
    }
    static var serverConstant: String {
        get {
            return CommonConst.userDefault.value(forKey: CommonConst.server) as? String ?? FormatsString.emptyString
        } set {
            CommonConst.userDefault.setValue(newValue, forKey: CommonConst.server)
        }
    }
    static var siteURLConstant: String {
        get {
            return CommonConst.userDefault.value(forKey: CommonConst.siteURL) as? String ?? FormatsString.emptyString
        } set {
            CommonConst.userDefault.setValue(newValue, forKey: CommonConst.siteURL)
        }
    }
    static var bmTokenURLConstant: String {
        get {
            return CommonConst.userDefault.value(forKey: CommonConst.bmTokenURL) as? String ?? FormatsString.emptyString
        } set {
            CommonConst.userDefault.setValue(newValue, forKey: CommonConst.bmTokenURL)
        }
    }
    static var trackingIdConstant: String {
        get {
            return CommonConst.userDefault.value(forKey: CommonConst.trackingId) as? String ?? FormatsString.emptyString
        } set {
            CommonConst.userDefault.setValue(newValue, forKey: CommonConst.trackingId)
        }
    }
    static var lastConnectedProjectorName: Any {
        get {
            return CommonConst.userDefault.value(forKey: CommonConst.lastConnectedProjector) ?? FormatsString.emptyString
        } set {
            CommonConst.userDefault.setValue(newValue, forKey: CommonConst.lastConnectedProjector)
        }
    }
    static var connectHost: Any {
        get {
            return CommonConst.userDefault.value(forKey: CommonConst.connectedHost) ?? FormatsString.emptyString
        } set {
            CommonConst.userDefault.setValue(newValue, forKey: CommonConst.connectedHost)
        }
    }
    static var connectPort: Any {
        get {
            return CommonConst.userDefault.value(forKey: CommonConst.connectedPort) ?? FormatsString.emptyString
        } set {
            CommonConst.userDefault.setValue(newValue, forKey: CommonConst.connectedPort)
        }
    }
    static func saveObjectForKey(value: Any, key: String) {
        CommonConst.userDefault.setValue(value, forKey: key)
    }
    static func getObjectFromKey(key: String) -> Any {
        return CommonConst.userDefault.value(forKey: key) ?? FormatsString.emptyString
    }
    static func removeObjectFromKey(key: String) {
        CommonConst.userDefault.removeObject(forKey: key)
    }
    static var subscribeEndDate: String {
        get {
            return CommonConst.userDefault.value(forKey: CommonConst.subscribedEndDate) as? String ?? FormatsString.emptyString
        } set {
            CommonConst.userDefault.setValue(newValue, forKey: CommonConst.subscribedEndDate)
        }
    }
    static var subscribeValid: Bool {
        get {
            return CommonConst.userDefault.value(forKey: CommonConst.subscriptionValid) as? Bool ?? false
        } set {
            CommonConst.userDefault.setValue(newValue, forKey: CommonConst.subscriptionValid)
        }
    }
    static var firstNameValue: String {
        get {
            return CommonConst.userDefault.value(forKey: CommonConst.firstName) as? String ?? FormatsString.emptyString
        } set {
            CommonConst.userDefault.setValue(newValue, forKey: CommonConst.firstName)
        }
    }
    static var lastNameValue: String {
        get {
            return CommonConst.userDefault.value(forKey: CommonConst.lastName) as? String ?? FormatsString.emptyString
        } set {
            CommonConst.userDefault.setValue(newValue, forKey: CommonConst.lastName)
        }
    }
    static var loginEmailText: String {
        get {
            return CommonConst.userDefault.value(forKey: CommonConst.loginEmail) as? String ?? FormatsString.emptyString
        } set {
            CommonConst.userDefault.setValue(newValue, forKey: CommonConst.loginEmail)
        }
    }
    static var loginPhoneText: String {
        get {
            return CommonConst.userDefault.value(forKey: CommonConst.loginPhone) as? String ?? FormatsString.emptyString
        } set {
            CommonConst.userDefault.setValue(newValue, forKey: CommonConst.loginPhone)
        }
    }
    static var customerIDText: String {
        get {
            return CommonConst.userDefault.value(forKey: CommonConst.customerID) as? String ?? FormatsString.emptyString
        } set {
            CommonConst.userDefault.setValue(newValue, forKey: CommonConst.customerID)
        }
    }
    static var customerCareEmailText: String {
        get {
            return CommonConst.userDefault.value(forKey: CommonConst.customerCareEmail) as? String ?? FormatsString.emptyString
        }
        set {
            CommonConst.userDefault.setValue(newValue, forKey: CommonConst.customerCareEmail)
        }
    }
    static var customerCareePhoneText: String {
        get {
            return CommonConst.userDefault.value(forKey: CommonConst.customerCareePhone) as? String ?? FormatsString.emptyString
        }
        set {
            CommonConst.userDefault.setValue(newValue, forKey: CommonConst.customerCareePhone)
        }
    }
    static var customerCareeTimingText: String {
        get {
            return CommonConst.userDefault.value(forKey: CommonConst.customerCareeTiming) as? String ?? FormatsString.emptyString
        }
        set {
            CommonConst.userDefault.setValue(newValue, forKey: CommonConst.customerCareeTiming)
        }
    }
    static var subscriptionStatusText: String {
        get {
            return CommonConst.userDefault.value(forKey: CommonConst.subscriptionStatus) as? String ?? FormatsString.emptyString
        }
        set {
            CommonConst.userDefault.setValue(newValue, forKey: CommonConst.subscriptionStatus)
        }
    }
    static var guestUserCheck: Bool {
        get {
            return CommonConst.userDefault.value(forKey: CommonConst.guestUser) as? Bool ?? false
        } set {
            CommonConst.userDefault.setValue(newValue, forKey: CommonConst.guestUser)
        }
    }
    static var demoVideoURLText: String {
        get {
            return CommonConst.userDefault.value(forKey: CommonConst.demoVideoURL) as? String ?? FormatsString.emptyString
        }
        set {
            CommonConst.userDefault.setValue(newValue, forKey: CommonConst.demoVideoURL)
        }
    }
    static var navCheckValue: Int {
        get {
            return CommonConst.userDefault.value(forKey: CommonConst.navCheck) as? Int ?? 0
        } set {
            CommonConst.userDefault.setValue(newValue, forKey: CommonConst.navCheck)
        }
    }
    static var mirrorReminderCheck: Bool {
        get {
            return CommonConst.userDefault.value(forKey: CommonConst.mirrorReminder) as? Bool ?? false
        } set {
            CommonConst.userDefault.setValue(newValue, forKey: CommonConst.mirrorReminder)
        }
    }
    static var cuttingReminderCheck: Bool {
        get {
            return CommonConst.userDefault.value(forKey: CommonConst.cuttingReminder) as? Bool ?? false
        } set {
            CommonConst.userDefault.setValue(newValue, forKey: CommonConst.cuttingReminder)
        }
    }
    static var spliceReminderCheck: Bool {
        get {
            return CommonConst.userDefault.value(forKey: CommonConst.spliceReminder) as? Bool ?? false
        } set {
            CommonConst.userDefault.setValue(newValue, forKey: CommonConst.spliceReminder)
        }
    }
    static var spliceMultiplePieceReminderCheck: Bool {
        get {
            return CommonConst.userDefault.value(forKey: CommonConst.spliceMultiplePieceReminder) as? Bool ?? false
        } set {
            CommonConst.userDefault.setValue(newValue, forKey: CommonConst.spliceMultiplePieceReminder)
        }
    }
    static var saveCalibPhotoReminderCheck: Bool {
        get {
            return CommonConst.userDefault.value(forKey: CommonConst.saveCalibPhotoReminder) as? Bool ?? false
        } set {
            CommonConst.userDefault.setValue(newValue, forKey: CommonConst.saveCalibPhotoReminder)
        }
    }
    static var currentIndexPathCheck: Int {
        get {
            return CommonConst.userDefault.value(forKey: CommonConst.currentIndexPath) as? Int ?? 0
        } set {
            CommonConst.userDefault.setValue(newValue, forKey: CommonConst.currentIndexPath)
        }
    }
    static var isFromInstructionbBackCheck: Bool {
        get {
            return CommonConst.userDefault.value(forKey: CommonConst.isFromInstructionbBack) as? Bool ?? false
        } set {
            CommonConst.userDefault.setValue(newValue, forKey: CommonConst.isFromInstructionbBack)
        }
    }
    static var intructionBackCheck: Bool {
        get {
            return CommonConst.userDefault.value(forKey: CommonConst.intructionBack) as? Bool ?? false
        } set {
            CommonConst.userDefault.setValue(newValue, forKey: CommonConst.intructionBack)
        }
    }
    static var selectedTabGarmentValue: Bool {
        get {
            return CommonConst.userDefault.value(forKey: CommonConst.selectedTabGarment) as? Bool ?? false
        } set {
            CommonConst.userDefault.setValue(newValue, forKey: CommonConst.selectedTabGarment)
        }
    }
    static var selectedTabLiningValue: Bool {
        get {
            return CommonConst.userDefault.value(forKey: CommonConst.selectedTabLining) as? Bool ?? false
        } set {
            CommonConst.userDefault.setValue(newValue, forKey: CommonConst.selectedTabLining)
        }
    }
    static var selectedTabInterfacingValue: Bool {
        get {
            return CommonConst.userDefault.value(forKey: CommonConst.selectedTabInterfacing) as? Bool ?? false
        } set {
            CommonConst.userDefault.setValue(newValue, forKey: CommonConst.selectedTabInterfacing)
        }
    }
    static var selectedTabOtherValue: Bool {
        get {
            return CommonConst.userDefault.value(forKey: CommonConst.selectedTabOther) as? Bool ?? false
        } set {
            CommonConst.userDefault.setValue(newValue, forKey: CommonConst.selectedTabOther)
        }
    }
}
