//
//  SplashViewModel.swift
//  Ditto
//
//  Created by Gokul Ramesh on 25/01/23.
//  Copyright © 2023 Infosys. All rights reserved.
//

import Foundation
import Alamofire
import UIKit

class SplashViewModel: NSObject {
    func logOutUser(viewController: UIViewController) {
        if !CommonConst.guestUserCheck {
            DatabaseHelper().deleteAllRowsFromTable(tableName: DBEntities.userDb)
            CommonConst.accessTokenText = FormatsString.emptyString
            UserDefaults.standard.synchronize()
        }
        CommonConst.myLibPatternCount = FormatsString.emptyString
        DatabaseHelper().deleteAllRowsFromTable(tableName: DBEntities.instructionDb)
        CommonConst.navCheckValue = 0
        CommonConst.guestUserCheck = false
        viewController.root(selectedStoryboard: .login, identifier: Constants.LoginViewControllerIdentifier)
        CommonConst.appUpdatedStatusCheck = true
        CommonConst.isInstructionSavedCheck = false
    }
    // MARK: Get BMToken
    func getBMToken(showloader: Bool = false, completion: @escaping (_ Status: Bool, _ expiryTime: Int) -> Void) {
        if let manager = NetworkReachabilityManager(), manager.isReachable {
            if showloader {
                Proxy.shared.showLottie()
            }
            let tStamp = "\(Int(Date().timeIntervalSince1970))"
            let sign = ServiceManagerProxy.shared.generateSignature(action: "/ditto/session", timestamp: tStamp, method: "GET", parameters: nil)
            let getBMTokenURLfirst = "\(Apis.BMTokenURL)\("/ditto/session?v=\(AppInfo.version)&o=ios&AccessKeyId=")\(AppKeys.accessKeyId)\("&Timestamp=")\(tStamp)\("&Signature=")"
            let sessionTokenURL = "\(getBMTokenURLfirst)\(sign)\(ApiUrlStrings.getBMTokenURLlast)"
            AF.request(sessionTokenURL, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { response in
                Proxy.shared.dismissLottie()
                KAppDelegate.window?.rootViewController?.view.viewWithTag(TagValue.lottieTag)?.removeFromSuperview()
                if response.response?.statusCode == 200 {
                    if response.data != nil && response.error == nil {
                        if let responseData = response.value as? [String: AnyObject] {
                            let response = responseData["response"] as? [String: Any] ?? [:]
                            if let accessToken = response["access_token"] as? String, let expiresIn = response["expires_in"] as? Int, let tokenType = response["token_type"] as? String {
                                let skVal = response["sk"] as? Int ?? 0
                                let token = OCAuthToken(accessToken: accessToken, expiresIn: expiresIn, tokenType: tokenType, skVal: skVal)
                                Proxy.shared.saveBMToken(authtoken: token)
                                UserDefaults.standard.set(Date(), forKey: lastSessionInitated)
                                UserDefaults.standard.synchronize()
                                completion(true, expiresIn)
                            } else {
                                completion(false, 0)
                            }
                        } else {
                            completion(false, 0)
                        }
                    } else {
                        completion(false, 0)
                    }
                } else {
                    completion(false, 0)
                }
            }
        } else {
            Proxy.shared.dismissLottie()
            Proxy.shared.openSettingApp()
            completion(false, 0)
        }
    }
    // MARK: Check for every 30 minutes to refresh Access token
    func checkSessionManager(isfromWorkspace: Bool = false, completion: @escaping (_ Status: Bool) -> Void) {   // Getting the last session initiated from the UserDefaults
        if UserDefaults.standard.object(forKey: lastSessionInitated) == nil {
            self.getBMToken { _, _  in
            }
        } else {
            if let lastInitiatedTime = UserDefaults.standard.object(forKey: lastSessionInitated) as? Date { // Getting the current time
                let now = Date()
                let diffComponents = Calendar.current.dateComponents([.minute], from: lastInitiatedTime, to: now) // Getting the difference to ensure the Expiry minutes timeout
                if let minutes = diffComponents.minute {
                    let authToken = Proxy.shared.getBMToken()
                    let expiryMinute: Int = authToken.expiryTime / 60
                    //            self.BMTokenExpiryMinute = expiryMinute
                    if minutes >= expiryMinute - 3 {   // Ensure the difference is less than 30 min
                        self.getBMToken(showloader: true) { (status, _)  in
                            completion(status)
                        }
                    } else {
                        if isfromWorkspace {
                            completion(true)
                        }
                    }
                }
            }
        }
    }
}
