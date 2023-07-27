//
//  AlertConstants.swift
//  Ditto
//
//  Created by Abiya Joy on 23/03/22.
//  Copyright © 2022 Infosys. All rights reserved.
//

import Foundation

enum AlertTitle {
    static let success = "Success"
    static let error = "Error"
    static let OKButton = "OK"
    static let NOButton = "NO"
    static let EmptyButton = ""

    static let YES = "YES"
    static let RETRY = "RETRY"
    static let CANCEL = "CANCEL"
    static let TUTORIAL = "TUTORIAL"
    static let LATER = "LATER"
    static let SETTINGS = "SETTINGS"
    static let goBackButton = "GO BACK"
    static let ADDTOFOLDER = "Add to Folder"
    static let CREATEFOLDER = "CREATE FOLDER"
    static let NEWFOLDER = "New folder"
    static let FOLDERNAME = "Folder name"
    static let RENAMEFOLDER = "RENAME FOLDER"
    static let renamefolder = "Rename Folder"
    static let doYouSeeEdge = "Do you see the edges lined upto projection?"
    static let cancel = "Cancel"
    static let mirror = "Mirror"
    static let skipCalibration = "SKIP CALIBRATION"
    static let retry = "Retry"
    static let downloadFail = "Download failed!"
    static let splicedPiecesText = "Spliced Pieces"
    static let multiSpliceDropText = "Multi-Directional Splicing Required"
    static let spliceDropText = "Splicing Required"
    static let Yes = "Yes"
    static let Skip = "Skip"
    static let Setting = "Setting"
    static let Settings = "Settings"
}
enum AlertTypes {
    static let WiFi = "wifi"
    static let BLE = "ble"
    static let SWITCHPROJECTOR = "switchProjector"
}
//Rohith
//Some alert messages cretaed
enum AlertMessage {
    
    static let UpdateProjectortxt = "Do you want to update projector"

    
    static let customerMismatch = "Customer doesn't match !"
    static let userName = "Please enter username or emailID"
    static let email = "Please enter email address"
    static let validEmail = "Please enter valid email address"
    static let password = "Please enter password"
    static let minPassword = "Password should contain mininum 8 character"
    static let deleteAlertText = "Are you sure you want to delete the account?"
    static let deleteScreenDescription = "Deleting your account permanently disables access to the Ditto Patterns website and mobile app. Are you sure you want to delete?"
    static let subscriptionRenewDescFirst = "Your subscription will get EXPIRED in "
    static let subscriptionRenewDescSecond = " Please contact Customer Service to reactivate your subscription."
    static let sureToDeleteFolder = "Are you sure you want to delete this folder?"
    static let downloadFailed = "Download failed!"
    static let noCalibrate = "No, Calibrate"
    static let placeaSheet = "Place a sheet of letter size paper on the projection and check if the lines are coinciding."
    static let apiFailedText = "API call failed!"
    static let invalidEntry = "The item tap is Invalid."
    static let wsCutAlertFirst = "Did you complete "
    static let wsCutAlertSecond = " piece(s)?"
    static let mirrorAlertText = "Piece will be replaced in workspace with a mirrored version."
    static let guestSaveDisableText = "Guest User does not have save functionality."
    static let downloadFailText = "Unable to download the pdf!"
    static let unabletoLoadFIle = "Unable to load the file, Please try again!"
    static let pdfUnavailableText = "No pdf document available to display !"
    static let multipleSpliceDropMsg = "Additional pieces cannot be in the workspace at the same time as a spliced piece."
    static let multiSpliceDropMsg = "This piece is too large for the projection area and will be projected across 3+ linked sections. TRACING the entire piece first is recommended before cutting due to the complexity. ATTRIBUTEDSTRING"
    static let spliceDropMsg = "This is a spliced piece that is too large for the projection area. It will be projected across two or more linked sections."
    static let spliceonSpliceMsg = "This is a large piece which required splicing. This piece can't be projected at the same time as other pieces."
    // TRAC-876
    static let patternImageIsCropped = "Calibration failed: \nCapture all four corners in the submitted photo."
    static let cameraDistanceTooFarBack = "Calibration failed: \nLimit background captured in the submitted photo."
    static let cameraHeightTooLow = "Calibration failed: \nCapture the photo of the cutting mat at a higher angle."
    static let cameraTooFarLeftOrRight = "Calibration failed: \nStand closer to opposite the beam (centered) when capturing the photo."
    static let orientationNotLandscape = "Calibration failed: \nCapture the photo in landscape orientation."
    static let cameraResolutionTooLow = "Calibration failed: \nCapture a non-blurred photo. "
    static let matIsRotated180Degrees = "Calibration failed: \nConfirm accurate mat setup."
    static let imageTooBlurr = "Calibration failed: \nCapture a non-blurred photo. "
    static let imageTooBright = "Calibration failed: \nDim the lighting in the work environment."
    static let failCalibration = "Calibration failed: \nPlease try again."
    //MARK:
    static let defaultCalibrationAlert = "Unknown error occured."
    static let cameraLaunchAlertText = "Do you see the edges lined upto projection?"
    static let cameraLaunchAlertMessage = "Place a sheet of letter size paper on the projection and check if the lines are coinciding."
    static let noCalibrateText = "No, Calibrate"
    static let unableToSaveText = "Unable to save to workspace."
    static let tailornovaAlertOne = "Hang tight.  Ditto is still working on your pattern, but it should be ready soon.  Sorry for the delay, please try again in a little bit."
    static let tailornovaAlertTwo = "There is an internal server issue. Please contact customer support with below message.\n\n"
    static let tailornovaAlertThree = "Unable to fetch the pattern properly."
    static let datafetchFailAlert = "Fetching data failed."
    static let errorFetchingData = "Error Fetching data"
    static let fetchSavedWSAlert = "Unable to fetch saved Workspace."
    static let noConnectionTitle = "Connection Problem"
    static let noConnectionDescription = "Please check the Network connection."
    static let cameraAccessDeniedText = "Camera access required for projector Calibration"
    static let imageFetchIssueText = "Image couldnot be fetched properly. Try again!"
    static let subscriptionExpiredText = "Your subscription has EXPIRED. Please contact Customer Service to reactivate your subscription."
    static let subscriptionPausedText = "Your subscription has been PAUSED. Please contact Customer Service to reactivate your subscription."
    static let subscriptionCancelledText = "Your subscription has CANCELLED. Please contact Customer Service to reactivate your subscription."

    static let questionMarkMessage = "Ditto uses standard 45\" with Nap and 60\" with Nap fabric widths to optimize the reference layout. If your pattern uses a different fabric width, please refer to the pattern sewing instructions for more information."
    static let serverErrorMessage = "Server Error !"
    static let rotationExceedMessage = "Rotation is not possible as piece is going outside border, either move the piece or use single finger to rotate."
}
enum AlertImg {
    static let closeIconThick = "close_icon_thick"
}
