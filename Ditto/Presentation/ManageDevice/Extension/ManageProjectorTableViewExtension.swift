//
//  ManageProjectorTableViewExtension.swift
//  Ditto
//
//  Created by abiya.joy on 29/09/22.
//  Copyright © 2022 Infosys. All rights reserved.
//

import UIKit

extension ManageProjectorViewController: UITableViewDataSource, UITableViewDelegate {
    // Table view functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataViewModel.availableProjectors.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIDevice.isPad ? 150 : 100
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tableViewCell = UITableViewCell()
        if let cell = tableView.dequeueReusableCell(withIdentifier: ReusableCellIdentifiers.manageCellIdentifier, for: indexPath) as? ProjectorsListTableViewCell {
            cell.configureCell(index: indexPath, viewModel: self.dataViewModel)
            tableViewCell = cell
        }
        return tableViewCell
    }
}
extension UIView {
    var ManageProjectorViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.next
            if parentResponder is UIViewController {
                return parentResponder as? UIViewController
            }
        }
        return nil
    }
}
