//
//  FaqViewModel.swift
//  Ditto
//
//  Created by Gaurav Rajan on 06/05/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import Foundation

class FaqViewModel {
    //MARK: VARIABLE DECLARATION
    var isFromWorkspace = false
    var isFromCalibFailure = false
    var arrFaqModel = [FaqModel]()
    var arrGlossaryFaqModel = [FaqModel]()
    var arrVideoFaqModel = [FaqModel]()
    func getFaqData(completion: @escaping() -> Void) {   // API call for data
        Proxy.shared.showLottie()
        ServiceManagerProxy.shared.getData(urlStr: ApiUrlStrings.faqDataURL, forpatternDesc: false) { response in
            if let resp = response {
                if resp.success {
                    DispatchQueue.main.async {
                        Proxy.shared.dismissLottie()
                    }
                }
                if let dictionaryData = resp.data {
                    do {
                        if let dictData = dictionaryData["c_body"] as? NSDictionary {
                            if let faqData = dictData["FAQ"] as? NSArray {   // FAQ tab data fetching
                                for faq in faqData {
                                    let objFaqModel = FaqModel()
                                    objFaqModel.setData(dictData: faq as? [String: AnyObject] ?? [:])
                                    self.arrFaqModel.append(objFaqModel)
                                }
                            }
                            if let glossaryData = dictData["Glossary"] as? NSArray {   // Glossary tab data fetching
                                for glossary in glossaryData {
                                    let objFaqModel = FaqModel()
                                    objFaqModel.setData(dictData: glossary as? [String: AnyObject] ?? [:])
                                    self.arrGlossaryFaqModel.append(objFaqModel)
                                }
                            }
                            if let videoData = dictData["Videos"] as? NSArray {   // Video tab data fetching
                                for video in videoData {
                                    let objFaqModel = FaqModel()
                                    objFaqModel.setData(dictData: video as? [String: AnyObject] ?? [:])
                                    self.arrVideoFaqModel.append(objFaqModel)
                                }
                            }
                        }
                        completion()
                    }
                } else {
                    ServiceManagerProxy.shared.displayerrorPopup(url: ApiUrlStrings.faqDataURL, responseError: AlertMessage.apiFailedText)
                }
            }
        }
    }
}
