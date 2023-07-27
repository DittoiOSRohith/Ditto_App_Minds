//
//  HamburgerViewModel.swift
//  Ditto
//
//  Created by Abiya Joy on 24/04/21.
//  Copyright © 2021 Infosys. All rights reserved.
//

import UIKit

class HamburgerViewModel {
    var arrHamBurgerMenu = [
        HamburgerObject(iconImage: ImageNames.aboutAppPoliciesImage, titleText: FormatsString.aboutAppLabel, isOpened: false, subMenuItems: []), HamburgerObject(iconImage: ImageNames.settingsImage, titleText: FormatsString.settingsLabel, isOpened: false, subMenuItems: [HamburgerInnerObject(iconImage: ImageNames.softwareUpdatesImage, titleText: FormatsString.softwareUpdateLabel), HamburgerInnerObject(iconImage: ImageNames.manageProjectorImage, titleText: FormatsString.manageProjectorLabel), HamburgerInnerObject(iconImage: ImageNames.workspaceSettingsImage, titleText: FormatsString.workspaceSettingsLabel),
            HamburgerInnerObject(iconImage: ImageNames.privacySettingsImage, titleText: FormatsString.accountInfoLabel),
            HamburgerInnerObject(iconImage: ImageNames.privacySettingsImage, titleText: FormatsString.subscriptionInfoLabel)]),
        HamburgerObject(iconImage: ImageNames.faqsImage, titleText: FormatsString.faqMenuLabel, isOpened: false, subMenuItems: []),
        HamburgerObject(iconImage: ImageNames.customerServiceImage, titleText: FormatsString.customerServiceLabel, isOpened: false, subMenuItems: []),
        HamburgerObject(iconImage: ImageNames.customerServiceImage, titleText: FormatsString.switchLanguageLabel, isOpened: false, subMenuItems: []),

       //Rohith
        //created update projector popup here
        HamburgerObject(iconImage: ImageNames.manageProjectorImage, titleText: FormatsString.updateProjectorLabel, isOpened: false, subMenuItems: []),

        HamburgerObject(iconImage: ImageNames.logOutImage, titleText: FormatsString.logOutLabel, isOpened: false, subMenuItems: [])]
   
    
    //MARK: FUNCTION LOGICS
    func removeWorkspaceSettingsCell() -> [HamburgerObject] {   // Restricting WS settings, Account Info and Subscription Info for Guest User
        if let settingIntex = arrHamBurgerMenu.firstIndex(of: arrHamBurgerMenu.filter {($0.titleText == FormatsString.settingsLabel)}.first!) {
            let workspaceObj = arrHamBurgerMenu[settingIntex].subMenuItems.filter {($0.titleText == FormatsString.workspaceSettingsLabel)}
            let workSpaceIntex = arrHamBurgerMenu[settingIntex].subMenuItems.firstIndex(of: workspaceObj.first!)
            arrHamBurgerMenu[settingIntex].subMenuItems.remove(at: workSpaceIntex!)
            let accountObj = arrHamBurgerMenu[settingIntex].subMenuItems.filter {($0.titleText == FormatsString.accountInfoLabel)}
            let accountIntex = arrHamBurgerMenu[settingIntex].subMenuItems.firstIndex(of: accountObj.first!)
            arrHamBurgerMenu[settingIntex].subMenuItems.remove(at: accountIntex!)
            let subscriptionObj = arrHamBurgerMenu[settingIntex].subMenuItems.filter {($0.titleText == FormatsString.subscriptionInfoLabel)}
            let subscriptionIntex = arrHamBurgerMenu[settingIntex].subMenuItems.firstIndex(of: subscriptionObj.first!)
            arrHamBurgerMenu[settingIntex].subMenuItems.remove(at: subscriptionIntex!)
        }
        return arrHamBurgerMenu
    }
}
