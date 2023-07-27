//
//  Ext+FloatingPoint.swift
//  Ditto
//
//  Created by Gaurav Rajan on 21/04/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import Foundation

extension FloatingPoint {
    var degreesToRadians: Self { return self * .pi / 180 }
    var radiansToDegrees: Self { return self * 180 / .pi }
}
