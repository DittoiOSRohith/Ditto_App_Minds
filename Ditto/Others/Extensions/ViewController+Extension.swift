//
//  ViewController+Extension.swift
//  WorkBench
//
//  Created by Infosys on 03/10/19.
//  Copyright © 2019 Infosys. All rights reserved.
//

import Foundation
import UIKit
import CryptoSwift
import Lottie

var animView = AnimationView()
extension UIAlertController {
    private static var globalPresentationWindow: UIWindow?
    func presentGlobally(animated: Bool, completion: (() -> Void)?) {
        UIAlertController.globalPresentationWindow = UIWindow(frame: UIScreen.main.bounds)
        UIAlertController.globalPresentationWindow?.rootViewController = UIViewController()
        UIAlertController.globalPresentationWindow?.windowLevel = UIWindow.Level.alert + 1
        UIAlertController.globalPresentationWindow?.backgroundColor = .clear
        UIAlertController.globalPresentationWindow?.makeKeyAndVisible()
        UIAlertController.globalPresentationWindow?.rootViewController?.present(self, animated: animated, completion: completion)
    }
    open override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        UIAlertController.globalPresentationWindow?.isHidden = true
        UIAlertController.globalPresentationWindow = nil
    }
}
@available(iOS 13.0, *)
extension String {
    func aesEncrypt(key: String = Constants.encryptKEY, ivVal: String = Constants.ivKEY) -> String {
        if let data = self.data(using: String.Encoding.utf8) {
            do {
                let enc = try AES(key: key, iv: ivVal, padding: .pkcs7).encrypt(data.bytes)
                let encData = Data(bytes: enc, count: Int(enc.count))
                let base64String: String = encData.base64EncodedString(options: NSData.Base64EncodingOptions(rawValue: 0))
                return base64String
            } catch _ {
                return FormatsString.emptyString
            }
        }
        return FormatsString.emptyString
    }
    // MARK: - Decrypt AES Method
    // This method will decrypt the Cipher string
    func aesDecrypt(key: String = Constants.encryptKEY, ivVal: String = Constants.ivKEY) -> String {
        if let data = Data(base64Encoded: self, options: Data.Base64DecodingOptions.init(rawValue: 0)) {
            do {
                let dec = try AES(key: key, iv: ivVal, padding: .pkcs7).decrypt(data.bytes)
                let decData = Data(bytes: dec, count: Int(dec.count))
                let result = String(data: decData, encoding: .utf8)
                return result ?? FormatsString.emptyString
            } catch _ {
                return FormatsString.emptyString
            }
        }
        return FormatsString.emptyString
    }
}
extension Data {
    var bytes: [UInt8] {
        return [UInt8](self)
    }
}
extension UIViewController {
    func showLottie() {
        let jsonName = ConnectivityUtils.jsonLoader
        let animation = Animation.named(jsonName)
        animView = AnimationView(animation: animation)
        if var currentView = KAppDelegate.window?.rootViewController?.view {
            animView.frame.size = currentView.frame.size
            animView.tag = 1993
            let anv = KAppDelegate.window?.rootViewController?.view.viewWithTag(TagValue.lottieTag)
            if anv != nil {
                animView.contentMode = .center
                animView.loopMode = .loop
                animView.play { _ in
                    DispatchQueue.main.async {
                        animView.removeFromSuperview()
                    }
                }
            } else {
                DispatchQueue.main.async {
                    KAppDelegate.window?.rootViewController?.view.addSubview(animView)
                    if currentView != self.view {
                        currentView = self.view
                    }
                    currentView.addSubview(animView)
                    animView.contentMode = .center
                    animView.loopMode = .loop
                    animView.play { _ in
                        DispatchQueue.main.async {
                            animView.removeFromSuperview()
                        }
                    }
                }
            }
        }
    }
    func dismissLottie() {
        DispatchQueue.main.async {
            animView.stop()
            animView.removeFromSuperview()
            self.view.viewWithTag(TagValue.lottieTag)?.removeFromSuperview()
            KAppDelegate.window?.rootViewController?.view.viewWithTag(TagValue.lottieTag)?.removeFromSuperview()
        }
    }
    func showNeedBLEAlert() { // TRAC_564
        DispatchQueue.main.async {
            let viewc = Constants.AlertWithTwoButtonsAndTitle.instantiateViewController(identifier: Constants.AlertWithTwoButonsTitleVCIdentifier) as AlertWithTwoButtonsAndTitleViewController
            viewc.alertArray = [ConnectivityMessages.titleConnectivity, ConnectivityMessages.needBLEDescription, AlertTitle.LATER, AlertTitle.SETTINGS]
            viewc.modalPresentationStyle = .overFullScreen
            if self.presentedViewController == nil {
                self.present(viewc, animated: true, completion: nil)
            }
        }
    }
    func noNetworkConnectionAlert() {
        DispatchQueue.main.async {
            let viewc = Constants.AlertWithTwoButtonsAndTitle.instantiateViewController(identifier: Constants.AlertWithTwoButonsTitleVCIdentifier) as AlertWithTwoButtonsAndTitleViewController
            viewc.alertArray = [AlertMessage.noConnectionTitle, AlertMessage.noConnectionDescription, AlertTitle.LATER, AlertTitle.SETTINGS]
            viewc.modalPresentationStyle = .overFullScreen
            if self.presentedViewController == nil {
                self.present(viewc, animated: true, completion: nil)
            }
        }
    }
    func showNeedWiFiAlert() { // TRAC_564
        DispatchQueue.main.async {
            let viewc = Constants.AlertWithTwoButtonsAndTitle.instantiateViewController(identifier: Constants.AlertWithTwoButonsTitleVCIdentifier) as AlertWithTwoButtonsAndTitleViewController
            viewc.alertArray = [ConnectivityMessages.titleConnectivity, ConnectivityMessages.needWiFiDescription, AlertTitle.LATER, AlertTitle.SETTINGS]
            viewc.modalPresentationStyle = .overFullScreen
            if self.presentedViewController == nil {
                self.present(viewc, animated: true, completion: nil)
            }
        }
    }
}
extension UIView {
    func addShadow() {
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 5.0
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        self.layer.shadowOpacity = 0.9
    }
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}
extension UserDefaults {
    func object<T: Codable>(_ type: T.Type, with key: String, usingDecoder decoder: JSONDecoder = JSONDecoder()) -> T? {
        guard let data = self.value(forKey: key) as? Data else { return nil }
        return try? decoder.decode(type.self, from: data)
    }
    func set<T: Codable>(object: T, forKey key: String, usingEncoder encoder: JSONEncoder = JSONEncoder()) {
        let data = try? encoder.encode(object)
        self.set(data, forKey: key)
    }
}
