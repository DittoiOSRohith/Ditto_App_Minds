//
//  Ext+RotationDropDownTableView.swift
//  Ditto
//
//  Created by abiya.joy on 27/03/23.
//  Copyright © 2023 Infosys. All rights reserved.
//

import UIKit

extension WorkspaceBaseViewController: UITableViewDelegate, UITableViewDataSource {
    // table view functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.objNewWorkSpaceBaseViewModel.rotationList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tableViewCell = UITableViewCell()
        if let cell = self.objNewWorkSpaceBaseViewModel.tableView.dequeueReusableCell(withIdentifier: ReusableCellIdentifiers.customListIdentifier, for: indexPath) as? CustomisedListCell {
            if indexPath.row < self.objNewWorkSpaceBaseViewModel.rotationList.count && indexPath.row >= 0 {
                cell.selectionImage.backgroundColor = .clear
                let size: CGFloat = UIDevice.isPhone ? 14 : 22
                let font = CustomFont.avenirLtProRegular(size: size)
                let combination = NSMutableAttributedString()
                combination.append(NSMutableAttributedString(string: self.objNewWorkSpaceBaseViewModel.rotationList[indexPath.row], attributes: [NSAttributedString.Key.font: font ?? UIFont.systemFont(ofSize: size )]))
                cell.nameLabel.attributedText = combination
                cell.nameLabel.leftAnchor.constraint(equalTo: self.objNewWorkSpaceBaseViewModel.tableView.leftAnchor, constant: 3).isActive = true
                tableViewCell = cell
            }
        }
        return tableViewCell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIDevice.isPad ? 37 : 27
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < self.objNewWorkSpaceBaseViewModel.rotationList.count && indexPath.row >= 0 {
            self.objNewWorkSpaceBaseViewModel.rotationSelection = indexPath.row
            self.workspaceAreaView.rotateDropDowniPhoneButton.setTitle(self.objNewWorkSpaceBaseViewModel.rotationList[indexPath.row], for: .normal)
            self.workspaceAreaView.rotateDropDowniPadButton.setTitle(self.objNewWorkSpaceBaseViewModel.rotationList[indexPath.row], for: .normal)
            self.removeRotateListView()
            self.rotateButtonFunction()
        }
    }
}
