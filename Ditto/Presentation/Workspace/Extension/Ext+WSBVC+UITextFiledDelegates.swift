//
//  Ext+WSBVC+UITextFiledDelegates.swift
//  Ditto
//
//  Created by Gaurav.rajan on 30/07/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit

extension WorkspaceBaseViewController: UITextFieldDelegate {
    // TextField delegate functions
    func textFieldShouldReturn(_ nameProjectField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    func textFieldDidBeginEditing(_ nameProjectField: UITextField) {
        if self.objNewWorkSpaceBaseViewModel.screenHeight <= 375.0 || self.objNewWorkSpaceBaseViewModel.screenHeight <= 1366.0 {
            UIView.animate(withDuration: 0.3, animations: {
                self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y - 130, width: self.view.frame.size.width, height: self.view.frame.size.height)
            })
        }
    }
    func textFieldDidEndEditing(_ nameProjectField: UITextField) {
        if self.objNewWorkSpaceBaseViewModel.screenHeight <= 375.0 || self.objNewWorkSpaceBaseViewModel.screenHeight <= 1366.0 {
            UIView.animate(withDuration: 0.3, animations: {
                self.view.frame = CGRect(x: self.view.frame.origin.x, y: self.view.frame.origin.y + 130, width: self.view.frame.size.width, height: self.view.frame.size.height)
            })
        }
    }
}
