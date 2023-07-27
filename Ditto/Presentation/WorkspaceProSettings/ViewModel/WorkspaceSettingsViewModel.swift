//
//  WorkspaceSettingsViewModel.swift
//  Ditto
//
//  Created by Abiya Joy on 26/05/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit

class WorkspaceSettingsViewModel {
    var arrWorkspaceSettings = [WorkspaceSettingsModel(titleText: FormatsString.mirroringReminderLabel, isEnabled: true), WorkspaceSettingsModel(titleText: FormatsString.cutNumberReminderLabel, isEnabled: true), WorkspaceSettingsModel(titleText: FormatsString.splicingNotificationLabel, isEnabled: false), WorkspaceSettingsModel(titleText: FormatsString.multidirSplicNotiLabel, isEnabled: false), WorkspaceSettingsModel(titleText: FormatsString.saveCalibPhotoLabel, isEnabled: false)]
    // MARK: FUNCTION LOGICS
    func callApi(parameters: [String: AnyObject], completion: @escaping() -> Void) {   // WS Settings screen API call
        let urlString = ApiUrlStrings.wsSettingsURL
        ServiceManagerProxy.shared.callPatchForWorkspaceSettings(urlStr: urlString, parameters: parameters) {
            completion()
        }
    }
    func getProSettingStatus(index: Int) -> String {   // Getting userDefault variables based on switch tap index
        switch index {
        case 0:
            return CommonConst.mirrorReminder
        case 1:
            return CommonConst.cuttingReminder
        case 2:
            return CommonConst.spliceReminder
        case 3:
            return CommonConst.spliceMultiplePieceReminder
        case 4:
            return CommonConst.saveCalibPhotoReminder
        default:
            return FormatsString.emptyString
        }
    }
    func createRequestBodyParams() -> [String: AnyObject] {   // Creating params for sending to API
        let param = ["\(self.getProSettingStatus(index: 0))": UserDefaults.standard.value(forKey: "\(self.getProSettingStatus(index: 0))"), "\(self.getProSettingStatus(index: 1))": UserDefaults.standard.value(forKey: "\(self.getProSettingStatus(index: 1))"), "\(self.getProSettingStatus(index: 2))": UserDefaults.standard.value(forKey: "\(self.getProSettingStatus(index: 2))"), "\(self.getProSettingStatus(index: 3))": UserDefaults.standard.value(forKey: "\(self.getProSettingStatus(index: 3))"), "\(self.getProSettingStatus(index: 4))": UserDefaults.standard.value(forKey: "\(self.getProSettingStatus(index: 4))")] as [String: AnyObject]
        return param
    }
}
