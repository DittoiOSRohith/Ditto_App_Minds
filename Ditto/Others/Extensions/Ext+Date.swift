//
//  Ext+Date.swift
//  Ditto
//
//  Created by Gaurav.rajan on 28/12/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit

extension Date {
    var millisecondsSince1970: Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    init(milliseconds: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
