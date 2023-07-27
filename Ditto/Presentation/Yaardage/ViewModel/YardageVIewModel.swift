//
//  YardageVIewModel.swift
//  Ditto
//
//  Created by Gokul Ramesh on 22/11/22.
//  Copyright © 2022 Infosys. All rights reserved.
//

import UIKit

class YardageVIewModel {
    // MARK: - VARIABLE DECLARATION
    var notionDetails = String()
    var yardageDetails = String()
    var yardagePdfUrl = String()
    var patternTitle = String()
    var fileURL: URL!
    //MARK: FUNCTION LOGICS
    func loadPDFPath() -> URL? {   // Function to load PDF
        guard let path = self.fileURL else {
            return nil
        }
        return path
    }
}
