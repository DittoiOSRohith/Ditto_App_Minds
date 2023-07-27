//
//  StoryBoardConstant.swift
//  Ditto
//
//  Created by Gaurav Rajan on 27/04/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit

struct Constants {
    static let fromAllPatterns = "AllPatterns"
    static let fromActive = "Active"
    static let fromCOMPLETED = "Completed"
    static let HANDSHAKESUCCESS = "TRACEbleConnected"
    static let SERVICESUCCESS = "SERVICESUCCESS"
    static let TRACEFAILED = "TRACEFailed"
    static let TRACEREQUEST = "TRACERequestIOS"
    static let encryptKEY = "3hb1L0x7*Ditto*i"
    static let ivKEY = "d16(}Ditt16(}Trc"
    static let domainKey = "local."
    static let typeKey = "_http._tcp."
    static let nameKey = "PROJECTOR_SERVICE"
    static let dittoOnlyCheck = "DITTO_"
    static let TRANSFERSERVICEUUID = "1805"
    static let TRANSFERCHARACTERISTICUUID = "2A2B"
    static let rotationRoundValue = CGFloat(45)
    static let rotationCheckLower = CGFloat(180)
    static let rotationCheckHigher = CGFloat(360)
    static let defaultTransformValue = "1.0"
    static let changingTransformValue = "-1.0"
    static let zeroTransformValue = "0.0"
    static let halfConstantValue = 2
    static let storyBoardCategory: UIStoryboard = UIStoryboard(name: "GetStarted", bundle: nil)
    static let loginStoryBoard: UIStoryboard = UIStoryboard(name: "Login", bundle: nil)
    static let storyBoardDummy: UIStoryboard = UIStoryboard(name: "CategoryListStoryboard", bundle: nil)
    static let dashBoardStoryBoard: UIStoryboard = UIStoryboard(name: "Dashboard", bundle: nil)
    static let callibrationStoryBoard: UIStoryboard = UIStoryboard(name: "callibration", bundle: nil)
    static let workspaceStoryBoard: UIStoryboard = UIStoryboard(name: "Workspace", bundle: nil)
    static let patternDescription: UIStoryboard = UIStoryboard(name: "patternDescription", bundle: nil)
    static let howToStoryBoard: UIStoryboard = UIStoryboard(name: "HowTo", bundle: nil)
    static let patternInstructions: UIStoryboard = UIStoryboard(name: "patternInstructions", bundle: nil)
    static let Yardage: UIStoryboard = UIStoryboard(name: "Yardage", bundle: nil)
    static let connectivity: UIStoryboard = UIStoryboard(name: "Connectivity", bundle: nil)
    static let myLibrary: UIStoryboard = UIStoryboard(name: "MyLibrary", bundle: nil) // TRAC_506_LANDINGUX
    static let LanguagePopupBoard: UIStoryboard = UIStoryboard(name: "LanguagePopupSB", bundle: nil) // TRAC_506_LANDINGUX

    static let AlertWithImageAndButtons: UIStoryboard = UIStoryboard(name: "AlertWithImageAndButtons", bundle: nil) // TRAC_601
    static let AlertWithTwoButtonsAndTitle: UIStoryboard = UIStoryboard(name: "AlertWithTwoButtonsAndTitle", bundle: nil) // TRAC_601
    static let AlertWithTwoButtonsAndTwoTextFields: UIStoryboard = UIStoryboard(name: "AlertWithTwoButtonsAndTwoTextFields", bundle: nil)
    static let faqView: UIStoryboard = UIStoryboard(name: "Faq", bundle: nil)
    static let accountSettings: UIStoryboard = UIStoryboard(name: "AccountSetting", bundle: nil)
    static let AlertWithButtonsAndOneTextField: UIStoryboard = UIStoryboard(name: "AlertWithButtonsAndOneTextField", bundle: nil)
    static let AlertWithTableViewAndBottons: UIStoryboard = UIStoryboard(name: "AlertWithTableViewAndBottons", bundle: nil)

