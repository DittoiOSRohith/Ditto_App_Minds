//
//  SubscriptionsViewModel.swift
//  Ditto
//
//  Created by Gokul Ramesh on 22/06/22.
//  Copyright © 2022 Infosys. All rights reserved.
//

import Foundation
import UIKit

class SubscriptionsViewModel {
    // MARK: Initial Setup
    func subscriptionDaysLeft() -> String {   // Calculation of Subscription days left logic
        var relativeDays = 0
        if CommonConst.subscribeValid && CommonConst.subscribeEndDate != FormatsString.emptyString {
            let endDateGiven = CommonConst.subscribeEndDate
            let currentDate = Date()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = FormatsString.dateFormat
            if let convertedEndDate = dateFormatter.date(from: endDateGiven) {
                relativeDays = Calendar.current.dateComponents([.day], from: currentDate, to: convertedEndDate).day ?? 0
            }
        }
        relativeDays = (relativeDays >= 0) ? relativeDays : 0
        return "\(relativeDays)"
    }
    // MARK: Open Subscription page in Safari browser
    func gotoSubscriptionView() {   // Redirecting to renew subscription URL
        guard let url = URL(string: Apis.renewSubscription), !url.absoluteString.isEmpty else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}
