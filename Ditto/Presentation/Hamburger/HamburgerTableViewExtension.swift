//
//  HamburgerTableViewExtension.swift
//  Ditto
//
//  Created by abiya.joy on 29/09/22.
//  Copyright © 2022 Infosys. All rights reserved.
//

import UIKit

extension HamburgerViewController: UITableViewDelegate, UITableViewDataSource {
    //MARK: Table view functions
    
    
    


    func numberOfSections(in tableView: UITableView) -> Int {
        return self.objHamburgerViewModel.arrHamBurgerMenu.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.objHamburgerViewModel.arrHamBurgerMenu.count > section {
            let sections = self.objHamburgerViewModel.arrHamBurgerMenu[section]
            return sections.isOpened ? sections.subMenuItems.count : 0   // Row count for section with submenu
        } else {
            return 0
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var tableViewCell = UIView()
        if section < self.objHamburgerViewModel.arrHamBurgerMenu.count {
            let dictData = self.objHamburgerViewModel.arrHamBurgerMenu[section]
            if let headerCell = tableView.dequeueReusableCell(withIdentifier: ReusableCellIdentifiers.hamburgerTableCellViewIdentifier) as? HamburgerTableCellView {
                let line = UIImageView.init(frame: CGRect(x: 0, y: 0, width: self.hamTableView.frame.width, height: 0.5))
                line.backgroundColor = (section == 0) ? .white : CustomColor.lightGreyLine // CustomColor.lightGreyLine
                headerCell.hamCellImage.image = UIImage(named: dictData.iconImage)
                headerCell.hamCellLabel.text = dictData.titleText
                headerCell.hamArrowButton.isHidden = true
                headerCell.hamArrowButton.isEnabled = false
                headerCell.hamImageLeadingConstrint.constant = UIDevice.isPhone ? 20 : 30
                headerCell.hamCellLabel.textColor = .black
                if !dictData.subMenuItems.isEmpty {   // Arrow handling logic for submenu count greater than zero
                    let arrowImage = dictData.isOpened ? ImageNames.upArrowImage : ImageNames.downArrowImage
                    headerCell.hamArrowButton.setImage(UIImage(named: arrowImage), for: .normal)
                    headerCell.hamArrowButton.isHidden = false
                    headerCell.hamArrowButton.tag = section
                    headerCell.hamArrowButton.addTarget(self, action: #selector(expandCell(_ :)), for: .touchUpInside)
                    headerCell.hamArrowButton.isEnabled = true
                }
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(headerTapped(_ :)))
                tapGesture.numberOfTapsRequired = 1
                headerCell.tag = section
                headerCell.addGestureRecognizer(tapGesture)
                if section == self.objHamburgerViewModel.arrHamBurgerMenu.count - 1 {   // Color change for last entries in hamburger menu
                    if CommonConst.guestUserCheck {   // Blue Color for Sign In in Guest Flow
                        headerCell.hamCellLabel.text = FormatsString.signInLabel
                        headerCell.hamCellLabel.textColor = CustomColor.signIn
                        headerCell.hamCellImage.image = UIImage(named: ImageNames.signInImage)
                    } else {   // Red color for Log out in Regular flow
                        headerCell.hamCellLabel.textColor = CustomColor.red
                    }
                }
                headerCell.addSubview(line)
                tableViewCell = headerCell
            }
        }
        return tableViewCell
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var tableViewCell = UITableViewCell()
        if indexPath.section < self.objHamburgerViewModel.arrHamBurgerMenu.count {
            let dictData = self.objHamburgerViewModel.arrHamBurgerMenu[indexPath.section]
            if let cell = tableView.dequeueReusableCell(withIdentifier: ReusableCellIdentifiers.hamburgerTableCellViewIdentifier) as? HamburgerTableCellView {
                cell.hamArrowButton.isHidden = true
                cell.hamArrowButton.isEnabled = false
                if !dictData.subMenuItems.isEmpty && indexPath.row < dictData.subMenuItems.count && indexPath.row >= 0 {   // Shifting submenus to right
                    cell.hamImageLeadingConstrint.constant = UIDevice.isPhone ? 35 : 60
                    cell.hamCellLabel.text = dictData.subMenuItems[indexPath.row].titleText
                    cell.hamCellImage.image = UIImage(named: dictData.subMenuItems[indexPath.row].iconImage)
                    tableViewCell = cell
                }
            }
        }
        return tableViewCell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat = 0
        height = UIDevice.isPad ? 70 : 44
        return height
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        var height: CGFloat = 0
        height = UIDevice.isPad ? 70 : 44
        return height
    }
    //Rohith
    //Handling manage projector screen here
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {   // Sub elements under Settings tapped action
        var myCurrentVC = UIViewController()
        if let visibleNavC = KAppDelegate.sideMenuVC.mainViewController as? UINavigationController, let visibleVC = visibleNavC.visibleViewController {
            myCurrentVC = visibleVC
        } else if let viewC = KAppDelegate.sideMenuVC.mainViewController {
            myCurrentVC = viewC
        }
        KAppDelegate.sideMenuVC.closeRight()
        if indexPath.row >= 0 {
            if indexPath.row == 0 {   // Software Update API call
                let tStamp = "\(Int(Date().timeIntervalSince1970))"
                ServiceManagerProxy.shared.getDittoVersion(timeStamp: tStamp, fromHamburgerUpdate: true)
            } else if indexPath.row == 1 {   // Navigation to Manage Projector Screen
                UserDefaults.standard.set(true, forKey: "projector")
                
                myCurrentVC.pushToNext(storyBoard: .manageDevice, identifier: Constants.ManageProjectorViewControllerIdentifier)
            } else if indexPath.row == 2 {   // Navigation to Workspace Settings Screen
                myCurrentVC.pushToNext(storyBoard: .workspaceSettings, identifier: Constants.WorkspaceSettingsViewControlleIdentifier)
            } else if indexPath.row == 3 {   // Navigation to Account Settings Screen
                myCurrentVC.pushToNext(storyBoard: .accountSettings, identifier: Constants.AccountSettingsViewControllerIdentifier)
            } else if indexPath.row == 4 {   // Navigation to Subscription Screen
                myCurrentVC.pushToNext(storyBoard: .subscriptions, identifier: Constants.SubcscriptionsViewControllerIdentifier)
            }
        }
    }
    //MARK: Other functions
    //Rohith
    // Side menu New function Added
    @objc func headerTapped(_ gestureRecognizer: UIGestureRecognizer) {   // Main elements on menu tapped action
        guard let section = gestureRecognizer.view?.tag else { return }
        var myCurrentVC = UIViewController()
        if let visibleNavC = KAppDelegate.sideMenuVC.mainViewController as? UINavigationController {
            myCurrentVC = visibleNavC.visibleViewController!
        } else if let viewC = KAppDelegate.sideMenuVC.mainViewController {
            myCurrentVC = viewC
        }
        if section != 1 {
            KAppDelegate.sideMenuVC.closeRight()
        }
        if section == 0 {   // Navigation to About App Screen
            myCurrentVC.pushToNext(storyBoard: .about, identifier: Constants.AboutAppAndPolicyViewControllerIdentifier)
        } else if section == 1 {   // Expanding Settings item in menu
            if self.objHamburgerViewModel.arrHamBurgerMenu.count > 1 {
                self.objHamburgerViewModel.arrHamBurgerMenu[section].isOpened = !self.objHamburgerViewModel.arrHamBurgerMenu[section].isOpened
            }
            DispatchQueue.main.async {
                self.hamTableView.reloadData()
            }
        } else if section == 2 {   // Navigation to FAQ Screen
            myCurrentVC.pushToNext(storyBoard: .faq, identifier: Constants.FaqViewControllerIdentifier)
        } else if section == 3 {   // Navigation to Customer Support Screen
            myCurrentVC.pushToNext(storyBoard: .customerSupport, identifier: Constants.CustomerSupportViewControllerIdentifier)
        }else if section == 4 {   // Switch Language
            NotificationCenter.default.post(name: NSNotification.Name("UserLanguage"),
            object: nil) 
            
        }else if section == 5 {   // Navigation to Customer Upadte Projector
            DispatchQueue.main.async {
                if let viewc = Constants.AlertWithTwoButtonsAndTitle.instantiateViewController(identifier: Constants.AlertWithTwoButonsTitleVCIdentifier) as? AlertWithTwoButtonsAndTitleViewController {
                    viewc.alertArray = [FormatsString.emptyString, ConnectivityMessages.UpdateProjectorSwitch, AlertTitle.CANCEL, AlertTitle.YES]
                    viewc.screenType = CalibrationMessages.calibrationScreenConfirmation
                    viewc.modalPresentationStyle = .overFullScreen
                    viewc.onYesPressed = {
                        self.dismiss(animated: false, completion: {// Navigation to Update Projector Screen
                            UserDefaults.standard.set(false, forKey: "projector")
                            myCurrentVC.pushToNext(storyBoard: .manageDevice, identifier: Constants.ManageProjectorViewControllerIdentifier)
                            self.dismiss(animated: false, completion: nil)
                        })
                    }
                    viewc.onNoPressed = {
                        self.dismiss(animated: false, completion: nil)
                    }
                    if self.presentedViewController == nil {
                        self.present(viewc, animated: false, completion: nil)
                    }
                }
            }
        }
        
        else if section == self.objHamburgerViewModel.arrHamBurgerMenu.count - 1 {
            if !CommonConst.guestUserCheck {
                DatabaseHelper().deleteAllRowsFromTable(tableName: DBEntities.userDb)
                CommonConst.accessTokenText = FormatsString.emptyString
                CommonConst.userDefault.synchronize()
                UserDefaults.standard.removeObject(forKey: "isChecked")//removing user first time login
            }
            CommonConst.myLibPatternCount = FormatsString.emptyString
            CommonConst.navCheckValue = 0
            CommonConst.guestUserCheck = false
            myCurrentVC.root(selectedStoryboard: .login, identifier: Constants.LoginViewControllerIdentifier)
        }
    }
    @objc func expandCell(_ sender: UIButton) {   // Function to expand Settings cell
        if let section = sender.tag as Int? {
            if self.objHamburgerViewModel.arrHamBurgerMenu.count > section {
                self.objHamburgerViewModel.arrHamBurgerMenu[section].isOpened = !self.objHamburgerViewModel.arrHamBurgerMenu[section].isOpened
            }
            DispatchQueue.main.async {
                self.hamTableView.reloadData()
            }
        } else {
            ServiceManagerProxy.shared.displayerrorPopup(url: FormatsString.emptyString, responseError: AlertMessage.invalidEntry)
        }
    }
}
