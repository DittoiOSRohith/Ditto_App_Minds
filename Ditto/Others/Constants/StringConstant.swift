//
//  StringConstant.swift
//  Ditto
//
//  Created by Gaurav Rajan on 27/04/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import Foundation

enum TutorialDataFetchType {
    static let beamSetup      =       "Beam Setup & Take Down"
    static let calibration    =       "Calibration"
    static let howTo          =       "How-To Videos"
    static let connectivity   =       "Connectivity"
}
enum CalibrationMessages {
    static let calibrationConfirmation = "Do you need to calibrate?"
    static let calibrationConfTitle = "Calibrate"
    static let calibrationSuccess = "Calibration success!"
    static let calibrationScreenConfirmation = "Calibration_Confirmation"
}
enum IsInPage: String {
    case patternDesc = "PatternDesc"
    case myLibrary = "MyLibrary"
}
enum ReferenceLayoutType {
    static let fourtyfive = "45"
    static let sixty = "60"
    static let twenty = "20"
    static let napLabel = "w/NAP"
}
enum CalibrationMessage {
    static let complete = "Does projected image line up with the features on calibration pattern?"
    static let notFilling = "Projector is not filling the calibration pattern"
    static let tooHigh = "Projector is too high"
}
enum WifiConnectionStatus: String {
    case connectionUnsuccessfull            =           "connection_failed"
    case traceBLEConnected                  =           "TRACEbleConnected"
    case serviceSuccess                     =           "SERVICESUCCESS"
    case traceFailed                        =            "TRACEFailed"
    case traceFailedWiFi                    =           "TRACEFailedWifi"
    case projectorConnectionSuccess         =           "Successfully connected"
    case showCalibPopAfterConnectionSuccess =           "showCalibPopUp" // TRAC_564
}
enum FromScreenType: String {
    case getStartedd = "getStarted"
    case calibrationn = "calibration"
}
enum  WorkspaceScreenType: String {
    case fromAllPatterns = "AllPatterns"
    case fromActive = "Active"
    case fromCompleted = "Completed"
}
struct ProjectorDetails {
    static var Host = String()
    static var port = Int32()
    static var projectorName = String() // TRAC_601
    static var isLastConnected = Bool()
    static var isProjectorConnected: Bool = false
    static var isCalibrated: Bool  = false // forAnimation
    static var isUserCalibrated: Bool  = false // forUserSelectedpopup
    static var showCalibratePopUp: Bool = false
}
enum ConnectivityUtils { // TRAC_564
    static let jsonLoader = "ditto_loader"
    static let spliceArrow = "arrow"
    static let successImage = "successTickImage" // TRAC_601
    static let failedImage = "connectionFailImage" // TRAC_601
    static let connectBtnLoader = "connect2"
}
enum ConnectivityMessages { // TRAC_564
    static let wiFiConnectionSuccess = "Successfully connected!"
    static let wiFiConnectionFailed = "WiFi Connection failed"
    static let projectorConnectionFailed = "Projector Connection failed "
    static let bleConnectionFailed = "Bluetooth Connection failed"
    static let connectionFailed = "Connection failed" // TRAC_601
    static let connectivityUnsuccessful = "Connectivity Unsuccessful"
    static let tryAgain = "Please try again connecting your device again to ditto projector."
    static let enterWifiCred = "Ditto projector found!"
    static let wifiPopUpTitle = "Wi-Fi Connectivity"
    static let titleConnectivity = "Connectivity"
    static let needBLEDescription = "This app needs Bluetooth connectivity"
    static let needWiFiDescription = "This app needs WiFi connectivity"
    static let needProjectorSwitch = "Do you want to switch the projector?" // TRAC_601
    static let UpdateProjectorSwitch = "A new version of projector is available, would you like to upgrade ? New features : Fixed the connection issues , updated the projection features " // TRAC_601

}
//  *** TRIAL PATTERNS REMOVED IN PRODUCTION AS PER CLIENT FEEDBACK, FOR THAT allQuery IS KEPT AS FALSE AND OTHER PARAMS ARE CHANGED*//
enum MyLibraryAttribute {
    static var purchasedPattern: Bool = true
    static var subscriptionList: Bool = true
    static var allQuery: Bool = false
    static var trialPattern: Bool = false
}
enum FolderAttribute {
    static var purchasedPattern: Bool = false
    static var subscriptionList: Bool = false
    static var allQuery: Bool = false
    static var trialPattern: Bool = false
}
enum OnClickFolderAttribute {
    static var purchasedPattern: Bool = true
    static var subscriptionList: Bool = true
    static var allQuery: Bool = false
    static var OwnedallQuery: Bool = true
    static var trialPattern: Bool = false
}
enum FavFolderAttribute {
    static var purchasedPattern: Bool = true
    static var subscriptionList: Bool = true
    static var allQuery: Bool = false
    static var trialPattern: Bool = false
}
enum AttributeType: String {
    case myLibrary = "MyLibrary"
    case folder = "Folder"
    case sync = "Sync"
    case search = "Search"
    case onClickFolder = "OnClickFolder"
    case favFolder = "FavFolder"
}
//Rohith
    //Some formating strings created
