//
//  LoginViewModel.swift
//  iOS_TraceJoAnn
//
//  Created by Infosys on 03/08/20.
//  Copyright © 2020 Infosys. All rights reserved.
//

import UIKit
import RxSwift

class LoginViewModel {
    //MARK: VARIABLE DECLARATION
    var forgotPasswordGesture = UITapGestureRecognizer()
    var signUpGesture = UITapGestureRecognizer()
    var seeMoreGesture = UITapGestureRecognizer()
    var loginImageName = String()
    var iconClick = true
    var landingModel: Landing?
    func getContentForLoginScreen(completion: @escaping(Landing) -> Void) {   // Login screen content fetching
        ServiceManagerProxy.shared.getData(urlStr: "\(ApiUrlStrings.landingScreenUrl)\(AppKeys.clientKeyServerAuth)", forpatternDesc: false) { response in
            if let resp = response {
                if resp.success {
                    DispatchQueue.main.async {
                        Proxy.shared.dismissLottie()
                    }
                    if resp.data != nil, let jsonData = resp.jsonData {
                        let jsonDecoder = JSONDecoder()
                        do {
                            self.landingModel = try jsonDecoder.decode(Landing.self, from: jsonData)
                            let landingArray: LandingContent = (self.landingModel?.landingContent)!
                            self.loginImageName = landingArray.imageUrll
                            CommonConst.userDefault.setValue(landingArray.customerCareePhonee, forKey: CommonConst.customerCareePhone)
                            CommonConst.userDefault.setValue(landingArray.customerCareEmaill, forKey: CommonConst.customerCareEmail)
                            CommonConst.userDefault.setValue(landingArray.customerCareeTimingg, forKey: CommonConst.customerCareeTiming)
                            CommonConst.userDefault.setValue(landingArray.videoUrll, forKey: CommonConst.demoVideoURL)
                            completion(self.landingModel!)
                        } catch {
                        }
                    }
                }
            }
        }
    }
    func hitLoginApi(postParam: LoginParams, completion: @escaping() -> Void) {   // Login API response saving
        let bodyParam = ["type": "credentials"] as [String: AnyObject]
        if postParam.isValidData() {
            ServiceManagerProxy.shared.authentication( urlStr: "\(ApiUrlStrings.loginApiUrl)\(AppKeys.clientKeyServerAuth)", authParam: postParam, bodyParam: bodyParam) { response in
                if let resp = response {
                    if resp.success {
                        DatabaseHelper().deleteAllRowsFromTable(tableName: DBEntities.userDb)
                        DatabaseHelper().insertNewRecordIntoEntity(DBEntities.userDb, withDict: ["username": postParam.email, "password": postParam.password, "settingsShowAgain": 0] as [String: AnyObject])
                        if let dictData = resp.data {
                            CommonConst.userDefault.setValue(dictData["c_subscriptionStatus"], forKey: CommonConst.subscriptionStatus)
                            CommonConst.userDefault.setValue(dictData["c_subscriptionPlanStartDate"], forKey: CommonConst.subscribedStartDate)
                            CommonConst.userDefault.setValue(dictData["c_subscriptionPlanEndDate"], forKey: CommonConst.subscribedEndDate)
                            CommonConst.userDefault.setValue(dictData["c_subscriptionValid"], forKey: CommonConst.subscriptionValid)
                            CommonConst.userDefault.setValue(dictData["login"], forKey: CommonConst.loginEmail)
                            CommonConst.userDefault.setValue(dictData["phone_home"], forKey: CommonConst.loginPhone)
                            CommonConst.userDefault.setValue(dictData["last_name"], forKey: CommonConst.lastName)
                            CommonConst.userDefault.setValue(dictData["first_name"], forKey: CommonConst.firstName)
                            CommonConst.userDefault.setValue(dictData["customer_id"], forKey: CommonConst.customerID)
                            if let customerNo = dictData["customer_no"] as? String {
                                CommonConst.customerNoText = customerNo
                            }
                            if let secretKey = dictData["c_encryptionKey"] as? String {
                                CommonConst.userDefault.set(secretKey, forKey: CommonConst.secretKey)
                            }
                            CommonConst.userDefault.set(dictData["c_cuttingReminder"] as? Bool, forKey: CommonConst.cuttingReminder)
                            CommonConst.userDefault.set(dictData["c_mirrorReminder"] as? Bool, forKey: CommonConst.mirrorReminder)
                            CommonConst.userDefault.set(dictData["c_spliceMultiplePieceReminder"] as? Bool, forKey: CommonConst.spliceMultiplePieceReminder)
                            CommonConst.userDefault.set(dictData["c_spliceReminder"] as? Bool, forKey: CommonConst.spliceReminder)
                            CommonConst.userDefault.set(dictData["c_saveCalibrationPhotos"] as? Bool, forKey: CommonConst.saveCalibPhotoReminder)
                            objUserModel.setData(dictData: dictData)
                        }
                        completion()
                    }
                }
            }
        }
    }
}
