//
//  Proxy.swift
//  JoannTraceApp
//
//  Created by Gaurav Rajan on 14/04/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit
import Lottie

let KAppDelegate = UIApplication.shared.delegate as! AppDelegate
class Proxy {
    static var shared: Proxy {
        return Proxy()
    }
    fileprivate init() {}
    let keyWindow = UIApplication.shared.connectedScenes.flatMap {($0 as? UIWindowScene)?.windows ?? []}.first {$0.isKeyWindow}
    // MARK: - REGISTER NIB FOR TABLE VIEW
    func registerNib(_ tblView: UITableView, nibName: String, identifierCell: String) {
        let nib = UINib(nibName: nibName, bundle: nil)
        tblView.register(nib, forCellReuseIdentifier: identifierCell)
    }
    func registerCollViewNib(_ collView: UICollectionView, nibName: String, identifierCell: String) {
        let nib = UINib(nibName: nibName, bundle: nil)
        collView.register(nib, forCellWithReuseIdentifier: identifierCell)
    }
    func saveBMToken(authtoken: OCAuthToken) {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(authtoken) {
            UserDefaults.standard.set(encoded, forKey: CommonConst.ocAuthToken)
        }
    }
    func getBMToken() -> (token: String, expiryTime: Int) {
        var tokenn = String()
        var expirytime = Int()
        let defaults = UserDefaults.standard
        if let savedToken = defaults.object(forKey: CommonConst.ocAuthToken) as? Data {
            let decoder = JSONDecoder()
            if let token = try? decoder.decode(OCAuthToken.self, from: savedToken) {
                tokenn = token.accessToken
                expirytime = token.expiresIn
            }
        }
        return (tokenn, expirytime)
    }
    // MARK: - Get Auth Token SHA256
    func getAuthToken(credentials: String = FormatsString.emptyString) -> String {
        let sVal = credentials == FormatsString.emptyString ? "storefront:Testing4$" : credentials
        let kVal = self.getSecretKeyfromBase64() // == "" ? "DittoPatterns" : self.getSecretKeyfromBase64()
        var sha = FormatsString.emptyString
        let isProd = CommonConst.isProdCheck
        sha = !isProd ? sVal.data(using: .utf8)!.base64EncodedString() : sVal.hmacb64(algorithm: .SHA256, key: kVal)
        return sha
    }
    // MARK: - Save allWorkedPatterns
    func saveAllWorkedPatternsID(patternID: String) {
        let defaults = CommonConst.userDefault
        if let workedPatternsIDArray = defaults.value(forKey: CommonConst.allWorkerPatterns) as? [String] {
            var updatedworkedPatternsIDArray: [String] = workedPatternsIDArray
            if !updatedworkedPatternsIDArray.contains(patternID) && !patternID.isEmpty {
                updatedworkedPatternsIDArray.append(patternID)
            }
            defaults.set(updatedworkedPatternsIDArray, forKey: CommonConst.allWorkerPatterns)
        } else {
            var patternIDArray = [String]()
            if !patternIDArray.contains(patternID) && !patternID.isEmpty {
                patternIDArray.append(patternID)
            }
            defaults.set(patternIDArray, forKey: CommonConst.allWorkerPatterns)
        }
    }
    func getAllWorkedPatternsIDArray() -> [String] {
        if let workedPatternsIDArray = CommonConst.userDefault.value(forKey: CommonConst.allWorkerPatterns) as? [String] {
            return workedPatternsIDArray
        } else {
            return [FormatsString.emptyString]
        }
    }
    // MARK: - Delete all User Defaults
    func removeAllUserDefaults() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        CommonConst.userDefault.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        CommonConst.userDefault.synchronize()
    }
    // MARK: Get Fromatted Quick Notes
    func returnFormattedNotes(isForDBSave: Bool, notesStr: String)-> String {
        var updatedStr = String()
        if isForDBSave{
            updatedStr = notesStr.replacingOccurrences(of: "\\n", with: "\n")
        } else {
            updatedStr = notesStr.replacingOccurrences(of: "\n", with: "\\n")
        }
        return updatedStr
    }
    // MARK: - Tailornova Design Name
    func savetrailPatternDesignName(nameDict: [String: Any]) {
        CommonConst.userDefault.set(nameDict, forKey: CommonConst.trailPatternDesignName)
    }
    // MARK: - Get Secret Key
    func getSecretKeyfromBase64() -> String {
        var decodedString = String()
        if let secretKey = UserDefaults.standard.object(forKey: CommonConst.secretKey) as? String {
            let base64Encoded = "\(secretKey)"
            let decodedData = Data(base64Encoded: base64Encoded)!
            decodedString = String(data: decodedData, encoding: .utf8)!
        }
        return decodedString
    }
    // MARK: - Base URL
    func saveEnvValues(url: String, id: String, clientKey: String, server: String, siteUrl: String, tokenUrl: String, trackingId: String, isProd: Bool) {
        CommonConst.baseUrlConstant = url
        CommonConst.siteIdConstant = id
        CommonConst.clientKeyServerAutConstant = clientKey
        CommonConst.serverConstant = server
        CommonConst.siteURLConstant = siteUrl
        CommonConst.isProdCheck = isProd
        CommonConst.bmTokenURLConstant = tokenUrl
        CommonConst.trackingIdConstant = trackingId
    }
    // MARK: - Display Toast
    func displayStatusAlert(message: String) { // state: "DropState"){
        DispatchQueue.main.async {
            let viewc = StoryBoardType.alertWithImageAndButtons.storyboard.instantiateViewController(identifier: Constants.AlertWithImageAndButonsVCIdentifier) as AlertWithImageAndButtonsViewController
            viewc.alertArray = [ConnectivityUtils.failedImage, "\(message)", FormatsString.emptyString, AlertTitle.OKButton, FormatsString.emptyString]
            viewc.modalPresentationStyle = .overFullScreen
            viewc.onOKPressed = {
                Proxy.shared.keyWindow?.rootViewController?.dismiss(animated: false, completion: nil)
            }
            if Proxy.shared.keyWindow?.rootViewController?.presentedViewController == nil {
                Proxy.shared.keyWindow?.rootViewController?.present(viewc, animated: false, completion: nil)
            }
        }
    }
    func showLottie() {
        let jsonName = ConnectivityUtils.jsonLoader
        let animation = Animation.named(jsonName)
        animView = AnimationView(animation: animation)
        let currentView = KAppDelegate.window?.rootViewController?.view
        animView.frame.size = currentView!.frame.size
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
                currentView!.addSubview(animView)
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
    func dismissLottie() {
        DispatchQueue.main.async {
            animView.stop()
            animView.removeFromSuperview()
            animView.animation = nil
            KAppDelegate.window?.rootViewController?.view.viewWithTag(TagValue.lottieTag)?.removeFromSuperview()
        }
    }
    func openSettingApp() {
        Proxy.shared.keyWindow?.rootViewController?.noNetworkConnectionAlert()
    }
    func getIntegerValuefromString(str: String) -> Int {
        return Int(str.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()) ?? 0
    }
    func stringifyWSJson(json: Any, prettyPrinted: Bool = false) -> String {
        var options: JSONSerialization.WritingOptions = []
        if prettyPrinted {
            options = JSONSerialization.WritingOptions.prettyPrinted
        }
        do {
            let data = try JSONSerialization.data(withJSONObject: json, options: options)
            if let string = String(data: data, encoding: String.Encoding.utf8) {
                return string
            }
        } catch {
        }
        return ""
    }
    func DarwinVersion() -> String {
        var sysinfo = utsname()
        uname(&sysinfo)
        let dv = String(bytes: Data(bytes: &sysinfo.release, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
        return "Darwin/\(dv)"
    }
    func CFNetworkVersion() -> String {
        let dictionary = Bundle(identifier: "com.apple.CFNetwork")?.infoDictionary!
        let version = dictionary?["CFBundleShortVersionString"] as! String
        return "CFNetwork/\(version)"
   }
   func deviceVersion() -> String {
        return "iOS/\(UIDevice.current.systemVersion)"
   }
   func deviceName() -> String {
        var sysinfo = utsname()
        uname(&sysinfo)
        return String(bytes: Data(bytes: &sysinfo.machine, count: Int(_SYS_NAMELEN)), encoding: .ascii)!.trimmingCharacters(in: .controlCharacters)
   }
   func appVersion() -> String {
        let dictionary = Bundle.main.infoDictionary!
        let version = dictionary["CFBundleShortVersionString"] as! String
        return "App/\(version)"
   }
}
