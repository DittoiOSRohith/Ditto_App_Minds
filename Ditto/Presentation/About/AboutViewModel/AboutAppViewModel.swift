//
//  AboutAppViewModel.swift
//  Ditto
//
//  Created by Shefrin Hakeem on 14/05/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit

class AboutAppViewModel {
    // MARK: VARIABLE DECLARATION
    var policyContent = String()
    var policyModel: PolicyModel?
    // MARK: FUNCTION LOGICS
    func getContentForAboutAppScreen(completion: @escaping(PolicyModel) -> Void) {   // API call for content
        ServiceManagerProxy.shared.getData(urlStr: ApiUrlStrings.aboutAppURL) { response in
            if let resp = response {
                if resp.success {
                    DispatchQueue.main.async {
                        Proxy.shared.dismissLottie()
                    }
                    if resp.data != nil , let jsonData = resp.jsonData {
                        let jsonDecoder = JSONDecoder()
                        do {
                            self.policyModel = try jsonDecoder.decode(PolicyModel.self, from: jsonData)
                            self.policyContent = self.policyModel?.policyContent ?? FormatsString.emptyString
                            completion(self.policyModel!)
                        } catch {
                        }
                    } else {
                        ServiceManagerProxy.shared.displayerrorPopup(url: ApiUrlStrings.aboutAppURL, responseError: AlertMessage.apiFailedText)
                    }
                } else {
                    ServiceManagerProxy.shared.displayerrorPopup(url: ApiUrlStrings.aboutAppURL, responseError: AlertMessage.apiFailedText)
                }
            }
        }
    }
}
