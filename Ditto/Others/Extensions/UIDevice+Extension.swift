//
//  UIDevice+Extension.swift
//  JoannTraceApp
//
//  Created by Prabha Rajalakshmi N on 21/08/20.
//  Copyright © 2020 Infosys. All rights reserved.
//

import Foundation
import UIKit

public extension UIDevice {
    class var isPhone: Bool {
        return UIDevice.current.userInterfaceIdiom == .phone
    }
    class var isPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    var hasNotch: Bool {
        let keyWindow = UIApplication.shared.connectedScenes.flatMap { ($0 as? UIWindowScene)?.windows ?? []}.first { $0.isKeyWindow }
        let bottom = keyWindow?.safeAreaInsets.bottom ?? 0
        return bottom > 0
    }
}
