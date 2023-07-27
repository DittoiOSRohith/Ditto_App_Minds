//
//  WorkspaceSettingsModel.swift
//  Ditto
//
//  Created by Abiya Joy on 27/05/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import Foundation

class WorkspaceSettingsModel: NSObject {
    var titleText = String()
    var isEnabled = Bool()
    init(titleText: String, isEnabled: Bool) {
        self.titleText = titleText
        self.isEnabled = isEnabled
    }
}
