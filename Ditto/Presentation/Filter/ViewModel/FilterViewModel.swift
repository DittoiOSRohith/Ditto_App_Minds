//
//  FilterViewModel.swift
//  Ditto
//
//  Created by niranjan on 19/05/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import Foundation
import UIKit

class FilterViewModel: NSObject {
    var patternDict: NSDictionary?
    // MARK: - Gettingt the filter datas as model from API call.
    func getFilterData(completion: @escaping() -> Void) {
        //  *** TRIAL PATTERNS REMOVED IN PRODUCTION AS PER CLIENT FEEDBACK, FOR THAT allQuery IS KEPT AS FALSE*//
        let paramDict = ["OrderFilter": ["purchasedPattern": true, "subscriptionList": true, "allQuery": false, "emailID": "subscustomerOne@gmail.com"],
                         "ProductFilter": []] as [String: Any]
        ServiceManagerProxy.shared.postData(urlStr: ApiUrlStrings.filterUrl, params: paramDict, forMyLib: false, shouldPassAuth: false) { response in
            if let responseData = response {
                if responseData.success {
                    DispatchQueue.main.async {
                        Proxy.shared.dismissLottie()
                    }
                    if let dictData = responseData.data {
                        do {
                            if let dictData = dictData["filter"] as? NSDictionary {
                                let objFilterModel = FilterModel()
                                objFilterModel.setData(dictData: dictData as! [String: AnyObject])
                            }
                            completion()
                            Proxy.shared.dismissLottie()
                        }
                    }
                    Proxy.shared.dismissLottie()
                }
            }
        }
    }
    func removeEmptyArrayObjects(dict: [String: [String]]) -> [String: [String]] {
        var temp = dict
        for item in dict where item.value.isEmpty {
            temp.removeValue(forKey: item.key)
        }
        return temp
    }
}
