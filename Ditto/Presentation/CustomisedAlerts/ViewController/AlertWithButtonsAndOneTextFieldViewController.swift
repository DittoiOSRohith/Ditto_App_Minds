//
//  AlertWithButtonsAndOneTextFieldViewController.swift
//  Ditto
//
//  Created by Abiya Joy on 13/09/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit

class AlertWithButtonsAndOneTextFieldViewController: UIViewController {
    // MARK: UI COMPONENT OUTLETS
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var folderNameTextField: UITextField!
    @IBOutlet weak var alertTitle: UILabel!
    @IBOutlet weak var textFielOneTitle: UILabel!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    // MARK: VARIABLE DECLARATION 
    var alertArray = [String]()
    var fromScreen = String()
    var createFolder: (() -> Void)?
    var renameFolder: (() -> Void)?
    // MARK: View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.alertTitle.text = self.alertArray[0]
        self.textFielOneTitle.text = self.alertArray[1]
        self.rightButton.setTitle(self.alertArray[3], for: .normal)
        self.leftButton.setTitle(self.alertArray[4], for: .normal)
    }
    // MARK: UI COMPONENT ACTIONS
    @IBAction func rightButtonClicked(_ sender: UIButton) {   // Right button action
        if self.fromScreen == ScreenTypeString.myLibraryFolder {
            self.createFolder?()
        } else if self.fromScreen == ScreenTypeString.myLibraryRenameFolder {
            self.renameFolder?()
        }
    }
    @IBAction func leftButtonClicked(_ sender: UIButton) {   // Left button action
        self.dismiss(animated: true, completion: nil)
    }
}