enum FormatsString {
    static let dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    static let dateFormatTwo = "E MMM d HH:mm:ss Z yyyy"
    static let dateFormatThree = "dd-MM-yyyy HH:mm a"
    static let passwordCharacterSetLabel = "^(?=.*)[A-Za-z\\d$@$#!%*?&]{6,}"
    static let emailFormatString = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
    static let authHeaderKey = "Authorization"
    static let contentHeaderKey = "Content-Type"
    static let acceptKey = "Accept"
    static let contentKeyValue = "application/json"
    static let bearerTokenKey = "Bearer "
    static let basicTokenKey = "Basic "
    static let userAgentKey = "User-Agent"
    static let xapiKey = "X-Api-Key"
    static let xapiKeyValue = "FA872702-6396-45DC-89F0-FC1BE900591B"
    static let DittoPatterns = "DittoPatterns"
    static let daysLeftLabel = " days left"
    static let daysLabel = " days."
    static let newFolderLabel = "New folder"
    static let attributedStringLabel = "ATTRIBUTEDSTRING"
    static let tracingLabel = "TRACING"
    static let emptyString = ""
    static let appSettings = "App-prefs:Settings"
    static let bluetoothLabel = "Bluetooth"
    static let NetworkStatus = "NetworkStatus"
    static let disconnectLabel = "Disconnect"
    static let connectLabel = "Connect"
    static let defaultYoutubeID = "Jli6Sqm-2DU"
    static let youtubeIDPattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
    static let projectorFoundLabel = " projectors found"
    static let manageProjectorLabel = "Manage Projector"

    static let workspaceSettingsLabel = "Workspace Settings"
    static let customerSupportLabel = "Customer Support"
    static let faqGlossaryLabel = "FAQs, Tips & Glossary"
    static let aboutAppLabel = "About the App & Policies"
    static let softwareUpdateLabel = "Software Updates"
    static let referenceLayoutLabel = "Reference Layout"
    static let settingsLabel = "Settings"
    static let accountInfoLabel = "Account Info"
    static let subscriptionInfoLabel = "Subscription Info"
    static let faqMenuLabel = "FAQs & Glossary"
    static let updateProjectorLabel = "Update Projector"

    static let customerServiceLabel = "Customer Service"
    static let mirroringReminderLabel = "Mirroring Reminder"
    static let cutNumberReminderLabel = "Cut Number Reminder"
    static let splicingNotificationLabel = "Splicing Notification"
    static let multidirSplicNotiLabel = "Multidirectional Splicing Notification"
    static let saveCalibPhotoLabel = "Save Calibration Photos"
    static let emailLabel = "EMAIL"
    static let phoneLabel = "PHONE"
    static let emailSubTitleOneLabel = "Wait Time: 24 hours"
    static let emailSubTitleTwoLabel = "Questions or Comments?"
    static let emailDescriptionLabel = "Email \(CommonConst.customerCareEmailText) to our customer care representatives and we will get back soon."
    static let phoneSubTitleOneLabel = "Wait Time: Less than 30 sec"
    static let phoneSubTitleTwoLabel = "US Toll Free:\n\n\(CommonConst.customerCareePhoneText)"
    static let hamburgerNameLabel = "Hi there "
    static let hamburgerSignInLabel = "Sign in to explore more"
    static let signInLabel = "Sign in"
    static let logOutLabel = "Log Out"
    static let switchLanguageLabel = "Switch Language"

