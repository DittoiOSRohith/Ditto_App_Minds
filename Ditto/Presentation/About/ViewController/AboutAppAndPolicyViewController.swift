//
//  AboutAppAndPolicyViewController.swift
//  Ditto
//
//  Created by Shefrin Hakeem on 14/05/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit
class AboutCell: UITableViewCell {
    @IBOutlet weak var aboutLabel: UILabel!
}

class AboutAppAndPolicyViewController: UIViewController {
    // MARK: UI COMPONENT OUTLETS
    @IBOutlet weak var tableView: UITableView!
    // MARK: VARIABLE DECLARATION
    var objPrivacyPolicyViewModel = AboutAppViewModel()
    // MARK: View Life Cycle Method
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavTitle()
        self.showLottie()
        self.objPrivacyPolicyViewModel.getContentForAboutAppScreen { _ in
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.view.viewWithTag(TagValue.lottieTag)?.removeFromSuperview()
            }
        }
    }
}
