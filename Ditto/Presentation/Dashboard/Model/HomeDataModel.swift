//
//  HomeViewModel.swift
//  JoannTraceApp
//
//  Created by Abiya Joy on 26/03/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import Foundation

class HomeObject: NSObject {
    var iconImage = String()
    var titleText = String()
    var text = String()
    init(iconImage: String, titleText: String, text: String) {
        self.iconImage = iconImage
        self.titleText = titleText
        self.text = text
    }
}
