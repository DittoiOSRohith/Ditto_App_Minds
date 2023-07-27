//
//  CallibrationCameraViewController.swift
//  JoannTraceApp
//
//  Created by Shefrin Hakeem on 10/08/20.
//  Copyright © 2020 Infosys. All rights reserved.
//

import UIKit
import AVFoundation
import FabricTraceTransformFrx
import FastSocket
import  Lottie

@objc protocol calibrationDelegate {
    @objc optional func passCalibrationStatus(status: Bool)
}
class CallibrationCameraViewController: UIViewController {
    //MARK: UI COMPONENT OUTLETS
    @IBOutlet weak var cameraButtonImageView: UIImageView!
    @IBOutlet weak var cameraButtonView: UIView!
    @IBOutlet weak var photoPreviewImageView: UIImageView!
    @IBOutlet weak var callibrationButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var lottieAnimationView: AnimationView!
    @IBOutlet weak var calibrationAlertView: CalibartionAlertView!
    @IBOutlet weak var cameraRedFrameView: UIView!
    @IBOutlet weak var instructionButton: UIButton!
    @IBOutlet weak var processingView: UIView!
    //MARK: VARIABLE DECLARATION
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!
    var goToWorkspaceFromCalibrationDelegate: DissmissConnectivityDelegate!
    var calScreenType  = FormatsString.emptyString
    var host = String()
    var port = Int32()
    var isCallibarating = false
    var isProjecting = false
    var takePicture = false
    var imagePickerController = UIImagePickerController()
    let yourAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 14),
        .foregroundColor: UIColor.white,
        .underlineStyle: NSUnderlineStyle.single.rawValue]
    var animView = AnimationView()
    var isPhotoTaken = false
    var capturedPhoto = UIImage()
    //MARK: Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.isUserInteractionEnabled = true
        if  UserDefaults.standard.value(forKey: CommonConst.isFromInstructionbBack) != nil {
            UserDefaults.standard.removeObject(forKey: CommonConst.isFromInstructionbBack)
            UserDefaults.standard.synchronize()
        }
        self.cameraView.backgroundColor = UIColor.clear
        self.calibrationAlertView.isHidden = true
        self.backButton.isHidden = true
        self.instructionButton.isHidden = false
        _ = NSMutableAttributedString(string: FormatsString.instructionLabel, attributes: self.yourAttributes)
        self.cameraRedFrameView.isHidden = true
        self.imagePickerController.modalPresentationStyle = .currentContext
        self.imagePickerController.delegate = self
        self.imagePickerController.sourceType = .camera
        let screenSize = UIScreen.main.bounds.size
        let cameraAspectRatio: Float = 4.0 / 3.0
        let imageHeight = floorf(Float(screenSize.height * CGFloat(cameraAspectRatio)))
        let scale = Float(screenSize.width / CGFloat(imageHeight))
        let trans = Float((screenSize.width - CGFloat(imageHeight)) / 2)
        let translate = CGAffineTransform(translationX: 0.0, y: CGFloat(trans))
        _ = translate.scaledBy(x: CGFloat(scale), y: CGFloat(scale))
        self.imagePickerController.cameraViewTransform = translate
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    override func viewWillAppear(_ animated: Bool) {
        self.title =  FormatsString.emptyString
        self.cameraView.backgroundColor = UIColor.black
        let button1 = UIBarButtonItem(image: UIImage(named: ImageNames.backImage), style: .plain, target: self, action: Selector(("action")))
        self.navigationItem.rightBarButtonItem  = button1
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.photoPreviewImageView.isHidden = true
        self.cameraRedFrameView.layer.borderWidth = 20
        self.cameraRedFrameView.layer.borderColor = UIColor(red: 255/255, green: 152/255, blue: 152/255, alpha: 0.5).cgColor
        if CommonConst.userDefault.value(forKey: CommonConst.isFromInstructionbBack) != nil {
            if !CommonConst.isFromInstructionbBackCheck && CommonConst.intructionBackCheck {
                self.checkCameraAccess(view: self)
            }
        } else {
            self.checkCameraAccess(view: self)
        }
    }
    func showConnectionLottie() {  // show connection lottie
        let jsonName = ConnectivityUtils.jsonLoader
        let animation = Animation.named(jsonName)
        let animView = AnimationView(animation: animation)
        animView.frame.size = self.processingView.frame.size
        self.view.addSubview(animView)
        self.processingView.isHidden = false
        self.view.bringSubviewToFront(animView)
        animView.contentMode = .center
        animView.loopMode = .loop
        animView.play()
    }
    func sendImage (img: UIImage) {  // Send image to projector
        self.isProjecting = true
        do {
            guard let client = FastSocket(host: ProjectorDetails.Host, andPort: String(ProjectorDetails.port)), client.connect() else { return }
            if let data =  img.pngData() {
                data.withUnsafeBytes { dataBytes in
                    if let buffer: UnsafePointer<CChar> = dataBytes.baseAddress?.assumingMemoryBound(to: CChar.self) {
                        _ = client.sendBytes(buffer, count: data.count)
                        client.close()
                        self.isProjecting = false
                    }
                }
            }
        }
    }
    func showImagePicker(sourceType: UIImagePickerController.SourceType, button: UIBarButtonItem) {  // show image picker for calibration capture
        self.imagePickerController.sourceType = sourceType
        self.imagePickerController.modalPresentationStyle = sourceType == UIImagePickerController.SourceType.camera ? UIModalPresentationStyle.fullScreen : UIModalPresentationStyle.popover
        if let presentationController = self.imagePickerController.popoverPresentationController {
            presentationController.barButtonItem = button
            presentationController.permittedArrowDirections = UIPopoverArrowDirection.any
        }
        // Display a popover from the UIBarButtonItem as an anchor.
        if sourceType == UIImagePickerController.SourceType.camera {
            self.imagePickerController.showsCameraControls = false
            if let overlay = Constants.callibrationStoryBoard.instantiateViewController(withIdentifier: Constants.SampleOverlayControllerIdentifier) as? SampleOverlayController {
                overlay.view.frame = (self.imagePickerController.cameraOverlayView?.frame)!
                self.imagePickerController.cameraOverlayView = overlay.view
                if let cameraButton = self.imagePickerController.cameraOverlayView?.viewWithTag(TagValue.cameraButtonTag) as? UIButton {  // action defining for camera button
                    cameraButton.addTarget(self, action: #selector(self.takeMyPhoto(_:)), for: .touchUpInside)
                }
                if let backButton = self.imagePickerController.cameraOverlayView?.viewWithTag(TagValue.cameraBackTag) as? UIButton {  // action defining for back button
                    backButton.addTarget(self, action: #selector(self.pickerBackButtonClicked(_:)), for: .touchUpInside)
                }
                if let instructionButton = self.imagePickerController.cameraOverlayView?.viewWithTag(TagValue.instructionTag) as? UIButton {  // action defining for instruction label
                    let attributeString = NSMutableAttributedString(string: FormatsString.instructionsssLabel,
                                                                    attributes: self.yourAttributes)
                    instructionButton.setAttributedTitle(attributeString, for: .normal)
                    instructionButton.addTarget(self, action: #selector(self.overlayInstructionButtonClicked(_:)), for: .touchUpInside)
                }
                if let retakeButton = self.imagePickerController.cameraOverlayView?.viewWithTag(TagValue.retakeTag) as? UIButton {  // action defining for retake button on preview popup
                    retakeButton.addTarget(self, action: #selector(self.overlayRetakeClicked(_:)), for: .touchUpInside)
                }
                if let submitButton = self.imagePickerController.cameraOverlayView?.viewWithTag(TagValue.submitTag) as? UIButton {  // action defining for submit button on preview popup
                    submitButton.addTarget(self, action: #selector(self.overlaySubmitClicked(_:)), for: .touchUpInside)
                }
            }
        }
        self.present(self.imagePickerController, animated: true, completion: nil)
    }
    func sendCalibImage(img: UIImage) {  // Send calibration image after success
        self.isProjecting = true
        do {
            guard let client = FastSocket(host: ProjectorDetails.Host, andPort: String(ProjectorDetails.port)), client.connect() else { return }
            if let data =  img.pngData() {
                _ = client.sendBytes(data.bytes, count: (data.count))
                client.close()
                self.isProjecting = false
            }
        }
    }
    private func updatePreviewOrientation(for connection: AVCaptureConnection, to orientation: AVCaptureVideoOrientation) {   // updating orientation of preview
        if connection.isVideoOrientationSupported {
            connection.videoOrientation = orientation
        }
        self.videoPreviewLayer.frame = self.cameraView.bounds
    }
    func navigateCalibrationSuccess(calibImage: UIImage) {  // navigation of successful calibration
        self.instructionButton.isHidden = true
        self.backButton.isHidden = true
        self.showCalibrationSuccesAlert()
    }
    func checkCameraAccess(view: UIViewController) {  // camera access permission in device checking before calibration
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .denied: // "Denied, request permission from settings"
            presentCameraSettings(viewController: view)
        case .restricted:
            break // "Restricted, device owner must approve"
        case .authorized: // "Authorized, proceed"
            DispatchQueue.main.async {
                self.showImagePicker(sourceType: UIImagePickerController.SourceType.camera, button: UIBarButtonItem())
            }
            self.isCallibarating = true
        case .notDetermined:  // cannot determine, ask for access
            AVCaptureDevice.requestAccess(for: .video) { success in
                DispatchQueue.main.async {
                }
                if success { // "Permission granted, proceed"
                    self.isCallibarating = true
                    DispatchQueue.main.async {
                        self.showImagePicker(sourceType: UIImagePickerController.SourceType.camera, button: UIBarButtonItem())
                    }
                } else { // Permission not granted, Dismiss the Page
                    DispatchQueue.main.async {
                        self.dismiss(animated: true) {
                            if self.calScreenType == ScreenTypeString.workSpaceScreen {
                                self.goToWorkspaceFromCalibrationDelegate.dismmissConnectionView(presentScreenType: ScreenTypeString.fromCalibrate)
                            } else {
                                let image = UIImage(named: ImageNames.launchImage)
                                self.sendCalibImage(img: image!)
                            }
                        }
                    }
                }
            }
        @unknown default:
            break
        }
    }
    func doCalibration(images: [UIImage], completion: (FabricTraceTransform.CalibrationErrorCode) -> Void) {  // perform calibration on the captured image
        DispatchQueue.main.async {
            self.animView.play()
        }
        self.takePicture = false
        let ret: FabricTraceTransform.CalibrationErrorCode = FabricTraceTransform.performCalibration(cameraImages: images, saveInputImage: CommonConst.saveCalibPhotoReminderCheck)
        completion(ret) // <--- Your return value ends up here
    }
    //MARK: Alerts
    func showCalibrationSuccesAlert() {   // Calibration success alert
        DispatchQueue.main.async {
            self.processingView.isHidden = true
            let alert = Constants.AlertWithImageAndButtons.instantiateViewController(identifier: Constants.AlertWithImageAndButonsVCIdentifier) as AlertWithImageAndButtonsViewController
            alert.modalPresentationStyle = .overFullScreen
            alert.alertArray = [ImageNames.calibrationSuccessImage, "\(CalibrationMessages.calibrationSuccess)", FormatsString.emptyString, AlertTitle.OKButton, FormatsString.emptyString]
            alert.onOKPressed = {
                DispatchQueue.global(qos: .userInitiated).async {
                    Thread.sleep(forTimeInterval: 5)
                    self.sendImage(img: UIImage(named: ImageNames.wsLaunchImage)!)
                }
                self.dismiss(animated: false, completion: {
                    ProjectorDetails.isCalibrated = true
                    ProjectorDetails.isUserCalibrated = false
                    self.goToWorkspaceFromCalibrationDelegate.dismmissConnectionView(presentScreenType: ScreenTypeString.calibConnectivitySuccessScreen)
                })
            }
            if self.presentedViewController == nil {
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    func  showAlertForErrorCaseCalibration(errorMessage: String ) {  // Calibration failed alert message handling functions
        let alert = Constants.AlertWithImageAndButtons.instantiateViewController(identifier: Constants.AlertWithImageAndButonsVCIdentifier) as AlertWithImageAndButtonsViewController
        alert.alertArray = [ImageNames.calibrationFailedImage, "\(errorMessage)", AlertTitle.RETRY, AlertTitle.skipCalibration, AlertTitle.TUTORIAL]
        alert.modalPresentationStyle = .overFullScreen
        alert.onTutorialPressed = {   // tutorial tap on calibration failed alert
            DispatchQueue.main.async {
                alert.thirdButton.isUserInteractionEnabled = false
            }
            self.goToWorkspaceFromCalibrationDelegate.dismmissConnectionView(presentScreenType: ScreenTypeString.tutorialClicked)
            DispatchQueue.global(qos: .background).async {
                Thread.sleep(forTimeInterval: 1)
                self.sendImage(img: UIImage(named: ImageNames.wsLaunchImage)!)
            }
            alert.thirdButton.isUserInteractionEnabled = true
        }
        alert.onOKPressed = {   // Skip calibration tap on calibration failed alert
            self.processingView.isHidden = true
            DispatchQueue.main.async {
                self.dismiss(animated: false, completion: {
                    ProjectorDetails.isCalibrated = true
                    ProjectorDetails.isUserCalibrated = false
                    ProjectorDetails.showCalibratePopUp = true
                    self.goToWorkspaceFromCalibrationDelegate.dismmissConnectionView(presentScreenType: ScreenTypeString.calibConnectivitySuccessScreen)
                    DispatchQueue.global(qos: .background).async {
                        Thread.sleep(forTimeInterval: 1)
                        self.sendImage(img: UIImage(named: ImageNames.wsLaunchImage)!)
                    }
                })
            }
        }
        alert.onCancelPressed = {   // retry tap on calibration failed alert
            self.dismiss(animated: true) {
                ProjectorDetails.isCalibrated = true
                ProjectorDetails.isUserCalibrated = true
                ProjectorDetails.showCalibratePopUp = true
                self.goToWorkspaceFromCalibrationDelegate.dismmissConnectionView(presentScreenType: ScreenTypeString.onRetry)
                DispatchQueue.global(qos: .background).async {
                    Thread.sleep(forTimeInterval: 1)
                    let image = UIImage(named: ImageNames.connectedRotatedImage)
                    self.sendImage(img: image!)
                }
            }
        }
        if self.presentedViewController == nil {
            self.present(alert, animated: true, completion: nil)
        }
    }
}