    /******************* StoryBoard Identifiers :****************************** */
    static let connectivityIdentifier = "connectNav"
    static let AlertWithImageAndButonsVCIdentifier = "AlertWithImageAndButtonsViewController"
    static let AlertWithTwoButonsTitleVCIdentifier = "AlertWithTwoButtonsAndTitleViewController"
    static let AlertWithTwoButonsTextFieldsVCIdentifier = "AlertWithTwoButtonsAndTwoTextFieldsViewController"
    static let LoginViewControllerIdentifier = "LoginViewController"
    static let AdvertisementVideoControllerIdentifier = "AdvertisementVideoController"
    static let ManageProjectorViewControllerIdentifier = "ManageProjectorViewController"
    static let WorkspaceSettingsViewControlleIdentifier = "WorkspaceSettingsViewController"
    static let AccountSettingsViewControllerIdentifier = "AccountSettingsViewController"
    static let SubcscriptionsViewControllerIdentifier = "SubscriptionsViewController"
    static let YardageViewControllerIdentifier = "YardageViewController"
    static let AboutAppAndPolicyViewControllerIdentifier = "AboutAppAndPolicyViewController"
    static let FaqViewControllerIdentifier = "FaqViewController"
    static let CustomerSupportViewControllerIdentifier = "CustomerSupportViewController"
    static let HamburgerViewControllerIdentifier = "HamburgerViewController"
    static let HomeViewControllerIdentifier = "HomeViewController"
    static let LaunchCameraAlertViewControllerIdentifier = "LaunchCameraAlertViewController"
    static let cameraNavIdentifier = "cameraNav"
    static let WorkspaceBaseViewControllerIdentifier = "WorkspaceBaseViewController"
    static let AlertForCutConfirmVCIdentifier = "AlertForCutConfirmationViewController"
    static let SampleOverlayControllerIdentifier = "SampleOverlayController"
    static let BeamSetUpViewControllerIdentifier = "BeamSetUpViewController"
    static let HowToViewControllerIdentifier = "HowToViewController"
    static let MyLibrarryViewControllerIdentifier = "MyLibrarryViewController"
    static let BuyPatternsViewControllerIdentifier = "BuyPatternsViewController"
    static let CoachMarkViewControllerIdentifier = "CoachMarkViewController"
    static let FilterViewControllerIdentifier = "FilterViewController"
    static let AlertWithButonsTextFieldVCIdentifier = "AlertWithButtonsAndOneTextFieldViewController"
    static let LanguagePopupVCIdentifier = "languagePopupVC"

    static let AlertWithTableBotonsVCIdentifier = "AlertWithTableViewAndBottonsViewController"
    static let PatternInstructionsIdentifier = "patternInstructions"
    static let AddNotesVCIdentifier = "AddNotesViewController"
}
enum ReusableCellIdentifiers {
    static let devicesTableCellViewIdentifier = "DevicesTableCellView"
    static let manageCellIdentifier = "manageCell"
    static let workspaceSettingsTableViewCellIdentifier = "WorkspaceSettingsTableViewCell"
    static let customerSupportCellIdentifier = "CustomerSupportCell"
    static let aboutCellIdentifier = "aboutCell"
    static let faqHeaderTableViewCellIdentifier = "FaqHeaderTableViewCell"
    static let faqAnswerTableViewCellIdentifier = "FaqAnswerTableViewCell"
    static let faqTableViewCellIdentifier = "FaqTableViewCell"
    static let hamburgerTableCellViewIdentifier = "HamburgerTableCellView"
    static let pageComingSoonViewIdentifier = "PageComingSoonView"
    static let calibartionAlertViewIdentifier = "CalibartionAlertView"
    static let beamSetupViewIdentifier = "BeamSetupView"
    static let referenceSpliceLayoutIdentifier = "ReferenceSpliceLayout"
    static let patternScrollableViewIdentifier = "PatternScrollableView"
    static let workspaceAreaViewIdentifier = "WorkspaceAreaView"
    static let patternCollectionViewCellIdentifier = "PatternCollectionViewCell"
    static let beamSetUpCollectionViewCellIdentifier = "BeamSetUpCollectionViewCell"
    static let beamsetupCellIdentifier = "beamsetupCell"
    static let tabCellsIdentifier = "TabCells"
    static let FiltertitleCell = "titleCell"
    static let FiltercontentCell = "contentCell"
    static let workDetailViewIdentifier = "WorkDetailView"
    static let bleDevicesIdentifier = "bleDevices"
    static let bLEDevicesTableViewCellIdentifier = "BLEDevicesTableViewCell"
    static let onboardCellIdentifier = "onboardCell"
    static let homeScreenCollectionViewCellIdentifier = "HomeScreenCollectionViewCell"
    static let homeCellIdentifier = "homeCell"
    static let homeCollectionViewCellIdentifier = "HomeCollectionViewCell"
    static let collectionViewLoaderIdentifier = "CollectionViewLoader"
    static let loadingresuableviewidIdentifier = "loadingresuableviewid"
    static let customListIdentifier = "customList"
    static let customisedListCellIdentifier = "CustomisedListCell"
}
enum StoryBoardType: String {
    case splash = "Splash"
    case login = "Login"
    case getStarted = "GetStarted"
    case categoryList = "CategoryListStoryboard"
    case dashboard = "Dashboard"
    case callibration = "callibration"
    case workspace = "Workspace"
    case patternDescription = "patternDescription"
    case howTo = "HowTo"
    case patternInstructions = "patternInstructions"
    case connectivity = "Connectivity"
    case hamburger  = "Hamburger"
    case faq = "Faq"
    case about = "AboutApp"
    case accountSettings = "AccountSetting"
    case subscriptions = "Subscriptions"
    case yardage = "Yardage"
    case customerSupport = "CustomerSupport"
    case workspaceSettings = "WorkspaceSettings"
    case manageDevice = "ManageDevice"
    case alertWithTwoButtonsAndTitle = "AlertWithTwoButtonsAndTitle"
    case alertWithImageAndButtons = "AlertWithImageAndButtons"
    case privacy = "PrivacyPolicy"
    var storyboard: UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: nil)
    }
}
enum StoryBoardIdentifiers: String {
    case getStartedd = "getStarted"
}
