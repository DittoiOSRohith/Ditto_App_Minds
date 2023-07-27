//
//  AccountSettingViewModel.swift
//  Ditto
//
//  Created by Gokul Ramesh on 02/02/22.
//  Copyright © 2022 Infosys. All rights reserved.
//

import UIKit

class AccountSettingViewModel {
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
    func accountDeletionLogic() {   // Delete account related userdefault and DB changes
        DatabaseHelper().deleteAllRowsFromTable(tableName: DBEntities.userDb)
        DatabaseHelper().deleteAllRowsFromTable(tableName: DBEntities.instructionDb)
        Proxy.shared.removeAllUserDefaults()
        CommonConst.accessTokenText = FormatsString.emptyString
        CommonConst.userDefault.synchronize()
        CommonConst.navCheckValue = 0
        CommonConst.guestUserCheck = false
    }
}
