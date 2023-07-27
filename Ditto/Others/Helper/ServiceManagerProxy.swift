//
//  ServiceManagerProxy.swift
//  Ditto
//
//  Created by Gaurav Rajan on 26/04/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import Alamofire
import UIKit

class ServiceManagerProxy {
    static var shared: ServiceManagerProxy {
        return ServiceManagerProxy()
    }
    let splashObj = SplashViewController()
    let guestUserStatus = CommonConst.guestUserCheck
    var wsSaveCalled: Bool = false
    fileprivate init() { }
    func authentication(urlStr: String, authParam: LoginParams, bodyParam: [String: AnyObject]? = nil, completion: @escaping (ApiResponse?) -> Void) {   // login authentication call
        if let manager = NetworkReachabilityManager(), manager.isReachable {
            Proxy.shared.showLottie()
            self.splashObj.splashViewModel.checkSessionManager { _ in }
            let credentialData = "\(authParam.email):\(authParam.password)".data(using: String.Encoding.utf8)!
            let base64CredentialsNU = credentialData.base64EncodedString()
            let headers: HTTPHeaders = [
                FormatsString.authHeaderKey: "Basic \(base64CredentialsNU)",
                FormatsString.acceptKey: FormatsString.contentKeyValue,
                FormatsString.contentHeaderKey: FormatsString.contentKeyValue]
            AF.request("\(Apis.baseUrl)\(urlStr)",
                       method: .post,
                       parameters: ["type": "credentials"],
                       encoding: JSONEncoding.default,
                       headers: headers )
            .responseJSON { response in
                if response.data != nil && response.error == nil {
                    if let dict = response.value as? [String: AnyObject] {
                        Proxy.shared.dismissLottie()
                        if response.response?.statusCode == 200 {
                            let res: ApiResponse?
                            res = ApiResponse(success: true, jsonData: response.data!, data: dict, message: dict["message"] as? String ?? AlertTitle.success)
                            completion(res!)
                        } else if response.response?.statusCode == 400 || response.response?.statusCode == 401 {
                            let dictData =  dict["fault"] as? [String: AnyObject]
                            self.displayerrorPopup(url: "\(Apis.baseUrl)\(urlStr)", responseError: (dictData!["message"] as? String)!)
                        } else {
                            self.statusHandler(response.response, data: response.data, error: response.error as NSError?)
                        }
                    } else {
                        self.displayerrorPopup(url: "\(Apis.baseUrl)\(urlStr)", responseError: AlertMessage.datafetchFailAlert)
                    }
                } else {
                    self.displayerrorPopup(url: "\(Apis.baseUrl)\(urlStr)", responseError: AlertMessage.errorFetchingData)
                }
            }
        } else {
            Proxy.shared.dismissLottie()
            Proxy.shared.openSettingApp()
        }
    }
    func deleteAccount(urlStr: String, completion: @escaping (ApiResponse?) -> Void) {  // delete account api call
        if let manager = NetworkReachabilityManager(), manager.isReachable {
            Proxy.shared.showLottie()
            self.splashObj.splashViewModel.checkSessionManager { _ in
            }
            let header: HTTPHeaders = [
                .authorization(bearerToken: Proxy.shared.getBMToken().token),
                .contentType(FormatsString.contentKeyValue)
            ]
            AF.request("\(Apis.baseUrl2)\(urlStr)",
                       method: .delete,
                       parameters: nil,
                       encoding: JSONEncoding.default,
                       headers: header ).responseJSON { response in
                if response.error == nil {
                    Proxy.shared.dismissLottie()
                    if let dict = response.value as? [String: AnyObject] {
                        let dictData = dict["fault"] as? [String: AnyObject]
                        ServiceManagerProxy.shared.displayerrorPopup(url: "\(Apis.baseUrl2)\(urlStr)", responseError: (dictData!["message"] as? String)!)
                    } else {
                        let res: ApiResponse?
                        res = ApiResponse(success: true, jsonData: nil, data: nil, message: "Success" as String? ?? AlertTitle.success)
                        completion(res!)
                    }
                } else {
                    Proxy.shared.dismissLottie()
                    KAppDelegate.window?.rootViewController?.view.viewWithTag(TagValue.lottieTag)?.removeFromSuperview()
                    ServiceManagerProxy.shared.displayerrorPopup(url: "\(Apis.baseUrl2)\(urlStr)", responseError: response.error!.localizedDescription)
                }
            }
        } else {
            Proxy.shared.openSettingApp()
            Proxy.shared.dismissLottie()
        }
    }
    func postData(urlStr: String, params: [String: Any]? = nil, showIndicator: Bool = true, forMyLib: Bool = true, shouldPassAuth: Bool = true, completion: @escaping (ApiResponse?) -> Void) {
        if let manager = NetworkReachabilityManager(), manager.isReachable {
            if !self.guestUserStatus {
                if showIndicator {
                    Proxy.shared.showLottie()
                }
                let authKey = shouldPassAuth ? ("\(FormatsString.basicTokenKey)\(Proxy.shared.getAuthToken())") : ("\(FormatsString.bearerTokenKey)\(Proxy.shared.getBMToken().token)")
                self.splashObj.splashViewModel.checkSessionManager { _ in
                }
                let finalurl = forMyLib ? urlStr : "\(Apis.baseUrl)\(urlStr)"
                AF.request(finalurl,
                           method: .post,
                           parameters: params!,
                           encoding: JSONEncoding.default,
                           headers: [FormatsString.authHeaderKey: "\(authKey)", FormatsString.userAgentKey: "\(AppInfo.userAgent)"])
                .responseJSON { response in
                    defer {
                        Proxy.shared.dismissLottie()
                        KAppDelegate.window?.rootViewController?.view.viewWithTag(TagValue.lottieTag)?.removeFromSuperview()
                    }
                    if response.data != nil && response.error == nil {
                        if let dict = response.value as? [String: AnyObject] {
                            do {
                                _ =  try JSONSerialization.jsonObject(with: response.data!, options: .fragmentsAllowed) as! [String: AnyObject]
                            } catch _ as NSError {
                            }
                            if response.response?.statusCode == 200 {
                                let res: ApiResponse?
                                res = ApiResponse(success: true, jsonData: response.data!, data: dict, message: "success" as String? ?? AlertTitle.success)
                                completion(res!)
                            } else if response.response?.statusCode == 400 {
                                self.displayerrorPopup(url: "\(Apis.baseUrl2)\(urlStr)", responseError: dict["errorMsg"] as? String ?? AlertTitle.error)
                            } else if response.response?.statusCode == 401 {
                                self.splashObj.splashViewModel.getBMToken { (status, _)  in
                                    if status {
                                        ServiceManagerProxy.shared.postData(urlStr: urlStr, params: params, showIndicator: showIndicator, forMyLib: forMyLib, shouldPassAuth: shouldPassAuth, completion: {_ in })
                                    }
                                }
                            } else {
                                self.statusHandler(response.response, data: response.data, error: response.error as NSError?)
                            }
                        } else {
                            self.displayerrorPopup(url: "\(Apis.baseUrl2)\(urlStr)", responseError: AlertMessage.datafetchFailAlert)
                        }
                    } else {
                        Proxy.shared.dismissLottie()
                        KAppDelegate.window?.rootViewController?.view.viewWithTag(TagValue.lottieTag)?.removeFromSuperview()
                        self.statusHandler(response.response, data: response.data, error: response.error as NSError?)
                    }
                }
            }
        } else {
            Proxy.shared.dismissLottie()
            Proxy.shared.openSettingApp()
        }
    }
    func putData(urlStr: String, params: [String: AnyObject]? = nil, showIndicator: Bool = true, completion: @escaping (ApiResponse?) -> Void) {   // create workspace api call
        self.wsSaveCalled = false
        if let manager = NetworkReachabilityManager(), manager.isReachable {
            if showIndicator {
                Proxy.shared.showLottie()
            }
            self.splashObj.splashViewModel.checkSessionManager {status in
                if !status {
                    self.splashObj.splashViewModel.getBMToken {_, _  in }
                }
            }
            AF.sessionConfiguration.timeoutIntervalForRequest = alamofirerequestTimeOut
            AF.request("\(Apis.baseUrl2)\(urlStr)",
                       method: .put,
                       parameters: params!,
                       encoding: JSONEncoding.default,
                       headers: [FormatsString.authHeaderKey: ("\(FormatsString.bearerTokenKey)\(Proxy.shared.getBMToken().token)"), FormatsString.contentHeaderKey: FormatsString.contentKeyValue]).responseJSON { response in
                if response.data != nil && response.error == nil {
                    if let dict = response.value as? [String: AnyObject] {
                        if (dict["fault"] as? [String: AnyObject]) != nil {
                            Proxy.shared.dismissLottie()
                            self.splashObj.splashViewModel.checkSessionManager(isfromWorkspace: true) {status in
                                if !status {
                                    Proxy.shared.dismissLottie()
                                    let res = ApiResponse(success: false, jsonData: nil, data: nil, message: AlertMessage.unableToSaveText)
                                    self.wsSaveCalled = true
                                    completion(res)
                                    return
                                }
                            }
                        }
                        if response.response?.statusCode == 200 || response.response?.statusCode == 201 {
                            Proxy.shared.dismissLottie()
                            let res: ApiResponse?
                            res = ApiResponse(success: true, jsonData: response.data!, data: dict, message: dict["success"] as? String ?? AlertTitle.success)
                            self.wsSaveCalled = true
                            completion(res!)
                        } else if response.response?.statusCode == 400 {
                            Proxy.shared.dismissLottie()
                            let res = ApiResponse(success: false, jsonData: nil, data: nil, message: dict["errorMsg"] as? String ?? AlertTitle.error)
                            self.wsSaveCalled = true
                            completion(res)
                        } else if response.response?.statusCode == 401 {
                            Proxy.shared.dismissLottie()
                            self.splashObj.splashViewModel.getBMToken { (status, _) in
                                if status {
                                    ServiceManagerProxy.shared.putData(urlStr: urlStr, params: params, showIndicator: showIndicator, completion: {res in
                                        completion(res)
                                    })
                                } else {
                                    Proxy.shared.dismissLottie()
                                    let res = ApiResponse(success: false, jsonData: nil, data: nil, message: AlertMessage.unableToSaveText)
                                    self.wsSaveCalled = true
                                    completion(res)
                                }
                            }
                            DispatchQueue.main.async {
                                if !self.wsSaveCalled {
                                    let res = ApiResponse(success: false, jsonData: nil, data: nil, message: AlertMessage.unableToSaveText)
                                    self.wsSaveCalled = true
                                    completion(res)
                                }
                            }
                        } else {
                            Proxy.shared.dismissLottie()
                            let res = ApiResponse(success: false, jsonData: nil, data: nil, message: AlertMessage.unableToSaveText)
                            self.wsSaveCalled = true
                            completion(res)
                        }
                    } else {
                        Proxy.shared.dismissLottie()
                        let res = ApiResponse(success: false, jsonData: nil, data: nil, message: AlertMessage.unableToSaveText)
                        self.wsSaveCalled = true
                        completion(res)
                    }
                } else {
                    Proxy.shared.dismissLottie()
                    let res = ApiResponse(success: false, jsonData: nil, data: nil, message: AlertMessage.unableToSaveText)
                    self.wsSaveCalled = true
                    completion(res)
                }
            }
        } else {
            Proxy.shared.dismissLottie()
            Proxy.shared.openSettingApp()
        }
    }
    func patchData(urlStr: String, params: [String: AnyObject]? = nil, showIndicator: Bool = true, completion: @escaping (ApiResponse?) -> Void) {  // update workspace api call
        self.wsSaveCalled = false
        if let manager = NetworkReachabilityManager(), manager.isReachable {
            if showIndicator {
                Proxy.shared.showLottie()
            }
            self.splashObj.splashViewModel.checkSessionManager(isfromWorkspace: true) {status in
                if !status {
                    self.splashObj.splashViewModel.getBMToken {_, _  in }
                }
            }
            let header: HTTPHeaders = [
                .authorization(bearerToken: Proxy.shared.getBMToken().token),
                .contentType(FormatsString.contentKeyValue)
            ]
            AF.sessionConfiguration.timeoutIntervalForRequest = alamofirerequestTimeOut
            AF.request("\(Apis.baseUrl2)\(urlStr)",
                       method: .patch,
                       parameters: params!,
                       encoding: JSONEncoding.default,
                       headers: header ).responseJSON { response in
                if response.data != nil && response.error == nil {
                    if let dict = response.value as? [String: AnyObject] {
                        if (dict["fault"] as? [String: AnyObject]) != nil {
                            Proxy.shared.dismissLottie()
                            self.splashObj.splashViewModel.checkSessionManager(isfromWorkspace: true) {status in
                                if !status {
                                    Proxy.shared.dismissLottie()
                                    let res = ApiResponse(success: false, jsonData: nil, data: nil, message: AlertMessage.unableToSaveText)
                                    self.wsSaveCalled = true
                                    completion(res)
                                }
                            }
                        }
                        if response.response?.statusCode == 200 {
                            Proxy.shared.dismissLottie()
                            let res: ApiResponse?
                            res = ApiResponse(success: true, jsonData: response.data!, data: dict, message: dict["success"] as? String ?? AlertTitle.success)
                            self.wsSaveCalled = true
                            completion(res!)
                        } else if response.response?.statusCode == 400 {
                            Proxy.shared.dismissLottie()
                            let res = ApiResponse(success: false, jsonData: nil, data: nil, message: dict["errorMsg"] as? String ?? AlertTitle.error)
                            self.wsSaveCalled = true
                            completion(res)
                        } else if response.response?.statusCode == 401 {
                            Proxy.shared.dismissLottie()
                            self.splashObj.splashViewModel.getBMToken { (status, _) in
                                if status {
                                    ServiceManagerProxy.shared.patchData(urlStr: urlStr, params: params, showIndicator: showIndicator, completion: {res in
                                        completion(res)
                                    })
                                } else {
                                    Proxy.shared.dismissLottie()
                                    let res = ApiResponse(success: false, jsonData: nil, data: nil, message: AlertMessage.unableToSaveText)
                                    self.wsSaveCalled = true
                                    completion(res)
                                }
                            }
                            DispatchQueue.main.async {
                                if !self.wsSaveCalled {
                                    let res = ApiResponse(success: false, jsonData: nil, data: nil, message: AlertMessage.unableToSaveText)
                                    self.wsSaveCalled = true
                                    completion(res)
                                }
                            }
                        } else {
                            Proxy.shared.dismissLottie()
                            let res = ApiResponse(success: false, jsonData: nil, data: nil, message: AlertMessage.unableToSaveText)
                            self.wsSaveCalled = true
                            completion(res)
                        }
                    } else {
                        Proxy.shared.dismissLottie()
                        let res = ApiResponse(success: false, jsonData: nil, data: nil, message: AlertMessage.unableToSaveText)
                        self.wsSaveCalled = true
                        completion(res)
                    }
                } else {
                    Proxy.shared.dismissLottie()
                    let res = ApiResponse(success: false, jsonData: nil, data: nil, message: AlertMessage.unableToSaveText)
                    self.wsSaveCalled = true
                    completion(res)
                }
            }
        } else {
            Proxy.shared.openSettingApp()
            Proxy.shared.dismissLottie()
        }
    }
    func getDataWS(urlStr: String, completion: @escaping (ApiResponse?) -> Void) {  // get workspace api call
        if let manager = NetworkReachabilityManager(), manager.isReachable {
            Proxy.shared.showLottie()
            AF.request("\(Apis.baseUrl2)\(urlStr)",
                       method: .get, parameters: nil,
                       encoding: JSONEncoding.default,
                       headers: [FormatsString.userAgentKey: "\(AppInfo.userAgent)"])
            .responseJSON { response in
                if response.data != nil && response.error == nil {
                    Proxy.shared.dismissLottie()
                    KAppDelegate.window?.rootViewController?.view.viewWithTag(TagValue.lottieTag)?.removeFromSuperview()
                    if let dict = response.value as? [String: AnyObject] {
                        if response.response?.statusCode == 200 {
                            let res: ApiResponse?
                            res = ApiResponse(success: true, jsonData: response.data!, data: dict, message: dict["message"] as? String ?? dict["success"] as? String ?? AlertTitle.success)
                            completion(res!)
                        } else if response.response?.statusCode == 400 {
                            Proxy.shared.displayStatusAlert(message: dict["error"] as? String ?? AlertTitle.error)
                        } else if response.response?.statusCode == 404 {
                            let res: ApiResponse?
                            res = ApiResponse(success: true,
                                              jsonData: response.data!,
                                              data: dict,
                                              message: dict["success"] as? String ?? AlertTitle.success)
                            completion(res!)
                        } else {
                            self.statusHandler(response.response, data: response.data, error: response.error as NSError?)
                        }
                    } else {
                        let res = ApiResponse(success: false, jsonData: nil, data: nil, message: AlertMessage.fetchSavedWSAlert)
                        completion(res)
                    }
                } else {
                    self.statusHandler(response.response, data: response.data, error: response.error as NSError?)
                }
            }
        } else {
            Proxy.shared.dismissLottie()
            KAppDelegate.window?.rootViewController?.view.viewWithTag(TagValue.lottieTag)?.removeFromSuperview()
            Proxy.shared.openSettingApp()
        }
    }
    func getData(urlStr: String, isfromVersionAPI: Bool = false, showIndicator: Bool = true, forpatternDesc: Bool = true, completion: @escaping (ApiResponse?) -> Void) {  // get data api call
        if let manager = NetworkReachabilityManager(), manager.isReachable {
            if showIndicator && forpatternDesc {
                Proxy.shared.showLottie()
            }
            var headers = HTTPHeaders()
            headers = [FormatsString.authHeaderKey: ("\(FormatsString.bearerTokenKey)\(Proxy.shared.getBMToken().token)"), FormatsString.userAgentKey: "\(AppInfo.userAgent)", FormatsString.xapiKey: FormatsString.xapiKeyValue]
            self.splashObj.splashViewModel.checkSessionManager { _ in
            }
            let finalurl = forpatternDesc ? urlStr : "\(Apis.baseUrl)\(urlStr)"
            AF.sessionConfiguration.timeoutIntervalForRequest = alamofirerequestTimeOut
            AF.request("\(finalurl)",
                       method: .get, parameters: nil,
                       encoding: JSONEncoding.default,
                       headers: isfromVersionAPI ? nil : headers)
            .responseJSON { response in
                defer {
                    Proxy.shared.dismissLottie()
                    KAppDelegate.window?.rootViewController?.view.viewWithTag(1993)?.removeFromSuperview()
                }
                if response.data != nil && response.error == nil {
                    if let dict = response.value as? [String: AnyObject] {
                        if response.response?.statusCode == 200 {
                            let res: ApiResponse?
                            res = ApiResponse(success: true, jsonData: response.data!, data: dict, message: dict["message"] as? String ?? dict["success"] as? String ?? AlertTitle.success)
                            completion(res!)
                        } else if response.response?.statusCode == 400 {
                            self.displayerrorPopup(url: "\(Apis.baseUrl2)\(urlStr)", responseError: dict["errorMsg"] as? String ?? AlertTitle.error)
                        } else if response.response?.statusCode == 401 {
                            self.splashObj.splashViewModel.getBMToken { (status,expiryTime) in
                                if status {
                                    ServiceManagerProxy.shared.getData(urlStr: urlStr, showIndicator: showIndicator, forpatternDesc: forpatternDesc, completion: {_ in })
                                }
                            }
                        } else {
                            self.statusHandler(response.response, data: response.data, error: response.error as NSError?)
                        }
                    } else {
                        Proxy.shared.displayStatusAlert(message: AlertMessage.datafetchFailAlert)
                    }
                } else {
                    Proxy.shared.dismissLottie()
                    KAppDelegate.window?.rootViewController?.view.viewWithTag(TagValue.lottieTag)?.removeFromSuperview()
                    self.statusHandler(response.response, data: response.data, error: response.error as NSError?)
                }
            }
        } else {
            Proxy.shared.dismissLottie()
            Proxy.shared.openSettingApp()
        }
    }
    func callPatchForWorkspaceSettings(urlStr: String, parameters: [String: AnyObject], completion: @escaping() -> Void) {  // WS settings screen api call
        defer {
            Proxy.shared.dismissLottie()
        }
        if let manager = NetworkReachabilityManager(), manager.isReachable {
            Proxy.shared.showLottie()
            self.splashObj.splashViewModel.checkSessionManager { _ in
            }
            let request = NSMutableURLRequest(url: NSURL(string: "\(Apis.baseUrl)\(urlStr)")! as URL)
            request.httpMethod = "PATCH"
            request.setValue(("\(FormatsString.bearerTokenKey)\(Proxy.shared.getBMToken().token)"), forHTTPHeaderField: FormatsString.authHeaderKey)
            do {
                let json = parameters
                let jsonData = try? JSONSerialization.data(withJSONObject: json)
                request.httpBody = jsonData
            }
            let task = URLSession.shared.dataTask(with: request as URLRequest) { (_, _, error) in
                if error != nil {
                    Proxy.shared.displayStatusAlert(message: "\(String(describing: error))" )
                    return
                } else {
                    completion()
                }
                return
            }
            task.resume()
        }
    }
    // MARK: - BM Token
    func generateSignature(action: String, timestamp: String, method: String, parameters: [String: Any]?) -> String {  // signature generation function
        let url = NSURL(string: Apis.BMTokenURL.appending(action))
        let emptyString = FormatsString.emptyString
        let method = method
        let domain = url?.host ?? FormatsString.emptyString
        let path = url?.path ?? FormatsString.emptyString
        var params = String()
        let signatureURL = "v=\(AppInfo.version)&o=ios&AccessKeyId=\(AppKeys.accessKeyId)\("&Timestamp=")\(timestamp)&Connect=\(AppKeys.server)"
        params = signatureURL
        let pass = FormatsString.DittoPatterns
        let stringToHash = "\(emptyString)\n\(pass)\n\(method)\n\(domain)\n\(path)\n\(params)"
        let trackingId = AppKeys.trackingId
        let signature = stringToHash.hmac(algorithm: .SHA256, key: trackingId)
        return signature
    }
    func getDittoVersion(timeStamp: String, fromHamburgerUpdate: Bool) {   // bm token api call
        Proxy.shared.showLottie()
        let signature = self.generateSignature(action: "/ditto/version", timestamp: timeStamp, method: "GET", parameters: nil)
        let versionURLfirst = "\(Apis.BMTokenURL)/ditto/version?v=\(AppInfo.version)&o=ios&AccessKeyId=\(AppKeys.accessKeyId)\("&Timestamp=")\(timeStamp)\("&Signature=")"
        let url = "\(versionURLfirst)\(signature)\(ApiUrlStrings.getBMTokenURLlast)"
        ServiceManagerProxy.shared.getData(urlStr: url, isfromVersionAPI: true, showIndicator: false) { response in
            if response!.success {
                DispatchQueue.main.async {
                    Proxy.shared.dismissLottie()
                }
                if let dictionaryData = response!.data!["response"] {
                    if let versionUpdate = dictionaryData.value(forKey: "version_update") as? Bool, let criticalUpdate = dictionaryData.value(forKey: "critical_update") as? Bool, let forceUpdate = dictionaryData.value(forKey: "force_update") as? Bool {
                        let bodyText = dictionaryData.value(forKey: "body") as? String ?? FormatsString.emptyString
                        let confirmText = dictionaryData.value(forKey: "confirm") as? String ?? FormatsString.emptyString
                        let confirmLink = dictionaryData.value(forKey: "confirm_link") as? String ?? FormatsString.emptyString
                        let cancelText = dictionaryData.value(forKey: "cancel") as? String ?? FormatsString.emptyString
                        if !fromHamburgerUpdate {
                            if !criticalUpdate && !forceUpdate {
                                return
                            }
                        }
                        self.softwareUpdateAvailableAlert(body: bodyText, confirm: confirmText, confirmLink: confirmLink, cancel: cancelText, force: forceUpdate, version: versionUpdate, critical: criticalUpdate)
                        CommonConst.versionAlertStatusOnLaunch = false
                    }
                }
            }
        }
    }
    func softwareUpdateAvailableAlert(body: String, confirm: String, confirmLink: String, cancel: String, force: Bool, version: Bool, critical: Bool) {  // software update alert
        DispatchQueue.main.async {
            let viewc = Constants.AlertWithImageAndButtons.instantiateViewController(identifier: Constants.AlertWithImageAndButonsVCIdentifier) as AlertWithImageAndButtonsViewController
            viewc.alertArray = [ImageNames.updateAvailableImage, body, cancel, confirm, FormatsString.emptyString]
            viewc.modalPresentationStyle = .overFullScreen
            viewc.screenType = ScreenTypeString.softwareUpdatePresent
            viewc.onUpdateNowPressed = {
                if force {
                    UIApplication.shared.open(NSURL(string: "\(confirmLink)")! as URL)
                } else {
                    Proxy.shared.keyWindow?.rootViewController?.dismiss(animated: false, completion: {
                        UIApplication.shared.open(NSURL(string: "\(confirmLink)")! as URL)
                    })
                }
            }
            viewc.onDismissPressed = {
                Proxy.shared.keyWindow?.rootViewController?.dismiss(animated: false, completion: nil)
            }
            if force {
                viewc.onDismissPressed = {
                    UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                }
            } else {
                if !version && !critical {
                    viewc.alertArray = [ConnectivityUtils.successImage, body, FormatsString.emptyString, AlertTitle.OKButton, FormatsString.emptyString]
                    viewc.onUpdateNowPressed = {
                        Proxy.shared.keyWindow?.rootViewController?.dismiss(animated: false, completion: nil)
                    }
                }
            }
            if Proxy.shared.keyWindow?.rootViewController?.presentedViewController == nil {
                Proxy.shared.keyWindow?.rootViewController?.present(viewc, animated: false, completion: nil)
            }
        }
    }
    func displayerrorPopup(url: String, responseError: String) {
        DispatchQueue.main.async {
            let viewc = Constants.AlertWithImageAndButtons.instantiateViewController(identifier: Constants.AlertWithImageAndButonsVCIdentifier) as AlertWithImageAndButtonsViewController
            viewc.alertArray = [ConnectivityUtils.failedImage, "\(responseError)", FormatsString.emptyString, AlertTitle.OKButton, FormatsString.emptyString]
            viewc.modalPresentationStyle = .overFullScreen
            viewc.onOKPressed = {
                Proxy.shared.keyWindow?.rootViewController?.dismiss(animated: false, completion: nil)
            }
            if Proxy.shared.keyWindow?.rootViewController?.presentedViewController == nil {
                Proxy.shared.keyWindow?.rootViewController?.present(viewc, animated: false, completion: nil)
            }
        }
    }
    func statusHandler(_ response: HTTPURLResponse?, data: Data?, error: NSError?) {
        Proxy.shared.dismissLottie()
        if let code = response?.statusCode {
            if code == 401 ||  code == 403 {
                CommonConst.accessTokenText = FormatsString.emptyString
                UserDefaults.standard.synchronize()
            }
        } else {
            if data != nil {
                let myHTMLString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                Proxy.shared.displayStatusAlert(message: myHTMLString! as String)
            } else {
                if error?.code != 13 {
                    Proxy.shared.displayStatusAlert(message: AlertMessage.serverErrorMessage)
                }
            }
        }
    }
    func getTailornovaPatternDetailsFrom(urlStr: String, completion: @escaping (ApiResponse?) -> Void) {  // tailornova api call
        if let manager = NetworkReachabilityManager(), manager.isReachable {
            self.splashObj.splashViewModel.checkSessionManager { _ in
            }
            let headers: HTTPHeaders = [FormatsString.xapiKey: FormatsString.xapiKeyValue]
            AF.request("\(urlStr)",
                       method: .get,
                       parameters: nil,
                       encoding: URLEncoding.httpBody,
                       headers: headers)
            .responseJSON { response in
                if response.data != nil && response.error == nil {
                    if let dict = response.value as? [String: AnyObject] {
                        if response.response?.statusCode == 200 {
                            let res: ApiResponse?
                            res = ApiResponse(success: true, jsonData: response.data!, data: dict, message: dict["success"] as? String ?? AlertTitle.success)
                            completion(res!)
                        } else if response.response?.statusCode == 400 {
                            Proxy.shared.displayStatusAlert(message: dict["error"] as? String ?? AlertTitle.error )
                        } else {
                            self.statusHandler(response.response, data: response.data, error: response.error as NSError?)
                        }
                    } else {
                        let res: ApiResponse?
                        res = ApiResponse(success: false, jsonData: nil, data: nil, message: AlertMessage.tailornovaAlertThree)
                        completion(res!)
                    }
                } else if response.data != nil {
                    let res: ApiResponse?
                    let error = NSString(data: response.data!, encoding: String.Encoding.utf8.rawValue)!
                    if error.contains("In progress") || error.contains("in progress") {
                        res = ApiResponse(success: false, jsonData: nil, data: nil, message: AlertMessage.tailornovaAlertOne)
                    } else {
                        res = ApiResponse(success: false, jsonData: nil, data: nil, message: AlertMessage.tailornovaAlertTwo + "\(error)")
                    }
                    completion(res!)
                } else {
                    let res: ApiResponse?
                    res = ApiResponse(success: false, jsonData: nil, data: nil, message: AlertMessage.tailornovaAlertThree)
                    completion(res!)
                }
            }
        }
    }
}
