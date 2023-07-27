//
//  WorkspaceSettingsViewController.swift
//  Ditto
//
//  Created by Abiya Joy on 26/05/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit

class WorkspaceSettingsViewController: UIViewController {
    // MARK: UI COMPONENT OUTLETS
    @IBOutlet weak var settingsTableView: UITableView!
    // MARK: VARIABLE DECLARATION
    var objWorkspaceSettingsViewModel = WorkspaceSettingsViewModel()
    // MARK: View Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = FormatsString.workspaceSettingsLabel
        self.configureNavTitle()
        self.settingsTableView.tableFooterView = UIView(frame: .zero)
    }
}
