//
//  Ext+MyLibrary+TextfieldDelegate.swift
//  Ditto
//
//  Created by Gokul Ramesh on 23/03/22.
//  Copyright © 2022 Infosys. All rights reserved.
//

import Foundation
import UIKit

extension MyLibrarryViewController: UITextFieldDelegate {
    //MARK: TextField Delegate Method
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.searchText {
            self.searchText.resignFirstResponder()
            if let searchValue = self.searchText.text as String? {
                self.filter(searchText: searchValue as String)
                return false
            }
        }
        return true
    }
}
