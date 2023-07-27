//
//  AlertForCutConfirmationViewController.swift
//  Ditto
//
//  Created by Gaurav.rajan on 10/06/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit

class AlertForCutConfirmationViewController: UIViewController {
    //MARK: UI COMPONENT OUTLETS
    @IBOutlet weak var labelAlertTitle: UILabel!
    //MARK: VARIABLE DECLARATION
    typealias CompletionHandler = (_ isCompleted: Bool) -> Void
    var completion: CompletionHandler?
    //MARK: View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    override func viewWillAppear(_ animated: Bool) {
        labelAlertTitle.text = AlertMessage.wsCutAlertFirst + (self.title ?? FormatsString.emptyString) + AlertMessage.wsCutAlertSecond
    }
    //MARK: UI COMPONENT ACTION
    @IBAction func actionYes(_ sender: UIButton) {   // Yes action on Alert
        guard let finalComp =  completion else {
            return
        }
        finalComp(true)
    }
    @IBAction func actionNo(_ sender: UIButton) {   // No action on Alert
        guard let finalComp =  completion else {
            return
        }
        finalComp(false)
    }
}
