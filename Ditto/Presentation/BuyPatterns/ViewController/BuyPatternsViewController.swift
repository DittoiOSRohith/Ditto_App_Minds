//
//  BuyPatternsViewController.swift
//  JoannTraceApp
//
//  Created by Shefrin Hakeem on 06/08/20.
//  Copyright © 2020 Infosys. All rights reserved.
//

import UIKit

class BuyPatternsViewController: UIViewController {
    //MARK: UI COMPONENT OUTLETS
    @IBOutlet weak var comingSoonMessageLabel: UILabel!
    //MARK: VARIABLE DECLARATION
    var comingSoonMessage = FormatsString.emptyString
    //MARK: View Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavTitle()
        self.comingSoonMessageLabel.text = self.comingSoonMessage
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
}
