//
//  WorkspaceSettingsTableViewExtension.swift
//  Ditto
//
//  Created by abiya.joy on 29/09/22.
//  Copyright © 2022 Infosys. All rights reserved.
//

import UIKit
import Alamofire

extension WorkspaceSettingsViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: Table view functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.objWorkspaceSettingsViewModel.arrWorkspaceSettings.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tableViewCell = UITableViewCell()
        if indexPath.row < self.objWorkspaceSettingsViewModel.arrWorkspaceSettings.count && indexPath.row >= 0 {
            if let cell = tableView.dequeueReusableCell(withIdentifier: ReusableCellIdentifiers.workspaceSettingsTableViewCellIdentifier) as? WorkspaceSettingsTableViewCell {
                let dictData = self.objWorkspaceSettingsViewModel.arrWorkspaceSettings[indexPath.row]
                cell.settingsTitleText.text = dictData.titleText
                cell.settingsStatusSwitch.isOn = (CommonConst.userDefault.value(forKey: self.objWorkspaceSettingsViewModel.getProSettingStatus(index: indexPath.row)) as? Bool) ?? true
                cell.settingsStatusSwitch.addTarget(self, action: #selector(self.tapSettingsSwitch(_ :)), for: .valueChanged)
                cell.settingsStatusSwitch.tag = indexPath.row
                tableViewCell = cell
            }
        }
        return tableViewCell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 0
        height = UIDevice.isPad ? 90 : 50
        return height
    }
    // MARK: UISwitch functionality for Workspace settings
    @objc func tapSettingsSwitch(_ sender: UISwitch) {   // Switch tap action
        if let index = sender.tag as Int? {
            if let manager = NetworkReachabilityManager(), manager.isReachable {
                sender.thumbTintColor = sender.isOn ? AppColor.safetyPinYellow : AppColor.needleGrey
                CommonConst.userDefault.setValue(sender.isOn, forKey: self.objWorkspaceSettingsViewModel.getProSettingStatus(index: index))
                self.objWorkspaceSettingsViewModel.callApi(parameters: self.objWorkspaceSettingsViewModel.createRequestBodyParams()) {
                    DispatchQueue.main.async {
                        self.settingsTableView.reloadData()
                    }
                }
            } else {
                sender.setOn(!sender.isOn, animated: true)
                ServiceManagerProxy.shared.displayerrorPopup(url: FormatsString.emptyString, responseError: AlertMessage.noConnectionDescription)
            }
        } else {
            ServiceManagerProxy.shared.displayerrorPopup(url: FormatsString.emptyString, responseError: AlertMessage.invalidEntry)
        }
    }
}