    static let beamSetupLabel = "Beam Setup"
    static let beamTakedownLabel = "Beam Takedown"
    static let zeroLabel = "0"
    static let oneLabel = "1"
    static let twoLabel = "2"
    static let threeLabel = "3"
    static let fourLabel = "4"
    static let sixLabel = "6"
    static let patternNotdownloaded = "Pattern didn't complete downloading. Try with Network Connection."
    static let trialPatternDownloadInProcess = "Downloading Trail Patterns in Progress"
    static let PatternLibrary = "Pattern Library"
    static let browseLabel = "Browse"
    static let libraryTileLabel = "Patterns in Your Library"
    static let offlinepatterns = "Offline Patterns"
    static let myfolders = "My Folders"
    static let showfilterResults = "Showing filtered results"
    static let searchPatternLibrary = "Search pattern library"
    static let favorite = "Favorite"
    static let OWNED = "OWNED"
    static let Owned = "Owned"
    static let Favorites = "Favorites"
    static let NEW = "NEW"
    static let new = "New"
    static let TRIAL = "TRIAL"
    static let Trial = "Trial"
    static let EXPIRED = "EXPIRED"
    static let SUBSCRIBED = "SUBSCRIBED"
    static let PAUSED = "PAUSED"
    static let CANCELLED = "CANCELLED"
    static let productTypes = "productTypes"
    static let productType = "productType"
    static let pRODUCTTypes = "Product Types"
    static let pRODUCTType = "Product Type"
    static let category = "category"
    static let brand = "brand"
    static let PatternDetail = "Pattern Details"
    static let RESUME = "RESUME"
    static let trialmake1 = "trial-make1"
    static let garment = "Garment"
    static let lining = "Lining"
    static let interfacing = "Interfacing"
    static let other = "Other"
    static let renewSubscription = "RENEW SUBSCRIPTION"
    static let Size = "Size"
    static let modifiedLabel = "Modified"
    static let addcustomisation = "Add Customization"
    static let selectSize = "Select Size"
    static let selectViewCupSize = "Select View / Cup Size"
    static let Retry = "Retry"
    static let Cancel = "Cancel"
    static let WORKSPACE = "WORKSPACE"
    static let shopJoann = " Shop Joann.com "
    static let buyPatterns = "Buy Patterns "
    static let WelcomeBack = "Welcome back, "
    static let HiThere = "Hi there, "
    static let beamLabel = "Beam Setup & Takedown"
    static let mirrorDirectionV = "V"
    static let mirrorDirectionH = "H"
    static let workspaceLabel = "workspace"
    static let instructionLabel = "Instruction"
    static let instructionsssLabel = "Instructions"
    static let cuttingLabel = "cutting"
    static let mirroringLabel = "Mirroring"
    static let splicingLabel = "Splicing"
    static let Tutorials = "Tutorials"
    static let newStausLabel = "New"
    static let wsSavejsonValueLabel = "c_traceWorkSpacePattern"
    static let calibrateWSLabel = "C"
    static let recalibrateWSLabel = "R"
    static let offStatusLabel = "Off"
    static let onStatusLabel = "On"
    static let unknowmDeviceLabel = "Unknown Device"
    static let uuidLabel = "2902"
    static let selectProjectorLabel = "Select projector"
    static let selectbluetoothLabel = "Select bluetooth device"
    static let SKIPLabel = "SKIP"
    static let scanBluetoothLabel = "SCAN VIA BLUETOOTH"
    static let trialOrderNoLabel = "111"
    static let WorkSpace = "WorkSpace"
    static let unlockLabel = "unlock"
    static let forgroundLabel = "foregroundLabel"
    static let rate = "rate"
    static let dittoAppOverview = " Ditto application overview"
    static let dittoTour = "   ditto tour"
    static let glossary = "  Glossary"
    static let zoomLabel = "Double tap to zoom"
    static let dragAndDropLabel = "LONG PRESS ON PATTERN PIECES TO DRAG INTO WORKSPACE"
    static let faqDescriptionMessage = "See FAQs, tips & words to know"
    static let versionText = "Version"
    static let selectAllLabel = "SelectAll"
    static let burdaLabel = "Burda"
    static let butterickLabel = "Butterick"
    static let dittoBrandLabel = "Ditto"
    static let connectedLabel = "Connected"
    static let yardagePdfLabel = "-Yardage"
    static let instructionPdfLabel = "-Instruction"
    static let tutorialPdfLabel = "-Tutorial"
    static let createNewFolder = "Create New Folder"
    static let patternsPerPageCount = "12"
    static let trueLabel = "true"
    static let rotateLabel = "Rotate"
    static let clockWiseLabel = "Clockwise"
    static let antiCWLabel = "Anti-Clockwise"
    static let EnterYourNotes = "Enter your notes"
}
enum SpliceDirectionType: String {
    case horizontalSplicing = "horizontalSplicing"
    case verticalSplicing = "verticalSplicing"
    case topToBottomSplicing = "Splice Top-to-Bottom"
    case leftToRightSplicing = "Splice Left-to-Right"
}
enum ScreenTypeString {
    static let softwareUpdatePresent = "SoftwareUpdatePresent"
    static let tailornovaAlert = "TailornovaAlert"
    static let myLibraryFolder = "myLibraryFolder"
    static let myLibraryRenameFolder = "myLibraryRenameFolder"
    static let fromSpliceAlert = "FromSpliceAlert"
    static let mirrorScreen = "MirrorScreen"
    static let deleteFolder = "DeleteFolder"
    static let PatternDesc = "PtternDesc"
    static let skipType = "skip"
    static let fAQScreen = "FAQScreen"
    static let fAQVideoScreen = "FAQVideoScreen"
    static let tutorial = "tutorial"
    static let calibrate = "calibrate"
    static let fromPatternDesc = "fromPatternDescription"
    static let pattenDesc = "patternDescription"
    static let calibConnectivitySuccessScreen = "CalibConnectivitySuccess"
    static let tutorialClicked = "tutorialClicked"
    static let onRetry = "onRetry"
    static let fromCalibrate = "fromCalibrate"
    static let workSpaceScreen = "workSpace"
    static let calibYes = "calibYes"
    static let workspaceFromCalibration = "workspaceFromCalibration"
}
enum MessageString {
    static let noActivityActive = "No Active Projects now, if you want to add project click here."
    static let noActivityCompleted = "No Completed Project"
    static let guestusernotAllowed = "Guest User does not have this functionality."
    static let folderAlreadyExist = "Folder already Exists!"
    static let unabletoFetchDesignID = "Unable to fetch the design Id!"
    static let downloadTrialPatternSuccessful = "Downloading Trial Patterns successfully completed..."
    static let downloadPatternSuccessfully = "Downloading Patterns successfully completed..."
    static let downloadTrialInProcess = "Downloading Trail Patterns in Progress."
    static let selectAnyCustomisation = "Please select any customization to continue!"
    static let selectAnySize = "Please select any Size to continue!"
    static let selectAnyViewCupSize = "Please select any View / Cup size to continue !"
    static let selectAnysizeAndCupSize = "Please select View / Cup size and Size to continue !"
    static let turnOnWiFi = "Turn on your Wi-Fi"
    static let dittoProjectorNotConnected = "Ditto projector is not connected"
    static let turnOnBluetooth = "Turn on your bluetooth"
    static let downloadFailed = "Download failed!"
    static let unableToDwnloadPDF = "Unable to download the pdf!"
    static let noPdftoDisplay = "No pdf document available to display !"
    static let shopForMaterials = "Shop for materials selected by JOANN to sew a garment to perfection!"
    static let stayTuned = "Stay tuned to browse more patterns that inspire you to start your next journey!"
    static let fetchPatternFailed = "Fetching Patterns failed!"
    static let invalidEmailOrPassword = "Invalid EmailId or Password!"
    static let noYardagetoDisplay = "No yardage or notions available to display !"
    static let showingFilterResults = "Showing filtered results"
}
enum EntityName {
    static let Active = "Active"
    static let Workspace = "Workspace"
}
enum FontName {
    static let openSans = "Open Sans"
    static let openSansSemiBold = "OpenSans-SemiBold"
    static let avenirNextLtPro = "Avenir Next LT Pro"
    static let openSansRegular = "OpenSans-Regular"
}
enum FromScreen {
    static let getStarted = "getStarted"
    static let FAQScreen = "FAQScreen"
    static let tutorial = "tutorial"
    static let FAQVideoScreen = "FAQVideoScreen"
    static let workspace = "workspace"
}
enum HomeTileTitleText {
    static let libraryTitle = "Browse 10 Patterns in Your Library"
    static let tutorialTitle = "Learn More"
    static let dittoPatternsTitle = "DittoPatterns.com"
    static let joannTitle = "Joann.com"
    static let libraryText = "Pattern Library (10) \n"
    static let tutorialText = "Setup & Calibration \n"
    static let dittoPatternsText = "Get More Patterns \n"
    static let joannText = "Shop Fabric & Supplies \n"
}
