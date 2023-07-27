//
//  AlertWithTableViewAndBottonsExtension.swift
//  Ditto
//
//  Created by abiya.joy on 29/09/22.
//  Copyright © 2022 Infosys. All rights reserved.
//

import UIKit

extension AlertWithTableViewAndBottonsViewController: UITableViewDelegate, UITableViewDataSource {
    // MARK: Table view functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.folderName.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tableViewCell = UITableViewCell()
        if let cell = deviceTableView.dequeueReusableCell(withIdentifier: ReusableCellIdentifiers.devicesTableCellViewIdentifier, for: indexPath) as? DevicesTableCellView {
            if indexPath.row < self.folderName.count && indexPath.row >= 0 {
                cell.selectionStyle = .none
                cell.deviceNameLabel.text = self.folderName[indexPath.row]
                cell.deviceNameLabel.textColor = (indexPath.row == 0) ? CustomColor.red : UIColor.black
                let foldersImage = (indexPath.row == 0) ? ImageNames.newFolderRedwithPlusImage : ImageNames.folderGrayImage
                cell.folderImageView.image = UIImage(named: foldersImage)
                tableViewCell = cell
            }
        }
        return tableViewCell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.newFolderTapped?()
        } else {
            if indexPath.row < self.folderName.count && indexPath.row > 0 {
                self.exsistingFolderTapped?(self.folderName[indexPath.row])
            }
        }
    }
}
