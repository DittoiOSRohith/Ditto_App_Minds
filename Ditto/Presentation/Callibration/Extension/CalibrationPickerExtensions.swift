import Foundation
import UIKit
import AVFoundation
import FabricTraceTransformFrx
import FastSocket
import  Lottie

extension UIImagePickerController {
    override open var shouldAutorotate: Bool {
        return true
    }
    override open var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return [.landscapeLeft, .landscapeRight]
    }
}
extension  CallibrationCameraViewController: UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    private func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (key.rawValue, value) })
    }
    private func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {  // after photo capturing
        DispatchQueue.main.async {
            self.photoPreviewImageView.isHidden = true
            self.cameraView.backgroundColor = UIColor.black
        }
        let info = self.convertFromUIImagePickerControllerInfoKeyDictionary(info)
        guard let image = info[self.convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage else {
            return
        }
        self.capturedPhoto = image
        self.imagePickerController.cameraOverlayView?.backgroundColor = .black  // making camera background black to display preview image confirmation popup
        if let previewPopup = self.imagePickerController.cameraOverlayView?.viewWithTag(TagValue.previewPopupTag) {  // display preview image confirmation popup
            previewPopup.isHidden = false
        }
        if let imgView = self.imagePickerController.cameraOverlayView?.viewWithTag(TagValue.previewImageTag) as? UIImageView {
            imgView.image = self.scaleAndRotateImage(image)
        }
    }
    @objc func overlayRetakeClicked(_ sender: UIButton) {  // retake button logic in preview image confirmation popup
        if let previewPopup = self.imagePickerController.cameraOverlayView?.viewWithTag(TagValue.previewPopupTag) {
            previewPopup.isHidden = true
        }
        if let cameraButton = self.imagePickerController.cameraOverlayView?.viewWithTag(TagValue.cameraButtonTag) {
            cameraButton.isUserInteractionEnabled = true
        }
        if let cameraBackButton = self.imagePickerController.cameraOverlayView?.viewWithTag(TagValue.cameraBackTag) {
            cameraBackButton.isUserInteractionEnabled = true
        }
        if let instructionButton = self.imagePickerController.cameraOverlayView?.viewWithTag(TagValue.instructionTag) {
            instructionButton.isUserInteractionEnabled = true
        }
        self.imagePickerController.cameraOverlayView?.backgroundColor = .clear  // clearing camera background on dismissing preview image confirmation popup
    }
    @objc func overlayInstructionButtonClicked(_ sender: UIButton) {   // camera overlay instruction button tap function
        CommonConst.isFromInstructionbBackCheck = true
        CommonConst.userDefault.synchronize()
        self.imagePickerController.dismiss(animated: true) {
            self.goToBeamSetUpViewController(fetchType: TutorialDataFetchType.calibration)
        }
    }
    func goToBeamSetUpViewController(fetchType: String) {
        if let categoryViewController = Constants.storyBoardCategory.instantiateViewController(withIdentifier: Constants.BeamSetUpViewControllerIdentifier) as? BeamSetUpViewController {
            categoryViewController.beamSetUpViewModel.fetchType =  fetchType
            categoryViewController.beamSetUpViewModel.fromScreenType = FromScreenType.calibrationn.rawValue
            categoryViewController.beamSetUpViewModel.ishandleBackForCamera = true
            self.navigationController?.pushViewController(categoryViewController, animated: true)
        }
    }
    @objc func takeMyPhoto(_ sender: UIButton) {  // take photo function...tap on camera capture button
        if let cameraButton = self.imagePickerController.cameraOverlayView?.viewWithTag(TagValue.cameraButtonTag) {
            cameraButton.isUserInteractionEnabled = false
        }
        if let cameraBackButton = self.imagePickerController.cameraOverlayView?.viewWithTag(TagValue.cameraBackTag) {
            cameraBackButton.isUserInteractionEnabled = false
        }
        if let instructionButton = self.imagePickerController.cameraOverlayView?.viewWithTag(TagValue.instructionTag) {
            instructionButton.isUserInteractionEnabled = false
        }
        CommonConst.isFromInstructionbBackCheck = true
        if !isPhotoTaken {
            DispatchQueue.global(qos: .userInitiated).async {
                DispatchQueue.main.async {
                    self.imagePickerController.takePicture()
                }
            }
        }
    }
    @objc func pickerBackButtonClicked(_ sender: UIButton) {  // Calibration camera view back button tap action
        CommonConst.isFromInstructionbBackCheck = true
        UserDefaults.standard.synchronize()
        DispatchQueue.global(qos: .background).async {
            Thread.sleep(forTimeInterval: 1)
            self.sendImage(img: UIImage(named: ImageNames.wsLaunchImage)!)
        }
        imagePickerController.dismiss(animated: true) {
            DispatchQueue.main.async {
                self.dismiss(animated: false) {
                    self.goToWorkspaceFromCalibrationDelegate.dismmissConnectionView(presentScreenType: ScreenTypeString.fromCalibrate)
                }
            }
        }
    }
    @objc func overlaySubmitClicked(_ sender: UIButton) {  // submit button logic in preview image confirmation popup
        var cameraImages = [UIImage]()
        cameraImages.append(self.capturedPhoto)
        self.imagePickerController.dismiss(animated: false) {
            self.showConnectionLottie()
            CommonConst.isFromInstructionbBackCheck = false
            self.photoPreviewImageView.isHidden = true
            self.cameraView.backgroundColor = UIColor.black
            self.callibrationButton.isHidden = true
            self.cameraButtonView.isHidden = true
            self.backButton.isHidden = true
            self.photoPreviewImageView.image = self.capturedPhoto
            DispatchQueue.global(qos: .userInitiated).async {
                let _: ()  =  self.doCalibration(images: cameraImages) { (result) in
                    self.isPhotoTaken = false
                    switch result {
                    case .success:
                        DispatchQueue.main.async {
                            self.isCallibarating = false
                            if let imageTrans = UIImage(named: ImageNames.calibpatternsuccessImage) {
                                let (retq, img) = FabricTraceTransform.performTransform(patternImage: imageTrans, overrideTransParams: nil, invertColor: false)
                                DispatchQueue.global(qos: .userInitiated).async {
                                    Thread.sleep(forTimeInterval: 0.5)
                                    _ = UIImage(named: ImageNames.calibpatternsuccessImage)
                                    if retq == .success {
                                        self.sendCalibImage(img: img)
                                    }
                                }
                                self.navigateCalibrationSuccess(calibImage: imageTrans)
                            }
                        }
                        // TRAC-876
                    case .patternImageIsCropped:
                        self.isCallibarating = false
                        DispatchQueue.main.async {
                            self.showAlertForErrorCaseCalibration(errorMessage: AlertMessage.patternImageIsCropped)
                        }
                    case .cameraDistanceTooFarBack:
                        self.isCallibarating = false
                        DispatchQueue.main.async {
                            self.showAlertForErrorCaseCalibration(errorMessage: AlertMessage.cameraDistanceTooFarBack)
                        }
                    case .cameraHeightTooLow:
                        self.isCallibarating = false
                        DispatchQueue.main.async {
                            self.showAlertForErrorCaseCalibration(errorMessage: AlertMessage.cameraHeightTooLow)
                        }
                    case .cameraTooFarLeftOrRight:
                        self.isCallibarating = false
                        DispatchQueue.main.async {
                            self.showAlertForErrorCaseCalibration(errorMessage: AlertMessage.cameraTooFarLeftOrRight)
                        }
                    case .orientationNotLandscape:
                        self.isCallibarating = false
                        DispatchQueue.main.async {
                            self.showAlertForErrorCaseCalibration(errorMessage: AlertMessage.orientationNotLandscape)
                        }
                    case .cameraResolutionTooLow:
                        self.isCallibarating = false
                        DispatchQueue.main.async {
                            self.showAlertForErrorCaseCalibration(errorMessage: AlertMessage.cameraResolutionTooLow)
                        }
                    case .matIsRotated180Degrees:
                        self.isCallibarating = false
                        DispatchQueue.main.async {
                            self.showAlertForErrorCaseCalibration(errorMessage: AlertMessage.matIsRotated180Degrees)
                        }
                    case .imageTooBlurr:
                        self.isCallibarating = false
                        DispatchQueue.main.async {
                            self.showAlertForErrorCaseCalibration(errorMessage: AlertMessage.imageTooBlurr)
                        }
                    case .imageTooBright:
                        self.isCallibarating = false
                        DispatchQueue.main.async {
                            self.showAlertForErrorCaseCalibration(errorMessage: AlertMessage.imageTooBright)
                        }
                    case .failCalibration:
                        self.isCallibarating = false
                        DispatchQueue.main.async {
                            self.showAlertForErrorCaseCalibration(errorMessage: AlertMessage.failCalibration)
                        }
                    default:
                        DispatchQueue.main.async {
                            self.isCallibarating = false
                            self.showAlertForErrorCaseCalibration(errorMessage: AlertMessage.defaultCalibrationAlert)
                        }
                    }
                }
            }
        }
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil)
    }
    func scaleAndRotateImage(_ image: UIImage) -> UIImage {   // keep the image captured using camera in the confirmation popup for preview image after scaling and rotating
        let kMaxResolution: CGFloat = 640
        let imgRef: CGImage = image.cgImage!
        let width: CGFloat = CGFloat(imgRef.width)
        let height: CGFloat = CGFloat(imgRef.height)
        var transform: CGAffineTransform = CGAffineTransform.identity
        var bounds: CGRect = CGRect(x: 0, y: 0, width: width, height: height)
        if width > kMaxResolution || height > kMaxResolution {
            let ratio: CGFloat = width / height
            if ratio > 1 {
                bounds.size.width = kMaxResolution
                bounds.size.height = (bounds.size.width / ratio)
            } else {
                bounds.size.height = kMaxResolution
                bounds.size.width = (bounds.size.height * ratio)
            }
        }
        let scaleRatio: CGFloat = bounds.size.width / width
        let imageSize: CGSize = CGSize(width: CGFloat(imgRef.width), height: CGFloat(imgRef.height))
        var boundHeight: CGFloat
        let orient: UIImage.Orientation = image.imageOrientation
        switch orient {
        case UIImage.Orientation.up:
            transform = CGAffineTransform.identity
        case UIImage.Orientation.upMirrored:
            transform = CGAffineTransform(translationX: imageSize.width, y: 0.0)
            transform = transform.scaledBy(x: -1.0, y: 1.0)
        case UIImage.Orientation.down:
            transform = CGAffineTransform(translationX: imageSize.width, y: imageSize.height)
            transform = transform.rotated(by: CGFloat(Double.pi))
        case UIImage.Orientation.downMirrored:
            transform = CGAffineTransform(translationX: 0.0, y: imageSize.height)
            transform = transform.scaledBy(x: 1.0, y: -1.0)
        case UIImage.Orientation.leftMirrored:
            boundHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = boundHeight
            transform = CGAffineTransform(translationX: imageSize.height, y: imageSize.width)
            transform = transform.scaledBy(x: -1.0, y: 1.0)
            transform = transform.rotated(by: CGFloat(3.0 * .pi / 2.0))
        case UIImage.Orientation.left:
            boundHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = boundHeight
            transform = CGAffineTransform(translationX: 0.0, y: imageSize.width)
            transform = transform.rotated(by: CGFloat(3.0 * .pi / 2.0))
        case UIImage.Orientation.rightMirrored:
            boundHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = boundHeight
            transform = CGAffineTransform(scaleX: -1.0, y: 1.0)
            transform = transform.rotated(by: CGFloat(.pi / 2.0))
        case UIImage.Orientation.right:
            boundHeight = bounds.size.height
            bounds.size.height = bounds.size.width
            bounds.size.width = boundHeight
            transform = CGAffineTransform(translationX: imageSize.height, y: 0.0)
            transform = transform.rotated(by: CGFloat(.pi / 2.0))
        default:
            break
        }
        UIGraphicsBeginImageContext(bounds.size)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        if orient == UIImage.Orientation.right || orient == UIImage.Orientation.left {
            context.scaleBy(x: -scaleRatio, y: scaleRatio)
            context.translateBy(x: -height, y: 0)
        } else {
            context.scaleBy(x: scaleRatio, y: -scaleRatio)
            context.translateBy(x: 0, y: -height)
        }
        context.concatenate(transform)
        UIGraphicsGetCurrentContext()?.draw(imgRef, in: CGRect(x: 0, y: 0, width: width, height: height))
        let imageCopy: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return imageCopy
    }
}
