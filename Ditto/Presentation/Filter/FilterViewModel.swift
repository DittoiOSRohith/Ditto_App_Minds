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
    // MARK: - Getting the filter datas as dictionary from plist for now.
    let path = Bundle.main.path(forResource: "filterForPatterns", ofType: "plist")
    // MARK: - Gettingt the filter datas as model from API call.
    func getFilterData(completion: @escaping() -> Void) {
        let paramDict = ["OrderFilter": ["purchasedPattern": false, "subscriptionList": false, "allQuery": true, "emailID": "subscustomerOne@gmail.com"], "ProductFilter": []] as [String: Any]
        ServiceManagerProxy.shared.postData(urlStr: "on/demandware.store/Sites-JoAnn-Site/default/TraceAppMyLibrary-Shows", params: paramDict, showIndicator: true) { (response) in
            if response!.success {
                DispatchQueue.main.async {
                    Proxy.shared.dismissLottie()
                }
                if let dictData = response!.data {
                    do {
                        if let dictData = dictData["filter"] as? NSDictionary {
                            print("Filter data: \(dictData)")
                            let objFilterModel = FilterModel()
                            objFilterModel.setData(dictData: dictData as! [String: AnyObject])
                        }
                        completion()
                        Proxy.shared.dismissLottie()
                    } catch {
                        print("done")
                    }
                }
                Proxy.shared.dismissLottie()
            }
        }
    }
}
