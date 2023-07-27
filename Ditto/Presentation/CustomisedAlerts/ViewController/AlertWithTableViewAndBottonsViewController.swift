//
//  AlertWithTableViewAndBottonsViewController.swift
//  Ditto
//
//  Created by Abiya Joy on 02/06/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit

class AlertWithTableViewAndBottonsViewController: UIViewController {
    //MARK: UI COMPONENT OUTLETS
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var alertView: UIView!
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var alertTitle: UILabel!
    @IBOutlet weak var deviceTableView: UITableView!
    //MARK: VARIABLE DECLARATION
    var alertArray = [String]()
    var newFolderTapped: (() -> Void)?
    var exsistingFolderTapped: ((_ folderName: String) -> Void)?
    var folderName = [String]()
    //MARK: View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.folderName.insert(FormatsString.createNewFolder, at: 0)
        self.refreshButton.setImage(UIImage(named: self.alertArray[0]), for: .normal)
        self.alertTitle.text = self.alertArray[1]
    }
    override func viewDidAppear(_ animated: Bool) {
        self.deviceTableView.flashScrollIndicators()
        self.setUI()
    }
    func setUI() {   // Setting UI view changes
        self.view.frame = UIScreen.main.bounds
        self.deviceTableView.layer.cornerRadius = 14
    }
    //MARK: UI COMPONENT ACTIONS
    @IBAction func refreshButtonClicked(_ sender: UIButton) {   // Refresh button action
        self.dismiss(animated: true, completion: nil)
    }
}
