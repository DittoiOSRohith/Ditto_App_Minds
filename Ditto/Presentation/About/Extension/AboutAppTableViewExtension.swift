//
//  AboutAppTableViewExtension.swift
//  Ditto
//
//  Created by abiya.joy on 29/09/22.
//  Copyright © 2022 Infosys. All rights reserved.
//

import UIKit

extension AboutAppAndPolicyViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: Table view functions
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tableViewCell = UITableViewCell()
        if let cell = tableView.dequeueReusableCell(withIdentifier: ReusableCellIdentifiers.aboutCellIdentifier, for: indexPath) as? AboutCell {
            cell.aboutLabel.attributedText = self.objPrivacyPolicyViewModel.policyContent.htmlToAttributedString
            tableViewCell = cell
        }
        return tableViewCell
    }
}
